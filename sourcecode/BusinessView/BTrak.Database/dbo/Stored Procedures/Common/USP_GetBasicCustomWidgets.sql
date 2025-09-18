CREATE PROCEDURE [dbo].[USP_GetBasicCustomWidgets]     
(    
    @OperationsPerformedBy UNIQUEIDENTIFIER,    
 @CustomWidgetId UNIQUEIDENTIFIER = NULL,     
 @DashboardId UNIQUEIDENTIFIER = NULL,     
 @SearchText NVARCHAR(250) = NULL,    
 @IsArchived BIT = NULL,    
    @CustomWidgetName NVARCHAR(250) = NULL,    
    @IsExport BIT = NULL    
)    
AS    
BEGIN    
   SET NOCOUNT ON    
   BEGIN TRY    
   SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED     
    
     IF(@CustomWidgetId = '00000000-0000-0000-0000-000000000000') SET @CustomWidgetId = NULL        
         
     IF(@DashboardId = '00000000-0000-0000-0000-000000000000') SET @DashboardId = NULL        
         
           DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))    
     DECLARE @EnableSprints BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')    
           DECLARE @EnableTestRepo BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')    
     DECLARE @EnableBugs BIT = (SELECT cast([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')    
               
     SELECT *  FROM(    
           SELECT CW.Id AS CustomWidgetId,    
            CW.CustomWidgetName,    
      CW.WidgetQuery,    
      CW.IsEditable,    
      CW.[Description],    
      (SELECT (SELECT  CACD.Id AS CustomApplicationChartId,    
                    CACD.XCoOrdinate,    
           CACD.YCoOrdinate AS YAxisDetails,    
           CACD.IsDefault,    
           CACD.VisualizationType,    
                       CACD.VisualizationName,    
           CACD.PivotMeasurersToDisplay,    
           CACD.HeatMapMeasure,    
           CACD.DefaultColumns As DefaultColumnsXml,    
     CACD.ColumnFormatQuery,  
     CACD.ColumnAltName,  
     CACD.ChartColorJson,
      CW1.ColumnBackgroundColor,
      CW1.ColumnFontColor,
      CW1.ColumnFontFamily,
      CW1.RowBackgroundColor,
      CW1.HeaderBackgroundColor,
      CW1.HeaderFontColor,
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
 --    (SELECT ColumnName Field,ColumnType [Filter],SubQuery,SubQueryTypeId,[Hidden],Width    
 --FROM CustomAppColumns WHERE CustomWidgetId =  CW.Id    
 -- FOR XML PATH('CustomWidgetHeaderModel'), ROOT('CustomAppColumns'), TYPE) AS CustomAppColumns,    
      0 AS IsHtml,    
      CW.IsProc,    
      CW.IsApi,    
      CW.ProcName,
      CW.ColumnBackgroundColor,
      CW.ColumnFontColor,
      CW.ColumnFontFamily,
      CW.RowBackgroundColor,
      CW.HeaderBackgroundColor,
      CW.HeaderFontColor,
	  CW.IsMongoQuery,
	  CW.CollectionName
          
           FROM CustomWidgets AS CW      
    LEFT JOIN CustomStoredProcWidget CSW ON CSW.CustomWidgetId = CW.Id AND CSW.CompanyId = @CompanyId    
    LEFT JOIN WorkSpaceDashboards WD ON WD.CustomWidgetId = CW.Id AND WD.CompanyId = @CompanyId    
              AND @DashboardId IS NOT NULL AND WD.InActiveDateTime IS NULL AND WD.Id = @DashboardId    
    LEFT JOIN [dbo].[CustomAppFilter] CAP ON CAP.[DashboardId] = WD.Id AND CAP.CreatedByUserId = @OperationsPerformedBy    
      WHERE CW.CompanyId = @CompanyId    
        --AND CW.Id IN (SELECT WidgetId FROM WidgetModuleConfiguration WMC INNER JOIN CompanyModule CM ON CM.ModuleId = WMC.ModuleId WHERE CompanyId = @CompanyId)    
         AND  (@CustomWidgetId IS NULL OR CW.Id = @CustomWidgetId)    
      AND (@EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND CW.CustomWidgetName NOT IN ('Test case status','Test case automation type','Test case type','Time configuration settings','QA productivity report',    
     'QA created and executed test cases','Talko2  file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',    
    'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))    
      AND ( @EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND CW.CustomWidgetName NOT IN ('Goals vs Bugs count (p0,p1,p2)',    
     'Project wise missed bugs count','More bugs goals list','Bugs count on priority basis','Goal work items VS bugs count','Bugs list',/*'Priority wise bugs count',*/'Total bugs count','Yesterday QA raised issues','Section details for all scenarios','Reg
  
ression pack sections details','All testruns','All test suites')))    
        
         
     UNION ALL    
    
     SELECT CH.Id AS CustomWidgetId,    
            CH.CustomHtmlAppName AS CustomWidgetName,    
      CH.HtmlCode AS  WidgetQuery,    
      NULL AS IsEditable,    
      CH.[Description],    
      NULL AS CustomWidgetsMultipleChartsXML,    
    --  null CustomAppColumns,    
      1 AS IsHtml,    
      0 AS IsProc,    
      0 AS IsApi, 
      NULL AS ColumnBackgroundColor,
      NULL AS ColumnFontColor,
      NULL AS ColumnFontFamily,
      NULL AS RowBackgroundColor,
      NULL AS HeaderBackgroundColor,
      NULL AS HeaderFontColor,   
      NULL AS ProcName,
	  0 AS IsMongoQuery,
	  NULL AS CollectionName
           FROM CustomHtmlApp AS CH     
     WHERE CH.Id = @CustomWidgetId    
     ) T    
     ORDER BY T.CustomWidgetName ASC    
    
           
   END TRY    
   BEGIN CATCH    
           
       THROW    
    
   END CATCH     
END