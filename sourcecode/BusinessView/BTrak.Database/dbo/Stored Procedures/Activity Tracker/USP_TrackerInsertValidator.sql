--EXEC [dbo].[USP_TrackerInsertValidator] @UserId = '3185CB4F-39C5-4290-86CD-D2AE371635E4',@TriggeredDate = '2020-12-19 06:30:09.1234567 +00:00'
CREATE PROC [dbo].[USP_TrackerInsertValidator]
(
	@UserId UNIQUEIDENTIFIER = NULL,
	@DeviceId NVARCHAR(500) = NULL,
	@TriggeredDate DATETIMEOFFSET = NULL
)
AS
BEGIN
	
	DECLARE @CompanyId UNIQUEIDENTIFIER,
					@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
					--@StealthModeId UNIQUEIDENTIFIER = '0FF0AC91-DDB3-4907-BEAE-C2C6B1A289BD',
					--@PrModeId UNIQUEIDENTIFIER = '786F40B4-4ED5-45B6-AED2-5D6A775AE71C',
					--@PunchCardModeId UNIQUEIDENTIFIER = '734D6880-639D-4CC5-97A7-46D1182F0BB8',
					--@MessengerModeId UNIQUEIDENTIFIER = '11A41B04-FCAB-4457-B42A-05CA8DD12616',
					@Time DATETIME = ISNULL(CONVERT(DATETIME2,@TriggeredDate),GETUTCDATE()),
					@SkipTimeCheck BIT = 1

	DECLARE @ConsiderPunchCard BIT
	DECLARE @ConsiderShift BIT
	DECLARE @IsActiveShift BIT
	DECLARE @CanInsert BIT
	DECLARE @CurrentClientDate DATETIME
	DECLARE @OffSet INT
	DECLARE @TimeZoneId UNIQUEIDENTIFIER 
	DECLARE @Temp DATETIME
	DECLARE @ActivityToken NVARCHAR(800)
	DECLARE @TimeNow TIME = CAST(@Time AS TIME)

	DECLARE @ModeConfig TABLE
	(
		ShiftBased BIT,
		PunchCardBased BIT,
		IsActiveShift BIT NULL,
		ModeTypeEnum INT,
		UserId UNIQUEIDENTIFIER
	)

	IF(@UserId = @EmptyGuid OR @UserId IS NULL)
	BEGIN
		INSERT INTO @ModeConfig (ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum)
		SELECT TOP 1 ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, @Time)
		IF(@UserId IS NULL)
		BEGIN
			SET @UserId = @EmptyGuid
		END
	END
	ELSE
	BEGIN

		INSERT INTO @ModeConfig (ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum)
		SELECT TOP 1 ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum FROM dbo.Ufn_GetUsersModeType(NULL, @UserId, @Time)

	END

	SET @UserId = (SELECT TOP 1 UserId FROM @ModeConfig)
	SET @IsActiveShift = (SELECT TOP 1 IsActiveShift FROM @ModeConfig)
	SET @ConsiderPunchCard = (SELECT TOP 1 PunchCardBased FROM @ModeConfig)
	SET @ConsiderShift = (SELECT TOP 1 ShiftBased FROM @ModeConfig)

	SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] (NOLOCK) WHERE Id = @UserId)
    SET @TimeZoneId = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId ORDER BY [Date] DESC)
	
	IF(@TimeZoneId IS NULL)
	BEGIN
		
		SET @TimeZoneId = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE [Date] = CAST(@Time AS DATE))

	END

	SET @OffSet = (SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId)
    SET @CurrentClientDate = DATEADD(MINUTE, CASE WHEN @Offset IS NOT NULL THEN @Offset ELSE 0 END,@Time) 

	DECLARE @DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop (NOLOCK) WHERE DesktopDeviceId = @DeviceId)

	IF((@UserId IS NULL OR @UserId = @EmptyGuid) AND (SELECT COUNT(*) FROM [User] (NOLOCK) WHERE DesktopId = @DesktopId) = 0)
	BEGIN
		SET @ActivityToken = (SELECT TOP 1 ActivityToken FROM UserActivityToken (NOLOCK) WHERE DesktopId = @DesktopId ORDER BY UpdatedDateTime DESC)
	END
	ELSE IF(@UserId IS NULL OR @UserId = @EmptyGuid)
	BEGIN
		SET @ActivityToken = ''
	END 
	ELSE 
	BEGIN
		SET @ActivityToken = (SELECT TOP 1 ActivityToken FROM UserActivityToken (NOLOCK) WHERE UserId = @UserId ORDER BY UpdatedDateTime DESC)
	END

	--SET @IsActiveShift = ISNULL(( SELECT CASE WHEN @TimeNow >= SW.StartTime AND @TimeNow <= SW.EndTime THEN 1 ELSE 0 END
	--                       FROM EmployeeShift ES
	--                       INNER JOIN Employee E ON ES.EmployeeId = E.Id
	--                                  AND E.UserId = @UserId
	--                       INNER JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId
	--                       INNER JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ST.Id
	--                       LEFT JOIN [ShiftException] SE ON SE.ShiftTimingId = ST.Id
	--                       WHERE SW.[DayOfWeek] = DATENAME(dw, DATEADD(MINUTE,@OffSet,@Time))),0)

	IF(@ConsiderShift = 1)
	BEGIN
		SET @CanInsert = CASE WHEN @IsActiveShift = 1 THEN 1 ELSE 0 END
	END
	ELSE IF((@ConsiderPunchCard = 0 OR @ConsiderPunchCard IS NULL) AND (@ConsiderShift = 0 OR @ConsiderShift IS NULL))
	BEGIN
	
		SET @CanInsert = 1

	END
	ELSE
	BEGIN
		
		IF((SELECT TOP 1 COUNT(Id) FROM TimeSheet (NOLOCK) WHERE [Date] = CONVERT(DATE,@CurrentClientDate) AND UserId = @UserId) > 0)
		BEGIN
			SET @Temp = ( SELECT TOP 1 @Time FROM TimeSheet (NOLOCK) AS TS WHERE @Time > TS.InTime AND (@Time <= TS.OutTime OR TS.OutTime IS NULL)
											AND(  TS.LunchBreakStartTime IS NULL OR ( @Time >= TS.LunchBreakEndTime ))--OR TS.LunchBreakEndTime IS NULL) )
											AND @Time NOT IN (SELECT @Time
																	FROM [UserBreak] (NOLOCK) UB WHERE
																	((@Time BETWEEN BreakIn AND BreakOut) OR (@Time>=BreakIn AND BreakOut IS NULL)) AND  UB.UserId = @UserId
																	AND Date = CONVERT(DATE,@CurrentClientDate)
																	)
											AND TS.UserId = @UserId AND TS.Date = CONVERT(DATE,@CurrentClientDate) 
											)
		END
		ELSE
		BEGIN
			DECLARE @PreviousDay DATE
			SET @PreviousDay = DATEADD(DAY, -1, @CurrentClientDate)

			SET @Temp = ( SELECT TOP 1 @Time FROM TimeSheet (NOLOCK) AS TS WHERE @Time > TS.InTime AND (@Time <= TS.OutTime OR TS.OutTime IS NULL)
											AND(  TS.LunchBreakStartTime IS NULL OR ( @Time >= TS.LunchBreakEndTime ))--OR TS.LunchBreakEndTime IS NULL) )
											AND @Time NOT IN (SELECT @Time
																	FROM [UserBreak] (NOLOCK) UB WHERE
																	((@Time BETWEEN BreakIn AND BreakOut) OR (@Time>=BreakIn AND BreakOut IS NULL)) AND  UB.UserId = @UserId
																	AND (Date = CONVERT(DATE,@CurrentClientDate) OR Date = @PreviousDay)
																	)
											AND TS.UserId = @UserId AND TS.Date = @PreviousDay
											)
		END

			SET @CanInsert = (CASE WHEN @Temp IS NOT NULL AND @Temp <> '' THEN 1 ELSE 0 END)
	END

	SELECT
		@CanInsert AS CanInsert,
		@ActivityToken AS ActivityToken,
		CASE WHEN @UserId = @EmptyGuid THEN NULL ELSE @UserId END AS UserId,
		@CompanyId AS CompanyId
		
END
GO