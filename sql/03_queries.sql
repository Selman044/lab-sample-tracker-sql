-- 1) Liste des échantillons et leur statut
SELECT SampleCode, Matrix, CollectedAt, Status
FROM dbo.Samples
ORDER BY CollectedAt DESC;

-- 2) Tests en attente / en cours
SELECT s.SampleCode, t.TestCode, t.TestName, st.Status, st.RequestedAt
FROM dbo.SampleTests st
JOIN dbo.Samples s ON s.SampleId = st.SampleId
JOIN dbo.Tests t ON t.TestId = st.TestId
WHERE st.Status IN ('REQUESTED','RUNNING')
ORDER BY st.RequestedAt DESC;

-- 3) Résultats + conformité
SELECT s.SampleCode, t.TestCode, r.MeasuredValue, t.Unit, r.IsConform, r.MeasuredAt
FROM dbo.Results r
JOIN dbo.SampleTests st ON st.SampleTestId = r.SampleTestId
JOIN dbo.Samples s ON s.SampleId = st.SampleId
JOIN dbo.Tests t ON t.TestId = st.TestId
ORDER BY r.MeasuredAt DESC;

-- 4) Taux de conformité par test
SELECT t.TestCode,
       COUNT(*) AS NbResults,
       SUM(CASE WHEN r.IsConform = 1 THEN 1 ELSE 0 END) AS NbConform,
       CAST(100.0 * SUM(CASE WHEN r.IsConform = 1 THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0) AS DECIMAL(5,2)) AS ConformRatePct
FROM dbo.Results r
JOIN dbo.SampleTests st ON st.SampleTestId = r.SampleTestId
JOIN dbo.Tests t ON t.TestId = st.TestId
GROUP BY t.TestCode
ORDER BY t.TestCode;

-- 5) Équipements dont la calibration arrive bientôt (30 jours)
SELECT Name, SerialNumber, CalibrationDueDate
FROM dbo.Equipment
WHERE CalibrationDueDate IS NOT NULL
  AND CalibrationDueDate <= DATEADD(day, 30, CAST(GETDATE() AS date))
ORDER BY CalibrationDueDate;
