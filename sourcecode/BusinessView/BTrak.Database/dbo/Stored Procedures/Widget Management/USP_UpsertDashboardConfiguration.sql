-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-12-31 00:00:00.000'
-- Purpose      To upsert the dashboard configuration
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_UpsertDashboardConfiguration] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_UpsertDashboardConfiguration]
(
	@DashboardConfigurationId UNIQUEIDENTIFIER = NULL,
	@DashboardId UNIQUEIDENTIFIER = NULL,
	@DefaultDashboardRoles NVARCHAR(MAX) = NULL,
	@ViewRoles NVARCHAR(MAX) = NULL,
	@EditRoles NVARCHAR(MAX) = NULL,
	@DeleteRoles NVARCHAR(MAX) = NULL,
	@TimeStamp TIMESTAMP = NULL,
	@OperationsPerformedBy 	UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
   
            DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
                
            IF (@HavePermission = '1')
            BEGIN

				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
				
				DECLARE @DashboardConfigurationIdCount INT = (SELECT COUNT(1) FROM DashboardConfiguration WHERE Id = @DashboardConfigurationId)
	
				IF(@DashboardConfigurationIdCount = 0 AND @DashboardConfigurationId IS NOT NULL)
				BEGIN
		    
	        		RAISERROR(50002,16, 1,'DashboardConfiguration')
		    
				END
				ELSE
				BEGIN

					DECLARE @IsLatest BIT = (CASE WHEN @DashboardConfigurationId IS NULL 
				                              THEN 1 ELSE CASE WHEN (SELECT [TimeStamp]
																	 FROM [DashboardConfiguration] WHERE Id = @DashboardConfigurationId) = @TimeStamp
															   THEN 1 ELSE 0 END END)
					IF(@IsLatest = 1)
					BEGIN

						DECLARE @Currentdate DATETIME = GETDATE()

						IF(@DashboardConfigurationId IS NULL)
						BEGIN

							SET @DashboardConfigurationId = NEWID()
		
							INSERT INTO [dbo].[DashboardConfiguration](
										[Id],
										[DashboardId],
										[DefaultDashboardRoles],
										[ViewRoles],
										[EditRoles],
										[DeleteRoles],
										[CompanyId],
										[CreatedDateTime],
										[CreatedByUserId]
										)
							SELECT @DashboardConfigurationId,
									@DashboardId,
									@DefaultDashboardRoles,
									@ViewRoles,
									@EditRoles,
									@DeleteRoles,
									@CompanyId,
									@Currentdate,
									@OperationsPerformedBy

						END
						ELSE
						BEGIN

							UPDATE [DashboardConfiguration] SET DashboardId = @DashboardId,
																DefaultDashboardRoles = @DefaultDashboardRoles,
																ViewRoles = @ViewRoles,
																EditRoles = @EditRoles,
																DeleteRoles = @DeleteRoles,
																CompanyId = @CompanyId,
																UpdatedDateTime = @Currentdate,
																UpdatedByUserId = @OperationsPerformedBy
							WHERE Id = @DashboardConfigurationId

						END

						SELECT Id FROM [dbo].[DashboardConfiguration] WHERE Id = @DashboardConfigurationId

					END
					
					ELSE
					RAISERROR (50008,11, 1)

				END

			END
			ELSE
				RAISERROR (@HavePermission,11, 1)
	END TRY
	BEGIN CATCH 
        
        THROW

    END CATCH
END
GO
