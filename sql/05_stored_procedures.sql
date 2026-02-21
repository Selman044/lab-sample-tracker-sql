IF OBJECT_ID('dbo.sp_CreateSample', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_CreateSample;
GO
CREATE PROCEDURE dbo.sp_CreateSample
  @SampleCode NVARCHAR(40),
  @Matrix NVARCHAR(40),
  @CollectedAt DATETIME2,
  @CollectedByUserId INT,
  @Notes NVARCHAR(400) = NULL
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.Samples (SampleCode, Matrix, CollectedAt, CollectedByUserId, Status, Notes)
  VALUES (@SampleCode, @Matrix, @CollectedAt, @CollectedByUserId, 'RECEIVED', @Notes);

  SELECT SCOPE_IDENTITY() AS SampleId;
END
GO

IF OBJECT_ID('dbo.sp_RequestTest', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_RequestTest;
GO
CREATE PROCEDURE dbo.sp_RequestTest
  @SampleId INT,
  @TestId INT,
  @RequestedByUserId INT
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.SampleTests (SampleId, TestId, RequestedByUserId, Status)
  VALUES (@SampleId, @TestId, @RequestedByUserId, 'REQUESTED');
END
GO

IF OBJECT_ID('dbo.sp_SaveResult', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_SaveResult;
GO
CREATE PROCEDURE dbo.sp_SaveResult
  @SampleTestId INT,
  @MeasuredValue DECIMAL(18,4) = NULL,
  @TextValue NVARCHAR(120) = NULL,
  @MeasuredByUserId INT,
  @EquipmentId INT = NULL
AS
BEGIN
  SET NOCOUNT ON;

  INSERT INTO dbo.Results (SampleTestId, MeasuredValue, TextValue, MeasuredByUserId, EquipmentId)
  VALUES (@SampleTestId, @MeasuredValue, @TextValue, @MeasuredByUserId, @EquipmentId);

  UPDATE dbo.SampleTests SET Status='DONE' WHERE SampleTestId=@SampleTestId;
END
GO
