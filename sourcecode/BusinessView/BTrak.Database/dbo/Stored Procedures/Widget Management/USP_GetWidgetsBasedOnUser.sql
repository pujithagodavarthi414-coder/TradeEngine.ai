--exec [dbo].[USP_GetWidgetsBasedOnUser] @OperationsPerformedBy = 'C3EDF85E-FA5C-4788-9100-EA71A0EC29CE',@PageSize = 1000,@SearchText = 'RFQ12'
CREATE PROCEDURE [dbo].[USP_GetWidgetsBasedOnUser]
(
 @OperationsPerformedBy UNIQUEIDENTIFIER,
 @CustomWidgetId UNIQUEIDENTIFIER = NULL,
 @WidgetId UNIQUEIDENTIFIER = NULL, 
 @SearchText NVARCHAR(250) = NULL,
 @SearchTag NVARCHAR(250) = NULL,
 @IsArchived BIT = NULL,
 @IsExport BIT = NULL,
 @PageNumber INT = 1,
 @TagId UNIQUEIDENTIFIER =NULL,
 @PageSize INT = 10,
 @SortBy NVARCHAR(100) = NULL,
 @SortDirection VARCHAR(20) = NULL,
 @WidgetIdsXml XML = NULL,
 @IsFavouriteWidget Bit = NULL,
 @IsFromSearch BIT = NULL,
 @IsQuery Bit = NULL
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
     
     SET @SearchText = '%'+ LOWER(RTRIM(LTRIM(@SearchText))) +'%'

     IF(@SearchTag = '') SET @SearchTag = NULL

    DECLARE @CompanyId UNIQUEIDENTIFIER = (SELECT [dbo].[Ufn_GetCompanyIdBasedOnUserId](@OperationsPerformedBy))

     SELECT REPLACE(ColumnName,'Label','') ColumnName,ColumnValue INTO #SoftLabel FROM( SELECT * from SoftLabelConfigurations  WHERE CompanyId = @CompanyId AND @SearchText IS NOT NULL )Z
      Unpivot(ColumnValue For ColumnName IN (ProjectLabel,GoalLabel,UserStoryLabel,AuditLabel,AuditsLabel,ConductLabel,ConductsLabel,ActionLabel,ActionsLabel,TimelineLabel,AuditReportLabel,AuditReportsLabel,ReportLabel,ReportsLabel,AuditActivityLabel,AuditAnalyticsLabel,AuditQuestionLabel,AuditQuestionsLabel,EmployeeLabel,DeadlineLabel,ProjectsLabel,GoalsLabel,EmployeesLabel,UserStoriesLabel,DeadlinesLabel,ScenarioLabel,ScenariosLabel,RunLabel,RunsLabel,VersionLabel,VersionsLabel,TestReportLabel,TestReportsLabel,EstimatedTimeLabel,EstimationLabel,EstimationsLabel,EstimateLabel,EstimatesLabel,ClientLabel,ClientsLabel)) AS H
      WHERE ColumnValue LIKE @SearchText

     IF(@SearchTag IS NOT NULL)
     BEGIN
     IF EXISTS(SELECT * FROM Tags WHERE TagName=@SearchTag AND CompanyId=@CompanyId) 
     SET @TagId = (SELECT Id FROM Tags WHERE TagName=@SearchTag AND CompanyId=@CompanyId)
     SET @SearchTag =  LOWER(RTRIM(LTRIM(@SearchTag))) 
     END

     IF(@IsArchived IS NULL)SET @IsArchived = 0

     IF(@IsFavouriteWidget IS NULL)SET @IsFavouriteWidget = 0

     IF(@IsQuery IS NULL)SET @IsQuery = 0

     IF(@IsExport IS NULL ) SET @IsExport = 0

     IF(@WidgetId = '00000000-0000-0000-0000-000000000000') SET @WidgetId = NULL         
     
     IF(@TagId = '00000000-0000-0000-0000-000000000000') SET @TagId = NULL         

     DECLARE @EnableSprints BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableSprints%')
           DECLARE @EnableTestRepo BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableTestcaseManagement%')
     DECLARE @EnableBugs BIT = (SELECT CAST([Value] as bit) FROM CompanySettings where CompanyId = @CompanyId AND [key] like '%EnableBugBoard%')
     DECLARE @Industry NVARCHAR(25) = (SELECT IndustryName FROM Industry I INNER JOIN Company C ON C.IndustryId = I.Id WHERE C.Id = @CompanyId)

        DECLARE @IsSupport BIT = ISNULL((SELECT TOP 1 ISNULL(R.IsHidden,0) FROM UserRole UR INNER JOIN [Role] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL
                                      WHERE UserId = @OperationsPerformedBy),0)

     DECLARE @IsOtherFilter BIT = 0
     IF(@TagId IS NOT NULL)
     BEGIN 
    IF EXISTS(SELECT * FROM Tags WHERE Id = @TagId AND TagName='Other' AND CompanyId=@CompanyId) 
     SET @IsOtherFilter = 1
     END
     IF(@SearchTag IS NOT NULL)
           BEGIN
                   IF EXISTS(SELECT * FROM Tags WHERE TagName=@SearchTag AND CompanyId=@CompanyId)
                     BEGIN
                         SET @TagId = (SELECT Id FROM Tags WHERE TagName=@SearchTag AND CompanyId=@CompanyId)
                         SET @SearchTag =  LOWER(RTRIM(LTRIM(@SearchTag)))
                     END
                   ELSE
                     RETURN
                   END
     DECLARE  @DuplicateRecordsCreationTable TABLE
     (
      Id INT
   )

   INSERT INTO @DuplicateRecordsCreationTable(Id) VALUES(1),(2)

    CREATE TABLE #WidgetIds
          (
                ItemId UNIQUEIDENTIFIER,
    CreatedDateTime DATETIME
          )

   INSERT INTO #WidgetIds(ItemId, CreatedDateTime)
            SELECT X.Y.value('ItemId[1]', 'uniqueidentifier'),
       X.Y.value('CreatedDateTime[1]', 'DATETIME')
            FROM @WidgetIdsXml.nodes('/row') X(Y)

      CREATE TABLE #RoleIds 
     (
    UserRoleId UNIQUEIDENTIFIER
     )

     INSERT INTO #RoleIds(UserRoleId)
     SELECT RoleId FROM [dbo].[Ufn_GetRoleIdsBasedOnUserId](@OperationsPerformedBy)

    SELECT *, TotalCount = COUNT(1) OVER() 
    FROM ( SELECT 
            ROW_NUMBER() OVER (ORDER BY [WidgetName])  AS Id
           ,WidgetId
           ,[WidgetName]
     ,[Description]
     ,[WidgetQuery]
     ,[FilterQuery]
     ,[DefaultColumns]
     ,T.[CreatedDateTime]
           ,T.[CreatedByUserId]
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
     ,ChartColorJson
     ,IsHtml
     ,IsProc
     ,IsApi
     ,ProcName
     ,IsProcess
     ,IsEntryApp
     ,IsPublished
     ,Filters
     ,IsFavouriteWidget
     ,RecentSearchCreatedDateTime
     ,IsQuery
     ,IsMongoQuery
     ,CollectionName
     FROM (
     SELECT W.[Id] AS WidgetId
           ,[WidgetName]
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
     ,NULL AS ChartColorJson
     ,0 AS IsHtml
     ,0 AS IsProc
     ,0 AS IsApi
     ,NULL AS ProcName
     ,0 AS IsProcess
     ,0 AS IsEntryApp
     ,NULL AS IsPublished
     ,NULL AS Filters
     ,FW.IsFavourite IsFavouriteWidget
     ,WI.CreatedDateTime RecentSearchCreatedDateTime
     ,0 AS IsQuery
     ,0 AS IsMongoQuery
     ,NULL AS CollectionName
     FROM  Widget W 
        LEFT JOIN  (
           SELECT WRC.WidgetId
              FROM WidgetRoleConfiguration WRC
                INNER JOIN #RoleIds R ON R.UserRoleId = WRC.RoleId AND WRC.Inactivedatetime IS NULL
              GROUP BY WRC.WidgetId
          ) WR ON WR.WidgetId = W.Id
     LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = W.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
     LEFT JOIN #WidgetIds WI ON WI.ItemId = WR.WidgetId
     WHERE W.CompanyId = @CompanyId
     AND (@IsSupport = 1 OR WR.WidgetId IS NOT NULL)
     AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
     AND (@IsQuery = 0 OR (@IsQuery = 1 AND  1=2))

   --  AND ((@Industry = 'HR Software' AND WidgetName NOT IN ('Activity','Activity tracker timeline')) OR (@Industry <> 'HR Software' AND 1 = 1))
     UNION 
     SELECT W.[Id] AS WidgetId
           ,W.[CustomWidgetName] AS WidgetName
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
     ,CACD.ChartColorJson
     ,0 AS IsHtml
     ,IsProc
     ,IsApi
     ,ProcName
     ,0 AS IsProcess
     ,0 AS IsEntryApp
     ,NULL AS IsPublished
     ,W.Filters AS Filters
     ,FW.IsFavourite IsFavouriteWidget
     ,WI.CreatedDateTime RecentSearchCreatedDateTime
     ,IsQuery
     ,W.IsMongoQuery
     ,W.CollectionName
     FROM  CustomWidgets W 
     INNER JOIN CustomAppDetails CACD ON CACD.CustomApplicationId = W.Id AND CACD.InActiveDateTime IS NULL and CACD.IsDefault = 1
     LEFT JOIN (SELECT CWRC.CustomWidgetId AS WidgetId
              FROM CustomWidgetRoleConfiguration CWRC
                INNER JOIN #RoleIds R ON R.UserRoleId = CWRC.RoleId AND CWRC.Inactivedatetime IS NULL
              GROUP BY CWRC.CustomWidgetId ) WR ON WR.WidgetId = W.Id
     LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = W.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
     LEFT JOIN #WidgetIds WI ON WI.ItemId = WR.WidgetId
     WHERE W.CompanyId = @CompanyId
     AND ((@IsArchived = 1 AND W.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND W.InActiveDateTime IS NULL))
     AND (@IsSupport = 1 OR WR.WidgetId IS NOT NULL)
     AND (@IsQuery = 0 OR (@IsQuery = 1 AND  @IsQuery = W.IsQuery))  

     UNION
     SELECT WH.[Id] AS WidgetId
           ,WH.[CustomHtmlAppName] AS WidgetName
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
     ,NULL AS ChartColorJson
     ,1 AS IsHtml
     ,0 AS IsProc
     ,0 AS IsApi
     ,NULL AS ProcName
     ,0 AS IsProcess
     ,0 AS IsEntryApp
     ,NULL AS IsPublished
     ,NULL AS Filters
     ,FW.IsFavourite IsFavouriteWidget
     ,WI.CreatedDateTime RecentSearchCreatedDateTime
     ,0 AS IsQuery
     ,0 AS IsMongoQuery
     ,NULL AS CollectionName
     FROM  CustomHtmlApp WH 
     LEFT JOIN (SELECT CHRC.CustomHtmlAppId AS WidgetId
              FROM CustomHtmlAppRoleConfiguration CHRC
                INNER JOIN #RoleIds R ON R.UserRoleId = CHRC.RoleId AND CHRC.Inactivedatetime IS NULL
              GROUP BY CHRC.CustomHtmlAppId )WR ON WH.Id = WR.WidgetId 
     LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = WH.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
     LEFT JOIN #WidgetIds WI ON WI.ItemId = WR.WidgetId
     WHERE WH.CompanyId = @CompanyId
     AND ((@IsArchived = 1 AND WH.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND WH.InActiveDateTime IS NULL))
     AND (@IsSupport = 1 OR WR.WidgetId IS NOT NULL)
     AND (@IsQuery = 0 OR (@IsQuery = 1 AND  1=2))

     UNION
     SELECT CA.[Id] AS WidgetId
           ,CA.[CustomApplicationName] AS WidgetName
     ,CA.[Description] AS [Description]
     ,NULL AS WidgetQuery
     ,NULL AS FilterQuery
     ,NULL AS DefaultColumns
           ,CA.[CreatedDateTime]
           ,CA.[CreatedByUserId]
           ,CA.[CompanyId]
      ,0 IsEditable
           ,CA.[InActiveDateTime]
     ,CA.TimeStamp
     ,0 AS IsCustomWidget
     ,NULL AS VisualizationType
     ,NULL AS XCoOrdinate
     ,NULL AS YCoOrdinate
     ,NULL AS VisualizationName
     ,NULL AS CustomAppVisualizationId
     ,NULL AS ChartColorJson
     ,0 AS IsHtml
     ,0 AS IsProc
     ,0 AS IsApi
     ,NULL AS ProcName
     ,1 AS IsProcess 
     ,CASE WHEN D.Id = 2 THEN 1 ELSE 0 END  AS IsEntryApp
     ,CA.IsPublished AS IsPublished
     ,NULL AS Filters
     ,FW.IsFavourite IsFavouriteWidget
     ,WI.CreatedDateTime RecentSearchCreatedDateTime
     ,0 AS Isquery
     ,0 AS IsMongoQuery
     ,NULL AS CollectionName
    FROM CustomApplication CA
     INNER JOIN @DuplicateRecordsCreationTable D ON 1=1
     LEFT JOIN (SELECT CARC.CustomApplicationId AS WidgetId
              FROM CustomApplicationRoleConfiguration CARC
                INNER JOIN #RoleIds R ON R.UserRoleId = CARC.RoleId 
              GROUP BY CARC.CustomApplicationId)  WR ON WR.WidgetId = CA.Id
     LEFT JOIN FavouriteWidgets FW ON FW.WidgetId = CA.Id AND FW.CreatedByUserId = @OperationsPerformedBy AND FW.CompanyId = @CompanyId
     LEFT JOIN #WidgetIds WI ON WI.ItemId = WR.WidgetId
     WHERE CA.CompanyId = @CompanyId 
     AND (@IsSupport = 1 OR WR.WidgetId IS NOT NULL)
     AND ((@IsArchived = 1 AND CA.InActiveDateTime IS NOT NULL) OR (@IsArchived = 0 AND CA.InActiveDateTime IS NULL))
     AND (@IsQuery = 0 OR (@IsQuery = 1 AND  1=2))
    ) T
    LEFT JOIN CustomTags CT ON CT.ReferenceId = WidgetId
	
    WHERE (@SearchText IS NULL OR ((LOWER(T.WidgetName) LIKE @SearchText AND LOWER(T.WidgetName) <>  STUFF((SELECT ' ' +  isnull(s.ColumnValue,k.[Value])  FROM [dbo].[Ufn_StringSplit](WidgetName,' ' )k left join #SoftLabel s on s.ColumnName = k.[Value]   FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,1,' '))   
	 OR   STUFF((SELECT ' ' +  isnull(s.ColumnValue,k.[Value])  FROM [dbo].[Ufn_StringSplit](WidgetName,' ' )k left join #SoftLabel s on s.ColumnName = k.[Value]   FOR XML PATH(''), TYPE)
        .value('.','NVARCHAR(MAX)'),1,1,' ') LIKE @SearchText )) 
      AND (@TagId IS NULL OR (@IsOtherFilter = 0 AND CT.TagId = @TagId) OR (@IsOtherFilter = 1 AND CT.Id IS NULL) ) 
     
    -- AND (@SearchTag IS NULL OR @SearchTag IN (SELECT LOWER([Value]) FROM [dbo].[Ufn_StringSplit](T.[Tags],',')))
     AND (@WidgetId IS NULL OR T.WidgetId = @WidgetId)
     AND((@IsFavouriteWidget = 0) OR IsFavouriteWidget = @IsFavouriteWidget)
     AND WidgetName not like '%Feedback type%' AND WidgetName not like 'spent time details'
     AND ( @IsExport = 1 OR @EnableSprints = 1 OR ((@EnableSprints = 0 OR @EnableSprints IS NULL) AND WidgetName NOT IN ('Sprint replan history','Sprint activity','Sprint bug report')))
     AND (@IsExport = 1 OR @EnableTestRepo = 1 OR ((@EnableTestRepo = 0 OR @EnableTestRepo IS NULL) AND WidgetName NOT IN ('Test case status','Regression test run report','Test case automation type','Test case type','Time configuration settings','QA productivity report',
     'QA created and executed test cases','Talko2 file uploads testrun details','All test suites','Reports details','All versions','Regression pack sections details',
     'All testruns','TestCases priority wise','Section details for all scenarios','Milestone  details')))
     AND (@EnableBugs = 1 OR ((@EnableBugs = 0 OR @EnableBugs IS NULL) AND T.WidgetName NOT IN ('Bug priority','Highest bugs goals list','Sprint bug report','Bug report','Project wise bugs count','Goals vs Bugs count (p0,p1,p2)','Goals vs Bugs count (p0, p1, p2)',
     'Project wise missed bugs count','More bugs goals list','Bugs count on priority basis','Goal work items VS bugs count','Bugs list',/*'Priority wise bugs count',*/'Total bugs count','Yesterday QA raised issues','Section details for all scenarios','Regression pack sections details','All testruns','All test suites')))
     AND (@CustomWidgetId IS NULL OR T.WidgetId = @CustomWidgetId)
     AND (@IsQuery = 0 OR (@IsQuery = 1 AND  @IsQuery = IsQuery))  
      GROUP BY WidgetId,[WidgetName],[Description],[WidgetQuery],[FilterQuery],[DefaultColumns],T.[CreatedDateTime],T.[CreatedByUserId]
           ,[CompanyId],[InActiveDateTime],[TimeStamp],IsCustomWidget,VisualizationType,XCoOrdinate,YCoOrdinate,VisualizationName
     ,CustomAppVisualizationId,IsEditable,IsHtml,IsProc,IsApi,ProcName,IsProcess,IsPublished,IsEntryApp,IsFavouriteWidget
     ,Filters,RecentSearchCreatedDateTime,IsQuery,IsMongoQuery,CollectionName,ChartColorJson
  ) A Where (@WidgetIdsXml IS NULL OR WidgetId IN (SELECT ItemId from #WidgetIds))
		AND (A.IsProcess = 0 OR ((ISNULL(@IsFromSearch, 0) = 0 AND (A.IsPublished = 1 AND A.IsEntryApp = 1)) OR ( ISNULL(@IsFromSearch, 0) = 1  AND 1 = 1) ) OR 
			((ISNULL(@IsFromSearch, 0) = 0 AND A.IsPublished = 1) OR (ISNULL(@IsFromSearch, 0) = 1 AND A.IsEntryApp = 0)))
      ORDER BY 
      CASE WHEN (@WidgetIdsXml IS NOT NULL) THEN RecentSearchCreatedDateTime 
     END DESC,
     CASE WHEN (@WidgetIdsXml IS NULL AND (@SortDirection IS NULL OR @SortDirection = 'ASC')) THEN
       CASE  WHEN(@SortBy IS NULL OR @SortBy = 'WidgetName') THEN WidgetName
          WHEN(@SortBy = 'Description') THEN [Description]
        END
      END ASC,
      CASE WHEN @SortDirection = 'DESC' THEN
       CASE  WHEN(@SortBy IS NULL OR @SortBy = 'WidgetName') THEN WidgetName
          WHEN(@SortBy = 'FDescription') THEN [Description]
          END
      END DESC
      OFFSET ((@PageNumber - 1) * @PageSize) ROWS
    
    FETCH NEXT @PageSize ROWS ONLY 

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