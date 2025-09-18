CREATE PROCEDURE [dbo].[Marker121]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Goal wise spent time VS productive hrs list','SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(G2.Id) [Bugs count] ,G.Id FROM UserStory US 
 INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
         AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '' '' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId =''@CompanyId''
LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL 
LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	                           								   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	                           								    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
	                           									OR (''@IsAll'' = 1)) GROUP BY G.GoalName,G.Id 
',@CompanyId)
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];


DELETE FROM [dbo].[CustomTags] WHERE [ReferenceId] = (SELECT Id FROM Widget WHERE WidgetName = 'Employee spent time' AND CompanyId =  @CompanyId)

	
	DELETE FROM CustomAppDashboardPersistance 
	WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name]='System app' AND CompanyId =  @CompanyId)

	DELETE FROM CustomAppFilter 
	WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name]='System app' AND CompanyId =  @CompanyId)

	DELETE FROM DashboardPersistance 
	WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name]='System app' AND CompanyId =  @CompanyId)

	--TODO
	DELETE FROM UserStory 
	WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name]='System app' AND CompanyId =  @CompanyId)

	DELETE FROM WorkspaceDashboards WHERE [Name]='System app' AND CompanyId =  @CompanyId

END




    