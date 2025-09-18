CREATE PROCEDURE [dbo].[Marker144]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
 ((SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Deadline date','datetimeoffset',5)
,((SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday logging compliance' AND CompanyId = @CompanyId),'Compliance %','nvarchar',3)
,((SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday logging compliance' AND CompanyId = @CompanyId),'Non Compliant Members','decimal',4)
)
  AS SOURCE ( [CustomWidgetId], [ColumnName], [ColumnType],[Order])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND Target.[ColumnType] = Source.[ColumnType]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [Order] = SOURCE.[Order];

UPDATE WorkspaceDashboards SET [Name] =  'This month company productivity'  WHERE  CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This month company productivity' 
 AND CompanyId = @CompanyId) AND [Name] =  'This month productivity' AND CompanyId = @CompanyId

UPDATE CustomAppDetails SET YCoOrdinate = ' This month company productivity '   WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This month company productivity' 
	                                          AND CompanyId = @CompanyId) AND YCoOrdinate = 'This month productivity'

 	UPDATE CustomAppColumns SET ColumnName = ' This month company productivity ' WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This month company productivity' 
 AND CompanyId = @CompanyId) AND ColumnName = 'This month productivity' AND CompanyId = @CompanyId

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT US.UserStoryName AS [Work item] 
FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	 INNER JOIN  Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
	 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND TaskStatusId =  ''166DC7C2-2935-4A97-B630-406D53EB14BC''
WHERE US.DependencyUserId = ''@OperationsPerformedBy'' AND G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL
AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
' WHERE CustomWidgetName ='Blocked on me' AND CompanyId = @CompanyId

END				
