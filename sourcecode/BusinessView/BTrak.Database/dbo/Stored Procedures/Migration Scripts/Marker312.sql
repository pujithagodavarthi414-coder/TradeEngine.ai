CREATE PROCEDURE [dbo].[Marker312]
(
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

		UPDATE CustomWidgets SET WidgetQuery = 'SELECT  GoalName [Goal name],[P0 bugs count],
					[P1 bugs count],
					[P2 bugs count],
					 [P3 bugs count] ,
					 [N/A] [Not Assigned],
					[Total count],Id 
 FROM (
 select  G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END) [P1 bugs count],
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END) [P3 bugs count] ,
					COUNT(CASE WHEN BP.Id IS NULL THEN 1 END) [N/A],
					COUNT(US.Id) [Total count],G.Id     ,G.GoalName 
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id  ) T' WHERE CustomWidgetName = 'Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId

 MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
 (NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goals vs Bugs count (p0, p1, p2)'),'GoalName', 'nvarchar', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId),'Not Assigned','int','SELECT US.Id  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND BP.Id IS NULL
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))','A77A8837-72E2-450A-A69F-B93FD6EB381E',@CompanyId,@UserId,GETDATE(),NULL) 
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);
 
END