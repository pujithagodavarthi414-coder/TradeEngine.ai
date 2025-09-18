-------------------------------------------------------------------------------
-- Author       Anupam sai kumar Vuyyuru
-- Created      '2020-02-02 00:00:00.000'
-- Purpose      To set custom app dashboard user level persistance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SetCustomAppPersistanceForUser] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@DashboardId='',@CustomApplicationId='',@CustomFormId=''
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SetCustomAppPersistanceForUser]
(
   @DashboardId UNIQUEIDENTIFIER = NULL,
   @CustomApplicationId UNIQUEIDENTIFIER = NULL,
   @CustomFormId UNIQUEIDENTIFIER = NULL,
   @DashboardIdToNavigate UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @QueryToFilter NVARCHAR(MAX) = NULL,
   @WorkSpaceId UNIQUEIDENTIFIER = NULL,
   @IsDefault BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL

		IF(@IsDefault IS NULL) SET @IsDefault = 0

		IF(@DashboardId IS NULL AND @WorkSpaceId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Dashboard Id')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @DashboardCount INT = (SELECT COUNT(1) FROM WorkspaceDashboards WHERE Id = @DashboardId AND CompanyId = @CompanyId)

			IF(@DashboardCount = 0 AND @DashboardId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16, 1,'Dashboard')
				END
				 
			ELSE
			BEGIN
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			    IF (@HavePermission = '1')
			    BEGIN
			       
					DECLARE @Currentdate DATETIME = GETDATE()
					IF(@IsDefault = 1)
					BEGIN

						UPDATE CP 
						SET	CP.[IsDefault] = 1
						FROM WorkspaceDashboards WD		
						INNER JOIN CustomAppDashboardPersistance CP on wd.id = cp.dashboardid
						WHERE WD.workspaceid = @WorkspaceId and inactivedatetime is null 
						AND CP.CreatedByUserId = @OperationsPerformedBy 
						
						DELETE CP
						FROM WorkspaceDashboards WD		
						INNER JOIN CustomAppDashboardPersistance cp on wd.id = cp.dashboardid
						WHERE WD.workspaceid = @WorkspaceId and inactivedatetime is null 
						AND CP.CreatedByUserId IN (
							SELECT UserId FROM UserRole UR
							INNER JOIN ROLE R ON R.Id = UR.RoleId
							WHERE R.ID IN (SELECT UR2.RoleId FROM UserRole UR2 WHERE UserId = @OperationsPerformedBy)
							AND ur.UserId <> @OperationsPerformedBy 
						)
						
					END
					ELSE
					BEGIN
						IF(NOT EXISTS(SELECT Id FROM CustomAppDashboardPersistance WHERE CreatedByUserId = @OperationsPerformedBy AND DashboardId = @DashboardId))
						BEGIN
			           
								INSERT INTO [dbo].CustomAppDashboardPersistance(
											[Id],
											[DashboardId],
											[CustomApplicationId],
											[CustomFormId],
											[DashboardIdToNavigate],
											[QueryToFilter],
											[CreatedDateTime],
											[CreatedByUserId])
									 SELECT NEWID(),
											@DashboardId,
											@CustomApplicationId,
											@CustomFormId,
											@DashboardIdToNavigate,
											@QueryToFilter,
											@Currentdate,
											@OperationsPerformedBy

						END
						ELSE
						BEGIN
						
							UPDATE [dbo].CustomAppDashboardPersistance
							SET    [CustomApplicationId] = @CustomApplicationId,
								[CustomFormId] = @CustomFormId,
								[DashboardIdToNavigate] = @DashboardIdToNavigate,
								[UpdatedDateTime] = @Currentdate,
								[QueryToFilter] = @QueryToFilter
								WHERE CreatedByUserId = @OperationsPerformedBy AND DashboardId = @DashboardId
						
						END
					END
				END
			    ELSE
			    BEGIN
			        RAISERROR (@HavePermission,11, 1)
			    END
			END
		END
    END TRY
    BEGIN CATCH
        THROW
    END CATCH
END