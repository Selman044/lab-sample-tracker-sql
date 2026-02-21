-- Lab Sample Tracker - Schema (SQL Server)
-- Run in an empty database

IF OBJECT_ID('dbo.Results', 'U') IS NOT NULL DROP TABLE dbo.Results;
IF OBJECT_ID('dbo.SampleTests', 'U') IS NOT NULL DROP TABLE dbo.SampleTests;
IF OBJECT_ID('dbo.Samples', 'U') IS NOT NULL DROP TABLE dbo.Samples;
IF OBJECT_ID('dbo.Tests', 'U') IS NOT NULL DROP TABLE dbo.Tests;
IF OBJECT_ID('dbo.Equipment', 'U') IS NOT NULL DROP TABLE dbo.Equipment;
IF OBJECT_ID('dbo.Users', 'U') IS NOT NULL DROP TABLE dbo.Users;

CREATE TABLE dbo.Users (
  UserId        INT IDENTITY(1,1) PRIMARY KEY,
  FullName      NVARCHAR(100) NOT NULL,
  Email         NVARCHAR(120) NOT NULL UNIQUE,
  Role          NVARCHAR(30)  NOT NULL CHECK (Role IN ('TECHNICIAN','QUALITY','ADMIN')),
  IsActive      BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Equipment (
  EquipmentId   INT IDENTITY(1,1) PRIMARY KEY,
  Name          NVARCHAR(80) NOT NULL,
  SerialNumber  NVARCHAR(40) NOT NULL UNIQUE,
  CalibrationDueDate DATE NULL,
  IsActive      BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Tests (
  TestId        INT IDENTITY(1,1) PRIMARY KEY,
  TestCode      NVARCHAR(30) NOT NULL UNIQUE,
  TestName      NVARCHAR(100) NOT NULL,
  Unit          NVARCHAR(20) NULL,
  MinAcceptable DECIMAL(18,4) NULL,
  MaxAcceptable DECIMAL(18,4) NULL,
  IsActive      BIT NOT NULL DEFAULT 1
);

CREATE TABLE dbo.Samples (
  SampleId      INT IDENTITY(1,1) PRIMARY KEY,
  SampleCode    NVARCHAR(40) NOT NULL UNIQUE,
  Matrix        NVARCHAR(40) NOT NULL CHECK (Matrix IN ('WATER','RAW_MATERIAL','PACKAGING')),
  CollectedAt   DATETIME2 NOT NULL,
  CollectedByUserId INT NOT NULL,
  Status        NVARCHAR(20) NOT NULL CHECK (Status IN ('RECEIVED','IN_PROGRESS','COMPLETED','REJECTED')),
  Notes         NVARCHAR(400) NULL,
  CONSTRAINT FK_Samples_Users FOREIGN KEY (CollectedByUserId) REFERENCES dbo.Users(UserId)
);

CREATE TABLE dbo.SampleTests (
  SampleTestId  INT IDENTITY(1,1) PRIMARY KEY,
  SampleId      INT NOT NULL,
  TestId        INT NOT NULL,
  RequestedAt   DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  RequestedByUserId INT NOT NULL,
  Status        NVARCHAR(20) NOT NULL CHECK (Status IN ('REQUESTED','RUNNING','DONE','CANCELLED')),
  CONSTRAINT FK_SampleTests_Samples FOREIGN KEY (SampleId) REFERENCES dbo.Samples(SampleId),
  CONSTRAINT FK_SampleTests_Tests FOREIGN KEY (TestId) REFERENCES dbo.Tests(TestId),
  CONSTRAINT FK_SampleTests_Users FOREIGN KEY (RequestedByUserId) REFERENCES dbo.Users(UserId),
  CONSTRAINT UQ_Sample_Test UNIQUE (SampleId, TestId)
);

CREATE TABLE dbo.Results (
  ResultId      INT IDENTITY(1,1) PRIMARY KEY,
  SampleTestId  INT NOT NULL UNIQUE,
  MeasuredValue DECIMAL(18,4) NULL,
  TextValue     NVARCHAR(120) NULL,
  MeasuredAt    DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
  MeasuredByUserId INT NOT NULL,
  EquipmentId   INT NULL,
  IsConform     AS (
    CASE
      WHEN MeasuredValue IS NULL THEN NULL
      ELSE
        CASE
          WHEN (SELECT MinAcceptable FROM dbo.Tests t
                JOIN dbo.SampleTests st ON st.TestId = t.TestId
                WHERE st.SampleTestId = SampleTestId) IS NULL
           AND (SELECT MaxAcceptable FROM dbo.Tests t
                JOIN dbo.SampleTests st ON st.TestId = t.TestId
                WHERE st.SampleTestId = SampleTestId) IS NULL
          THEN NULL
          ELSE
            CASE
              WHEN MeasuredValue >= ISNULL((SELECT MinAcceptable FROM dbo.Tests t
                                            JOIN dbo.SampleTests st ON st.TestId = t.TestId
                                            WHERE st.SampleTestId = SampleTestId), MeasuredValue)
               AND MeasuredValue <= ISNULL((SELECT MaxAcceptable FROM dbo.Tests t
                                            JOIN dbo.SampleTests st ON st.TestId = t.TestId
                                            WHERE st.SampleTestId = SampleTestId), MeasuredValue)
              THEN 1 ELSE 0 END
        END
    END
  ),
  CONSTRAINT FK_Results_SampleTests FOREIGN KEY (SampleTestId) REFERENCES dbo.SampleTests(SampleTestId),
  CONSTRAINT FK_Results_Users FOREIGN KEY (MeasuredByUserId) REFERENCES dbo.Users(UserId),
  CONSTRAINT FK_Results_Equipment FOREIGN KEY (EquipmentId) REFERENCES dbo.Equipment(EquipmentId)
);

-- Indexes for typical queries
CREATE INDEX IX_Samples_Status ON dbo.Samples(Status);
CREATE INDEX IX_SampleTests_Status ON dbo.SampleTests(Status);
CREATE INDEX IX_SampleTests_SampleId ON dbo.SampleTests(SampleId);
