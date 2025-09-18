CREATE PROCEDURE [dbo].[Marker81]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
      (NEWID(),'Delayed work items','SELECT US.UserStoryName As [Work item],US.Id,p.IsDateTimeConfiguration,DeadLineDate FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                          AND P.InActiveDateTime IS NULL  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
				AND USS.CompanyId =''@CompanyId''
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
			    LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
				WHERE ((US.GoalId IS NOT NULL AND GS.Id IS  NOT NULL AND ((P.IsDateTimeConfiguration = 1 AND  US.DeadLineDate < SYSDATETIMEOFFSET() )
                        OR (ISNULL(P.IsDateTimeConfiguration,0) = 0 AND  CONVERT(DATE,US.DeadLineDate) < CONVERT(DATE,GETDATE())))) 
                        OR (US.SprintId IS NOT NULL AND S.Id IS Not NULL AND CAST(S.SprintEndDate AS date) < CAST(GETDATE() AS date))) 
						AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	                         OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'')
	                         OR (''@IsAll'' = 1))',@CompanyId)
,(NEWID(),'Planned and actual burned  cost','SELECT ISNULL(SUM(PlannedRate),0)PlannedRate FROM RosterActualPlan RAP
           WHERE  PlanDate >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AND PlanDate  <=
		   ISNULL(@DateTo,EOMONTH(GETDATE())) AND  RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
		    AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')',@CompanyId)
,(NEWID(),'Week wise roster plan vs actual rate','SELECT T.Date,PlannedRate = ISNULL((SELECT	SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate<= T.Date)
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 ),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(@DateTo,EOMONTH(GETDATE()))))T ',@CompanyId)
                  	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];


END