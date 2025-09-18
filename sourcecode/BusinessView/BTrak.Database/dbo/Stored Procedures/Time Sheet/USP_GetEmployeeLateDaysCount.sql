CREATE PROCEDURE [dbo].[USP_GetEmployeeLateDaysCount]
(
	@Date DATETIME
)
AS
BEGIN

DECLARE @TimeSheet TABLE
(
    [Date] DATETIME,
    TotalCount INT,
    MorningLateCount INT,
    LunchbreakLateCount INT
)

DECLARE @DateFrom DATETIME
DECLARE @DateTo DATETIME

SELECT @DateFrom = CONVERT(Date,DATEADD(month, -6, @Date), 103)
SELECT @DateTo = @Date
  
   INSERT INTO @TimeSheet([Date])
   SELECT [Date] FROM TimeSheet WITH (NOLOCK)
   WHERE (@DateFrom <= [Date] AND @DateTo > [Date])
   GROUP BY [Date]

UPDATE @TimeSheet SET TotalCount = ISNULL(TSInner.TotalCount,0)
FROM @TimeSheet TS
    LEFT JOIN (SELECT [Date],COUNT(1) TotalCount
           FROM TimeSheet 
           WHERE [Date] >= @DateFrom AND [Date] <= @DateTo
           GROUP BY [Date]) TSInner ON TSInner.[Date] = TS.[Date]

UPDATE @TimeSheet SET MorningLateCount = ISNULL(TSInner.MorningLateCount,0)
FROM @TimeSheet TS
    LEFT JOIN (SELECT [Date],COUNT(1) MorningLateCount
           FROM TimeSheet 
           WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND CAST(InTime AS TIME) >= '03:46:00.000'
           GROUP BY [Date]) TSInner ON TSInner.[Date] = TS.[Date]

UPDATE @TimeSheet SET LunchbreakLateCount = ISNULL(TSInner.LunchbreakLateCount,0)
FROM @TimeSheet TS
    LEFT JOIN (SELECT [Date],COUNT(1) LunchbreakLateCount
           FROM TimeSheet 
           WHERE [Date] >= @DateFrom AND [Date] <= @DateTo AND DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, '+00:00'),SWITCHOFFSET(LunchBreakEndTime, '+00:00')) >= 71
           GROUP BY [Date]) TSInner ON TSInner.[Date] = TS.[Date]

SELECT * FROM @TimeSheet
END