IF OBJECT_ID('dbo.v_SampleProgress', 'V') IS NOT NULL DROP VIEW dbo.v_SampleProgress;
GO

CREATE VIEW dbo.v_SampleProgress AS
SELECT
  s.SampleId,
  s.SampleCode,
  s.Status AS SampleStatus,
  COUNT(st.SampleTestId) AS NbTests,
  SUM(CASE WHEN st.Status = 'DONE' THEN 1 ELSE 0 END) AS NbDone,
  SUM(CASE WHEN st.Status IN ('REQUESTED','RUNNING') THEN 1 ELSE 0 END) AS NbPending
FROM dbo.Samples s
LEFT JOIN dbo.SampleTests st ON st.SampleId = s.SampleId
GROUP BY s.SampleId, s.SampleCode, s.Status;
GO
