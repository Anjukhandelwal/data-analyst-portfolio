-- LFB incident records: SQL validation checks
-- Table assumed: lfb_incidents (import the raw CSV as-is, do not clean it first).
-- Written in standard SQL and tested in SQLite. For PostgreSQL, MySQL or SQL Server only small
-- syntax changes should be needed. If a column imports as text, CAST it (e.g. CAST(Latitude AS REAL)).
-- TODO: check column names against your imported table.

-- 0. SIZE OF THE TABLE
SELECT COUNT(*) AS total_rows FROM lfb_incidents;

-- 1. COMPLETENESS: how many key fields are empty?
SELECT
    SUM(CASE WHEN IncidentNumber IS NULL THEN 1 ELSE 0 END) AS missing_incident_number,
    SUM(CASE WHEN DateOfCall IS NULL THEN 1 ELSE 0 END) AS missing_date,
    SUM(CASE WHEN IncGeo_BoroughName IS NULL THEN 1 ELSE 0 END) AS missing_borough,
    SUM(CASE WHEN Latitude IS NULL OR Longitude IS NULL THEN 1 ELSE 0 END) AS missing_coordinates,
    SUM(CASE WHEN FirstPumpArriving_AttendanceTime IS NULL THEN 1 ELSE 0 END) AS missing_first_pump_time
FROM lfb_incidents;

-- 2. UNIQUENESS: which incident numbers appear more than once?
SELECT IncidentNumber, COUNT(*) AS times_seen
FROM lfb_incidents
GROUP BY IncidentNumber
HAVING COUNT(*) > 1
ORDER BY times_seen DESC;

-- 2b. UNIQUENESS with a window function: how many rows would be removed if we keep one per incident?
WITH ranked AS (
    SELECT
        IncidentNumber,
        ROW_NUMBER() OVER (PARTITION BY IncidentNumber ORDER BY DateOfCall) AS row_num
    FROM lfb_incidents
)
SELECT COUNT(*) AS duplicate_rows_to_remove
FROM ranked
WHERE row_num > 1;

-- 3. VALIDITY: values outside possible ranges
SELECT COUNT(*) AS hour_outside_0_23
FROM lfb_incidents
WHERE HourOfCall < 0 OR HourOfCall > 23;

SELECT COUNT(*) AS coordinates_outside_greater_london
FROM lfb_incidents
WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL
  AND (Latitude NOT BETWEEN 51.2 AND 51.8 OR Longitude NOT BETWEEN -0.6 AND 0.4);

SELECT COUNT(*) AS negative_first_pump_time
FROM lfb_incidents
WHERE FirstPumpArriving_AttendanceTime < 0;

SELECT COUNT(*) AS first_pump_over_60_min_review
FROM lfb_incidents
WHERE FirstPumpArriving_AttendanceTime > 3600;

-- 4. CONSISTENCY: borough names that differ only by case or spaces
SELECT
    UPPER(TRIM(IncGeo_BoroughName)) AS borough_key,
    COUNT(DISTINCT IncGeo_BoroughName) AS spellings_found,
    COUNT(*) AS rows_affected
FROM lfb_incidents
WHERE IncGeo_BoroughName IS NOT NULL
GROUP BY UPPER(TRIM(IncGeo_BoroughName))
HAVING COUNT(DISTINCT IncGeo_BoroughName) > 1;

-- 4b. CONSISTENCY: unexpected incident groups
SELECT IncidentGroup, COUNT(*) AS rows_affected
FROM lfb_incidents
WHERE IncidentGroup NOT IN ('Fire', 'Special Service', 'False Alarm')
GROUP BY IncidentGroup;

-- 5. ACCURACY: second pump should not arrive before the first
SELECT COUNT(*) AS second_pump_before_first
FROM lfb_incidents
WHERE FirstPumpArriving_AttendanceTime IS NOT NULL
  AND SecondPumpArriving_AttendanceTime IS NOT NULL
  AND SecondPumpArriving_AttendanceTime < FirstPumpArriving_AttendanceTime;

-- 6. DATA QUALITY SCORECARD: all key checks in one table (copy these numbers into the README)
WITH checks AS (
    SELECT 'Completeness' AS dimension, 'Missing coordinates' AS check_name, COUNT(*) AS rows_affected
    FROM lfb_incidents WHERE Latitude IS NULL OR Longitude IS NULL
    UNION ALL
    SELECT 'Completeness', 'Missing first pump time', COUNT(*)
    FROM lfb_incidents WHERE FirstPumpArriving_AttendanceTime IS NULL
    UNION ALL
    SELECT 'Validity', 'Hour outside 0-23', COUNT(*)
    FROM lfb_incidents WHERE HourOfCall < 0 OR HourOfCall > 23
    UNION ALL
    SELECT 'Validity', 'Coordinates outside Greater London', COUNT(*)
    FROM lfb_incidents
    WHERE Latitude IS NOT NULL AND Longitude IS NOT NULL
      AND (Latitude NOT BETWEEN 51.2 AND 51.8 OR Longitude NOT BETWEEN -0.6 AND 0.4)
    UNION ALL
    SELECT 'Validity', 'Negative first pump time', COUNT(*)
    FROM lfb_incidents WHERE FirstPumpArriving_AttendanceTime < 0
    UNION ALL
    SELECT 'Accuracy', 'Second pump before first', COUNT(*)
    FROM lfb_incidents
    WHERE FirstPumpArriving_AttendanceTime IS NOT NULL
      AND SecondPumpArriving_AttendanceTime IS NOT NULL
      AND SecondPumpArriving_AttendanceTime < FirstPumpArriving_AttendanceTime
)
SELECT
    dimension,
    check_name,
    rows_affected,
    ROUND(100.0 * rows_affected / (SELECT COUNT(*) FROM lfb_incidents), 2) AS pct_of_rows
FROM checks
ORDER BY dimension, rows_affected DESC;
