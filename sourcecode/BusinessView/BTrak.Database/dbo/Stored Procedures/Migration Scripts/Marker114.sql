CREATE PROCEDURE [dbo].[Marker114]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 



 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Today''s target','SELECT COUNT(1)[Today''s target] FROM
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
				LEFT JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL  AND G.aParkedDateTime IS NULL
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
					
UPDATE CustomAppColumns SET ColumnName ='Productivity' WHERE 
CustomWidgetId IN (SELECT Id FROM CUSTOMWIDGETS WHERE CustomWidgetName ='Productivity indexes for this month' AND CompanyId = @CompanyId
) AND ColumnName ='Productivity '


END


