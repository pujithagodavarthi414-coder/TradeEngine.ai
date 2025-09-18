-------------------------------------------------------------------------------
-- Author       Geetha Ch
-- Created      '2020-02-06 00:00:00.000'
-- Purpose      To Get the Workspace Dashboard Filters
-- Copyright © 2019,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------
--EXEC [dbo].[USP_GetWorkspaceDashboardFilters] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetWorkspaceDashboardFilters]
(
	@OperationsPerformedBy UNIQUEIDENTIFIER,
	@WorkspaceDashboardFilterId UNIQUEIDENTIFIER = NULL,
	@WorkspaceDashboardId UNIQUEIDENTIFIER = NULL,
	@IsCalenderView BIT = NULL
)
AS
BEGIN
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		
		IF(@WorkspaceDashboardFilterId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardFilterId = NULL
		
		IF(@WorkspaceDashboardId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceDashboardId = NULL
		
		IF(@OperationsPerformedBy = '00000000-0000-0000-0000-000000000000') SET @OperationsPerformedBy = NULL
		
		DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		
		DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))

		IF(@HavePermission = '1')
		BEGIN
			
			SELECT WDF.Id AS WorkspaceDashboardFilterId
			       ,WDF.WorkspaceDashboardId
				   ,WDF.FilterJson
				   ,WDF.IsCalenderView
				   ,WDF.CreatedByUserId
				   ,WDF.CreatedDateTime
			FROM WorkspaceDashboardFilter WDF
			WHERE CreatedByUserId = @OperationsPerformedBy
			      AND (@WorkspaceDashboardFilterId IS NULL OR @WorkspaceDashboardFilterId = WDF.Id)
				  AND (@WorkspaceDashboardId IS NULL OR @WorkspaceDashboardId = WDF.WorkspaceDashboardId)
				 -- AND (@IsCalenderView IS NULL OR @IsCalenderView = WDF.IsCalenderView)
			ORDER BY WDF.CreatedDateTime DESC

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
