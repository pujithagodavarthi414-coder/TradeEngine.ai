CREATE PROCEDURE [dbo].[USP_GetWidgetsBasedOnUserForExport]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
    @CustomWidgetId UNIQUEIDENTIFIER = NULL,
	@WidgetId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
	@IsExport BIT = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		DECLARE @HavePermission NVARCHAR(250)  = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
		
		IF (@HavePermission = '1')
	    BEGIN

		   IF(@SearchText = '') SET @SearchText = NULL
		   
		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@IsArchived IS NULL)SET @IsArchived = 0

		   IF(@IsExport IS NULL ) SET @IsExport = 0

		   IF(@WidgetId = '00000000-0000-0000-0000-000000000000') SET @WidgetId = NULL		   		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

		   DECLARE @EnableSprints BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
           DECLARE @EnableTestRepo BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		   DECLARE @EnableBugs BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

		   --DECLARE @UserRoleId UNIQUEIDENTIFIER  = (SELECT RoleId FROM [User] U WHERE U.Id = @OperationsPerformedBy AND U.InActiveDateTime IS NULL)

		   DECLARE  @DuplicateRecordsCreationTable TABLE
		   (
		    Id INT
			)

			INSERT INTO @DuplicateRecordsCreationTable(Id) VALUES(1),(2)


		    CREATE TABLE #RoleIds 
		   (
				UserRoleId UNIQUEIDENTIFIER
		   )

		   INSERT INTO #RoleIds(UserRoleId)
		   SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)

		   SELECT 
		          ROW_NUMBER() OVER (ORDER BY [WidgetName])  AS Id
		         ,WidgetId
		         ,[WidgetName]
				 ,RoleIds
				 ,[Description]
				 ,[WidgetQuery]
				 ,[FilterQuery]
				 ,[DefaultColumns]
				 ,[CreatedDateTime]
		         ,[CreatedByUserId]
		         ,[CompanyId]
				 ,IsEditable
		         ,[InActiveDateTime]
		         ,[TimeStamp]
				 ,IsCustomWidget
				 ,VisualizationType
				 ,XCoOrdinate
				 ,YCoOrdinate
				 ,VisualizationName
				 ,CustomAppVisualizationId
				 ,Tags
				 ,IsHtml
				 ,IsProc
				 ,IsApi
				 ,ProcName
				 ,IsProcess
				 ,IsEntryApp
				 ,RoleNames
				 ,WorkSpaceNames
				 ,IsPublished
				 ,IsFavouriteWidget
		   FROM (
			  SELECT W.[Id] AS WidgetId
			        ,[WidgetName]
					,RoleIds = (STUFF((SELECT ',' + LOWER(CAST(WRC.RoleId AS NVARCHAR(MAX))) [text()]
				  FROM WidgetRoleConfiguration WRC 
				  WHERE W.Id = WRC.WidgetId  
						AND WRC.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,W.Description
					,NULL AS [WidgetQuery]
					,NULL AS [FilterQuery]
					,NULL AS [DefaultColumns]
			        ,W.[CreatedDateTime]
			        ,W.[CreatedByUserId]
			        ,W.[CompanyId]
					,0 IsEditable
			        ,W.[InActiveDateTime]
			        ,W.[TimeStamp]
					,0 AS IsCustomWidget
					,NULL AS VisualizationType
					,NULL AS XCoOrdinate
					,NULL AS YCoOrdinate
					,NULL AS VisualizationName
					,NULL AS CustomAppVisualizationId
					, Tags =  (STUFF((SELECT ',' + T.TagName [text()]
			  				  FROM CustomTags CT
			  						INNER JOIN Tags T ON CT.ReferenceId = W.Id AND CT.TagId = T.Id 
			   				  WHERE  CT.ReferenceId = W.Id
							  ORDER BY T.[Order]
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,0 AS IsHtml
					,0 AS IsProc
					,0 AS IsApi
					,NULL AS ProcName
					,0 AS IsProcess
					,0 AS IsEntryApp
			  		,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				  FROM WidgetRoleConfiguration WRC 
						INNER JOIN [Role] R ON R.Id = WRC.RoleId 
						AND WRC.InActiveDateTime IS NULL 
						AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
 				  WHERE  W.Id = WRC.WidgetId
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,WorkSpaceNames =  (STUFF((SELECT ',' + WS.WorkspaceName [text()]
                                       FROM WorkspaceDashboards WD
                                       INNER JOIN WorkSpace WS ON WS.Id = WD.WorkspaceId AND (WD.IsCustomWidget = 0 OR WD.IsCustomWidget IS NULL)
                                       WHERE  WD.[Name] = W.WidgetName AND WD.CompanyId = @CompanyId
                                       GROUP BY WS.WorkspaceName
                                       ORDER BY WS.WorkspaceName
                                      FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) 
				  ,NULL AS IsPublished
				 ,FW.IsFavourite IsFavouriteWidget
			  FROM  (
			        SELECT WRC.WidgetId
		            FROM WidgetRoleConfiguration WRC
			             INNER JOIN #RoleIds R ON R.UserRoleId = WRC.RoleId AND WRC.Inactivedatetime IS NULL
		            GROUP BY WRC.WidgetId
			       ) WR
			  INNER JOIN Widget W ON W.Id = WR.WidgetId
			  LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = W.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
			  LEFT JOIN CustomTags CT ON CT.ReferenceId = W.Id
			  WHERE W.CompanyId = @CompanyId
			  AND W.InActiveDateTime IS NULL
			  AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
			  UNION ALL
			  SELECT W.[Id] AS WidgetId
			        ,W.[CustomWidgetName] AS WidgetName
					, RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWRC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomWidgetRoleConfiguration CWRC 
					WHERE W.Id = CWRC.CustomWidgetId AND CWRC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))		
					,W.[Description]
					,W.[WidgetQuery]
					,CACD.[FilterQuery]
					,CACD.[DefaultColumns]
			        ,W.[CreatedDateTime]
			        ,W.[CreatedByUserId]
			        ,W.[CompanyId]
					,ISNULL(W.IsEditable,0) IsEditable
			        ,W.[InActiveDateTime]
					,NULL
					,1 AS IsCustomWidget
					,CACD.VisualizationType
					,CACD.XCoOrdinate
					,CACD.YCoOrdinate
					,CACD.VisualizationName
					,CACD.Id AS CustomAppVisualizationId
					, Tags =  (STUFF((SELECT ',' + T.TagName [text()]
			  				  FROM CustomTags CT
			  						INNER JOIN Tags T ON CT.ReferenceId = W.Id AND CT.TagId = T.Id 
			   				  WHERE  CT.ReferenceId = W.Id
							  ORDER BY T.[Order]
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,0 AS IsHtml
					,IsProc
					,IsApi
					,ProcName
					,0 AS IsProcess
					,0 AS IsEntryApp					
			  		,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
			  				  FROM CustomWidgetRoleConfiguration WRC 
			  						INNER JOIN [Role] R ON R.Id = WRC.RoleId 
			   				  WHERE  W.Id = WRC.CustomWidgetId AND WRC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,WorkSpaceNames =  (STUFF((SELECT ',' + WS.WorkspaceName [text()]
                                       FROM WorkspaceDashboards WD
                                       INNER JOIN WorkSpace WS ON WS.Id = WD.WorkspaceId AND (WD.IsCustomWidget = 0 OR WD.IsCustomWidget IS NULL)
                                       WHERE  WD.[Name] = W.CustomWidgetName AND WD.CompanyId = @CompanyId
                                       GROUP BY WS.WorkspaceName
                                       ORDER BY WS.WorkspaceName
                                      FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) 
					,NULL AS IsPublished
					,FW.IsFavourite IsFavouriteWidget
			  FROM (
			        SELECT CWRC.CustomWidgetId AS WidgetId
		            FROM CustomWidgetRoleConfiguration CWRC
			             INNER JOIN #RoleIds R ON R.UserRoleId = CWRC.RoleId AND CWRC.Inactivedatetime IS NULL
		            GROUP BY CWRC.CustomWidgetId
			       ) WR
			  INNER JOIN CustomWidgets W ON W.Id = WR.WidgetId
			  INNER JOIN CustomAppDetails CACD ON CACD.CustomApplicationId = W.Id AND CACD.InActiveDateTime IS NULL and CACD.IsDefault = 1
			  LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = W.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
			  LEFT JOIN CustomTags CT ON Ct.ReferenceId = W.Id
			  WHERE W.CompanyId = @CompanyId
			  AND W.InActiveDateTime IS NULL
			  AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
			  UNION ALL
			  SELECT WH.[Id] AS WidgetId
			        ,WH.[CustomHtmlAppName] AS WidgetName,
					 RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWHC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomHtmlAppRoleConfiguration CWHC 
					WHERE WH.Id = CWHC.CustomHtmlAppId AND CWHC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,WH.[Description]
					,WH.[HtmlCode] AS WidgetQuery
					,NULL AS FilterQuery
					,NULL AS DefaultColumns
			        ,WH.[CreatedDateTime]
			        ,WH.[CreatedByUserId]
			        ,WH.[CompanyId]
					,0 AS IsEditable
			        ,WH.[InActiveDateTime]
					,WH.TimeStamp
					,0 AS IsCustomWidget
					,NULL AS VisualizationType
					,NULL AS XCoOrdinate
					,NULL AS YCoOrdinate
					,NULL AS VisualizationName
					,NULL AS CustomAppVisualizationId
					,Tags =   (STUFF((SELECT ',' + T.TagName [text()]
			  				  FROM CustomTags CT
			  						INNER JOIN Tags T ON CT.ReferenceId = WH.Id AND CT.TagId = T.Id 
			   				  WHERE  CT.ReferenceId = WH.Id
							  ORDER BY T.[Order]
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,1 AS IsHtml
					,0 AS IsProc
					,0 AS IsApi
					,NULL AS ProcName
					,0 AS IsProcess
					,0 AS IsEntryApp					
			  		,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
			  				  FROM CustomHtmlAppRoleConfiguration WHRC 
			  						INNER JOIN [Role] R ON R.Id = WHRC.RoleId
			   				  WHERE  WH.Id = WHRC.CustomHtmlAppId AND WHRC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,NULL AS WorkSpaceNames
					,NULL AS IsPublished
					,NULL AS IsFavouriteWidget
			  FROM (
			        SELECT CHRC.CustomHtmlAppId AS WidgetId
		            FROM CustomHtmlAppRoleConfiguration CHRC
			             INNER JOIN #RoleIds R ON R.UserRoleId = CHRC.RoleId AND CHRC.Inactivedatetime IS NULL
		            GROUP BY CHRC.CustomHtmlAppId
			       )WR
			  INNER JOIN CustomHtmlApp WH ON WH.Id = WR.WidgetId
			 -- LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = WH.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
			  WHERE WH.CompanyId = @CompanyId
			  AND WH.InActiveDateTime IS NULL
			  AND ((@IsArchived = 1 AND WH.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND WH.InActiveDateTime IS NULL))
			  UNION ALL
			  SELECT CA.[Id] AS WidgetId
			        ,CA.[CustomApplicationName] AS WidgetName
					,RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CARC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomApplicationRoleConfiguration CARC 
					WHERE CA.Id = CARC.CustomApplicationId 
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))	
					,CA.[Description] AS [Description]
					,NULL AS WidgetQuery
					,NULL AS FilterQuery
					,NULL AS DefaultColumns
			        ,CA.[CreatedDateTime]
			        ,CA.[CreatedByUserId]
			        ,FT.[CompanyId]
					 ,0 IsEditable
			        ,CA.[InActiveDateTime]
					,CA.TimeStamp
					,0 AS IsCustomWidget
					,NULL AS VisualizationType
					,NULL AS XCoOrdinate
					,NULL AS YCoOrdinate
					,NULL AS VisualizationName
					,NULL AS CustomAppVisualizationId
					,Tags =  (STUFF((SELECT ',' + T.TagName [text()]
			  				  FROM CustomTags CT
			  						INNER JOIN Tags T ON CT.ReferenceId = CA.Id AND CT.TagId = T.Id 
			   				  WHERE  CT.ReferenceId = CA.Id
							  ORDER BY T.[Order]
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')) 
					,0 AS IsHtml
					,0 AS IsProc
					,0 AS IsApi
					,NULL AS ProcName
					,1 AS IsProcess 
					,CASE WHEN D.Id = 2 THEN 1 ELSE 0 END  AS IsEntryApp					
			  		,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
			  				  FROM CustomApplicationRoleConfiguration CARC 
			  						INNER JOIN [Role] R ON R.Id = CARC.RoleId
			   				  WHERE  CA.Id = CARC.CustomApplicationId 
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
					,NULL AS WorkSpaceNames
					,CA.IsPublished AS IsPublished
					,NULL IsFavouriteWidget
			 FROM (
			        SELECT CARC.CustomApplicationId AS WidgetId
		            FROM CustomApplicationRoleConfiguration CARC
			             INNER JOIN #RoleIds R ON R.UserRoleId = CARC.RoleId 
		            GROUP BY CARC.CustomApplicationId
			       ) WR
			  INNER JOIN @DuplicateRecordsCreationTable D ON 1=1
			  INNER JOIN CustomApplication CA ON CA.Id = WR.WidgetId
			  INNER JOIN [CustomApplicationForms] CAF ON CAF.CustomApplicationId = CA.Id
			  INNER JOIN GenericForm GF ON GF.Id = CAF.GenericFormId AND GF.InActiveDateTime IS NULL
			  INNER JOIN FormType FT ON FT.Id = GF.FormTypeId AND FT.InActiveDateTime IS NULL
			 --LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = CA.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
			 WHERE FT.CompanyId = @CompanyId 
			  AND CA.InActiveDateTime IS NULL
			  AND ((@IsArchived = 1 AND CA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CA.InActiveDateTime IS NULL))

		  ) T
		  WHERE (@SearchText IS NULL OR (T.WidgetName LIKE @SearchText))
			  AND (@WidgetId IS NULL OR T.WidgetId = @WidgetId)
			  AND WidgetName not like '%Feedback type%' AND WidgetName not like 'spent time details'
			  AND ( @IsExport = 1 OR @EnableSprints = 1 OR ((@EnableSprints = 0 OR @EnableSprints IS NULL) AND WidgetName NOT IN ('Sprint replan history','Sprint activity','Sprint bug report')))
			  AND (@IsExport = 1 OR @EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND WidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',
			  'QA created and executed test cases','Talko2  file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',
			  'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
			  AND (@EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND T.WidgetName NOT IN ('Bug priority','Sprint bug report','Bug report','Goals vs Bugs count (p0,p1,p2)',
			  'Project wise missed bugs count','More bugs goals list','Bugs count on priority basis','Goal work items VS bugs count','Bugs list',/*'Priority wise bugs count',*/'Total bugs count','Yesterday QA raised issues','Section details for all scenarios','Regression pack sections details','All testruns','All test suites')))
			  AND (@CustomWidgetId IS NULL OR T.WidgetId = @CustomWidgetId)  
			  GROUP BY WidgetId,[WidgetName],[Description],[WidgetQuery],[FilterQuery],[DefaultColumns],[CreatedDateTime],[CreatedByUserId]
		         ,[CompanyId],[InActiveDateTime],[TimeStamp],IsCustomWidget,VisualizationType,XCoOrdinate,YCoOrdinate,VisualizationName
				 ,CustomAppVisualizationId,IsEditable,Tags,IsHtml,IsProc,IsApi,ProcName,RoleNames,WorkSpaceNames,RoleIds,IsProcess,IsPublished,IsEntryApp,IsFavouriteWidget
		  ORDER BY WidgetName ASC

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