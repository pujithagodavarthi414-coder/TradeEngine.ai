-------------------------------------------------------------------------------
-- Author       Praneeth Kumar Reddy Salukooti
-- Created      '2019-09-17 00:00:00.000'
-- Purpose      To Save the ScreenShot of the User Activity
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
-- EXEC [dbo].[USP_UpsertUserActivityScreenshot] @ScreenShotName = 'wfdgd',@ScreenShotUrl='http://sgfdg.sfd',@ScreenShotDate='2019-09-19',
-- @ApplicationName = 'asp.net'
CREATE PROCEDURE [dbo].[USP_UpsertUserActivityScreenshot]
(
	@ScreenShotName NVARCHAR(MAX) = NULL,
	@ScreenShotUrl NVARCHAR(MAX) = NULL,
	@ScreenShotDate DATETIMEOFFSET = NULL,
	@ApplicationName NVARCHAR(800) = NULL,
	@MouseMovement DECIMAL(18,0) = 0,
	@KeyStroke DECIMAL(18,0) = 0,
	@MAC NVARCHAR(20) = '',
	@OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@TimeZone NVARCHAR(100) = NULL,
	@DeviceId NVARCHAR(500) = NULL,
	@IsLiveScreenShot BIT = 0
)
AS
BEGIN

SET NOCOUNT ON

	BEGIN  TRY
	
		DECLARE @EmptyGuid UNIQUEIDENTIFIER = '00000000-0000-0000-0000-000000000000',
					@DesktopId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM ActivityTrackerDesktop WHERE DesktopDeviceId = @DeviceId)

		IF(@OperationsPerformedBy = @EmptyGuid)
		BEGIN
			SET @OperationsPerformedBy = (SELECT TOP 1 UserId FROM dbo.Ufn_GetUsersModeType(@DeviceId, NULL, NULL))
			IF(@OperationsPerformedBy IS NULL)
			BEGIN
				SET @OperationsPerformedBy = @EmptyGuid
			END
		END

		DECLARE @UserId UNIQUEIDENTIFIER = @OperationsPerformedBy

		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		SET @ApplicationName = IIF(CHARINDEX('/', @ApplicationName) > 0,LEFT(REPLACE(REPLACE(@ApplicationName, 'http://',''),'https://','')
				,CHARINDEX('/', REPLACE(REPLACE(@ApplicationName,'http://',''),'https://','')) - 1), 
				LTRIM(RTRIM(IIF(CHARINDEX('|', @ApplicationName ) > 0,LEFT(@ApplicationName ,CHARINDEX('|', @ApplicationName ) - 1), IIF(CHARINDEX('-', REVERSE(@ApplicationName )) > 0, REVERSE(LEFT(REVERSE(@ApplicationName ),CHARINDEX('-', REVERSE(@ApplicationName )) - 1)), @ApplicationName ))))
				)

		DECLARE @ApplicationId UNIQUEIDENTIFIER = (SELECT TOP 1 A.Id FROM ActivityTrackerApplicationUrl AS A WHERE A.InActiveDateTime IS NULL AND (@ApplicationName LIKE '%'+ A.AppUrlName +'%') AND CompanyId = @CompanyId)

		SELECT  DISTINCT (CASE WHEN URLMapper.RoleId IS NOT NULL AND URLMapper.RoleId = UR.RoleId THEN (SELECT ATT.ID FROM ApplicationType ATT WHERE  ATT.IsProductive =  URLMapper.IsProductive)
							   WHEN URLMapper.RoleId IS NULL THEN (SELECT TOP 1 ATT.Id FROM ApplicationType ATT WHERE  ATT.IsProductive IS NULL) 
						  END) AS ApplicationTypeId INTO #UserScreenshot
									FROM [User] U 
										INNER JOIN UserRole UR ON UR.UserId = U.Id AND UR.InactiveDateTime IS NULL 
																	AND U.CompanyId = @CompanyId AND U.Id = @UserId 
																	AND U.InActiveDateTime IS NULL AND U.IsActive = 1
										OUTER APPLY (SELECT Top 1 * FROM
													(SELECT A.Id AS Id,ATA.RoleId,ATA.IsProductive
																FROM ActivityTrackerApplicationUrl AS A 
																JOIN ActivityTrackerApplicationUrlRole AS ATA ON A.Id = ATA.ActivityTrackerApplicationUrlId AND ATA.InActiveDateTime IS NULL									
													WHERE 
													(((@ApplicationName LIKE '%'+ LTRIM(RTRIM(A.AppUrlName)) +'%' 
													   OR LTRIM(RTRIM(A.AppUrlName)) LIKE '%'+ @ApplicationName +'%' 
													   OR REPLACE(@ApplicationName, ' ','') LIKE '%'+ REPLACE(A.AppUrlName, ' ', '') +'%' 
													   OR REPLACE(A.AppUrlName, ' ', '') LIKE '%'+ REPLACE(@ApplicationName, ' ', '') +'%')) 
													   OR REPLACE(@ApplicationName, ' ', '') = REPLACE(A.AppUrlName, ' ', '') )
													AND A.InActiveDateTime IS NULL AND  ATA.RoleId = UR.RoleId AND A.CompanyId = @CompanyId AND ATA.CompanyId = @CompanyId
													) T ORDER BY IsProductive DESC ) URLMapper

								INSERT INTO [dbo].[ActivityScreenShot](
														[Id],
														[MACAddress],
														[UserId],
														[ScreenShotName],
														[ScreenShotUrl],
														[ScreenShotDateTime],
														[KeyStroke],
														[MouseMovement],
														[ApplicationName],
														[ApplicationTypeId],
														[ApplicationId],
														[CreatedDateTime],
														[ScreenShotTimeZoneId],
														[DesktopId]
														)
								SELECT NEWID(),
										@MAC,
										@UserId,
										@ScreenShotName,
										@ScreenShotUrl,
										@ScreenShotDate,
										@KeyStroke,
										@MouseMovement,
										@ApplicationName,
										U.ApplicationTypeId,
										CASE WHEN @ApplicationId IS NULL THEN (SELECT TOP 1 Id FROM ApplicationType WHERE ApplicationTypeName='Neutral') ELSE @ApplicationId END AS ApplicationId,
										@ScreenShotDate,
										(SELECT TOP 1 Id FROM TimeZone WHERE TimeZone = @TimeZone),
										@DesktopId
										FROM #UserScreenshot AS U
										WHERE ( ( (SELECT COUNT(*) FROM #UserScreenshot) = 1 ) OR 
												( ((SELECT COUNT(*) FROM #UserScreenshot) > 1) AND U.ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE IsProductive = 1) ) )

										DROP TABLE #UserScreenshot
								
								SELECT @ScreenShotName

								IF(@DesktopId IS NULL AND @UserId IS NOT NULL)
								BEGIN
									
									SET @DesktopId = (SELECT DesktopId FROM [User] WHERE Id = @UserId)

								END

								DECLARE @ScreenShotDateTime DATETIMEOFFSET = NULL

								IF(@UserId IS NULL AND @DesktopId IS NOT NULL)
								BEGIN
									
									UPDATE ActivityTrackerDesktop SET LatestScreenShotId = (SELECT Id FROM ActivityScreenShot 
									                                                        WHERE DesktopId = @DesktopId 
																							      AND ScreenShotDateTime = (SELECT MAX(ScreenShotDateTime)
									                                                                                        FROM ActivityScreenShot
									                                                                                        WHERE DesktopId = @DesktopId
																															GROUP BY DesktopId))
									WHERE Id = @DesktopId
								
								END
								ELSE
								BEGIN

								    UPDATE ActivityTrackerDesktop SET LatestScreenShotId = (SELECT Id FROM ActivityScreenShot 
								    	                                                        WHERE UserId = @UserId 
								    															      AND ScreenShotDateTime = (SELECT MAX(ScreenShotDateTime)
								    	                                                                                        FROM ActivityScreenShot
								    	                                                                                        WHERE UserId = @UserId
																																GROUP BY UserId))
								    	WHERE Id = @DesktopId

									UPDATE [User] SET LatestScreenShotId = (SELECT Id FROM ActivityScreenShot 
								    	                                                        WHERE UserId = @UserId 
								    															      AND ScreenShotDateTime = (SELECT MAX(ScreenShotDateTime)
								    	                                                                                        FROM ActivityScreenShot
								    	                                                                                        WHERE UserId = @UserId
																																GROUP BY UserId))
								   WHERE Id = @UserId

								END
		
	END TRY
	
	BEGIN CATCH
		
			THROW

	END CATCH

END
GO