DECLARE @TourId int = 12;
DECLARE @Capacity int = 13;

-- Put any dates you want here
;WITH Dates AS (
    SELECT CAST('2025-10-11' AS date) d UNION ALL
    SELECT '2025-10-12' UNION ALL
    SELECT '2025-10-13' UNION ALL
    SELECT '2025-10-24'
),
TimeSlots AS (
    SELECT 10  AS h,  30 AS m UNION ALL
    SELECT 11 AS h, 30 AS m UNION ALL
    SELECT 15 AS h,  0 AS m UNION ALL
    SELECT 16 AS h, 30 AS m
)
INSERT INTO dbo.TourDates (TourId, Capacity, Status, DateTimeUtc)
SELECT  @TourId,
        @Capacity,
        'Open',
        DATETIMEFROMPARTS(YEAR(d.d), MONTH(d.d), DAY(d.d), s.h, s.m, 0, 0)
FROM Dates d
CROSS JOIN TimeSlots s
WHERE NOT EXISTS (
    SELECT 1
    FROM dbo.TourDates x
    WHERE x.TourId = @TourId
      AND x.DateTimeUtc = DATETIMEFROMPARTS(YEAR(d.d), MONTH(d.d), DAY(d.d), s.h, s.m, 0, 0)
);
