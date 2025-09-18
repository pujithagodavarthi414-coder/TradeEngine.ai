-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-22 00:00:00.000'
-- Purpose      To Get Workspaces
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtW., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetWorkspaces] @OperationsPerformedBy = '7eaa4593-746c-4d6e-a5c7-b2c6454ebe23'
-------------------------------------------------------------------------------
Create PROCEDURE [dbo].[USP_GetWorkspaces]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER ,
	@WorkspaceId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = 0,
	@IsHidden BIT = NULL,
	@IsFromExport BIT = NULL,
    @WorkspaceName NVARCHAR(250) = NULL,
	@MenuItemId UNIQUEIDENTIFIER = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1' AND @MenuItemId IS NULL)
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL

		   IF(@IsArchived IS NULL) SET @IsArchived = 0

		   IF(@IsFromExport IS NULL)SET @IsFromExport = 0
		   
		   --IF(@IsHidden IS NULL)SET @IsHidden = 0

		   IF(@WorkspaceName = '')SET @WorkspaceName = NULL

		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@WorkspaceId = '00000000-0000-0000-0000-000000000000') SET @WorkspaceId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   
		   DECLARE @EnableTestRepo BIT 
		   SELECT @EnableTestRepo = cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%'

		   DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)
       	  		 
		   SELECT W.Id
		         ,W.[WorkspaceName]
				 ,W.Description
		         ,W.[CreatedDateTime]
		         ,W.[CreatedByUserId]
		         ,W.[CompanyId]
				 ,W.[IsCustomizedFor]
				 ,IsEditable = CASE WHEN W.CreatedByUserId = @OperationsPerformedBy THEN 1 ELSE 0 END
				 , 1 AS CanView
				 ,CASE WHEN (SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId](CVDC.EditRoles,@OperationsPerformedBy)) > 0 OR @IsSupport =1 THEN 1 ELSE 0 END AS CanEdit
				 ,CASE WHEN UDD.Id IS NOT NULL THEN 1 ELSE CASE WHEN (SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId](CVDC.DefaultDashboardRoles,@OperationsPerformedBy)) > 0 THEN 1 ELSE 0 END END AS IsDefault
				 ,CASE WHEN (SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId](CVDC.DeleteRoles,@OperationsPerformedBy)) > 0  OR @IsSupport =1  THEN 1 ELSE 0 END AS  CanDelete
				 ,[InActiveDateTime]
		         ,W.[Id] AS WorkspaceId
		         ,W.[TimeStamp]
				 ,IsHidden
				 ,RoleIds = CVDC.ViewRoles
				 ,EditRoleIds = CVDC.EditRoles
				 ,IsAppsInDraft = (CASE WHEN (SELECT COUNT(1) FROM WorkspaceDashboards WD WHERE WD.WorkspaceId = W.Id AND WD.IsDraft = 1 AND CreatedByUserId = @OperationsPerformedBy) > 0 THEN 1 ELSE 0 END)
				 ,DeleteRoleIds = CVDC.DeleteRoles	
				 ,DefaultDashboardRoleIds = CVDC.DefaultDashboardRoles
				 ,W.IsListView
				 ,W.MenuItemId
		   		 ,RoleNames =(CASE WHEN CVDC.ViewRoles = '' OR CVDC.ViewRoles IS NULL THEN NULL ELSE ( (STUFF((SELECT ',' + R.RoleName [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](CVDC.ViewRoles,',')) WRC
		   							 INNER JOIN [Role] R ON R.Id = WRC.[Value] AND R.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,'')))
							  END)
			     ,DeleteRoleNames = (CASE WHEN CVDC.DeleteRoles = '' OR CVDC.DeleteRoles IS NULL THEN NULL ELSE ((STUFF((SELECT ',' + R.RoleName [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](CVDC.DeleteRoles,',')) WRC
		   							 INNER JOIN [Role] R ON R.Id = WRC.[Value] AND R.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,'')))
							  END)
                 ,EditRoleNames =(CASE WHEN CVDC.EditRoles= '' OR CVDC.EditRoles IS NULL THEN NULL ELSE ((STUFF((SELECT ',' + R.RoleName [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](CVDC.EditRoles,',')) WRC
		   							 INNER JOIN [Role] R ON R.Id = WRC.[Value] AND R.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,'')))
							  END)
                 ,DefaultDashboardRolesNames = (CASE WHEN CVDC.DefaultDashboardRoles= '' OR CVDC.DefaultDashboardRoles IS NULL THEN NULL ELSE ((STUFF((SELECT ',' + R.RoleName [text()]
		   							 FROM (SELECT [Value] FROM [dbo].[Ufn_StringSplit](CVDC.DefaultDashboardRoles,',')) WRC
		   							 INNER JOIN [Role] R ON R.Id = WRC.[Value] AND R.CompanyId = @CompanyId
		   					  FOR XML PATH(''), TYPE).value('.','NVARCHAR(1000)'),1,1,'')))
							  END),
				CASE WHEN R.ChildDashboardId IS NULL then w.Id ELSE R.ChildDashboardId END  as ParentId
		   FROM  Workspace W 
		   LEFT JOIN DashboardRelation R ON W.ID = R.ParentDashboardId
		   LEFT JOIN DashboardConfiguration CVDC ON CVDC.DashboardId = W.Id AND (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](CVDC.ViewRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0
		   LEFT JOIN UserDefaultDashboard UDD ON UDD.DashboardId = W.Id AND UDD.CreatedByUserId = @OperationsPerformedBy
		   WHERE W.CompanyId = @CompanyId
		   AND (@SearchText IS NULL OR (W.WorkspaceName LIKE @SearchText))
		   AND (@WorkspaceName IS NULL OR W.WorkspaceName = @WorkspaceName)
		   AND (@WorkspaceId IS NULL OR W.Id = @WorkspaceId)
		   AND ((W.IsCustomizedFor IS NULL AND @IsFromExport = 0) OR @IsFromExport =1)
		   AND (@IsHidden IS NULL OR (@IsHidden = 0 AND (W.IsHidden = 0 OR W.IsHidden IS NULL)) OR (@IsHidden = 1 AND W.IsHidden = 1))
		   AND (@IsFromExport = 1 OR @IsSupport =  1 OR (@IsFromExport = 0 AND CVDC.Id IS NOT NULL))
		   AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND W.WorkspaceName NOT IN ('Testrepo management')))
		   AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
		   ORDER BY UDD.Id DESC,CASE WHEN R.ChildDashboardId IS NULL then w.Id ELSE R.ChildDashboardId END DESC,
		   CASE WHEN (SELECT [dbo].[Ufn_GetWidgetPermissionBasedOnUserId](CVDC.DefaultDashboardRoles,@OperationsPerformedBy)) > 0 THEN 1 ELSE 0 END DESC,W.WorkspaceName
		END
		
      
	   ELSE IF(@MenuItemId IS NOT NULL)
		BEGIN
		 SELECT W.Id
		         ,W.[WorkspaceName]
				 ,W.Description
		         ,W.[CreatedDateTime]
		         ,W.[CreatedByUserId]
		         ,W.[CompanyId]
				 ,W.[IsCustomizedFor]
				 ,W.[Id] AS WorkspaceId
		         ,W.[TimeStamp]
			     ,W.MenuItemId
		   	  FROM  Workspace W 
		   
		   WHERE (W.MenuItemId = @MenuItemId)
		   AND (@WorkspaceId IS NULL OR W.Id = @WorkspaceId)
		  
		
		END


	    ELSE
	    BEGIN
	    
	    		RAISERROR (@HavePermission,11, 1)
	    		
	    END


   END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END

