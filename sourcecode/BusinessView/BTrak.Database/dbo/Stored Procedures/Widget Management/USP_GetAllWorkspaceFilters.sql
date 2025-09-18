----------------------------------------------------------------------------------
-- Author       Nikilesh R
-- Created      '2020-05-26 00:00:00.000'
-- Purpose      To Get Workspace filters
-- Copyright © 2020,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
----------------------------------------------------------------------------------
-- EXEC [dbo].[USP_GetWorkspaceFilters] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
----------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetAllWorkspaceFilters]
(
	@DashboardId UNIQUEIDENTIFIER = NULL,
	@DashboardAppId UNIQUEIDENTIFIER = NULL,
	@OperationsPerformedBy UNIQUEIDENTIFIER
)
AS
BEGIN

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	BEGIN TRY
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL;
		
		IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL;

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF (@HavePermission = '1')
        BEGIN
				
			DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

			DECLARE @DashboardAppIds TABLE
			(
				AppId UNIQUEIDENTIFIER
			)

			INSERT INTO @DashboardAppIds
			SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId = @DashboardId

			DECLARE @AppWorkspaceFilters TABLE
			(
				FilterId UNIQUEIDENTIFIER
				,FilterKey NVARCHAR(250)
				,FilterValue NVARCHAR(250)
				,DashboardFilterValue NVARCHAR(250)
				,FilterName  NVARCHAR(250)
				,IsSystemFilter BIT
				,DashboardId UNIQUEIDENTIFIER
				,DashboardAppId UNIQUEIDENTIFIER
			)

			INSERT INTO @AppWorkspaceFilters(FilterId,FilterKey,FilterValue,FilterName,IsSystemFilter,DashboardId,DashboardAppId)
			SELECT  WF.WorkspaceParameterId,WP.ParameterName,WF.FilterValue,WP.ParameterLabel,WP.IsSystemFilter,@DashboardId,WP.ReferenceId
			FROM WorkspaceFilter WF
				INNER JOIN WorkspaceParameter WP ON WP.Id = WF.WorkspaceParameterId
                AND WF.CreatedByUserId = @OperationsPerformedBy
				AND 
					(
						@DashboardId = WP.ReferenceId
						OR (WP.ReferenceId IN (SELECT * FROM @DashboardAppIds) AND @DashboardAppId IS NULL)
					)

			DECLARE @WorkspaceFilters TABLE
			(
				FilterId UNIQUEIDENTIFIER
				,FilterKey NVARCHAR(250)
				,FilterValue NVARCHAR(250)
				,FilterName  NVARCHAR(250)
				,IsSystemFilter BIT
				,DashboardId UNIQUEIDENTIFIER
				,DashboardAppId UNIQUEIDENTIFIER
			)

			INSERT INTO @WorkspaceFilters(FilterId,FilterKey,FilterValue,FilterName,IsSystemFilter,DashboardId,DashboardAppId)
			SELECT WF.WorkspaceParameterId,WP.ParameterName,WF.FilterValue,WP.ParameterLabel,WP.IsSystemFilter,@DashboardId,WP.ReferenceId
			FROM WorkspaceFilter WF
				INNER JOIN WorkspaceParameter WP ON WP.Id = WF.WorkspaceParameterId
                AND WF.CreatedByUserId = @OperationsPerformedBy AND @DashboardId = WP.ReferenceId
				

			UPDATE @AppWorkspaceFilters SET DashboardFilterValue = WF.FilterValue
			FROM @AppWorkspaceFilters AWF 
			LEFT JOIN @WorkspaceFilters WF ON AWF.FilterKey = WF.FilterKey AND WF.IsSystemFilter = AWF.IsSystemFilter
			WHERE AWF.FilterValue IS NULL

			SELECT FilterId,FilterKey,ISNULL(FilterValue,DashboardFilterValue) AS FilterValue,FilterName,IsSystemFilter,DashboardId,DashboardAppId
			FROM @AppWorkspaceFilters
			UNION
			SELECT FilterId,FilterKey,FilterValue,FilterName,IsSystemFilter,DashboardId,DashboardAppId
			FROM @WorkspaceFilters
			WHERE FilterKey NOT IN (SELECT FilterKey FROM @AppWorkspaceFilters)

		END
		ELSE
		BEGIN
			
			RAISERROR(@HavePermission,11,1)

		END

	END TRY
	BEGIN CATCH 
		
		THROW

	END CATCH

END
GO