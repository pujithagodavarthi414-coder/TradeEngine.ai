CREATE FUNCTION [dbo].[Ufn_GetUserIdleTimeForTimeSheet]
(
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
    @DateFrom1 DATETIME = NULL,
    @DateTo1 DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER,
	@UserId UNIQUEIDENTIFIER = NULL
)
RETURNS TABLE AS RETURN
(
	
		SELECT UserId,SUM(T.TotalTimeInMin) AS TotalIdleTime,TrackedDateTime
		FROM (
				SELECT UserId,IdleInMinutes TotalTimeInMin,CONVERT(DATE,CreatedDateTime) TrackedDateTime
				FROM UserActivityTimeSummary
				WHERE CompanyId = @CompanyId
					  AND (@UserId IS NULL OR @UserId = UserId)
				      AND CONVERT(DATE,CreatedDateTime) BETWEEN @DateFrom1 AND @DateTo1
			  )T  
	GROUP BY UserId,TrackedDateTime

)
GO