-------------------------------------------------------------------------------
-- Author       Anupam sai kumar Vuyyuru
-- Created      '2020-02-02 00:00:00.000'
-- Purpose      To get custom app dashboard user level persistance
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetCustomAppPersistanceForUser] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',
--@DashboardId=''
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetCustomAppPersistanceForUser]
(
   @DashboardId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL

		IF(@DashboardId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Dashboard Id')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @DashboardIdCount INT = (SELECT COUNT(1) FROM WorkspaceDashboards WHERE Id = @DashboardId AND CompanyId = @CompanyId)

			IF(@DashboardIdCount = 0 AND @DashboardId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16, 1,'Dashboard')
				END
				 
			ELSE
			BEGIN
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			  
			  IF (@HavePermission = '1')
			    BEGIN
					IF NOT EXISTS(SELECT TOP 1 Id FROM CustomAppDashboardPersistance
								WHERE DashboardId = @DashboardId
								AND CreatedByUserId = @OperationsPerformedBy)
					BEGIN
						SELECT Id,
						   DashboardId,
						   CustomApplicationId,
						   CustomFormId,
						   DashboardIdToNavigate,
						   QueryToFilter
						FROM CustomAppDashboardPersistance
						WHERE DashboardId = @DashboardId
						AND IsDefault = 1 
					END
					ELSE
					BEGIN
						SELECT Id,
							   DashboardId,
							   CustomApplicationId,
							   CustomFormId,
							   DashboardIdToNavigate,
							   QueryToFilter
						FROM CustomAppDashboardPersistance
						WHERE DashboardId = @DashboardId
							  AND CreatedByUserId = @OperationsPerformedBy
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