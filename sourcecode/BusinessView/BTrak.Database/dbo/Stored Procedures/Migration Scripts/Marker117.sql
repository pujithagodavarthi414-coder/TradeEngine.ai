CREATE PROCEDURE [dbo].[Marker117]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Pipeline work','SELECT G.GoalName [Goal name],S.SprintName [Sprint name] ,US.UserStoryName [Work item name],ISNULL(DeadLineDate,SprintEndDate)[Deadline],  FORMAT(ISNULL(DeadLineDate,SprintEndDate),''dd/MM/yyyy hh:mm:ss'') [Deadline date] ,
US.Id,US.SprintId,US.GoalId
              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
			  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							   AND USS.CompanyId = ''@CompanyId''
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
	                                      AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)
							   WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							                    )  AND ((''@IsReportingOnly'' = 1 
									  AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND US.OwnerUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
												AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND US.DeadLineDate > GETDATE()) 
												OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))',@CompanyId)
 
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

		  UPDATE CustomAppColumns SET ColumnName = 'Today''s target' WHERE ColumnName = 'Today target' 
		  AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s target' AND CompanyId = @CompanyId)

END




    