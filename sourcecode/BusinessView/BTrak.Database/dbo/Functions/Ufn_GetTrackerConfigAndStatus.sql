CREATE FUNCTION [dbo].[Ufn_GetTrackerConfigAndStatus]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@DeviceId NVARCHAR(500) = NULL,
	@Time DATETIME,
	@Date DATE,
	@SkipTimeCheck BIT = 0
)
RETURNS @TrackerConfig TABLE
(
	ScreenShotFrequency INT NULL,
	ScreenShotMultiplier INT NULL,
	IsScreenShot BIT NULL,
	IsKeyBoardTracking BIT NULL,
	IsMouseTracking BIT NULL,
	IsTrack BIT NULL,
	TrackApps BIT NULL,
	CanInsert BIT,
	DisableUrls BIT,
	ActivityToken nvarchar(800),
	LastHeartBeatTime DATETIME,
	ConsiderPunchCard BIT,
	TrackOnlyTime BIT,
	IsTracking BIT,
	OffSet INT,
	IpAddress NVARCHAR(255),
	TimeZone NVARCHAR(100),
	OfflineTracking BIT, --TODO
	IsBasicTracking BIT,
	IsActiveShift BIT,
	ModeTypeEnum INT,
	ActiveUserId UNIQUEIDENTIFIER NULL,
	TimeZoneName NVARCHAR(255),
	TimeZoneAbbrevation NVARCHAR(255),
	DeviceId NVARCHAR(500),
	CompanyInActive BIT,
	RandomScreenshot BIT,
	AllowedIdleTime INT --TODO
)
BEGIN

	DECLARE @CompanyId UNIQUEIDENTIFIER,
					@UserId UNIQUEIDENTIFIER,
					@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
					@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop (NOLOCK) WHERE DesktopDeviceId = @DeviceId)

	DECLARE @ConsiderPunchCard BIT
	DECLARE @ConsiderShift BIT
	DECLARE @IsActiveShift BIT
	DECLARE @ModeTypeEnum INT

	DECLARE @ModeConfig TABLE
	(
		ShiftBased BIT,
		PunchCardBased BIT,
		IsActiveShift BIT NULL,
		ModeTypeEnum INT,
		UserId UNIQUEIDENTIFIER
	)

	IF(@OperationsPerformedBy = @EmptyGuid OR @OperationsPerformedBy IS NULL)
	BEGIN
		INSERT INTO @ModeConfig (ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum)
		SELECT TOP 1 ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, @Time)
		IF(@OperationsPerformedBy IS NULL)
		BEGIN
			SET @OperationsPerformedBy = @EmptyGuid
		END
	END
	ELSE
	BEGIN
		INSERT INTO @ModeConfig (ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum)
		SELECT TOP 1 ShiftBased, PunchCardBased, IsActiveShift, UserId, ModeTypeEnum FROM dbo.Ufn_GetUsersModeType(NULL, @OperationsPerformedBy, @Time)
	END

	SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM @ModeConfig)
	SET @IsActiveShift = (SELECT TOP 1 IsActiveShift FROM @ModeConfig)
	SET @ConsiderPunchCard = (SELECT TOP 1 PunchCardBased FROM @ModeConfig)
	SET @ConsiderShift = (SELECT TOP 1 ShiftBased FROM @ModeConfig)
	SET @ConsiderPunchCard = (SELECT TOP 1 PunchCardBased FROM @ModeConfig)
	SET @ModeTypeEnum = (SELECT TOP 1 ModeTypeEnum FROM @ModeConfig)

	SET @UserId  = @OperationsPerformedBy
	SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] (NOLOCK) WHERE Id = @UserId)

	IF((@UserId IS NULL OR @UserId = @EmptyGuid) AND (SELECT COUNT(*) FROM [User] (NOLOCK) WHERE DesktopId = @DesktopId) = 0)
	BEGIN
		INSERT INTO @TrackerConfig 
		(
			ScreenShotFrequency,ScreenShotMultiplier,IsScreenShot,	IsKeyBoardTracking,	IsMouseTracking,	IsTrack,TrackApps,CanInsert,DisableUrls,
			ActivityToken,LastHeartBeatTime,ConsiderPunchCard,TrackOnlyTime,IsTracking,OffSet,IpAddress,TimeZone,OfflineTracking,IsBasicTracking,ModeTypeEnum,ActiveUserId,DeviceId,CompanyInActive,RandomScreenshot,AllowedIdleTime
		) 
		VALUES 
		(
			1, --ScreenShotFrequency
			1, --ScreenShotMultiplier
			0, --IsScreenShot
			1, --IsKeyBoardTracking
			1, --IsMouseTracking
			0, --IsTrack
			0, --TrackApps
			CASE WHEN (DATEDIFF(MINUTE,(SELECT TOP(1) LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = CONVERT(DATE,GETDATE()) ORDER BY LastActiveDateTime DESC),@Time)) < 3 THEN 1 ELSE 0 END, --CanInsert
			1, --DisableUrls
			(SELECT TOP 1 ActivityToken FROM UserActivityToken (NOLOCK) WHERE DesktopId = @DesktopId ORDER BY UpdatedDateTime DESC), --ActivityToken
			(SELECT TOP 1 LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = CAST(GETDATE() AS DATE) ORDER BY LastActiveDateTime DESC), --LastHeartBeatTime
			0, --ConsiderPunchCard
			1, --TrackOnlyTime
			0, --IsTracking
			(SELECT TOP 1 OffSet FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date), --OffSet
			(SELECT TOP 1 IpAddress FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date), --IpAddress
			(SELECT TOP 1 TimeZone FROM TimeZone WHERE Id = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date)), --TimeZone
			0, --OfflineTracking
			1, --IsBasicTracking
			1, --ModeTypeEnum
			NULL, --ActiveUserId
			CASE WHEN (SELECT TOP 1 DesktopDeviceId FROM ActivityTrackerDesktop WHERE @DeviceId = DesktopDeviceId AND InActiveDateTime IS NULL) IS NOT NULL THEN @DeviceId ELSE NULL END, --DeviceId
			0, --CompanyInActive
			0, --RandomScreenshot
			0 --AllowedIdleTime
		)

		RETURN 
	END
	ELSE IF(@UserId IS NULL OR @UserId = @EmptyGuid)
	BEGIN
		INSERT INTO @TrackerConfig 
		(
			ScreenShotFrequency,ScreenShotMultiplier,IsScreenShot,	IsKeyBoardTracking,	IsMouseTracking,	IsTrack,TrackApps,CanInsert,DisableUrls,
			ActivityToken,LastHeartBeatTime,ConsiderPunchCard,TrackOnlyTime,IsTracking,OffSet,IpAddress,TimeZone,OfflineTracking,IsBasicTracking,RandomScreenshot,AllowedIdleTime
		) 
		VALUES 
		(
			1, -- ScreenShotFrequency
			1, --ScreenShotMultiplier
			0, --IsScreenShot
			0, --IsKeyBoardTracking
			0, --IsMouseTracking
			0, --IsTrack
			0, --TrackApps
			0, --CanInsert
			0, --DisableUrls
			'', --ActivityToken
			NULL, --LastHeartBeatTime
			0, --ConsiderPunchCard
			0, --TrackOnlyTime
			0, --IsTracking
			0, --OffSet
			'', --IpAddress
			'', --TimeZone
			0, --OfflineTracking
			0, --IsBasicTracking
			0, --RandomScreenshot
			0 -- AllowedIdleTime
		)

		RETURN
	END

	DECLARE @ScreenShotFrequency INT
	DECLARE @ScreenShotMultiplier INT
	DECLARE @IsScreenShot BIT
	DECLARE @IsKeyBoardTracking BIT
	DECLARE @IsMouseTracking BIT
	DECLARE @IsTrack BIT
	DECLARE @TrackApps BIT
	DECLARE @CanInsert BIT
	DECLARE @DisableUrls BIT
	DECLARE @ActivityToken NVARCHAR(800)
	DECLARE @LastHeartBeatTime DATETIME
	DECLARE @Temp DATETIME
	DECLARE @TrackOnlyTime BIT
	DECLARE @IsTracking BIT
	DECLARE @OffSet INT
	DECLARE @IpAddress NVARCHAR(255)
	DECLARE @TimeZone NVARCHAR(100)
	DECLARE @OfflineTracking BIT
	DECLARE @IsBasicTracking BIT
	DECLARE @TimeZoneName NVARCHAR(255)
	DECLARE @TimeZoneAbbrevation NVARCHAR(255)
	DECLARE @DeviceIdInDb NVARCHAR(500)
	DECLARE @CompanyInActive BIT
	DECLARE @RandomScreenshot BIT
	DECLARE @AllowedIdleTime INT

	DECLARE @TrackStatusId TABLE
	(
		Id UNIQUEIDENTIFIER
	)

	SET @ActivityToken = (SELECT TOP 1 ActivityToken FROM UserActivityToken (NOLOCK) WHERE UserId = @UserId ORDER BY UpdatedDateTime DESC)

	SET @OfflineTracking = ISNULL((SELECT TOP(1) IsOfflineTracking FROM ActivityTrackerRolePermission (NOLOCK) AS A
																JOIN UserRole AS UR ON UR.RoleId = A.RoleId AND A.RoleId IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@UserId))
																		AND UR.InactiveDateTime IS NULL
																			 WHERE CompanyId = @CompanyId
																			 ORDER BY IsOfflineTracking DESC), 0)

	DECLARE @TimeZoneId UNIQUEIDENTIFIER 
    SET @TimeZoneId = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId ORDER BY [Date] DESC)
	SET @TimeZone = (SELECT TOP 1 TimeZone FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId)
	SET @OffSet = (SELECT TOP 1 OffsetMinutes FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId)
    SET @IpAddress = (SELECT TOP 1 IpAddress FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId ORDER BY [Date] DESC)
	SET @TimeZoneAbbrevation = (SELECT TOP 1 TimeZoneAbbreviation FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId)
	SET @TimeZoneName = (SELECT TOP 1 TimeZoneName FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId)
	SET @DeviceIdInDb = (SELECT TOP 1 DesktopDeviceId FROM ActivityTrackerDesktop (NOLOCK) WHERE Id = (SELECT TOP 1 DesktopId FROM [User] WHERE Id = @UserId))
	SET @RandomScreenshot = ISNULL((SELECT TOP(1) RandomScreenshot FROM ActivityTrackerScreenShotFrequency WHERE ComapnyId = @CompanyId), 0)

	DECLARE @CompanyStatus TABLE
	(
		TrailVersion BIT,
		PaidVersion BIT,
		Expired BIT
	)
	INSERT INTO @CompanyStatus (TrailVersion, PaidVersion, Expired)
	SELECT TrailVersion, PaidVersion, Expired FROM dbo.Ufn_GetCompanyStatus(@CompanyId)

	IF(
			(
				(SELECT TOP 1 TrailVersion FROM @CompanyStatus) = 1
				OR 
				(SELECT TOP 1 PaidVersion FROM @CompanyStatus) = 1
			)
			AND (SELECT TOP 1 Expired FROM @CompanyStatus) = 0 
		)
	BEGIN
		SET @CompanyInActive = 0
	END
	ELSE
	BEGIN
		SET @CompanyInActive = 1
	END

	DECLARE @UserTrack BIT = ISNULL((SELECT TOP 1 TrackEmployee FROM Employee WHERE UserId = @UserId AND InActiveDateTime IS NULL), 0)
						
	DECLARE @TrackId UNIQUEIDENTIFIER = (SELECT TOP 1 ActivityTrackerAppUrlTypeId FROM ActivityTrackerUserConfiguration (NOLOCK) AS A
		WHERE UserId = @UserId AND A.ActivityTrackerAppUrlTypeId <> (SELECT TOP 1 Id FROM ActivityTrackerAppUrlType (NOLOCK) WHERE AppURL = 'Off') ORDER BY UpdatedDateTime DESC)
	DECLARE @IsOff BIT
	DECLARE @ScreenshotTime INT
	SET @DisableUrls = 1
	SET @IsBasicTracking = (SELECT TOP 1 IsBasicTracking FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
	SET @LastHeartBeatTime = (SELECT TOP 1 LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId AND [Date] = CAST(GETDATE() AS DATE) ORDER BY LastActiveDateTime DESC)

	IF(@UserTrack = 1)
	BEGIN
		SET @IsOff = (CASE WHEN @UserTrack = 1 AND @TrackId IS NOT NULL THEN 0 ELSE 1 END)

		IF(CHARINDEX('url',(SELECT TOP 1 AppURL FROM ActivityTrackerAppUrlType WHERE Id = @TrackId)) > 0)
		BEGIN
			SET @DisableUrls = 0
		END
		
		SET @ScreenshotTime = (SELECT TOP(1) ScreenShotFrequency FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId AND InActiveDateTime IS NULL)
		SET @Screenshotfrequency = (SELECT TOP(1) Multiplier FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId AND InActiveDateTime IS NULL)
		SET @IsScreenshot = (SELECT TOP(1) IsScreenshot FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId AND InActiveDateTime IS NULL)

		SET @TrackApps = (CASE WHEN @IsOff = 0 THEN 1 ELSE 0 END)
		SET @ScreenShotMultiplier = @Screenshotfrequency
		SET @ScreenShotFrequency = @ScreenshotTime
		SET @IsScreenShot = @IsScreenshot

		SET @IsTrack  = 
			(SELECT TOP 1 IsTrack FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId)
		SET @IsKeyBoardTracking  = 
			(SELECT TOP 1 IsKeyboardTracking FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId)
		SET @IsMouseTracking  = 
			(SELECT TOP 1 IsMouseTracking FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId)
							
	END
	ELSE
	BEGIN
		INSERT INTO @TrackStatusId (Id)
		SELECT DISTINCT ActivityTrackerAppUrlTypeId FROM ActivityTrackerRoleConfiguration (NOLOCK) AS A 
						JOIN [User] AS U ON U.CompanyId = A.ComapnyId
						JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
						WHERE U.Id = @UserId AND A.ComapnyId = @CompanyId AND A.ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType (NOLOCK) WHERE AppURL = 'Off')

		SET @IsOff = (CASE WHEN (SELECT COUNT(Id) FROM @TrackStatusId) >= 1 
								THEN 0
								ELSE 1 END
								)

		IF
		(
			(SELECT TOP 1 AppURL FROM ActivityTrackerAppUrlType ATA
			JOIN @TrackStatusId TS ON TS.Id = ATA.Id
			WHERE CHARINDEX('url', AppURL) > 0) IS NOT NULL
		)
		BEGIN
			SET @DisableUrls = 0
		END

		SET @ScreenshotTime = (SELECT TOP(1) ScreenShotFrequency FROM ActivityTrackerScreenShotFrequency (NOLOCK) AS A
																JOIN [User] AS U ON U.CompanyId = A.ComapnyId
																JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
																WHERE U.Id = @UserId
																ORDER BY ScreenShotFrequency , Multiplier DESC)

							

		SET @Screenshotfrequency = (SELECT TOP(1) Multiplier FROM ActivityTrackerScreenShotFrequency (NOLOCK) AS A
																	JOIN [User] AS U ON U.CompanyId = A.ComapnyId
																	JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
																	WHERE U.Id = @UserId
																	ORDER BY ScreenShotFrequency , Multiplier DESC)

		SET @TrackApps = (CASE WHEN @IsOff = 0 THEN 1 ELSE 0 END)
		SET @ScreenShotMultiplier = @Screenshotfrequency
		SET @ScreenShotFrequency = @ScreenshotTime
		SET @IsScreenShot = (SELECT TOP 1 IsScreenshot FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
		SET @IsTrack = (SELECT TOP 1 IsTracking FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)

		DECLARE @KeyBoard BIT = (SELECT TOP 1 IsRecord FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
		DECLARE @KeyBoardRecordRoles BIT = (SELECT TOP 1 RecordRoles FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)

		IF(@KeyBoard = 1 AND @KeyBoardRecordRoles = 1)
		BEGIN
			SET @IsKeyBoardTracking  = 
				ISNULL((SELECT TOP 1 IsRecordActivity FROM ActivityTrackerRolePermission (NOLOCK) ATR
				JOIN [UserRole] UR ON UR.RoleId = ATR.RoleId AND UR.InactiveDateTime IS NULL
				JOIN [User] U ON U.Id = UR.UserId AND U.Id = @UserId
				ORDER BY IsRecordActivity DESC),0)
		END
		ELSE
		BEGIN
			SET @IsKeyBoardTracking  = 
			(SELECT TOP 1 IsRecord FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
		END

		DECLARE @Mouse BIT = (SELECT TOP 1 IsMouse FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
		DECLARE @MouseRoles BIT = (SELECT TOP 1 MouseRoles FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId)
		IF(@Mouse = 1 AND @MouseRoles = 1)
		BEGIN
			SET @IsMouseTracking  = 
				ISNULL((SELECT TOP 1 IsMouseTracking FROM ActivityTrackerRolePermission (NOLOCK) ATR
				JOIN [UserRole] UR ON UR.RoleId = ATR.RoleId AND UR.InactiveDateTime IS NULL
				JOIN [User] U ON U.Id = UR.UserId AND U.Id = @UserId
				ORDER BY IsMouseTracking DESC), 0)
		END
		ELSE
		BEGIN
			SET @IsMouseTracking = @Mouse
		END
	END
	

	DECLARE @ActiveTime DATETIME
	DECLARE @TimeDiff INT

	--SET @ConsiderPunchCard = (SELECT TOP 1 ConsiderPunchCard FROM ActivityTrackerRoleConfiguration AS A 
     --                   JOIN [User] AS U ON U.CompanyId = A.ComapnyId
     --                   JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
     --                   WHERE U.Id = @UserId AND A.ComapnyId = @CompanyId
     --                   ORDER BY ConsiderPunchCard DESC)
	DECLARE @CurrentClientDate DATETIME
    SET @CurrentClientDate = DATEADD(MINUTE, CASE WHEN @Offset IS NOT NULL THEN @Offset ELSE 0 END,@Time) 
	IF(@ConsiderShift = 1)
	BEGIN
		SET @CanInsert = CASE WHEN @IsActiveShift = 1 THEN 1 ELSE 0 END
	END
	ELSE IF((@ConsiderPunchCard = 0 OR @ConsiderPunchCard IS NULL) AND (@ConsiderShift = 0 OR @ConsiderShift IS NULL))
	BEGIN
		SET @ActiveTime = (SELECT TOP(1) LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@CurrentClientDate) ORDER BY LastActiveDateTime DESC)

		SET @TimeDiff = (DATEDIFF(MINUTE,@ActiveTime,@Time))
		SET @CanInsert = CASE WHEN @TimeDiff < 3 OR @SkipTimeCheck = 1 THEN 1 ELSE 0 END
	END
	ELSE
	BEGIN
		SET @ActiveTime = (SELECT TOP(1) LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId AND [Date] = CONVERT(DATE,@CurrentClientDate) ORDER BY LastActiveDateTime DESC)

		SET @TimeDiff = (DATEDIFF(MINUTE,@ActiveTime,@Time))

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
											AND (@TimeDiff  < 3 OR @SkipTimeCheck = 1)
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
											AND (@TimeDiff  < 3 OR @SkipTimeCheck = 1)
											)
		END

		
					
			SET @CanInsert = (CASE WHEN @Temp IS NOT NULL AND @Temp <> '' THEN 1 ELSE 0 END)
	END

    DECLARE @CanTrackProcess BIT = IIF((@IsTrack = 1 AND @TrackApps = 1 AND @CanInsert = 1), 1, 0)
    SET @TrackOnlyTime = IIF(((@IsMouseTracking = 1 OR @IsKeyBoardTracking = 1) AND @CanTrackProcess = 0), 1, 0)

	SET @IsTracking = CASE WHEN 
									@CanInsert = 1 
									AND 
									(
										(@IsTrack = 1 AND @TrackApps = 1)
										OR @IsMouseTracking = 1
										OR @IsKeyBoardTracking = 1
										OR @IsScreenShot = 1
									)
									THEN 1 ELSE 0 END
	
	SET @AllowedIdleTime = ISNULL((SELECT MIN(MinimumIdelTime) AS MinimumIdelTime 
							FROM ActivityTrackerRolePermission ATR
							    INNER JOIN UserRole UR ON UR.RoleId = ATR.RoleId
									AND UR.InactiveDateTime IS NULL
									AND UR.UserId = @UserId
							        AND ATR.InActiveDateTime IS NULL
							WHERE ATR.CompanyId = @CompanyId),5)

	INSERT INTO @TrackerConfig 
	(
		ScreenShotFrequency,
		ScreenShotMultiplier,
		IsScreenShot,
		IsKeyBoardTracking,
		IsMouseTracking,
		IsTrack,
		TrackApps,
		CanInsert,
		DisableUrls,
		ActivityToken,
		LastHeartBeatTime,
		ConsiderPunchCard,
		TrackOnlyTime,
		IsTracking,
		OffSet,
		IpAddress,
		TimeZone,
		OfflineTracking,
		IsBasicTracking,
		IsActiveShift,
		ModeTypeEnum,
		ActiveUserId,
		TimeZoneName,
		TimeZoneAbbrevation,
		DeviceId,
		CompanyInActive,
		RandomScreenshot,
		AllowedIdleTime
	) 
	VALUES 
	(
		@ScreenShotFrequency,
		@ScreenShotMultiplier,
		@IsScreenShot,
		@IsKeyBoardTracking,
		@IsMouseTracking,
		@IsTrack,
		@TrackApps,
		@CanInsert,
		@DisableUrls,
		@ActivityToken,
		@LastHeartBeatTime,
		@ConsiderPunchCard,
		@TrackOnlyTime,
		@IsTracking,
		@OffSet,
		@IpAddress,
		@TimeZone,
		@OfflineTracking,
		@IsBasicTracking,
		@IsActiveShift,
		@ModeTypeEnum,
		CASE WHEN @UserId = @EmptyGuid THEN NULL ELSE @UserId END,
		@TimeZoneName,
		@TimeZoneAbbrevation,
		@DeviceIdInDb,
		@CompanyInActive,
		@RandomScreenshot,
		@AllowedIdleTime
	)
	
	RETURN
END
GO