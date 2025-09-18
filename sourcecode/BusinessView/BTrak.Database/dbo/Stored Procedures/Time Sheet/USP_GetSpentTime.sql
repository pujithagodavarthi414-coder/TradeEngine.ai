CREATE PROCEDURE [dbo].[USP_GetSpentTime]
(
   @UserId UNIQUEIDENTIFIER,
   @FromDate VARCHAR(500),
   @ToDate VARCHAR(500),
   @CompanyId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
    DECLARE @SpentTime TABLE
    (
        UserId UNIQUEIDENTIFIER,
        UserName VARCHAR(500),
        [Date] DATETIME,
        TimeSpent VARCHAR(100),
        TotalTimeSpent NUMERIC(10,2)
    )

   DECLARE @StartDate DATETIME
   DECLARE @EndDate DATETIME
   DECLARE @CurrentDate DATE

   SELECT @CurrentDate = CONVERT(DATE,GETUTCDATE())
   SELECT @StartDate = DATEADD(MONTH, DATEDIFF(MONTH, 0, @CurrentDate), 0)
   SELECT @EndDate = DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, @CurrentDate) + 1, 0))

   IF (@CompanyId = '00000000-0000-0000-0000-000000000000')
   BEGIN
   SET @CompanyId = NULL
   END

   IF(@UserId = '00000000-0000-0000-0000-000000000000')
   BEGIN
        INSERT INTO @SpentTime ([Date],TotalTimeSpent)
        
		SELECT T.[Date],AVG(T.SpentTime) FROM (SELECT TS.[Date],(ISNULL(DATEDIFF(MINUTE, TS.InTime,CASE WHEN TS.[Date] = CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETUTCDATE() ELSE TS.OutTime END),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0))/60.0 AS SpentTime --,[dbo].[Ufn_GetMinutesToHHMM](AVG(DATEDIFF(MINUTE, InTime,OutTime)))
        FROM [User] U WITH (NOLOCK) JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id LEFT JOIN UserBreak UB ON UB.[Date] = TS.[Date] AND UB.UserId = TS.UserId
        WHERE (CONVERT(DATE,TS.[Date]) >= @FromDate) AND (CONVERT(DATE,TS.[Date]) <= @ToDate) AND (CompanyId = @CompanyId)
        GROUP BY TS.[Date],TS.UserId,TS.InTime,OutTime,TS.LunchBreakStartTime,TS.LunchBreakEndTime ) T GROUP BY T.[Date]

		UPDATE @SpentTime SET TimeSpent = [dbo].[Ufn_GetMinutesToHHMM](TotalTimeSpent*60) FROM @SpentTime
   END
   ELSE
   BEGIN
        INSERT INTO @SpentTime (UserId,UserName,[Date],TotalTimeSpent)
        SELECT U.Id,U.FirstName,TS.[Date],(ISNULL(DATEDIFF(MINUTE, TS.InTime,CASE WHEN TS.[Date] = CAST(GETUTCDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETUTCDATE() ELSE TS.OutTime END),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0))/60.0--,CAST(DATEDIFF(MINUTE,InTime,OutTime)/60 AS VARCHAR(50)) + 'hr:' + CAST(DATEDIFF(MINUTE, InTime,OutTime)%60 AS VARCHAR(50)) + 'min'
        FROM [User] U WITH (NOLOCK) JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id LEFT JOIN UserBreak UB ON UB.[Date] = TS.[Date] AND UB.UserId = TS.UserId
        WHERE (CONVERT(DATE,TS.[Date]) >= @FromDate) AND (CONVERT(DATE,TS.[Date]) <= @ToDate) AND U.Id  = @UserId AND (CompanyId = @CompanyId)
        GROUP BY U.Id,U.FirstName,TS.[Date],TS.UserId,TS.InTime,OutTime,TS.LunchBreakStartTime,TS.LunchBreakEndTime
		
		UPDATE @SpentTime SET TimeSpent = [dbo].[Ufn_GetMinutesToHHMM](TotalTimeSpent*60) FROM @SpentTime

   END

    SELECT * FROM @SpentTime

END
