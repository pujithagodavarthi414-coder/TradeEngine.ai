-------------------------------------------------------------------------------
-- Author       Anupam Sai Kumar
-- Created      '2019-11-01 00:00:00.000'
-- Purpose      To Get Custom Widgets
-- Copyright © 2019,Snovasys Software Solutions India Pvt. LtW., All Rights Reserved
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--EXEC  [dbo].[USP_GetCustomWidgets] @OperationsPerformedBy = '127133F1-4427-4149-9DD6-B02E0E036971'
-------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[USP_GetCustomWidgets]
(
    @OperationsPerformedBy UNIQUEIDENTIFIER,
	@CustomWidgetId UNIQUEIDENTIFIER = NULL,	
	@DashboardId UNIQUEIDENTIFIER = NULL,	
	@SearchText NVARCHAR(250) = NULL,
	@IsArchived BIT = NULL,
    @CustomWidgetName NVARCHAR(250) = NULL,
    @IsExport BIT = NULL,
	@IsQuery BIT = NULL
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
		   
		   IF(@IsExport IS  NULL)SET @IsExport = 0

		   SET @SearchText = '%'+ @SearchText +'%'

		   IF(@CustomWidgetName = '') SET @CustomWidgetName = NULL

		   IF(@CustomWidgetId = '00000000-0000-0000-0000-000000000000') SET @CustomWidgetId = NULL		  
		   
		   IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL		  
		   
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))
		   DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
           DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
		   DECLARE @EnableBugs BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')

		   
       	         DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)
       	   
		   SELECT *,TotalCount = COUNT(1) OVER() FROM(
           SELECT CW.Id AS CustomWidgetId,
				  RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWRC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomWidgetRoleConfiguration CWRC 
					WHERE CW.Id = CWRC.CustomWidgetId AND CWRC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
				 ModuleIds = (STUFF((SELECT ',' + LOWER(CAST(WM.ModuleId AS NVARCHAR(MAX))) [text()]
					FROM WidgetModuleConfiguration WM 
					WHERE CW.Id = WM.WidgetId AND WM.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
				ModuleNames = (STUFF((SELECT ',' + LOWER(CAST(M.ModuleName AS NVARCHAR(MAX))) [text()]
					FROM WidgetModuleConfiguration WM INNER JOIN Module M ON M.Id = WM.ModuleId  
					WHERE CW.Id = WM.WidgetId AND WM.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
				  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
					FROM CustomWidgetRoleConfiguration CWRC 
				    INNER JOIN [Role] R ON R.Id = CWRC.RoleId AND CWRC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
 					WHERE CW.Id = CWRC.CustomWidgetId
					ORDER BY R.RoleName ASC			  			  
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
		   	      CW.CustomWidgetName,
				  CW.WidgetQuery,
				  CW.IsEditable,
				  CW.[Description],
		   	      CW.InActiveDateTime,
				  CAD.XCoOrdinate,
				  CAD.YCoOrdinate AS YAxisDetails,
				  CAD.VisualizationType,
				  CAD.VisualizationName,
				  CE.CronExpressionName,
				  CE.CronExpression,
				  CE.SelectedChartIds AS SelectedCharts,
				  CE.TemplateType,
				  CE.TemplateUrl,
				  CE.Id As CronExpressionId,
				  CE.TimeStamp,
				  CE.JobId,
				  (SELECT (SELECT  CACD.Id AS CustomApplicationChartId,
					               CACD.XCoOrdinate,
								   CACD.YCoOrdinate AS YAxisDetails,
								   CACD.IsDefault,
								   CACD.VisualizationType,
				                   CACD.VisualizationName,
								   CACD.PivotMeasurersToDisplay,
								   CACD.HeatMapMeasure,
								   CACD.DefaultColumns As DefaultColumnsXml,
								   CACD.ChartColorJson,
      CW.ColumnBackgroundColor,
      CW.ColumnFontColor,
      CW.ColumnFontFamily,
      CW.RowBackgroundColor,
      CW.HeaderBackgroundColor,
      CW.HeaderFontColor,
								   CASE WHEN @DashboardId IS NOT NULL THEN ISNULL(CAP.FilterQuery,CACD.FilterQuery) ELSE CACD.FilterQuery END AS FilterQuery,
								   
								   ISNULL((SELECT TOP 1
										[PersistanceJson]
										FROM [Persistance] WHERE ReferenceId = CACD.Id AND [UserId] = @OperationsPerformedBy AND [IsUserLevel] = 1), '') AS
									'PersistanceJson'
					       FROM CustomAppDetails CACD WITH (NOLOCK)	
						   JOIN CustomWidgets CW1 ON CACD.CustomApplicationId = CW1.Id
						   AND CACD.InActiveDateTime IS NULL
	  	  			       WHERE CW1.Id = CW.Id
						     AND CACD.InactiveDateTime IS NULL
                     FOR XML PATH('CustomAppChartModel'), TYPE)FOR XML PATH('CustomWidgetsMultipleChartsModel'), TYPE) AS CustomWidgetsMultipleChartsXML,

		   	      CW.CreatedDateTime,
		   	      CW.CreatedByUserId,
				  CW.UpdatedByUserId,
				  CW.UpdatedDateTime,
				  FW.IsFavourite IsFavouriteWidget,
				 (SELECT ColumnName Field,ColumnType [Filter],SubQuery,SubQueryTypeId,[Hidden],Width
 FROM CustomAppColumns WHERE CustomWidgetId =  CW.Id
  FOR XML PATH('CustomWidgetHeaderModel'), ROOT('CustomAppColumns'), TYPE) AS CustomAppColumns,
				Tags = (STUFF((SELECT ',' + T.TagName [text()]
				  FROM  [CustomTags] CT 
						INNER JOIN [Tags]T ON T.Id = CT.TagId
						AND CW.CompanyId = @CompanyId
 				  WHERE  CW.Id = CT.ReferenceId
				  GROUP BY T.TagName,T.[Order]
				  ORDER BY T.[order] ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				  CASE WHEN CW.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  0 AS IsHtml,
				  CW.IsProc,
				  CW.IsApi,
				  CW.ProcName,
				  CSW.Id AS CustomStoredProcId,
				  CSW.[TimeStamp] AS CustomProcWidgetTimeStamp,
				  NULL AS FileUrls,
				  CW.[IsQuery],
				  CW.[CollectionName],
				  CW.IsMongoQuery
           FROM CustomWidgets AS CW	 
				JOIN CustomAppDetails CAD ON CAD.CustomApplicationId = CW.Id AND CAD.IsDefault = 1 AND CAD.InActiveDateTime IS NULL
		        LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = CW.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
				LEFT JOIN WorkSpaceDashboards WD ON WD.CustomWidgetId = CW.Id
				          AND @DashboardId IS NOT NULL AND WD.InActiveDateTime IS NULL AND WD.Id = @DashboardId
				LEFT JOIN CronExpression CE ON CE.CustomWidgetId = CW.Id AND CE.InActiveDateTime IS NULL 
		        LEFT JOIN [dbo].[CustomAppFilter] CAP ON CAP.[DashboardId] = WD.Id AND CAP.CreatedByUserId = @OperationsPerformedBy
				--LEFT JOIN CustomTags CT ON CT.ReferenceId = CW.Id
				LEFT JOIN CustomStoredProcWidget CSW ON CSW.CustomWidgetId = CW.Id
				--LEFT JOIN (SELECT WidgetId FROM  WidgetModuleConfiguration WMC WHERE  WMC.InActiveDateTime IS NULL 
		             --    AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport= 1)) GROUP BY WidgetId)WMC ON  WMC.WidgetId = CW.Id 
               -- LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL GROUP BY WidgetId)MC  ON MC.WidgetId = CW.Id
           WHERE CW.CompanyId = @CompanyId
		      --AND CW.Id IN (SELECT WidgetId FROM WidgetModuleConfiguration WMC INNER JOIN CompanyModule CM ON CM.ModuleId = WMC.ModuleId WHERE CompanyId = @CompanyId)
		       AND (@SearchText IS NULL OR (CW.CustomWidgetName LIKE @SearchText))
		   	   AND (@CustomWidgetId IS NULL OR CW.Id = @CustomWidgetId)
			   --AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
               AND (@CustomWidgetName IS NULL OR CW.CustomWidgetName = @CustomWidgetName)
			   AND (@IsExport = 1 OR @EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND CW.CustomWidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',
			  'QA created and executed test cases','Talko2  file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',
			 'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
			   AND (@IsExport = 1 OR @EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND CW.CustomWidgetName NOT IN ('Goals vs Bugs count (p0,p1,p2)',
			  'Project wise missed bugs count','More bugs goals list','Bugs count on priority basis','Goal work items VS bugs count','Bugs list',/*'Priority wise bugs count',*/'Total bugs count','Yesterday QA raised issues','Section details for all scenarios','Regression pack sections details','All testruns','All test suites')))
			   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CW.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CW.InActiveDateTime IS NULL))
				AND (@IsQuery IS NULL OR (@IsQuery = 1 AND CW.IsQuery = @IsQuery))

		   UNION ALL

		   SELECT CH.Id AS CustomWidgetId,
				  RoleIds = (STUFF((SELECT ',' + LOWER(CAST(CWHC.RoleId AS NVARCHAR(MAX))) [text()]
					FROM CustomHtmlAppRoleConfiguration CWHC 
					WHERE CH.Id = CWHC.CustomHtmlAppId AND CWHC.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				ModuleIds = (STUFF((SELECT ',' + LOWER(CAST(WM.ModuleId AS NVARCHAR(MAX))) [text()]
					FROM WidgetModuleConfiguration WM 
					WHERE CH.Id = WM.WidgetId AND WM.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
				ModuleNames = (STUFF((SELECT ',' + LOWER(CAST(M.ModuleName AS NVARCHAR(MAX))) [text()]
					FROM WidgetModuleConfiguration WM INNER JOIN Module M ON M.Id = WM.ModuleId  
					WHERE CH.Id = WM.WidgetId AND WM.InActiveDateTime IS NULL
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),	
			
				  RoleNames = (STUFF((SELECT ',' + R.RoleName [text()]
					FROM CustomHtmlAppRoleConfiguration CWHC 
				    INNER JOIN [Role] R ON R.Id = CWHC.RoleId AND CWHC.InActiveDateTime IS NULL AND R.InactiveDateTime IS NULL
 					WHERE CH.Id = CWHC.CustomHtmlAppId
					ORDER BY R.RoleName ASC			  			  
					FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
		   	      CH.CustomHtmlAppName AS CustomWidgetName,
				  CH.HtmlCode AS  WidgetQuery,
				  NULL AS IsEditable,
				  CH.[Description],
		   	      CH.InActiveDateTime,
				  NULL AS XCoOrdinate,
				  NULL AS YAxisDetails,
				  NULL AS VisualizationType,
				  NULL AS VisualizationName,
				  NULL AS CronExpressionName,
				  NULL AS CronExpression,
				  NULL AS SelectedCharts,
				  NULL AS TemplateType,
				  NULL AS TemplateUrl,
				  NULL As CronExpressionId,
				  CH.TimeStamp,
				  NULL AS JobId,
				  NULL AS CustomWidgetsMultipleChartsXML,
		   	      CH.CreatedDateTime,
		   	      CH.CreatedByUserId,
				  CH.UpdatedByUserId,
				  CH.UpdatedDateTime,
				  null IsFavouriteWidget,
				  null CustomAppColumns,
				  Tags = (STUFF((SELECT ',' + T.TagName [text()]
				  FROM  [CustomTags] CT 
						INNER JOIN [Tags]T ON T.Id = CT.TagId
						AND CH.CompanyId = @CompanyId
 				  WHERE  CH.Id = CT.ReferenceId
				  GROUP BY T.TagName,T.[Order]
				  ORDER BY T.[order] ASC			  			  
				  FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,1,'')),
				  CASE WHEN CH.InActiveDateTime IS NULL THEN 0 ELSE 1 END IsArchived,
				  1 AS IsHtml,
				  0 AS IsProc,
				  0 AS IsApi,
				  NULL AS ProcName,
				  NULL AS CustomStoredProcId,
				  NULL AS CustomProcWidgetTimeStamp,
				  CH.FileUrls,
				  0 AS IsQuery,
				  NULL AS CollectionName,
				  0 AS IsMongoQuery
           FROM CustomHtmlApp AS CH	 --LEFT JOIN (SELECT WidgetId FROM  WidgetModuleConfiguration WMC WHERE  WMC.InActiveDateTime IS NULL 
		   --AND ModuleId IN (SELECT ModuleId FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND (IsActive = 1 OR @IsSupport= 1)) GROUP BY WidgetId)WMC ON  WMC.WidgetId = CH.Id 
		   --LEFT JOIN (SELECT WidgetId FROM WidgetModuleConfiguration WRC WHERE  WRC.InActiveDateTime IS NULL GROUP BY WidgetId)MC  ON MC.WidgetId = CH.Id
		   WHERE CH.CompanyId = @CompanyId
		    AND (@SearchText IS NULL OR (CH.CustomHtmlAppName LIKE @SearchText))
			AND (@CustomWidgetName IS NULL OR CH.CustomHtmlAppName = @CustomWidgetName)
		   	AND (@CustomWidgetId IS NULL OR CH.Id = @CustomWidgetId)
			--AND (WMC.WidgetId IS NOT NULL OR MC.WidgetId IS NULL)
		   AND (@IsArchived IS NULL OR (@IsArchived = 1 AND CH.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CH.InActiveDateTime IS NULL))
		   ) T
		   ORDER BY T.CustomWidgetName ASC

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
