CREATE PROCEDURE [dbo].[Marker308]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


	
		UPDATE CustomWidgets SET WidgetQuery = 'SELECT G.GoalName as [Goal name],COUNT(1) [Work items count], (SELECT COUNT(1) FROM  UserStory US1 INNER JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug = 1
                        INNER JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL AND  US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
						INNER JOIN UserStory US2 ON  US2.Id =  US1.ParentUserStoryId AND US2.InActiveDateTime IS NULL AND US2.ParkedDateTime IS NULL AND G.Id = US2.GoalId
						)[Bugs count] ,G.Id 
						FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
         AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND GoalStatusId =''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL  AND P.CompanyId =''@CompanyId''  AND (''@ProjectId'' = '' '' OR P.Id = ''@ProjectId'') 
AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy''  AND InActiveDateTime IS NULL)
WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers] (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
OR (''@IsAll'' = 1)) GROUP BY G.GoalName,G.Id' WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name],S.SprintName [Sprint name],US.Id,US.GoalId,US.SprintId
  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                        AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND CAST(SprintEndDate as date) >= CAST( GETDATE() AS date))OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
							AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'')
	OR (''@IsAll'' = 1))' WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId

END
GO