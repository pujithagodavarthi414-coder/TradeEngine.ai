-------------------------------------------------------------------------------
-- Author       Padmini Badam
-- Created      '2019-05-23 00:00:00.000'
-- Purpose      To Get Dashboards
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtD., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetDashboards] @OperationsPerformedBy = 'd2d64a3c-cb87-4e88-b5cc-4a93a6e91341',@WorkspaceId='30cc1be3-e9b7-434b-b473-c3144a359bd9'
-------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[USP_GetDashboards]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER = NULL,
	@DashboardId UNIQUEIDENTIFIER = NULL,	
	@WorkspaceId  UNIQUEIDENTIFIER = NULL,	
	@IsArchived BIT = NULL,
    @CustomWidgetId UNIQUEIDENTIFIER = NULL,
    @AppName NVARCHAR(250) = NULL,
	@DashboardName  NVARCHAR(250) = NULL,
	@IsFromExport BIT=null

)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
			
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL		
		   
		   IF(@CustomWidgetId = '00000000-0000-0000-0000-000000000000') SET @CustomWidgetId = NULL    

           IF(@AppName = '') SET @AppName = NULL

		   IF(@IsFromExport IS NULL) SET @IsFromExport = 0
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @HaveAccess BIT = 0 

		     DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

            DECLARE @TabsCount INT = (SELECT COUNT(1) FROM DynamicTab WHERE Id = @WorkspaceId AND InActiveDateTime IS NULL)
       	   
		   IF( EXISTS(SELECT W.Id FROM  Workspace W INNER JOIN DashboardConfiguration CVDC ON CVDC.DashboardId = W.Id  AND W.Id = @WorkspaceId
		                      AND (SELECT COUNT(1) RoleIdsCount FROM [dbo].[Ufn_StringSplit](CVDC.ViewRoles,',')T WHERE IIF(T.Value = '',NULL,T.Value) 
		                      IN (SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)))  > 0) OR @TabsCOunt >0 )
		   BEGIN

		   SET @HaveAccess = 1

		   END

           SELECT D.Id AS DashboardId,
		   	      D.CompanyId,
				  D.WorkspaceId,
				  ISNULL(DP.[X], D.[X]) AS [X],
				  ISNULL(Dp.[Y],D.[Y]) AS [Y],
				  ISNULL(Dp.[Row],D.[Row]) AS [Rows],
				  ISNULL(Dp.[Col],D.[Col]) AS [Cols],
				  ISNULL(Dp.[MinItemCols],D.[MinItemCols]) [MinItemCols],
				  ISNULL(Dp.[MinItemRows],D.[MinItemRows]) [MinItemRows],
				  D.[Name],
				  D.[Component],
				   ModuleIds = (STUFF((SELECT ',' + LOWER(CAST(WM.ModuleId AS NVARCHAR(MAX))) [text()]
					FROM WidgetModuleConfiguration WM 
					WHERE ISNULL(D.CustomWidgetId,WW.Id) = WM.WidgetId AND WM.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
				  ISNULL((SELECT TOP 1
						   [PersistanceJson]
					FROM [Persistance] WHERE ReferenceId = D.CustomAppVisualizationId AND [UserId] = @OperationsPerformedBy AND [IsUserLevel] = 1), '') AS
				  'PersistanceJson',
				  D.[CustomWidgetId],
				  D.[IsCustomWidget],
				  D.IsDraft,
				  W.WorkspaceName,
		   	      D.CreatedDateTime,
		   	      D.CreatedByUserId,
				  D.DashboardName,
				  D.CustomAppVisualizationId,
				  CW.IsProc,
				  CW.IsApi,
				  CW.IsEditable,
				  CASE WHEN CHA.Id IS NOT NULL THEN 1 ELSE 0 END IsHtml,
				  CASE WHEN CA.Id IS NOT NULL THEN 1 ELSE 0 END IsProcess,
				  CW.ProcName,
				  CW.CustomWidgetName AS CustomWidgetOriginalName,
				  CASE WHEN D.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  D.ExtraVariableJson,
				  CW.IsMongoQuery,
				  CW.CollectionName,
				  ISNULL(DO.[Order],D.[Order]) AS [Order],
		   	      TotalCount = COUNT(1) OVER()
           FROM WorkspaceDashboards D		        
				LEFT JOIN Workspace W ON D.WorkspaceId = W.Id AND D.InActiveDateTime IS NULL  AND W.Id = @WorkspaceId
				LEFT JOIN DynamicTab DT ON DT.Id = D.WorkspaceId AND DT.Id = @WorkspaceId AND DT.InActiveDateTime IS NULL
				LEFT JOIN DashboardPersistance DP ON DP.DashboardId = D.Id AND DP.CreatedByUserId = @OperationsPerformedBy
				LEFT JOIN DashboardCustomViewOrder DO ON DO.DashboardId = D.Id AND DO.WorkspaceId = W.Id AND DO.UserId = @OperationsPerformedBy
				LEFT JOIN CustomWidgets CW ON CW.Id = D.CustomWidgetId
				LEFT JOIN CustomHtmlApp CHA ON CHA.Id = D.CustomWidgetId
				LEFT JOIN CustomApplication CA ON CA.Id = D.CustomWidgetId
				LEFT JOIN Widget WW ON WW.WidgetName =  D.[Name] AND WW.CompanyId = @CompanyId AND D.IsCustomWidget = 0
           WHERE D.CompanyId = @CompanyId
				AND (D.IsDraft = 0 OR D.IsDraft IS NULL OR (D.IsDraft = 1 AND D.CreatedByUserId = @OperationsPerformedBy))
		   	    AND (@DashboardId IS NULL OR D.Id = @DashboardId)
				AND (DT.Id IS NULL OR W.Id IS NULL)
			    AND (@CustomWidgetId IS NULL OR D.CustomWidgetId = @CustomWidgetId)
                AND ((@AppName IS NULL OR D.[Name] = @AppName) AND (@IsFromExport = 0 OR (( @DashboardName IS NULL AND  D.DashboardName IS NULL) OR  D.DashboardName = @DashboardName)))
			    AND D.WorkspaceId = @WorkspaceId
			    AND D.InActiveDateTime IS NULL
				AND (W.IsCustomizedFor IS NOT NULL OR @HaveAccess = 1 OR @IsSupport = 1)
		   ORDER BY  ISNULL(DO.[Order],D.[Order]),D.[Name]   ASC,D.CreatedDateTime desc;

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