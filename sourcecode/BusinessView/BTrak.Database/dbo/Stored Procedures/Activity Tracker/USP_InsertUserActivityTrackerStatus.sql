-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Save the ScreenShot of the User Activity
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_InsertUserActivityTrackerStatus] @TrackedDateTime ='2019-09-19',@MouseMovement = 0,@KeyStroke = 0,@UserId = 'FF6B8CED-CAD3-4A52-8A71-4D59EF36CEC1'
-- ,@UserIdleRecordXml = '<InsertUserActivityTimeInputModel><InputCommandGuid>2f0197d0-b4ec-428e-97e5-c8a4c50e4580</InputCommandGuid><InputCommandTypeGuid>66163cc9-360f-4617-83f8-d12244985d75</InputCommandTypeGuid><Id>80ca9a09-4aeb-4009-b5b2-82646e504914</Id><ApplicationName>TimeChamp | Anupam Sai Kumar Vuyyuru </ApplicationName><IsApp>true</IsApp><IsBackground>false</IsBackground><AbsoluteAppName>TimeChamp</AbsoluteAppName><ApplicationStartTime>2021-02-15T12:31:37.4057006Z</ApplicationStartTime><ApplicationEndTime>2021-02-15T12:33:37.4507006Z</ApplicationEndTime><ActivityDate>2021-02-15T12:31:37.4247006Z</ActivityDate><IdleTime>2019-01-01T00:00:00</IdleTime><SpentTime>2019-01-01T00:01:00.024</SpentTime></InsertUserActivityTimeInputModel>'

CREATE PROCEDURE [dbo].[USP_InsertUserActivityTrackerStatus]
(
	@TrackedDateTime DATETIME,
	@MouseMovement INT = 0,
	@KeyStroke INT = 0,
	@UserId UNIQUEIDENTIFIER,
	@DeviceId NVARCHAR(500) = NULL,
	@UserIdleRecordXml XML = NULL
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY

		DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
			@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop WHERE DesktopDeviceId = @DeviceId)

		IF(@UserId = @EmptyGuid)
		BEGIN
			SET @UserId = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
			IF(@UserId IS NULL)
			BEGIN
				SET @UserId = @EmptyGuid
			END
		END

		IF((@UserId IS NOT NULL OR @DesktopId IS NOT NULL) AND @TrackedDateTime IS NOT NULL)
		BEGIN
			
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@UserId))
			
			IF(@UserIdleRecordXml IS NOT NULL)
			BEGIN
				
				DECLARE @IdleTimeValueInMin INT = ISNULL((SELECT MIN(MinimumIdelTime) 
			                                          FROM ActivityTrackerRolePermission ATR
													       INNER JOIN UserRole UR ON UR.RoleId = ATR.RoleId
														              AND UR.UserId = @UserId
																	  AND UR.InactiveDateTime IS NULL
													                  AND ATR.InActiveDateTime IS NULL
													  WHERE ATR.CompanyId = @CompanyId
												      GROUP BY UserId),5)

				DECLARE @IdleRecords TABLE 
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
					IsBackground BIT,
					IdleTimeStart DATETIME,
					IdleTimeEnd DATETIME,
					[Date] DATE
				)

				INSERT INTO @IdleRecords (Id,CompanyId,ApplicationName,AbsoluteAppName,ApplicationStartTime,ApplicationEndTime,IdleTime,TimeSpent,OperationDate,IsApp,IsBackground)
				SELECT	x.value('Id[1]','UNIQUEIDENTIFIER') Id,
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
				FROM  @UserIdleRecordXml.nodes('InsertUserActivityTimeInputModel') XmlData(x)
				
				DECLARE @MinBreakTime DATETIME = NULL
				        ,@MaxBreakTime DATETIME = NULL
						--,@IsArchive BIT = 0
				        --,@IdleTimerecorded INT = (SELECT DATEDIFF(MINUTE,ApplicationStartTime,ApplicationEndTime) FROM @IdleRecords)
						,@IdleTimeStart DATETIME = (SELECT SWITCHOFFSET(ApplicationStartTime,'+00:00') FROM @IdleRecords)
				        ,@IdleTimeEnd DATETIME = (SELECT SWITCHOFFSET(ApplicationEndTime,'+00:00') FROM @IdleRecords)

				UPDATE @IdleRecords SET IdleTimeStart = @IdleTimeStart
				                        ,IdleTimeEnd = @IdleTimeEnd	
										,[Date] = CONVERT(DATE,OperationDate)
				
				DECLARE  @BreakTable TABLE
				(
					--RowNumber INT IDENTITY(1,1), -- TODO
					[BreakDate] DATETIME NULL,
					[BreakStart] DATETIME NULL,
					[BreakEnd] DATETIME NULL
				);
				
				INSERT INTO @BreakTable(BreakDate, BreakStart, BreakEnd)
                SELECT UB.[Date],SWITCHOFFSET(UB.BreakIn,'+00:00'),SWITCHOFFSET(UB.BreakOut,'+00:00') 
				FROM [UserBreak] UB
				WHERE UserId = @UserId
					  AND (SWITCHOFFSET(UB.BreakIn,'+00:00') BETWEEN @IdleTimeStart AND @IdleTimeEnd
						   OR 
						  SWITCHOFFSET(UB.BreakOut,'+00:00') BETWEEN @IdleTimeStart AND @IdleTimeEnd
						  )
				UNION 
				SELECT TS.[Date],SWITCHOFFSET(TS.LunchBreakStartTime,'+00:00'),SWITCHOFFSET(TS.LunchBreakEndTime,'+00:00')
				FROM TimeSheet TS
				WHERE UserId = @UserId
					  AND (SWITCHOFFSET(TS.LunchBreakStartTime,'+00:00') BETWEEN @IdleTimeStart AND @IdleTimeEnd
						   OR 
						  SWITCHOFFSET(TS.LunchBreakEndTime,'+00:00') BETWEEN @IdleTimeStart AND @IdleTimeEnd
						  )
				
				SET @MinBreakTime = (SELECT MIN(BreakStart) FROM @BreakTable)
				
				SET @MaxBreakTime = (SELECT MAX(BreakEnd) FROM @BreakTable)

				IF(@MinBreakTime IS NOT NULL AND @MinBreakTime < @IdleTimeStart)
				BEGIN
					
					UPDATE @BreakTable SET BreakStart = @IdleTimeStart
					WHERE BreakStart = @MinBreakTime

				END

				IF(@MaxBreakTime IS NOT NULL AND @MaxBreakTime > @IdleTimeEnd)
				BEGIN
					
					UPDATE @BreakTable SET BreakEnd = @IdleTimeEnd
					WHERE BreakEnd = @MaxBreakTime

				END

				IF(EXISTS(SELECT BreakStart FROM @BreakTable WHERE BreakEnd IS NULL))
				BEGIN

					UPDATE @BreakTable SET BreakEnd = @IdleTimeEnd
					WHERE BreakEnd IS NULL

				END

				--IF(@IdleTimerecorded >= ISNULL(@IdleTimeValueInMin,5))
				--BEGIN
					
				--	SET @IsArchive = 1

				--END

				/*Split time interval to multiple rows start*/

				SELECT *,DATEDIFF(MINUTE,[StartTime],[EndTime]) IdleMinutes
				       ,IIF(DATEDIFF(MINUTE,[StartTime],[EndTime]) >= ISNULL(@IdleTimeValueInMin,5),1,0) IsArchive
				INTO #IdleRecordsList
				FROM (
				SELECT  [Date] as [Date], IdleTimeStart as [StartTime], ISNULL(firstBreak.BreakStart, IdleTimeEnd) as [EndTime]
				FROM    @IdleRecords W
				        LEFT JOIN (
				            SELECT  BreakDate,  BreakStart, BreakEnd, ROW_NUMBER() OVER (PARTITION BY BreakDate ORDER BY BreakStart) AS ROWNUM
				            FROM    @BreakTable
				        ) AS firstBreak ON W.[Date] = firstBreak.BreakDate AND firstBreak.ROWNUM = 1
				UNION
				SELECT  BreakStart.BreakDate, BreakStart.BreakEnd, ISNULL(BreakEnd.BreakStart, endTime.IdleTimeEnd)
				FROM    (
				            SELECT  BreakDate,  BreakStart, BreakEnd, ROW_NUMBER() OVER (PARTITION BY BreakDate ORDER BY BreakStart) AS ROWNUM
				            FROM    @BreakTable
				        ) AS BreakStart
				        LEFT JOIN (
				            SELECT  BreakDate,  BreakStart, BreakEnd, ROW_NUMBER() OVER (PARTITION BY BreakDate ORDER BY BreakStart) AS ROWNUM
				            FROM    @BreakTable
				        ) AS BreakEnd ON BreakStart.BreakDate = BreakEnd.BreakDate AND BreakStart.ROWNUM = BreakEnd.ROWNUM - 1
				        LEFT JOIN (
				            SELECT  [Date], IdleTimeEnd
				            FROM    @IdleRecords
				        ) AS endTime ON BreakStart.BreakDate = endTime.[Date]
				) T WHERE [StartTime] <> [EndTime]
				
				/*Split time interval to multiple rows end*/

				INSERT INTO [dbo].[UserActivityTrackerStatus]([Id],UserId,CompanyId,StartDateTime,TrackedDateTime,IdleTimeInMin,[KeyStroke]
				                                              ,[MouseMovement],CreatedDateTime,DesktopId,IsIdleRecord)
				SELECT NEWID(),@UserId,@CompanyId,StartTime,EndTime,IdleMinutes
				       ,0,0,GETDATE(),@DesktopId,IsArchive
				FROM #IdleRecordsList

				DECLARE @UserTime XML = (
				SELECT (
				SELECT  NEWID() AS Id ,IR.MACAddress AS MACAddress
				        ,IR.UserId AS UserId
						,IR.CompanyId AS CompanyId
						,IR.ApplicationName AS ApplicationName
						,IR.AbsoluteAppName AS AbsoluteAppName
						,IRL.StartTime AS ApplicationStartTime
				        ,IRL.EndTime AS ApplicationEndTime
						,IR.IdleTime AS IdleTime
						,DATEADD(MINUTE,DATEDIFF(MINUTE,IRL.StartTime,IRL.EndTime),0) AS SpentTime
						,IR.OperationDate AS ActivityDate
						,IR.IsApp AS IsApp
						,IR.IsBackground AS IsBackground
				FROM @IdleRecords IR
					 INNER JOIN #IdleRecordsList IRL ON 1 = 1
				FOR XML PATH('InsertUserActivityTimeInputModel'),TYPE ) 
				FOR XML PATH('ListItems') , ROOT('GenericListOfInsertUserActivityTimeInputModel'))

				EXEC [dbo].[USP_UpsertUserTime] @UserTime = @UserTime,@DeviceId = @DeviceId,@IsArchive = 0,@OperationsPerformedBy = @UserId

				UPDATE UserActivityTime SET InActiveDateTime = CASE WHEN IDL.IsArchive = 1 THEN GETDATE() ELSE NULL END
				FROM #IdleRecordsList IDL
					 INNER JOIN UserActivityTime UT ON UT.ApplicationStartTime = IDL.StartTime
							    AND IDL.EndTime = UT.ApplicationEndTime AND UT.UserId = @UserId

			END

			INSERT INTO [dbo].[UserActivityTrackerStatus]([Id],UserId,CompanyId,TrackedDateTime,[KeyStroke],[MouseMovement],CreatedDateTime,DesktopId)
			SELECT NEWID(),@UserId,@CompanyId,@TrackedDateTime,@KeyStroke,@MouseMovement,GETDATE(),@DesktopId

		END

	END TRY
	
	BEGIN CATCH
		
			THROW

	END CATCH

END
GO