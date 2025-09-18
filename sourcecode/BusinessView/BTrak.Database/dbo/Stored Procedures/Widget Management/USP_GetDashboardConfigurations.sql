-------------------------------------------------------------------------------
-- Author       Manoj Kumar Gurram
-- Created      '2019-12-31 00:00:00.000'
-- Purpose      To get the dashboard configurations by applying filters
-- Copyright © 2018,Snovasys Software Solutions India Pvt. Ltd., All Rights Reserved
-------------------------------------------------------------------------------

--EXEC [dbo].[USP_GetDashboardConfigurations] @OperationsPerformedBy='127133F1-4427-4149-9DD6-B02E0E036971'

CREATE PROCEDURE [dbo].[USP_GetDashboardConfigurations]
(
	@DashboardConfigurationId UNIQUEIDENTIFIER = NULL,
	@DashboardId UNIQUEIDENTIFIER = NULL,
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
				DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')

				SELECT DC.Id AS DashboardConfigurationId,
						W.Id AS DashboardId,
						W.WorkspaceName AS DashboardName,
						DC.DefaultDashboardRoles,
						DC.ViewRoles,
						DC.EditRoles,
						DC.DeleteRoles,
						DC.[TimeStamp],
						TotalCount = COUNT(1) OVER()
				FROM [dbo].[Workspace] W WITH (NOLOCK)
					LEFT JOIN [DashboardConfiguration] DC ON W.Id = DC.DashboardId AND W.InactiveDateTime IS NULL
				WHERE W.CompanyId = @CompanyId AND W.InActiveDateTime IS NULL
					AND (@DashboardConfigurationId IS NULL OR DC.Id = @DashboardConfigurationId)
					AND W.IsCustomizedFor IS NULL
					AND (@DashboardId IS NULL OR W.Id = @DashboardId)
					AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND W.WorkspaceName NOT IN ('Testrepo management')))
				ORDER BY W.WorkspaceName
			END
			ELSE
				RAISERROR (@HavePermission,11, 1)
	END TRY
	BEGIN CATCH 
        
        THROW

    END CATCH
END
GO
