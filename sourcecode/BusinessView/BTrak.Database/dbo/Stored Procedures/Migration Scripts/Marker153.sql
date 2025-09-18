CREATE PROCEDURE [dbo].[Marker153]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE CustomWidgets SET WidgetQuery =' select  G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END) [P1 bugs count],
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END) [P3 bugs count] ,
					COUNT(US.Id) [Total count],G.Id     
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id' WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId
		
		        UPDATE CustomAppColumns SET ColumnName = 'P3 bugs count' WHERE ColumnName ='P3BugsCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId) AND InActiveDateTime IS NULL
				UPDATE CustomAppColumns SET ColumnName = 'P0 bugs count' WHERE ColumnName ='P0BugsCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId)  AND InActiveDateTime IS NULL
				UPDATE CustomAppColumns SET ColumnName = 'Total count' WHERE ColumnName ='TotalCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId)  AND InActiveDateTime IS NULL
				UPDATE CustomAppColumns SET ColumnName = 'P1 bugs count' WHERE ColumnName ='P1BugsCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId)  AND InActiveDateTime IS NULL
				UPDATE CustomAppColumns SET ColumnName = 'Goal name' WHERE ColumnName ='GoalName' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId)  AND InActiveDateTime IS NULL
				UPDATE CustomAppColumns SET ColumnName = 'P2 bugs count' WHERE ColumnName ='P2BugsCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName  ='Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId)  AND InActiveDateTime IS NULL

UPDATE WorkspaceDashboards SET [Name] ='Project wise bugs count' WHERE [Name] = 'Project wise missed bugs count' AND InActiveDateTime IS NULL AND CustomWidgetId IN (SELECT Id FROM CustomWidgets  WHERE CustomWidgetName ='Project wise missed bugs count' AND CompanyId = @CompanyId )
UPDATE CustomWidgets SET CustomWidgetName = 'Project wise bugs count' WHERE CustomWidgetName = 'Project wise missed bugs count' AND CompanyId = @CompanyId

END