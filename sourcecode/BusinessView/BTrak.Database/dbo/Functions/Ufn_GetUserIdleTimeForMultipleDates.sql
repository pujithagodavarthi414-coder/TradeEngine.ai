CREATE FUNCTION [dbo].[Ufn_GetUserIdleTimeForMultipleDates]
(
    @DateFrom DATETIME = NULL,
    @DateTo DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER
)
RETURNS TABLE AS RETURN
(

	SELECT UserId,SUM(T.TotalTimeInMin) AS TotalIdleTime,TrackedDateTime
		FROM (
				SELECT UserId,IdleInMinutes TotalTimeInMin,CONVERT(DATE,CreatedDateTime) TrackedDateTime
				FROM UserActivityTimeSummary
				WHERE CompanyId = @CompanyId
				      AND CONVERT(DATE,CreatedDateTime) BETWEEN @DateFrom AND @DateTo
			  )T  
	GROUP BY UserId,TrackedDateTime
	
)
GO
