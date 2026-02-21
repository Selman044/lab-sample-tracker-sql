INSERT INTO dbo.Users (FullName, Email, Role)
VALUES
('Alice Martin', 'alice.martin@example.com', 'TECHNICIAN'),
('Karim Benali', 'karim.benali@example.com', 'TECHNICIAN'),
('Sophie Durand', 'sophie.durand@example.com', 'QUALITY'),
('Admin Lab', 'admin.lab@example.com', 'ADMIN');

INSERT INTO dbo.Equipment (Name, SerialNumber, CalibrationDueDate)
VALUES
('pH Meter', 'PH-00019', '2026-11-30'),
('Spectrophotometer', 'SP-00311', '2026-07-15');

INSERT INTO dbo.Tests (TestCode, TestName, Unit, MinAcceptable, MaxAcceptable)
VALUES
('PH', 'pH', NULL, 6.5000, 8.5000),
('NO3', 'Nitrates', 'mg/L', 0.0000, 50.0000),
('TURB', 'Turbidity', 'NTU', 0.0000, 5.0000);

INSERT INTO dbo.Samples (SampleCode, Matrix, CollectedAt, CollectedByUserId, Status, Notes)
VALUES
('VTL-2026-09-001', 'WATER', DATEADD(day, -2, SYSUTCDATETIME()), 1, 'IN_PROGRESS', 'Source A'),
('VTL-2026-09-002', 'WATER', DATEADD(day, -1, SYSUTCDATETIME()), 2, 'RECEIVED', 'Source B');

-- Request tests
INSERT INTO dbo.SampleTests (SampleId, TestId, RequestedByUserId, Status)
VALUES
(1, 1, 3, 'RUNNING'), -- pH
(1, 2, 3, 'REQUESTED'), -- Nitrates
(1, 3, 3, 'REQUESTED'), -- Turbidity
(2, 1, 3, 'REQUESTED'),
(2, 2, 3, 'REQUESTED');

-- Results for one test
INSERT INTO dbo.Results (SampleTestId, MeasuredValue, MeasuredByUserId, EquipmentId)
VALUES
(1, 7.2000, 1, 1);

UPDATE dbo.SampleTests SET Status='DONE' WHERE SampleTestId=1;
