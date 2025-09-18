CREATE PROCEDURE [dbo].[USP_UpsertDashboardVisuaizationType]
(
   @DashboardId UNIQUEIDENTIFIER = NULL,
   @WorkspaceId  UNIQUEIDENTIFIER = NULL,
   @CustomAppVisualizationId  UNIQUEIDENTIFIER = NULL,
   @OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

	    IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL

	    IF(@DashboardId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'DashboardId')

		END
		ELSE IF(@WorkspaceId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'WorkspaceId')

		END
		ELSE IF(@CustomAppVisualizationId IS NULL)
		BEGIN
		   
		    RAISERROR(50011,16, 2, 'VisualizationType')

		END
		ELSE
		BEGIN

		   DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

			IF (@HavePermission = '1')
			BEGIN
				
				DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					DECLARE @Currentdate DATETIME = GETDATE()

						UPDATE [dbo].[WorkspaceDashboards]
						SET [CustomAppVisualizationId] = @CustomAppVisualizationId
							,CompanyId = @CompanyId
							,[UpdatedDateTime] = @Currentdate
							,[UpdatedByUserId] = @OperationsPerformedBy
						WHERE Id = @DashboardId AND WorkspaceId = @WorkspaceId

					SELECT Id FROM [dbo].[WorkspaceDashboards] WHERE Id = @DashboardId AND WorkspaceId = @WorkspaceId

				END
		END
	END TRY
	BEGIN CATCH

		THROW

	END CATCH

END
GO