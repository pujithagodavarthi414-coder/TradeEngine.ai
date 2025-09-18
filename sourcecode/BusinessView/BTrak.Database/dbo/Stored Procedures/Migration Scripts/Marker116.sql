CREATE PROCEDURE [dbo].[Marker116]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Pipeline work','SELECT G.GoalName [Goal name],S.SprintName [Sprint name] ,US.UserStoryName [Work item name],ISNULL(DeadLineDate,SprintEndDate)[Deadline],  FORMAT(ISNULL(DeadLineDate,SprintEndDate),''dd/mm/yyyy hh:mm:ss'') [Deadline date] ,
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
   , (NEWID(),'Today''s target','SELECT COUNT(1)[Today''s target] FROM
	(SELECT US.Id FROM UserStory US 
	               INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = ''@CompanyId''
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
				INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = US.Id
				INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId 
				INNER JOIN UserStoryStatus USS1 ON USS1.Id = WET.ToWorkflowUserStoryStatusId
				INNER JOIN TaskStatus TS1 ON TS.Id = USS.TaskStatusId AND TS1.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
				LEFT JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL  AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL
				                 AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				WHERE CAST(UST.TransitionDateTime AS date) < CAST(GETDATE() AS date)
				      AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) 
					  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
				group by US.Id)T',@CompanyId)
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Deadline date','datetimeoffset','SELECT US.Id,US.UserStoryName FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
LEFT JOIN Goal G ON G.Id = US.GoalId	     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL
AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)
WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''	) 
AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND CAST(US.DeadLineDate AS date) = cast(''##Deadline##'' as date))
OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))
AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'')
WHERE ChildId <>  ''@OperationsPerformedBy''))	
OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )
OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Deadline','datetimeoffset',null,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id,GoalName FROM Goal WHERE Id =  ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Goal' ),@CompanyId,@UserId,GETDATE(),NULL)

)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND RTRIM(Target.[ColumnType]) = RTRIM(Source.[ColumnType])
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




    