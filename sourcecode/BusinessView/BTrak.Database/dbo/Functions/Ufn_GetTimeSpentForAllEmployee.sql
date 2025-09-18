CREATE FUNCTION [dbo].[Ufn_GetTimeSpentForAllEmployee]
(
	@UserId UNIQUEIDENTIFIER= null,
	@Fromdate datetime,
	@ToDate datetime,
	@CompanyId uniqueidentifier
)
RETURNS @returntable TABLE
(
	UserId UNIQUEIDENTIFIER,
	EmployeeId UNIQUEIDENTIFIER,
    [Date] DATETIME,
    TimeSpent VARCHAR(100),
	[FromTime] Time,
	[ToTime] Time,
	[BreakMins] INT
)
AS
BEGIN

	INSERT @returntable
	SELECT TS.[UserId], E.Id,  TS.[Date],
		(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(InTime, '+00:00'), ISNULL(OutTime, GETUTCDATE())),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0) - ISNULL(UB.BreakTime,0)) TotalTimeSpent,
		SWITCHOFFSET(Intime, '+00:00'), ISNULL(SWITCHOFFSET(OutTime, '+00:00'), convert(time,  GETUTCDATE() )) OutTime, ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, '+00:00'), SWITCHOFFSET(TS.LunchBreakEndTime, '+00:00')),0) + ISNULL(UB.BreakTime,0) BreakMins
        FROM [User] U WITH (NOLOCK)
		INNER JOIN Employee E ON E.UserId = U.Id
		INNER JOIN TimeSheet TS WITH (NOLOCK) ON TS.UserId = U.Id AND U.InactiveDateTime IS NULL
		OUTER APPLY (SELECT UB.[Date], ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn, UB.BreakOut)),0) AS BreakTime
                        FROM UserBreak UB WHERE UB.UserId = U.Id AND U.InActiveDateTime IS NULL 
                                                    AND U.CompanyId = @CompanyId AND CONVERT(DATE,UB.[Date]) = TS.[Date]
                        GROUP BY UB.[Date]) UB
        WHERE (CONVERT(DATE,TS.[Date]) BETWEEN CONVERT(DATE,@FromDate) AND CONVERT(DATE,@ToDate))
		AND (CompanyId = @CompanyId)
		AND (@UserId IS NULL OR U.Id = @UserId)
	RETURN
END