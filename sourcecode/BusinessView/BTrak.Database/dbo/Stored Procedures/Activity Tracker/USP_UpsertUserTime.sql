---------------------------------------------------------------------------------
---- Author       Praneeth Kumar Reddy Salukooti
---- Created      '2019-09-17 00:00:00.000'
---- Purpose      To Insert the User Activity Time
---- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
---------------------------------------------------------------------------------
----EXEC [dbo].[USP_UpsertUserTime] @UserTime = '
----<GenericListOfInsertUserActivityTimeInputModel>
----<ListItems>
----<InsertUserActivityTimeInputModel>
----	<InputCommandGuid>0ec93184-c5eb-4950-b23c-a60732193734</InputCommandGuid>
----	<InputCommandTypeGuid>66163cc9-360f-4617-83f8-d12244985d75</InputCommandTypeGuid>
----	<MacAddress>8C-EC-4B-C1-C7-69</MacAddress>
----	<ApplicationName> Visual Studio Code </ApplicationName>
----  <ApplicationStartTime>2019-09-13T12:05:12</ApplicationStartTime>
----  <ApplicationEndTime>2019-09-13T12:25:17</ApplicationEndTime>
----  <IdleTime>00:00:00</IdleTime>
----  <SpentTime>00:20:05</SpentTime>
----  <IsApp>1</IsApp>
----  <IsBackground>0</IsBackground>
----	<ActivityDate>2019-09-13T00:20:05</ActivityDate>
----</InsertUserActivityTimeInputModel>
----<InsertUserActivityTimeInputModel>
----	<InputCommandGuid>afacb429-f582-4145-ad04-6cb34a20d016</InputCommandGuid>
----	<InputCommandTypeGuid>66163cc9-360f-4617-83f8-d12244985d75</InputCommandTypeGuid>
----	<MacAddress>8C-EC-4B-C1-C7-69</MacAddress>
----	<ApplicationName> Stack Overflow </ApplicationName>
----  <ApplicationStartTime>2019-09-13T12:05:12</ApplicationStartTime>
----  <ApplicationEndTime>2019-09-13T12:25:17</ApplicationEndTime>
----  <IdleTime>00:06:00</IdleTime>
----  <SpentTime>00:10:05</SpentTime>
----  <IsApp>0</IsApp>
----  <IsBackground>0</IsBackground>
----	<ActivityDate>2019-09-17T00:10:05</ActivityDate>
----</InsertUserActivityTimeInputModel>
----</ListItems>
----</GenericListOfInsertUserActivityTimeInputModel>'

CREATE PROCEDURE [dbo].[USP_UpsertUserTime]
(
	@UserTime XML = NULL ,
    @MAC NVARCHAR(20) = '',
	@DeviceId NVARCHAR(500) = NULL,
	@IsArchive BIT = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY

		DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
						@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop WHERE DesktopDeviceId = @DeviceId)
		
		IF(@OperationsPerformedBy = @EmptyGuid OR @OperationsPerformedBy IS NULL)
		BEGIN
			SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				SET @OperationsPerformedBy = @EmptyGuid
			END
		END

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		IF(@CompanyId IS NULL OR @CompanyId = @EmptyGuid)
		BEGIN
			SET @CompanyId = (SELECT TOP 1 CompanyId FROM ActivityTrackerDesktop WHERE Id = @DesktopId)
		END
		
		DECLARE @UserId UNIQUEIDENTIFIER = @OperationsPerformedBy

		DECLARE @UserTrack BIT
		DECLARE @TrackId UNIQUEIDENTIFIER = NULL
		
		IF(@UserTime IS NOT NULL)
		BEGIN					
			
			IF(@IsArchive IS NULL) SET @IsArchive = 0

			DECLARE @CTE TABLE 
			(
				Id UNIQUEIDENTIFIER ,
				MACAddress NVARCHAR(20),
				UserId UNIQUEIDENTIFIER,
				CompanyId UNIQUEIDENTIFIER,
				ApplicationName NVARCHAR(800),
				AbsoluteAppName NVARCHAR(1000),
				ApplicationStartTime DATETIMEOFFSET,
				ApplicationEndTime  DATETIMEOFFSET,
				IdleTime DATETIME,
				TimeSpent DATETIME,
				OperationDate DATETIMEOFFSET,
				DateRank INT,
				IsApp BIT,
				IsBackground BIT
			)

			INSERT INTO @CTE (Id,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,IsBackground)
			
			SELECT	x.value('Id[1]','UNIQUEIDENTIFIER') Id,
					--x.value('MacAddress[1]','nvarchar(20)') MACAddress,
					--(SELECT UserId FROM UserMAC WHERE MACAddress = x.value('MacAddress[1]','nvarchar(20)') AND InActiveDateTime IS NULL) UserId,
					(SELECT U.CompanyId FROM [User] AS U JOIN [UserMAC] AS UM ON U.Id = UM.UserId WHERE UM.MACAddress = x.value('MacAddress[1]','nvarchar(20)')) CompanyId,
					x.value('ApplicationName[1]','nvarchar(800)') ApplicationName,
					x.value('AbsoluteAppName[1]','nvarchar(800)') AbsoluteAppName,
					x.value('ApplicationStartTime[1]', 'DATETIMEOFFSET') ApplicationStartTime,
					x.value('ApplicationEndTime[1]','DATETIMEOFFSET') ApplicationEndTime,
					x.value('IdleTime[1]','DATETIME') IdleTime,
					x.value('SpentTime[1]','DATETIME') AS TimeSpent,
					x.value('ActivityDate[1]','DATETIMEOFFSET') AS OperationDate,
					x.value('IsApp[1]','BIT') AS IsApp,
					x.value('IsBackground[1]','BIT') AS IsBackground
			FROM  @UserTime.nodes('/GenericListOfInsertUserActivityTimeInputModel/ListItems/InsertUserActivityTimeInputModel') XmlData(x)

			INSERT INTO [dbo].[ActivityTrackerApplicationUrl](Id,AppUrlName,ActivityTrackerAppUrlTypeId,CompanyId,CreatedByUserId,CreatedDateTime) 
			SELECT NEWID(),C.AbsoluteAppName,CASE WHEN C.IsApp = 1 THEN (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App') ELSE (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'URL') END
				   ,@CompanyId,@OperationsPerformedBy,GETDATE()
			FROM @CTE C 
			WHERE C.AbsoluteAppName NOT IN (SELECT A.AppUrlName FROM ActivityTrackerApplicationUrl A WHERE A.CompanyId = @CompanyId AND A.InActiveDateTime IS NULL)
			GROUP BY C.AbsoluteAppName,C.IsApp

			UPDATE @CTE SET MACAddress = @MAC

			DECLARE @TrackStatusId TABLE
			(
				Id UNIQUEIDENTIFIER
			)
			
			;WITH Temp AS 
			(
					SELECT DISTINCT RANK() OVER(PARTITION BY ApplicationName,ApplicationStartTime 
					ORDER BY ApplicationStartTime,ApplicationEndTime DESC) Repeated, * 
					FROM @CTE
			)
			SELECT T.Id,MACAddress,UserId,T.CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime
			      ,IdleTime,TimeSpent,OperationDate,IsApp,IsBackground
			INTO #CTEDummy
			FROM Temp AS T
			WHERE T.Repeated = 1
			
			UPDATE #CTEDummy SET UserId = @UserId, CompanyId = @CompanyId

			SET @UserTrack = ISNULL((SELECT TrackEmployee FROM Employee WHERE UserId = @UserId), 0)
			SET @TrackId = (SELECT TOP 1 ActivityTrackerAppUrlTypeId FROM ActivityTrackerUserConfiguration AS A
							WHERE UserId = @UserId AND A.ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off'))

			INSERT INTO @TrackStatusId (Id)
			SELECT DISTINCT ActivityTrackerAppUrlTypeId FROM ActivityTrackerRoleConfiguration AS A 
							JOIN [User] AS U ON U.CompanyId = A.ComapnyId AND U.InActiveDateTime IS NULL
							JOIN [UserRole] AS UR ON U.Id = UR.UserId AND UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
							WHERE U.Id = @UserId AND U.IsActive = 1 AND A.ComapnyId = @CompanyId AND U.CompanyId =  @CompanyId 
							AND A.ActivityTrackerAppUrlTypeId <> (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Off')

			DECLARE @IsOff BIT = (CASE WHEN ((SELECT COUNT(Id) FROM @TrackStatusId) >= 1 OR (@UserTrack = 1 AND @TrackId IS NOT NULL))
										THEN 0
										ELSE 1 END
										)

			IF(@UserId IS NOT NULL OR @DesktopId IS NOT NULL)
			BEGIN

				DECLARE @Url TABLE(Id UNIQUEIDENTIFIER, AppType varchar(50))

				DECLARE @SORTED TABLE 
				(
					Id UNIQUEIDENTIFIER ,
					MACAddress NVARCHAR(20),  
					UserId UNIQUEIDENTIFIER,
					CompanyId UNIQUEIDENTIFIER,
					ApplicationName NVARCHAR(800),
					AbsoluteAppName NVARCHAR(1000),
					TrimApplication NVARCHAR(800),
					ApplicationStartTime DATETIMEOFFSET,
					ApplicationEndTime  DATETIMEOFFSET,
					IdleTime DATETIME,
					TimeSpent DATETIME,
					OperationDate DATETIMEOFFSET,
					IsApp BIT,
					DesktopId UNIQUEIDENTIFIER
				)
				
				INSERT INTO @Url (Id, AppType)
				SELECT DISTINCT ActivityTrackerAppUrlTypeId, AppURL 
				FROM ActivityTrackerRoleConfiguration AS A 
					 JOIN [UserRole] AS UR ON UR.RoleId = A.RoleId AND UR.InactiveDateTime IS NULL
					 JOIN [User] AS U ON U.Id = UR.UserId AND U.InActiveDateTime IS NULL AND U.IsActive = 1
					 INNER JOIN ActivityTrackerAppUrlType ATAT on ATAT.Id = A.ActivityTrackerAppUrlTypeId
				WHERE U.Id = @UserId AND A.ComapnyId = @CompanyId

				IF(
					(@IsOff = 1 AND (SELECT COUNT(*) FROM @Url) = 1 AND (SELECT TOP 1 AppType FROM @Url) = 'Off')
					OR
					(SELECT COUNT(*) FROM @Url) = 0
				)
				BEGIN

					Delete @Url

					INSERT INTO @Url (Id, AppType)
					SELECT TOP 1 Id, AppURL FROM ActivityTrackerAppUrlType WHERE AppURL = 'App'
					
					IF(@UserTrack <> 1)
					BEGIN
						SET @TrackId = (SELECT TOP 1 Id FROM @Url)
					END
				END

				IF( (@UserTrack = 1 AND @TrackId = (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App and Url (Detailed)')) OR (@UserTrack = 0 AND (SELECT COUNT(1) FROM @Url WHERE AppType='App and Url (Detailed)') > 0))
				BEGIN
					INSERT INTO @SORTED (Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,DesktopId) 
					SELECT C.Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,C.IsApp,@DesktopId 
					FROM #CTEDummy C
					WHERE C.IsApp IS NOT NULL
				END
				ELSE 
				BEGIN

					IF((@UserTrack = 1 AND @TrackId = (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App and Url')) OR (@UserTrack = 0 AND (SELECT COUNT(1) FROM @Url WHERE AppType='App and Url') > 0))
					BEGIN

						INSERT INTO @SORTED (Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,DesktopId) 
						SELECT C.Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,C.IsApp,@DesktopId
						FROM #CTEDummy C
						WHERE C.IsApp IS NOT NULL AND C.IsBackground = 0

					END
					ELSE
					BEGIN

						IF((@UserTrack = 1 AND @TrackId = (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'Url')) OR (@UserTrack = 0 AND (SELECT COUNT(1) FROM @Url WHERE AppType='Url') > 0))
						BEGIN

							INSERT INTO @SORTED (Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,DesktopId) 
							SELECT C.Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,C.IsApp,@DesktopId
							FROM #CTEDummy C
							WHERE C.IsApp IS NOT NULL AND (C.IsApp = 0 OR C.ApplicationName = 'Idle Time' )AND C.IsBackground = 0

						END

						IF((@UserTrack = 1 AND @TrackId = (SELECT Id FROM ActivityTrackerAppUrlType WHERE AppURL = 'App')) OR (@UserTrack = 0 AND (SELECT COUNT(1) FROM @Url  WHERE AppType='App') > 0))
						BEGIN

							INSERT INTO @SORTED (Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,DesktopId) 
							SELECT C.Id,MACAddress,UserId,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,C.IsApp,@DesktopId
							FROM #CTEDummy C
							WHERE C.IsApp IS NOT NULL AND C.IsApp = 1 AND C.IsBackground = 0

						END
					END
				END

				SELECT Id, ApplicationName ,TrimName = 
				IIF
				(
					CHARINDEX('/', ApplicationName) > 0,
					LEFT
					(
						REPLACE(REPLACE(ApplicationName, 'http://',''),'https://',''),
						IIF
						(
							CHARINDEX('/', REPLACE(REPLACE(ApplicationName,'http://',''),'https://','')) > 0,
							CHARINDEX('/', REPLACE(REPLACE(ApplicationName,'http://',''),'https://','')) - 1,
							LEN(ApplicationName) - 1
						)
					),
					ApplicationName
				)
				INTO #TrimTable FROM @SORTED WHERE IsApp = 0
			
				UPDATE @SORTED SET TrimApplication = TrimName FROM #TrimTable AS TT JOIN @SORTED AS S ON S.Id = TT.Id

				--UPDATE @SORTED SET ApplicationName = LTRIM(RTRIM(IIF(CHARINDEX('|', ApplicationName ) > 0,LEFT(ApplicationName ,CHARINDEX('|', ApplicationName ) - 1), IIF(CHARINDEX('-', REVERSE(ApplicationName )) > 0, REVERSE(LEFT(REVERSE(ApplicationName ),CHARINDEX('-', REVERSE(ApplicationName )) - 1)), ApplicationName ))))
				--				WHERE IsApp = 1

				SELECT  DISTINCT C.Id AS Id,
							C.MACAddress MACAddress,
							C.UserId UserId,
							IIF(ISNULL(URLMapper.Id,'00000000-0000-0000-0000-000000000000')='00000000-0000-0000-0000-000000000000',
							NULL,URLMapper.Id) ApplicationId,
							CONVERT(DATE,CONVERT(DATETIME, OperationDate)) AS CreatedDateTime,
							CASE WHEN ApplicationStartTime = '0001-01-01T00:00:00' THEN GETDATE() ELSE convert(DATETIME, ApplicationStartTime) END AS ApplicationStartTime,
							CONVERT(DATETIME, ApplicationEndTime) AS ApplicationEndTime,
							CONVERT(TIME, C.IdleTime) AS IdleTime,
							CONVERT(TIME, C.TimeSpent) AS TimeSpent,
							--IIF(ISNULL(URLMapper.Id,'00000000-0000-0000-0000-000000000000')='00000000-0000-0000-0000-000000000000',
							--C.ApplicationName,NULL) OtherApplication,
							C.ApplicationName AS OtherApplication,
							C.AbsoluteAppName AS AbsoluteAppName,
							C.TrimApplication TrimApplication,
							C.IsApp IsApp,
							(CASE WHEN URLMapper.RoleId IS NOT NULL AND URLMapper.RoleId = UR.RoleId 
							           THEN (SELECT ATT.ID FROM ApplicationType ATT WHERE  ATT.IsProductive =  URLMapper.IsProductive)
								  WHEN URLMapper.RoleId IS NULL THEN (SELECT ATT.Id FROM ApplicationType ATT WHERE  ATT.IsProductive IS NULL) 
								  END) ApplicationTypeId,
							(CASE WHEN C.IsApp = 0 THEN C.ApplicationName
								  WHEN C.IsApp = 1 THEN NULL
								  END) AS TrackedUrl,
							C.DesktopId AS DesktopId
					INTO #UserTime
					FROM @SORTED C 
							--LEFT JOIN [User] U ON U.Id COLLATE database_default = C.UserId COLLATE database_default 
							LEFT JOIN [User] U ON U.Id = C.UserId 
							           AND U.CompanyId = @CompanyId AND U.Id = @UserId--= E.UserId 
							LEFT JOIN UserRole UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL
							OUTER APPLY (SELECT Top 1 * FROM
										(SELECT A.Id AS Id,ATA.RoleId,ATA.IsProductive
													FROM ActivityTrackerApplicationUrl AS A 
													JOIN ActivityTrackerApplicationUrlRole AS ATA ON A.Id = ATA.ActivityTrackerApplicationUrlId 
													     AND ATA.InActiveDateTime IS NULL									
										WHERE C.AbsoluteAppName = A.AppUrlName
												AND A.InActiveDateTime IS NULL 
												AND (ATA.RoleId = UR.RoleId  OR @OperationsPerformedBy = @EmptyGuid)
												AND A.CompanyId  = C.CompanyId 
												AND ATA.CompanyId = C.CompanyId
										) T  ORDER BY IsProductive DESC) URLMapper

					SELECT U.Id, COUNT(U.Id) AS TotalCount INTO #IdÇount 
										FROM @SORTED AS C
										JOIN #UserTime AS U ON U.Id = C.Id
										WHERE U.Id NOT IN (SELECT Id FROM UserActivityTime WHERE UserId = @UserId)
										GROUP BY U.Id

					INSERT INTO [dbo].[UserActivityTime](
									[Id],
									[MACAddress],
									[UserId],
									[ApplicationId],
									[CreatedDateTime],
									[ApplicationStartTime],
									[ApplicationEndTime],
									[IdleTime],
									[SpentTime],
									[OtherApplication],
									[CommonUrl],
									[AbsoluteAppName],
									[ApplicationTypeId],
									[IsApp],
									[TrackedUrl],
									[DesktopId],
									InActiveDateTime
									)

					SELECT U.Id,U.MACAddress,U.UserId,U.ApplicationId,U.CreatedDateTime,U.ApplicationStartTime,U.ApplicationEndTime,U.IdleTime,U.TimeSpent,--U.OtherApplication
					--IIF((U.OtherApplication = NULL OR U.IsApp = 0), U.OtherApplication, IIF(CHARINDEX('-', REVERSE(U.OtherApplication)) > 0, REVERSE(LEFT(REVERSE(U.OtherApplication),CHARINDEX('-', REVERSE(U.OtherApplication)) - 1)), IIF(CHARINDEX('|', U.OtherApplication) > 0,LEFT(U.OtherApplication,CHARINDEX('|', U.OtherApplication) - 1), U.OtherApplication)))
					--IIF((U.OtherApplication = NULL OR U.IsApp = 0), U.OtherApplication ,IIF(CHARINDEX('|', U.OtherApplication ) > 0,LEFT(U.OtherApplication ,CHARINDEX('|', U.OtherApplication ) - 1), IIF(CHARINDEX('-', REVERSE(U.OtherApplication )) > 0, REVERSE(LEFT(REVERSE(U.OtherApplication ),CHARINDEX('-', REVERSE(U.OtherApplication )) - 1)), U.OtherApplication )))
					U.OtherApplication
					,U.TrimApplication,U.AbsoluteAppName,U.ApplicationTypeId,U.IsApp,U.TrackedUrl,U.DesktopId
					,CASE WHEN @IsArchive = 1 THEN GETDATE() ELSE NULL END
								FROM #UserTime AS U
							    JOIN #IdÇount AS I ON U.Id = I.Id AND ( I.TotalCount = 1 OR (I.TotalCount > 1 AND U.ApplicationTypeId = (SELECT ATT.ID FROM ApplicationType ATT WHERE  ATT.IsProductive = 1) ) )

					--IF((SELECT COUNT(1) FROM #UserTime WHERE OtherApplication = 'Idle Time') > 0)
					--BEGIN
						
					--	DECLARE @Time TIME = (SELECT TimeSpent FROM #UserTime WHERE OtherApplication = 'Idle Time')
					--	DECLARE @Start DATETIME = (SELECT ApplicationStartTime FROM #UserTime WHERE OtherApplication = 'Idle Time')
					--	DECLARE @End DATETIME = (SELECT ApplicationEndTime FROM #UserTime WHERE OtherApplication = 'Idle Time')
					--	DECLARE @User UNIQUEIDENTIFIER = (SELECT UserId FROM #UserTime WHERE OtherApplication = 'Idle Time')

					--	UPDATE UserActivityTime SET InActiveDateTime = GETDATE()
					--			WHERE UserId = @User AND
					--				  ((ApplicationStartTime >= @Start AND ApplicationStartTime <= @End)
					--				  OR (ApplicationEndTime >= @Start AND ApplicationEndTime <= @End)) AND OtherApplication <> 'Idle Time'

					--END

					DROP TABLE #UserTime

					DROP TABLE #IdÇount
	
				SELECT 'Inserted Successfully'

			END
			ELSE IF(@IsOff = 1) --ADDED THIS CONDITON FOR TRACKING ONLY TIME
			BEGIN
				SELECT 'Inserted Successfully'
			END
			ELSE
			BEGIN
				SELECT 'Insert not done'
			END
			

		END
		
	END TRY
	
	BEGIN CATCH
		
			THROW

	END CATCH

END
GO