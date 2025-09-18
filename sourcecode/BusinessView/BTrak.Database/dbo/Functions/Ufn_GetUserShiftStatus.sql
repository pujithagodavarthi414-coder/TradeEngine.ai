CREATE FUNCTION [dbo].[Ufn_GetUserShiftStatus]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@UtcDateTime DATETIME = NULL,
	@CompanyId UNIQUEIDENTIFIER = NULL
)
RETURNS @ShiftConfig TABLE
(
	ShiftStartTime TIME NULL,
	ShiftEndTime TIME NULL,
	IsActiveShift BIT NULL,
	UserId UNIQUEIDENTIFIER
)
BEGIN
	DECLARE @ShiftStartTime TIME,
					@ShiftEndTime TIME,
					@IsActiveShift BIT,
					@CurrentUtcTime DATETIME = GETUTCDATE(),
					@TimeZoneId UNIQUEIDENTIFIER,
					@TimeNow TIME


	IF(@UtcDateTime IS NOT NULL)
	BEGIN
		SET @CurrentUtcTime = @UtcDateTime
	END

	SET @TimeNow = CAST(@CurrentUtcTime AS TIME)
	SET @TimeZoneId = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE [Date] = CAST(@CurrentUtcTime AS DATE))

	DECLARE @Users TABLE
	(
		UserId UNIQUEIDENTIFIER
	)

	IF(@CompanyId IS NULL)
	BEGIN
		INSERT INTO @Users 
		SELECT @UserId
	END
	ELSE
	BEGIN
		INSERT INTO @Users (UserId)
		SELECT Id FROM [User] (NOLOCK) WHERE CompanyId = @CompanyId
	END

	INSERT INTO @ShiftConfig (ShiftStartTime, ShiftEndTime, IsActiveShift,UserId)
	SELECT SW.StartTime, SW.EndTime, CASE WHEN @TimeNow >= SW.StartTime AND @TimeNow <= SW.EndTime THEN 1 ELSE 0 END,U.UserId
	FROM EmployeeShift ES
	INNER JOIN Employee E ON ES.EmployeeId = E.Id
	--INNER JOIN [User] U ON U.Id = E.UserId AND (U.Id = @UserId OR U.CompanyId = @CompanyId)
	INNER JOIN @Users U ON U.UserId = E.UserId
	INNER JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId
	INNER JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ST.Id
	LEFT JOIN [ShiftException] SE ON SE.ShiftTimingId = ST.Id
		WHERE SW.[DayOfWeek] = DATENAME(dw, DATEADD(MINUTE,CASE WHEN (SELECT OffsetMinutes FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId) IS NULL THEN 0 ELSE (SELECT OffsetMinutes FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId) END,@CurrentUtcTime))

	RETURN
END
