--EXEC [USP_GetActivityTrackerRecorderForTracker] NULL,NULL,'hqkoI_3ucIKcivJR3CWZ_DEKOOQ22LroEq2udgqyZsE','2021-03-15','2021-03-15'
--EXEC [USP_GetActivityTrackerRecorderForTracker] '142A0903-3567-4E29-96A9-ACB0824A9E8E',NULL,NULL,'2021-03-15','2021-03-15'

CREATE PROCEDURE [dbo].[USP_GetActivityTrackerRecorderForTracker]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@Mac XML = NULL,
	@DeviceId NVARCHAR(500) = NULL,
	@Time DATETIME,
	@Date DATE,
	@OSName nvarchar(250),
	@OSVersion nvarchar(150),
	@Platform nvarchar(50),
	@TimeChampVersion nvarchar(50)
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
		BEGIN TRY

			DECLARE @CompanyId UNIQUEIDENTIFIER,
							@UserId UNIQUEIDENTIFIER,
							@EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
							@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop (NOLOCK) WHERE DesktopDeviceId = @DeviceId)

			
			UPDATE [ActivityTrackerDesktop] SET TimechampVersion = @TimeChampVersion, 
												[Platform] = @Platform, 
												OSName = @OSName,
												OSVersion = @OSVersion
												WHERE DesktopDeviceId = @DeviceId

			DECLARE @ConsiderPunchCard BIT
			DECLARE @ConsiderShift BIT
			DECLARE @IsActiveShift BIT
			DECLARE @ModeTypeEnum INT
			DECLARE @OffsetMinutes INT = (SELECT OffsetMinutes FROM Timezone WHERE Id = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE [Date] = CAST(@Time AS DATE)))
			DECLARE @TimeNow TIME = CAST(@Time AS TIME)

			IF(@OperationsPerformedBy = @EmptyGuid OR @OperationsPerformedBy IS NULL)
			BEGIN
		
				SELECT CASE WHEN @TimeNow >= SW.StartTime AND @TimeNow <= SW.EndTime THEN 1 ELSE 0 END AS IsActiveShift,U.Id AS UserId
				INTO #ShiftDetailes
				FROM ActivityTrackerDesktop ATD 
				INNER JOIN [User] U ON U.DesktopId = ATD.Id AND U.InActiveDateTime IS NULL
				INNER JOIN Employee E ON E.UserId = U.Id
				INNER JOIN  EmployeeShift ES ON ES.EmployeeId = E.Id
				INNER JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId
				INNER JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ST.Id
				LEFT JOIN [ShiftException] SE ON SE.ShiftTimingId = ST.Id
				WHERE U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
				--AND U.CompanyId = '56142756-6724-4f63-b9b3-7f4db717363d'
				AND ATD.DesktopDeviceId = @DeviceId
				AND  SW.[DayOfWeek] = DATENAME(dw, DATEADD(MINUTE,CASE WHEN @OffsetMinutes IS NULL THEN 0 ELSE @OffsetMinutes END,@Time))

				SELECT  TOP 1 @OperationsPerformedBy = U.Id,@IsActiveShift = ISNULL(SD.IsActiveShift,0)
				        ,@ConsiderPunchCard = AR.PunchCardBased,@ConsiderShift = AR.ShiftBased
						,@ModeTypeEnum = ATM.ModeTypeEnum
				FROM ActivityTrackerDesktop ATD 
				INNER JOIN [User] U ON U.DesktopId = ATD.Id AND U.InActiveDateTime IS NULL
				INNER JOIN UserRole UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
				INNER JOIN (SELECT * FROM ActivityTrackerModeConfiguration A CROSS APPLY STRING_SPLIT(A.Roles,',') ) AR ON AR.value = UR.RoleId
				INNER JOIN ActivityTrackerMode ATM ON ATM.Id = AR.ModeId
				LEFT JOIN #ShiftDetailes SD ON SD.UserId = U.Id
				WHERE ATD.DesktopDeviceId = @DeviceId
				ORDER BY ModeTypeEnum DESC, ShiftBased DESC ,SD.IsActiveShift DESC

				IF(@OperationsPerformedBy IS NULL)
				BEGIN

					SET @OperationsPerformedBy = @EmptyGuid
		
				END

			END
			ELSE
			BEGIN

				SELECT @IsActiveShift = CASE WHEN @TimeNow >= SW.StartTime AND @TimeNow <= SW.EndTime THEN 1 ELSE 0 END
				FROM Employee E --ON E.UserId = U.Id
				INNER JOIN  EmployeeShift ES ON ES.EmployeeId = E.Id
				INNER JOIN [ShiftTiming] ST ON ST.Id = ES.ShiftTimingId
				INNER JOIN [ShiftWeek] SW ON SW.ShiftTimingId = ST.Id
				LEFT JOIN [ShiftException] SE ON SE.ShiftTimingId = ST.Id
				WHERE E.UserId = @OperationsPerformedBy
				--AND U.CompanyId = '56142756-6724-4f63-b9b3-7f4db717363d'
				AND  SW.[DayOfWeek] = DATENAME(dw, DATEADD(MINUTE,CASE WHEN @OffsetMinutes IS NULL THEN 0 ELSE @OffsetMinutes END,@Time))
				
				SET @IsActiveShift = ISNULL(@IsActiveShift,0)

				SELECT TOP 1 @ConsiderPunchCard = AR.PunchCardBased,@ConsiderShift = AR.ShiftBased
						,@ModeTypeEnum = ATM.ModeTypeEnum
                FROM UserRole UR 
                INNER JOIN (SELECT * FROM ActivityTrackerModeConfiguration A CROSS APPLY STRING_SPLIT(A.Roles,',') ) AR ON AR.value = UR.RoleId
                INNER JOIN ActivityTrackerMode ATM ON ATM.Id = AR.ModeId
                WHERE  UR.InactiveDateTime IS NULL
                AND UR.UserId = @OperationsPerformedBy
                ORDER BY UR.RoleId

			END

			SET @UserId  = @OperationsPerformedBy
			SET @CompanyId = (SELECT TOP 1 CompanyId FROM [User] (NOLOCK) WHERE Id = @UserId)

			IF((@UserId IS NULL OR @UserId = @EmptyGuid) AND (SELECT COUNT(*) FROM [User] (NOLOCK) WHERE DesktopId = @DesktopId) = 0)
			BEGIN

				SELECT 1 AS ScreenShotFrequency,
					1 AS ScreenShotMultiplier,
					0 AS IsScreenShot,
					1 AS IsKeyBoardTracking,
					1 AS IsMouseTracking,
					0 AS IsTrack,
					0 AS TrackApps,
					CASE WHEN (DATEDIFF(MINUTE,(SELECT TOP(1) LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = CONVERT(DATE,GETDATE()) ORDER BY LastActiveDateTime DESC),@Time)) < 11 THEN 1 ELSE 0 END AS CanInsert,
					1 AS DisableUrls,
					(SELECT TOP 1 ActivityToken FROM UserActivityToken (NOLOCK) WHERE DesktopId = @DesktopId ORDER BY UpdatedDateTime DESC) AS ActivityToken,
					(SELECT TOP 1 LastActiveDateTime FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = CAST(GETDATE() AS DATE) ORDER BY LastActiveDateTime DESC) AS LastHeartBeatTime,
					0 AS ConsiderPunchCard,
					1 AS TrackOnlyTime,
					0 AS IsTracking,
					(SELECT TOP 1 OffSet FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date) AS OffSet,
					(SELECT TOP 1 IpAddress FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date) AS IpAddress,
					(SELECT TOP 1 TimeZone FROM TimeZone WHERE Id = (SELECT TOP 1 TimeZoneId FROM ActivityTrackerStatus (NOLOCK) WHERE DesktopId = @DesktopId AND [Date] = @Date)) AS TimeZone,
					0 AS OfflineTracking,
					1 AS IsBasicTracking,
					1 AS ModeTypeEnum,
					NULL AS ActiveUserId,
					CASE WHEN (SELECT TOP 1 DesktopDeviceId FROM ActivityTrackerDesktop WHERE @DeviceId = DesktopDeviceId AND InActiveDateTime IS NULL) IS NOT NULL THEN @DeviceId ELSE NULL END AS DeviceId,
					0 AS CompanyInActive,
					0 AS RandomScreenshot,
					0 AS AllowedIdleTime,
					0 AS IsTimesheetActive

			END
			ELSE IF(@UserId IS NULL OR @UserId = @EmptyGuid)
			BEGIN

				SELECT 1 AS  ScreenShotFrequency
					,1 AS ScreenShotMultiplier
					,0 AS IsScreenShot
					,0 AS IsKeyBoardTracking
					,0 AS IsMouseTracking
					,0 AS IsTrack
					,0 AS TrackApps
					,0 AS CanInsert
					,0 AS DisableUrls
					,'' AS ActivityToken
					,NULL AS LastHeartBeatTime
					,0 AS ConsiderPunchCard
					,0 AS TrackOnlyTime
					,0 AS IsTracking
					,0 AS OffSet
					,'' AS IpAddress
					,'' AS TimeZone
					,0 AS OfflineTracking
					,0 AS IsBasicTracking
					,0 AS RandomScreenshot
					,0 AS AllowedIdleTime
					,0 AS IsTimesheetActive

			END
			ELSE
			BEGIN

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
				SELECT TOP 1 @TimeZoneId = TimeZoneId ,@IpAddress = IpAddress 
				FROM ActivityTrackerStatus (NOLOCK) WHERE UserId = @UserId ORDER BY [Date] DESC

				SELECT TOP 1 @TimeZone = TimeZone, @OffSet = OffsetMinutes, @TimeZoneAbbrevation = TimeZoneAbbreviation
				              ,@TimeZoneName = TimeZoneName
				 FROM TimeZone (NOLOCK) WHERE Id = @TimeZoneId

				SET @DeviceIdInDb = CASE WHEN (@UserId IS NULL OR @UserId = @EmptyGuid) THEN (SELECT TOP 1 DesktopDeviceId FROM ActivityTrackerDesktop (NOLOCK) WHERE Id =  @DesktopId)
									ELSE (SELECT TOP 1 DesktopDeviceId FROM ActivityTrackerDesktop (NOLOCK) WHERE Id = (SELECT TOP 1 DesktopId FROM [User] WHERE Id = @UserId)) END

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
		
					SELECT TOP(1) @ScreenshotTime = ScreenShotFrequency, @Screenshotfrequency = Multiplier, @IsScreenshot = IsScreenshot
					FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId AND InActiveDateTime IS NULL

					SET @TrackApps = (CASE WHEN @IsOff = 0 THEN 1 ELSE 0 END)
					SET @ScreenShotMultiplier = @Screenshotfrequency
					SET @ScreenShotFrequency = @ScreenshotTime
					SET @IsScreenShot = @IsScreenshot

                    SELECT TOP 1 @IsTrack = IsTrack, @IsKeyBoardTracking = IsKeyboardTracking,@IsMouseTracking = IsMouseTracking			
					FROM ActivityTrackerUserConfiguration (NOLOCK) WHERE UserId = @UserId
						
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

					DECLARE @KeyBoard BIT,@KeyBoardRecordRoles BIT

					SELECT TOP(1) @ScreenshotTime = ScreenShotFrequency, @Screenshotfrequency = Multiplier
					FROM ActivityTrackerScreenShotFrequency (NOLOCK) AS A
																			JOIN [User] AS U ON U.CompanyId = A.ComapnyId
																			JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
																			WHERE U.Id = @UserId
																			ORDER BY ScreenShotFrequency , Multiplier DESC

					SET @TrackApps = (CASE WHEN @IsOff = 0 THEN 1 ELSE 0 END)
					SET @ScreenShotMultiplier = @Screenshotfrequency
					SET @ScreenShotFrequency = @ScreenshotTime

					SELECT TOP 1 @IsScreenShot = IsScreenshot
					             , @IsTrack = IsTracking, @KeyBoard = IsRecord
								 ,@KeyBoardRecordRoles = RecordRoles
					FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId

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

					DECLARE @Mouse BIT, @MouseRoles BIT
					
					SELECT TOP 1 @Mouse = IsMouse, @MouseRoles = MouseRoles FROM ActivityTrackerConfigurationState (NOLOCK) WHERE CompanyId = @CompanyId
					
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
	
				DECLARE @CurrentClientDate DATETIME
				SET @CurrentClientDate = DATEADD(MINUTE, CASE WHEN @Offset IS NOT NULL THEN @Offset ELSE 0 END,@Time) 
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
				
				DECLARE @IsTimesheetActive BIT = 0

				IF(EXISTS(SELECT 1 FROM TimeSheet TS 
						  WHERE CONVERT(DATE,DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = TS.InTimeTimeZone),CONVERT(DATETIME,TS.[Date]))) = CONVERT(DATE,@Time) 
						  AND USerId = @UserId
						  ))
				BEGIN

					SET @IsTimesheetActive = CASE WHEN (SELECT OutTime FROM TimeSheet TS WHERE USerId = @UserId AND CONVERT(DATE,DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = TS.InTimeTimeZone),CONVERT(DATETIME,TS.[Date]))) = CONVERT(DATE,@Time) AND InTime IS NOT NULL) IS NULL THEN 1 ELSE 0 END

				END
				ELSE IF(EXISTS(SELECT 1 FROM TimeSheet TS WHERE USerId = @UserId AND CONVERT(DATE,DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = TS.InTimeTimeZone),CONVERT(DATETIME,TS.[Date]))) = DATEADD(DAY,-1,CONVERT(DATE,@Time)) ))
				BEGIN
			
					SET @IsTimesheetActive = CASE WHEN (SELECT OutTime FROM TimeSheet TS WHERE USerId = @UserId AND CONVERT(DATE,DATEADD(MINUTE,(SELECT OffsetMinutes FROM TimeZone WHERE Id = TS.InTimeTimeZone),CONVERT(DATETIME,TS.[Date]))) = DATEADD(DAY,-1,CONVERT(DATE,@Time)) AND InTime IS NOT NULL) IS NULL THEN 1 ELSE 0 END

				END

				SELECT @ScreenShotFrequency AS ScreenShotFrequency,
					@ScreenShotMultiplier AS ScreenShotMultiplier,
					@IsScreenShot AS IsScreenShot,
					@IsKeyBoardTracking AS IsKeyBoardTracking,
					@IsMouseTracking AS IsMouseTracking,
					@IsTrack AS IsTrack,
					@TrackApps AS TrackApps,
					@CanInsert AS CanInsert,
					@DisableUrls AS DisableUrls,
					@ActivityToken AS ActivityToken,
					@LastHeartBeatTime AS LastHeartBeatTime,
					@ConsiderPunchCard AS ConsiderPunchCard,
					@TrackOnlyTime AS TrackOnlyTime,
					@IsTracking AS IsTracking,
					@OffSet AS OffSet,
					@IpAddress AS IpAddress,
					@TimeZone AS TimeZone,
					@OfflineTracking AS OfflineTracking,
					@IsBasicTracking AS IsBasicTracking,
					@IsActiveShift AS IsActiveShift,
					@ModeTypeEnum AS ModeTypeEnum,
					CASE WHEN @UserId = @EmptyGuid THEN NULL ELSE @UserId END AS ActiveUserId,
					@TimeZoneName AS TimeZoneName,
					@TimeZoneAbbrevation AS TimeZoneAbbrevation,
					@DeviceIdInDb AS DeviceId,
					@CompanyInActive AS CompanyInActive,
					@RandomScreenshot AS RandomScreenshot,
					@AllowedIdleTime AS AllowedIdleTime,
					@IsTimesheetActive AS IsTimesheetActive

			END

		END TRY
		BEGIN CATCH

		    THROW

	    END CATCH

END
GO