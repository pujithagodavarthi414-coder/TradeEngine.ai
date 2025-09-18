CREATE FUNCTION [dbo].[Ufn_GetUsersTrackingStatus]
(
	@CompanyId UNIQUEIDENTIFIER = NULL
)
RETURNS @TrackerUserStatus TABLE
(
	UserId UNIQUEIDENTIFIER,
	TimeTrackLastActiveDate DATETIME,
	ScreenTrackeLastActiveDate DATETIME,
	LastActiveDateTime DATETIME,
	IsTracking BIT
)
BEGIN

	DECLARE @Time DATETIME = GETUTCDATE()
	DECLARE @UserTimeStatus TABLE
	(
		UserId UNIQUEIDENTIFIER,
		LastActiveDateTime DATETIME
	)

	DECLARE @UserScreenShotStatus TABLE
	(
		UserId UNIQUEIDENTIFIER,
		LastActiveDateTime DATETIME
	)

	INSERT INTO @UserTimeStatus
	SELECT UserId, MAX(TrackedDateTime) AS LastActiveDateTime FROM UserActivityTrackerStatus
	GROUP BY UserId

	INSERT INTO @UserScreenShotStatus
	SELECT UserId, SWITCHOFFSET(MAX(Screenshotdatetime),'+00:00') AS LastActiveDateTime FROM ActivityScreenShot
	GROUP BY UserId

	INSERT INTO @TrackerUserStatus
	SELECT U.Id,UTS.LastActiveDateTime,USS.LastActiveDateTime,
	CASE  
			WHEN UTS.LastActiveDateTime IS NULL THEN USS.LastActiveDateTime
			WHEN USS.LastActiveDateTime IS NULL THEN UTS.LastActiveDateTime
			WHEN UTS.LastActiveDateTime > USS.LastActiveDateTime 
			THEN UTS.LastActiveDateTime 
			ELSE USS.LastActiveDateTime END AS LastActiveDateTime,
	(CASE WHEN DATEDIFF(MINUTE,CASE  
									WHEN UTS.LastActiveDateTime IS NULL THEN USS.LastActiveDateTime
									WHEN USS.LastActiveDateTime IS NULL THEN UTS.LastActiveDateTime
									WHEN UTS.LastActiveDateTime > USS.LastActiveDateTime 
									THEN UTS.LastActiveDateTime 
									ELSE USS.LastActiveDateTime END,@Time) < 11 THEN 1 ELSE 0 END) AS IsTracking
	FROM [User] U
	LEFT JOIN @UserTimeStatus UTS ON UTS.UserId = U.Id
	LEFT JOIN @UserScreenShotStatus USS ON USS.UserId = U.Id
	WHERE U.CompanyId = @CompanyId
	
	RETURN
END
GO