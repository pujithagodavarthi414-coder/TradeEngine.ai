CREATE PROCEDURE [dbo].[USP_GetSpentAndLogTimeDetails]
(
	@Date DATE,
	@UserId UNIQUEIDENTIFIER,
	@CompanyId UNIQUEIDENTIFIER
)
AS
BEGIN

	SELECT U.*,@Date [Date], CAST(ISNULL(ST.SpentTime,0) AS NUMERIC(10,2)) SpentTime, ISNULL(LT.LogTime,0) LogTime
	FROM [User] U WITH (NOLOCK)
	     LEFT JOIN (SELECT TS.UserId,(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, '+00:00'),CASE WHEN @Date = CAST(GETUTCDATE() AS DATE) AND SWITCHOFFSET(TS.InTime, '+00:00') IS NOT NULL AND SWITCHOFFSET(OutTime, '+00:00') IS NULL THEN GETUTCDATE() ELSE SWITCHOFFSET(TS.OutTime, '+00:00') END) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE, UB.BreakIn, UB.BreakOut)),0))/60.0 SpentTime
		            FROM TimeSheet TS WITH (NOLOCK) LEFT JOIN UserBreak UB ON UB.[Date] = TS.[Date] AND UB.UserId = TS.UserId
					WHERE TS.[Date] = @Date AND TS.UserId = @UserId
					GROUP BY TS.UserId,TS.InTime,OutTime,TS.LunchBreakStartTime,TS.LunchBreakEndTime) ST ON ST.UserId = U.Id
		 LEFT JOIN (SELECT UserId,SUM(SpentTimeInMin/60.0) LogTime
		            FROM UserStorySpentTime WITH (NOLOCK)  
					WHERE CONVERT(DATE,CreatedDateTime) = @Date AND UserId = @UserId
					GROUP BY UserId) LT ON LT.UserId = U.Id
	WHERE Id = @UserId AND CompanyId = @CompanyId

END