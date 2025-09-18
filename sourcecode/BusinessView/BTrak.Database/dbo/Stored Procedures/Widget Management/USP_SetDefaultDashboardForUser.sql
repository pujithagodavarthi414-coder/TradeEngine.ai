-------------------------------------------------------------------------------
-- Author       Anupam sai kumar Vuyyuru
-- Created      '2020-01-27 00:00:00.000'
-- Purpose      To set default dashboard for user
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_SetDefaultDashboardForUser] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971',@DashboardId='',
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_SetDefaultDashboardForUser]
(
   @DashboardId UNIQUEIDENTIFIER,
   @OperationsPerformedBy UNIQUEIDENTIFIER,
   @DefaultForAll BIT = NULL
)
AS
BEGIN
    SET NOCOUNT ON
    BEGIN TRY
    
	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

		IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL

		IF(@DefaultForAll IS NULL) SET @DefaultForAll = 0

		IF(@DashboardId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'Workspace Id')

		END
		ELSE
		BEGIN

			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @WorkSpaceIdCount INT = (SELECT COUNT(1) FROM Workspace WHERE Id = @DashboardId AND CompanyId = @CompanyId)

			IF(@WorkSpaceIdCount = 0 AND @DashboardId IS NOT NULL)
				BEGIN
					RAISERROR(50002,16, 1,'Workspace')
				END
				 
			ELSE
			BEGIN
			    DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			    IF (@HavePermission = '1')
			    BEGIN
			       
					DECLARE @Currentdate DATETIME = GETDATE()


					IF(NOT EXISTS(SELECT Id FROM UserDefaultDashboard WHERE CreatedByUserId = @OperationsPerformedBy))
			        BEGIN
			           
							INSERT INTO [dbo].UserDefaultDashboard(
							            [Id],
							            [DashboardId],
							            [CreatedDateTime],
							            [CreatedByUserId])
							     SELECT NEWID(),
							            @DashboardId,
							            @Currentdate,
							            @OperationsPerformedBy

					END
			        ELSE
			        BEGIN

			                 UPDATE [dbo].UserDefaultDashboard
			                 SET    [DashboardId] = @DashboardId,
			                        [UpdatedDateTime] = @Currentdate 
			                        WHERE CreatedByUserId = @OperationsPerformedBy

			        END

					IF(@DefaultForAll = 1)
					BEGIN

						 UPDATE [dbo].UserDefaultDashboard
			             SET    [IsDefault] = 1
						 WHERE CreatedByUserId = @OperationsPerformedBy

						DELETE UD
						FROM UserDefaultDashboard UD		
						WHERE UD.CreatedByUserId IN (
							SELECT UserId FROM UserRole UR
							INNER JOIN ROLE R ON R.Id = UR.RoleId
							WHERE R.ID IN (SELECT UR2.RoleId FROM UserRole UR2 WHERE UserId = @OperationsPerformedBy)
							AND ur.UserId <> @OperationsPerformedBy 
						)
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
GO