-- EXEC [dbo].[USP_GetAllWidgets] @OperationsPerformedBy = 'f0ff4ff3-6193-436e-a9db-3698cab79c66', @PageNumber = 2, @Pagesize = 0
CREATE PROC [dbo].[USP_GetAllWidgets]
(
@OperationsPerformedBy UNIQUEIDENTIFIER,
@WidgetId UNIQUEIDENTIFIER = NULL,	
@SearchText NVARCHAR(250) = NULL,
@IsArchived BIT = NULL,
@PageNumber INT = 1,
@PageSize INT = 30,
@SortBy NVARCHAR(100) = NULL,
@SortDirection NVARCHAR(100) = NULL
)
AS
BEGIN
   SET NOCOUNT ON
   BEGIN TRY
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 
				DECLARE @HavePermission NVARCHAR(250) = (SELECT [dbo].[Ufn_UserCanHaveAccess](@OperationsPerformedBy,(SELECT OBJECT_NAME(@@PROCID))))
				IF(@HavePermission = '1')
					BEGIN					
					   IF(@SearchText = '') SET @SearchText = NULL
		   
					   SET @SearchText = '%'+ @SearchText +'%'

					   IF(@IsArchived IS NULL)SET @IsArchived = 0

					   IF(@WidgetId = '00000000-0000-0000-0000-000000000000') SET @WidgetId = NULL		   		  
		   
					   DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

					   DECLARE @EnableSprints BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
					   DECLARE @EnableTestRepo BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
					   DECLARE @EnableBugs BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

					   	    DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

			SELECT *, TotalCount = COUNT(1) OVER() FROM	( SELECT W.Id AS WidgetId
		   	      ,W.WidgetName
		   	      ,W.[Description]
				  ,NULL AS [WidgetQuery]
					,NULL AS [FilterQuery]
					,NULL AS [DefaultColumns]
		   	      ,W.[TimeStamp]
				  ,0 AS IsHtml
					,0 AS IsProc
					,0 AS IsApi
					,0 AS IsMongoQuery
					,NULL AS ProcName
				  	,0 AS IsCustomWidget
					,NULL AS VisualizationType
					,NULL AS XCoOrdinate
					,NULL AS YCoOrdinate
					,NULL AS VisualizationName
					,NULL AS CustomAppVisualizationId
					,RoleIds = (STUFF((SELECT ',' + LOWER(CAST(WRC.RoleId AS NVARCHAR(MAX))) [text()]
				  FROM WidgetRoleConfiguration WRC 
				  WHERE W.Id = WRC.WidgetId  
						AND WRC.InActiveDateTime IS NULL
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))		   
				  ,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
				  FROM WidgetRoleConfiguration WRC 
						INNER JOIN [Role] R ON R.Id = WRC.RoleId 
						AND WRC.InActiveDateTime IS NULL 
						AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
 				  WHERE  W.Id = WRC.WidgetId
				  ORDER BY R.RoleName ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,Tags = (STUFF((SELECT ',' + T.TagName [text()]
				  FROM  [CustomTags] CT 
						INNER JOIN [Tags]T ON T.Id = CT.TagId
						AND W.CompanyId = @CompanyId
 				  WHERE  W.Id = CT.ReferenceId
				  GROUP BY T.TagName,T.[Order]
				  ORDER BY T.[order] ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,@IsArchived IsArchived
				  ,NULL AS CollectionName
		   	     
           FROM Widget AS W	LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL 
			  AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))  GROUP BY WidgetId)WMC ON WMC.WidgetId = W.Id
			  LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL GROUP BY WidgetId)MC  ON MC.WidgetId = W.Id
           WHERE W.CompanyId = @CompanyId
		        --AND W.Id IN (SELECT WidgetId FROM WidgetModuleConfiguration WMC INNER JOIN CompanyModule CM ON CM.ModuleId = WMC.ModuleId AND WMC.InActiveDateTime IS NULL WHERE CM.CompanyId = @CompanyId)
		       AND (@SearchText IS NULL OR (W.WidgetName LIKE @SearchText))
		   	   AND (@WidgetId IS NULL OR W.Id = @WidgetId)
			   AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
			   AND (@EnableSprints = 1 OR ((@EnableSprints = 0 OR @EnableSprints IS NULL) AND W.WidgetName NOT IN ('Sprint replan history','Sprint activity','Sprint bug report')))
			   AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND WidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',
			  'QA created and executed test cases','Talko2  file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',
			  'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
			  AND (@EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND W.WidgetName NOT IN ('Bug priority','Bug report','Sprint bug report','Project wise bugs count')))
			  AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
		   
		   UNION ALL
		   
		   SELECT W.[Id] AS WidgetId
			        ,W.[CustomWidgetName] AS WidgetName						
					,W.[Description]
					,W.[WidgetQuery]
					,CACD.[FilterQuery]
					,CACD.[DefaultColumns]
					,NULL
					,0 AS IsHtml
					,IsProc
					,IsApi
					,ProcName
					,IsMongoQuery
					,1 AS IsCustomWidget
					,CACD.VisualizationType
					,CACD.XCoOrdinate
					,CACD.YCoOrdinate
					,CACD.VisualizationName
					,CACD.Id AS CustomAppVisualizationId
					, RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWRC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomWidgetRoleConfiguration CWRC 
					WHERE W.Id = CWRC.CustomWidgetId AND CWRC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))	
			  		,RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
			  				  FROM CustomWidgetRoleConfiguration WRC 
			  						INNER JOIN [Role] R ON R.Id = WRC.RoleId 
			   				  WHERE  W.Id = WRC.CustomWidgetId AND WRC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
						AND R.CompanyId = @CompanyId
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))							  
					, Tags =  (STUFF((SELECT ',' + T.TagName [text()]
			  				  FROM CustomTags CT
			  						INNER JOIN Tags T ON CT.ReferenceId = W.Id AND CT.TagId = T.Id 
			   				  WHERE  CT.ReferenceId = W.Id
							  ORDER BY T.[Order]
			  				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,@IsArchived IsArchived
				  ,W.CollectionName
		   	      
			 FROM CustomWidgets W 
			  INNER JOIN CustomAppDetails CACD ON CACD.CustomApplicationId = W.Id AND CACD.InActiveDateTime IS NULL and CACD.IsDefault = 1
			  LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL 
			  AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1)) GROUP BY WidgetId)WMC ON WMC.WidgetId = W.Id
			  LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL GROUP BY WidgetId)MC  ON MC.WidgetId = W.Id
			  LEFT JOIN CustomTags CT ON Ct.ReferenceId = W.Id
			  WHERE  W.CompanyId = @CompanyId
		       AND (@SearchText IS NULL OR (W.CustomWidgetName LIKE @SearchText))
		   	   AND (@WidgetId IS NULL OR W.Id = @WidgetId)
			   AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
			   AND ( @EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND W.CustomWidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',
			  'QA created and executed test cases','Talko2  file uploads testrun details','Regression test run report','All test suites','Reports details','All versions','Regression pack sections details',
			 'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
			   AND (@EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND W.CustomWidgetName NOT IN ('Goals vs Bugs count (p0,p1,p2)','Goals vs Bugs count (p0, p1, p2)',
			  'Project wise missed bugs count','Project wise bugs count','More bugs goals list','Bugs count on priority basis','Highest bugs goals list','Goal work items VS bugs count','Bugs list',/*'Priority wise bugs count',*/'Total bugs count','Yesterday QA raised issues','Section details for all scenarios','Regression pack sections details','All testruns','All test suites')))
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))

			   UNION ALL


			   SELECT CH.Id AS WidgetId,
		   	      CH.CustomHtmlAppName AS WidgetName,
				  CH.[Description],				  
				  CH.HtmlCode AS  WidgetQuery
					,NULL AS FilterQuery
					,NULL AS DefaultColumns
					,CH.TimeStamp
					  ,1 AS IsHtml,
				  0 AS IsProc,
				  0 AS IsApi,
				  0 AS IsMongoQuery,
				  NULL AS ProcName
					,0 AS IsCustomWidget
				  ,NULL AS VisualizationType,
				  NULL AS XCoOrdinate,
				  NULL AS YAxisDetails,
				  NULL AS VisualizationName
					,NULL AS CustomAppVisualizationId
				   ,RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWHC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomHtmlAppRoleConfiguration CWHC 
					WHERE CH.Id = CWHC.CustomHtmlAppId AND CWHC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),				   
				  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
					FROM CustomHtmlAppRoleConfiguration CWHC 
				    INNER JOIN [Role] R ON R.Id = CWHC.RoleId AND CWHC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
 					WHERE CH.Id = CWHC.CustomHtmlAppId
					ORDER BY R.RoleName ASC			  			  
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
					Tags = (STUFF((SELECT ',' + T.TagName [text()]
				  FROM  [CustomTags] CT 
						INNER JOIN [Tags]T ON T.Id = CT.TagId
						AND CH.CompanyId = @CompanyId
 				  WHERE  CH.Id = CT.ReferenceId
				  GROUP BY T.TagName,T.[Order]
				  ORDER BY T.[order] ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,''))
				  ,@IsArchived IsArchived
		   	      ,NULL AS CollectionName
           FROM CustomHtmlApp AS CH	LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL 
			  AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport = 1))  GROUP BY WidgetId)WMC ON WMC.WidgetId = CH.Id
			   LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL GROUP BY WidgetId)MC  ON MC.WidgetId = CH.Id
		   WHERE CH.CompanyId = @CompanyId
		    AND (@SearchText IS NULL OR (CH.CustomHtmlAppName LIKE @SearchText))
		   	AND (@WidgetId IS NULL OR CH.Id = @WidgetId)
			AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
		   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CH.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CH.InActiveDateTime IS NULL))
) A

		    GROUP BY WidgetId,[WidgetName],[Description],[WidgetQuery],[FilterQuery],[DefaultColumns],[TimeStamp],IsCustomWidget,VisualizationType,XCoOrdinate,YCoOrdinate,VisualizationName
				 ,CustomAppVisualizationId,Tags,IsHtml,IsProc,IsApi,ProcName,RoleNames,RoleIds,IsArchived,IsMongoQuery,CollectionName

		  ORDER BY 
					CASE WHEN (@SortDirection IS NULL OR @SortDirection = 'ASC') THEN
						 CASE  WHEN(@SortBy IS NULL OR @SortBy = 'WidgetName') THEN WidgetName
							   WHEN(@SortBy = 'Description') THEN [Description]
							   WHEN @SortBy = 'Tags' THEN Tags
							   WHEN @SortBy = 'RoleNames' THEN RoleNames
						  END
					 END ASC,
					 CASE WHEN @SortDirection = 'DESC' THEN
						 CASE  WHEN(@SortBy IS NULL OR @SortBy = 'WidgetName') THEN WidgetName
							   WHEN(@SortBy = 'Description') THEN [Description]
							   WHEN @SortBy = 'Tags' THEN Tags
							   WHEN @SortBy = 'RoleNames' THEN RoleNames
							   END
					 END DESC
		    OFFSET ((@PageNumber - 1) * @PageSize) ROWS
				
				FETCH NEXT @PageSize ROWS ONLY 



					END
				ELSE
					BEGIN
					 RAISERROR (@HavePermission,10, 1)
					END

    END TRY
   BEGIN CATCH
       
       THROW

   END CATCH 
END