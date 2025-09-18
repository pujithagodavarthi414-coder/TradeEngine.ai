CREATE PROCEDURE [dbo].[USP_GetChatActivityTrackerRecorder](
@isSingle BIT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
	 SET NOCOUNT ON
		BEGIN TRY
			IF (@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedBy)

			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				RAISERROR(50011,11,2,'OperationsPerformedBy')
			END

			ELSE
			BEGIN
			  	
				DECLARE @HavePermission NVARCHAR(250)  = '1' --(SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
						 
				 IF (@HavePermission = '1')
				 BEGIN	
				 
				 DECLARE @IsActivityStatusUpdated BIT = 1
				 
				 CREATE TABLE #Users
				 (
					Id INT IDENTITY(1,1),
					UserId UNIQUEIDENTIFIER,
					MACAddress NVARCHAR(12),
					[Status] BIT
				 )

				 INSERT INTO #Users(UserId)
				 SELECT Id FROM [User] WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL
				 
				 DECLARE @MaxCount INT, @Counter INT = 1
				 SELECT @MaxCount = COUNT(1) FROM #Users

				 WHILE(@Counter <= @MaxCount)
				 BEGIN

					DECLARE @Id UNIQUEIDENTIFIER = (SELECT UserId FROM #Users WHERE Id = @Counter)

					DECLARE @MACAddress NVARCHAR(12) = (SELECT TOP(1) UM.MACAddress FROM [User] AS U JOIN 
																				  UserMAC AS UM ON U.Id = UM.UserId AND UM.InActiveDateTime IS NULL 
																				  WHERE U.CompanyId = @CompanyId AND U.Id = @Id)

					DECLARE @Temp DATETIME

					IF(@MACAddress IS NOT NULL AND ( @MACAddress <> '' OR @MACAddress <> ' ') )
					BEGIN
						--DECLARE @TrackStatusId UNIQUEIDENTIFIER = (SELECT DISTINCT ActivityTrackerAppUrlTypeId FROM ActivityTrackerRoleConfiguration AS A 
						--																					   JOIN [User] AS U ON U.CompanyId = A.ComapnyId
						--																					   JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId
						--																					   JOIN UserMAC AS UM ON UM.UserId = U.Id AND UM.CompanyId = U.CompanyId
						--																					   WHERE UM.MACAddress = @MACAddress AND UM.UserId = @Id
						--																							 AND UM.InActiveDateTime IS NULL)

						--DECLARE @IsOff BIT = (CASE WHEN @TrackStatusId = (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off') 
						--								THEN 1
						--								ELSE 0 END
						--								)
						DECLARE @TrackStatusId TABLE
						(
						 Id UNIQUEIDENTIFIER
						)
						
						INSERT INTO @TrackStatusId (Id)
						SELECT DISTINCT ActivityTrackerAppUrlTypeId FROM ActivityTrackerRoleConfiguration AS A 
										JOIN [User] AS U ON U.CompanyId = A.ComapnyId
										JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
										JOIN UserMAC AS UM ON UM.UserId = U.Id AND UM.CompanyId = U.CompanyId
										WHERE UM.MACAddress = @MACAddress AND A.ComapnyId = @CompanyId AND A.ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off')

						DECLARE @IsOff BIT = (CASE WHEN (SELECT COUNT(Id) FROM @TrackStatusId) >= 1
													THEN 0
													ELSE 1 END
													)

						DECLARE @ScreenshotTime INT = (SELECT TOP(1) ScreenShotFrequency FROM ActivityTrackerScreenShotFrequency AS A
																					JOIN [User] AS U ON U.CompanyId = A.ComapnyId
																					JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
																					WHERE U.Id = @Id
																					ORDER BY ScreenShotFrequency , Multiplier DESC)

						DECLARE @Screenshotfrequency INT = (SELECT TOP(1) Multiplier FROM ActivityTrackerScreenShotFrequency AS A
																					JOIN [User] AS U ON U.CompanyId = A.ComapnyId
																					JOIN UserRole AS UR ON UR.UserId = U.Id AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
																					WHERE U.Id = @Id
																					ORDER BY ScreenShotFrequency , Multiplier DESC)

						DECLARE @IsScreenshot BIT = ( CASE WHEN @ScreenshotTime = 0 OR @Screenshotfrequency = 0 OR @ScreenshotTime IS NULL OR @Screenshotfrequency IS NULL
														 THEN 1
														 ELSE 0 END )
					
						DECLARE @Time DATETIME = GETUTCDATE()

						DECLARE @Date DATE = GETUTCDATE()

						IF(@IsOff = 0 OR @IsScreenshot = 0)
						BEGIN

						DECLARE @ActiveTime DATETIME = (SELECT TOP(1) LastActiveDateTime FROM ActivityTrackerStatus WHERE UserId = @Id AND [Date] = CONVERT(DATE,GETDATE()) ORDER BY ActivityTrackerStartTime,LastActiveDateTime DESC)

						DECLARE @TimeDiff INT = (DATEDIFF(MINUTE,@ActiveTime,@Time))

							IF(@isSingle IS NULL)
							BEGIN

								SET @Temp = ( SELECT @Time FROM TimeSheet AS TS WHERE @Time > TS.InTime AND (@Time <= TS.OutTime OR TS.OutTime IS NULL)
																  AND(  TS.LunchBreakStartTime IS NULL OR ( @Time >= TS.LunchBreakEndTime ))--OR TS.LunchBreakEndTime IS NULL) )
																  AND @Time NOT IN (SELECT @Time
																							FROM [UserBreak] UB WHERE
																							((@Time BETWEEN BreakIn AND BreakOut) OR (@Time>=BreakIn AND BreakOut IS NULL)) AND UB.UserId = @Id
																							AND Date = @Date
																							)
																  AND TS.UserId = @Id AND TS.Date = @Date AND @TimeDiff  < 2)

							END
							ELSE
							BEGIN

								SET @Temp = ( SELECT @Time FROM TimeSheet AS TS WHERE @Time > TS.InTime AND (@Time <= TS.OutTime OR TS.OutTime IS NULL)
																  AND(  TS.LunchBreakStartTime IS NULL OR ( @Time >= TS.LunchBreakEndTime ))--OR TS.LunchBreakEndTime IS NULL) )
																  AND @Time NOT IN (SELECT @Time
																							FROM [UserBreak] UB WHERE
																							((@Time BETWEEN BreakIn AND BreakOut) OR (@Time>=BreakIn AND BreakOut IS NULL)) AND UB.UserId = @Id
																							AND Date = @Date
																							)
																  AND TS.UserId = @Id AND TS.Date = @Date )

							END
						END
						--IF(@IsOff = 1)
						--BEGIN
						
						--	SET @Temp = ''

						--END
					END
					ELSE
					BEGIN
						SET @Temp = ''
					END
					DECLARE @StatusId BIT 
					SET @StatusId= (SELECT 0 AS IsTracking where @Temp = '' OR @Temp IS NULL
									UNION
									SELECT 1 AS IsTracking WHERE @Temp IS NOT NULL AND @Temp <> '')

					UPDATE #Users SET [Status] = @StatusId,[MACAddress] = @MACAddress WHERE Id = @Counter

					SET @Counter = @Counter + 1
				 END

				END
				 ELSE
				 BEGIN
				   
				   		RAISERROR (@HavePermission,11, 1)
				 END
		    END

			SELECT UserId AS ReceiverUserId,[Status] AS ActivityTrackerStatus,[MACAddress] AS MACAddress,@IsActivityStatusUpdated AS IsActivityStatusUpdated FROM #Users
		END TRY
		
		BEGIN CATCH
        
		    THROW

	    END CATCH
END