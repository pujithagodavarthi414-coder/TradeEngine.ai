--EXEC [dbo].[USP_UpsertActTrackerRolePermission] @OperationsPerformedBy = '0B2921A9-E930-4013-9047-670B5352F308',
--@IsRecordActivity=1,
--@RoleIdXMl='<?xml version="1.0" encoding="utf-8"?>
--<GenericListOfNullableOfGuid
-- xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
--  xmlns:xsd="http://www.w3.org/2001/XMLSchema">
--  <ListItems><guid>7C494C06-3857-4029-90E6-B78B59E7F4BE</guid>
--			<guid>606e7152-047c-43ba-8426-03a743bbaef4</guid>
--			<guid>381d7c81-1274-4c77-970b-142a82bf6e2b</guid>
--			<guid>90d51fd0-f599-4b89-ad20-31a74f1a93ea</guid>
--			<guid>511bbedd-5c23-49fd-af05-2e82061426df</guid></ListItems></GenericListOfNullableOfGuid>'
-------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_UpsertActTrackerRolePermission](
@RoleIdXMl XMl = NULL,
@IsDeleteScreenShots BIT =NULL,
@IsRecordActivity BIT =NULL,
@IsIdleTime BIT = NULL,
@IdleScreenShotCaptureTime INT = NULL,
@IdleAlertTime INT = NULL,
@MinimumIdelTime INT = NULL,
@IsManualEntryTime BIT = NULL,
@IsOfflineTracking BIT = NULL,
@IsMouseActivity BIT = NULL,
@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS 
BEGIN
	   SET NOCOUNT ON
	   BEGIN TRY
	   IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
            BEGIN
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess] ( @OperationsPerformedBy ,(SELECT OBJECT_NAME(@@PROCID))))
            IF(@HavePermission = '1')
            BEGIN
                    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
                    DECLARE @Currentdate DATETIME = GETDATE()
                       CREATE TABLE #RoleIds ( 
                                              Id UNIQUEIDENTIFIER,
                                              RoleId UNIQUEIDENTIFIER,
                                              IsDeleteScreenShots BIT ,
                                              IsRecordActivity BIT ,
                                              IsIdleTime BIT ,
                                              IdleScreenShotCaptureTime INT,
                                              IdleAlertTime BIT ,
                                              IsManualEntryTime INT,
											  IsOfflineTracking BIT,
											  IsMouseActivity BIT,
                                              IsToChange BIT,
                                              IsChanged BIT,
                                              IsExist BIT
                                            )
					IF(@RoleIdXMl IS NOT NULL)
					BEGIN
						INSERT INTO #RoleIds(Id,RoleId,IsToChange)
						SELECT NEWID(),
								x.y.value('(text())[1]','UNIQUEIDENTIFIER'),
								1                          
								FROM  
								@RoleIdXMl.nodes('/GenericListOfNullableOfGuid
														   /ListItems/guid')AS x(y)
                  
						UPDATE #RoleIds SET IsExist = 1 FROM #RoleIds R JOIN [ActivityTrackerRolePermission] ATR ON ATR.RoleId = R.RoleId
					END
                
                IF (@IsDeleteScreenShots IS NOT NULL OR @IsDeleteScreenShots <> 0)
                BEGIN
                  UPDATE [ActivityTrackerRolePermission] SET IsDeleteScreenShots = @IsDeleteScreenShots WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                  UPDATE [ActivityTrackerRolePermission] SET IsDeleteScreenShots = 0 WHERE IsDeleteScreenShots = @IsDeleteScreenShots AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
                END
                IF (@IsIdleTime IS NOT NULL OR @IsIdleTime <> 0)
                BEGIN
                UPDATE [ActivityTrackerRolePermission] SET IsIdleTime = @IsIdleTime, IdleScreenShotCaptureTime = @IdleScreenShotCaptureTime, IdleAlertTime=@IdleAlertTime, MinimumIdelTime = @MinimumIdelTime WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                UPDATE [ActivityTrackerRolePermission] SET IsIdleTime = 0 ,  IdleScreenShotCaptureTime = 0, IdleAlertTime=0, MinimumIdelTime = @MinimumIdelTime WHERE @IsIdleTime = IsIdleTime AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
                END
                IF (@IsManualEntryTime IS NOT NULL OR @IsManualEntryTime <> 0)
                BEGIN
                  UPDATE [ActivityTrackerRolePermission] SET IsManualEntryTime = @IsManualEntryTime WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                  UPDATE [ActivityTrackerRolePermission] SET IsManualEntryTime = 0 WHERE IsManualEntryTime = @IsManualEntryTime AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
                END
                IF (@IsRecordActivity IS NOT NULL OR @IsRecordActivity <> 0)
                BEGIN
                  UPDATE [ActivityTrackerRolePermission] SET IsRecordActivity = @IsRecordActivity WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                  UPDATE [ActivityTrackerRolePermission] SET IsRecordActivity = 0 WHERE IsRecordActivity = @IsRecordActivity AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
                END                 
				IF(@IsOfflineTracking IS NOT NULL OR @IsOfflineTracking <> 0)
				BEGIN
				  UPDATE [ActivityTrackerRolePermission] SET IsOfflineTracking = @IsOfflineTracking WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                  UPDATE [ActivityTrackerRolePermission] SET IsOfflineTracking = 0 WHERE IsOfflineTracking = @IsOfflineTracking AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
				END
				IF(@IsMouseActivity IS NOT NULL OR @IsMouseActivity <> 0)
				BEGIN
				  UPDATE [ActivityTrackerRolePermission] SET IsMouseTracking = @IsMouseActivity WHERE RoleId IN (SELECT RoleId FROM #RoleIds WHERE IsExist = 1) AND CompanyId = @CompanyId
                  
                  UPDATE [ActivityTrackerRolePermission] SET IsMouseTracking = 0 WHERE IsMouseTracking = @IsMouseActivity AND RoleId NOT IN (SELECT RoleId FROM #RoleIds) AND CompanyId = @CompanyId
				END
                 
                  INSERT INTO [dbo].[ActivityTrackerRolePermission](
                                                                Id,
                                                                CompanyId,
                                                                CreatedDateTime,
                                                                CreatedByUserId,
                                                                IsDeleteScreenShots,
                                                                IsRecordActivity,
                                                                IsIdleTime,
                                                                IdleScreenShotCaptureTime,
																MinimumIdelTime,
                                                                IdleAlertTime,
                                                                IsManualEntryTime,
																IsOfflineTracking,
																IsMouseTracking,
                                                                RoleId
                                                               )
                                                        SELECT R.Id,
                                                               @CompanyId,
                                                               @Currentdate,
                                                               @OperationsPerformedBy,
                                                               @IsDeleteScreenShots,
                                                               @IsRecordActivity,
                                                               @IsIdleTime,
                                                               @IdleScreenShotCaptureTime,
															   @MinimumIdelTime,
                                                               @IdleAlertTime,
                                                               @IsManualEntryTime,
															   @IsOfflineTracking,
															   @IsMouseActivity,
                                                               R.RoleId
                                                               FROM #RoleIds R WHERE IsExist IS NULL
                 
                 SELECT x.y.value('(text())[1]','UNIQUEIDENTIFIER') AS RoleIds FROM @RoleIdXMl.nodes('/GenericListOfNullableOfGuid/ListItems/guid')AS x(y)
         
                
                   END
                   ELSE
                   BEGIN
                   
                        RAISERROR (@HavePermission,11, 1)
                    END
                END
			  END TRY
    BEGIN CATCH
        
        THROW

    END CATCH
END
GO