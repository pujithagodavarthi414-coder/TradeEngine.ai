CREATE PROCEDURE [dbo].[Marker177]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'This Month Company Productivity Percent','This app provides the company productivity percent based on configured value in the company settings.Users can download the information in the app and can change the visualization of the app 
                 ', N'SELECT CAST(ISNULL(T.Productivity*1.00/ CASE WHEN ISNULL(Req,0) = 0 THEN NULL ELSE Req END,0) AS decimal(10,2))*100  [This Month Company Productivity Percent] FROM(SELECT Cast(ISNULL(SUM(ISNULL(Z.EstimatedTime,0)),0) as decimal(10,2))Productivity, ((SELECT COUNT(1) EmployeesCount FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
	                      WHERE CompanyId = ''@CompanyId'')* (SELECT CAST(ISNULL([Value],0) AS decimal(10,2)) FROM CompanySettings WHERE CompanyId = ''@CompanyId'' AND [Key] =  ''ExpectedProductivityFromEmployeePerMonth''))
		Req			FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),null,''@CompanyId'')Z 
	INNER JOIN UserStory US  ON US.Id = Z.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId''))T

', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  , (NEWID(), N'Project Report','This app provides the all project detailed information like project name, delayed goals count,active goals count,delayed sprints count and bugs counts etc.Users can download the information in the app and can change the visualization of the app 
                 ', N'SELECT  P.ProjectName,ISNULL(U.FirstName,'''')+'' ''+ISNULL(U.SurName,'''') [Project Manager],
        CAST(P.ProjectStartDate AS DATE) [Start date],
		CAST(P.ProjectEndDate AS DATE) [End Date],
		(SELECT COUNT(1) FROM(SELECT UP.UserId FROM UserProject UP WHERE UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL GROUP BY UP.UserId)T) [Project Members]
       ,(SELECT COUNT(1) FROM Goal G WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE'' AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL)[Active Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.InActiveDateTime IS NULL AND S.SprintStartDate IS NULL AND S.ProjectId = P.Id AND ISNULL(S.IsComplete,0) = 0)[Active Sprints]
       ,(SELECT COUNT(1) FROM Goal G WHERE Id IN (SELECT GoalId FROM UserStory US WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND P.Id = US.ProjectId AND ((ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS DATE) < CAST(GETDATE() AS date))) OR ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate  < GETDATE()))) AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL) [Delayed Goals]
       ,(SELECT COUNT(1) FROM Sprints S WHERE S.ProjectId = P.Id AND CAST(S.SprintEndDate AS date) < CAST( GETDATE() AS date) ) [Delayed Sprints],
        (SELECT COUNT(1) FROM Goal G 
	               LEFT JOIN (SELECT US.GoalId, COUNT(1)Counts FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
       									AND USS.TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
                                      GROUP BY US.GoalId)T ON G.Id = T.GoalId
									  WHERE T.GoalId IS NULL AND G.ProjectId = P.Id AND G.OnboardProcessDate IS NOT NULL) [Completed goals],
        (SELECT COUNT(1) FROM Sprints S  WHERE S.ProjectId = P.Id AND S.IsComplete = 1)[Completed Sprints],
        (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
                                           INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  
                                           LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
                                           LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
                                           WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL)) [Total Bugs],
        (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
                                           INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND USS.TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
                                           LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
                                           LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
                                           WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL)) [Resolved bugs],
			(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.ProjectId = P.Id
            INNER JOIN UserStoryStatus USS ON USS.ID = US.UserStoryStatusId  AND USS.TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
            LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND ISNULL(S.IsReplan,0) = 0
            LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalStatusId = ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
            WHERE (S.Id IS NOT NULL OR G.Id IS NOT NULL))[Pending Bugs],
         dbo.Ufn_GetFilesCount(P.Id)  [Nunber Of Documents]
FROM Project P INNER JOIN [User] U ON U.Id = P.ProjectResponsiblePersonId AND P.InActiveDateTime IS NULL
    WHERE P.CompanyId = ''@CompanyId''', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
    , (NEWID(), N'Goal Report','This app provides the all goal detailed information like goal name,project name,start date,end date, total tasks,pending tasks,number of replans,number of blocked tasks and bugs counts.Users can download the information in the app and can change the visualization of the app 
                 ', N'SELECT G.GoalName [Goal Name],P.ProjectName [Project Name],CAST(G.OnboardProcessDate AS DATE) [Start Date],
	CAST((SELECT MAX(US.DeadLineDate) FROM UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL) AS DATE) [End date],
	U.FirstName+'' ''+U.SurName [Goal Responsible Person],
(SELECT COUNT(1) FROM GoalReplan  WHERE GoalId = G.Id AND InActiveDateTime IS NULL)[Number Of Replans],
(SELECT COUNT(1) FROM  UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL)[Total Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  AND US.GoalId = G.Id ) [Pending Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  AND US.GoalId = G.Id ) [Completed tasks],
 (CAST((SELECT (ISNULL(COUNT(CASE WHEN  USS.TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  THEN 1 END),0)
 *1.00 )/ CASE WHEN COUNT(1) = 0 THEN 1 ELSE COUNT(1) END  *1.00  
FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id= US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
 WHERE US.GoalId = G.Id) AS decimal(10,2)))* 100 [Goal Completion Percentage],
 (SELECT COUNT(1) FROM UserStory US WHERE US.GoalId = G.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate < GETDATE()) OR (ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date))))[Delayed Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
WHERE US.GoalId = G.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND USS.TaskStatusId =''166DC7C2-2935-4A97-B630-406D53EB14BC'' )[Blocked Tasks],
 (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN Sprints S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId)[Total Bugs],
  (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId AND USS.TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76''))[Resolved bugs],
   (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.GoalId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.GoalId = G.Id AND US1.GoalId  <> US.GoalId AND USS.TaskStatusId  NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')) [Pending Bugs]
FROM Goal G INNER JOIN Project P ON P.ID = G.ProjectId AND G.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
                                           LEFT JOIN [User]U ON U.Id = G.GoalResponsibleUserId 
										   WHERE P.CompanyId = ''@CompanyId'' AND G.GoalStatusId =  ''7A79AB9F-D6F0-40A0-A191-CED6C06656DE''
', @CompanyId, @UserId, GETDATE())
   , (NEWID(), N'Sprint Report','This app provides the all goal detailed information like sprint name,project name,start date,end date, total tasks,pending tasks,number of replans,number of blocked tasks and bugs counts.Users can download the information in the app and can change the visualization of the app 
                 ', N'SELECT S.SprintName [Sprint Name],P.ProjectName [Project Name],CAST(S.SprintStartDate AS DATE) [Start Date],CAST(S.SprintEndDate AS DATE) [End Date],U.FirstName+'' ''+U.SurName [Sprint Responsible Person],
(SELECT COUNT(1) FROM GoalReplan WHERE GoalId = S.Id)[Number Of Replans],
(SELECT COUNT(1) FROM  UserStory US WHERE US.SprintId = S.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL)[Total Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  AND US.SprintId = S.Id ) [Pending Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
WHERE TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  AND US.SprintId = S.Id ) [Completed tasks],
CAST((SELECT (COUNT(CASE WHEN  USS.TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  THEN 1 END)
 *1.00 )/ COUNT(1) *1.00   
FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id= US.UserStoryStatusId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND S.Id = US.SprintId
 ) AS DECIMAL(10,2)) * 100 [Sprint Completion Percentage],
 (SELECT COUNT(1) FROM UserStory US WHERE US.SprintId = S.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND ((P.IsDateTimeConfiguration = 1 AND US.DeadLineDate < GETDATE()) OR (ISNULL(P.IsDateTimeConfiguration,0) = 0 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date))))[Delayed Tasks],
(SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id
WHERE US.SprintId = S.Id AND US.InActiveDateTime IS  NULL AND US.ParkedDateTime IS NULL AND USS.TaskStatusId =''166DC7C2-2935-4A97-B630-406D53EB14BC'' )[Blocked Tasks],
 (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId)[Total Bugs],
  (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId AND USS.TaskStatusId  IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76''))[Resolved bugs],
   (SELECT COUNT(1) FROM UserStory US INNER JOIN UserStoryType UST ON US.UserStoryTypeId = UST.Id AND UST.IsBug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                    INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL
									INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
									INNER JOIN Sprints S2 ON S2.Id = US.SprintId AND S2.InActiveDateTime IS NULL AND ISNULL(S2.IsReplan,0) = 0 AND ISNULL(S2.IsComplete,0) = 0 
  WHERE  US1.SprintId = S.Id AND US1.SprintId  <> US.SprintId AND USS.TaskStatusId  NOT IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')) [Pending Bugs]
FROM Sprints S INNER JOIN Project P ON P.ID = S.ProjectId AND S.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL
                                           LEFT JOIN [User]U ON U.Id = S.SprintResponsiblePersonId 
										   WHERE P.CompanyId = ''@CompanyId'' AND  S.SprintStartDate IS NOT NULL AND ISNULL(IsReplan,0) =0
', @CompanyId, @UserId, GETDATE())
  , (NEWID(), 'Headcount Report','This app provides the all employees details like employee name ,department,date of join ,date of birth and salary details.Users can download the information in the app and can change the visualization of the app 
    ', N'SELECT E.EmployeeNumber [Employee ID],U.FirstName [First Name],U.SurName [Last Name],U.RegisteredDateTime [DOJ],E.DateofBirth [DOB],DesignationName [Designation],
 STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS [Repoting Manager], CAST((Amount -ES.NetPayAmount) / 12.00 AS decimal(10,2)) [Monthly CTC],Amount- ES.NetPayAmount AS [Annual CTC]
					FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                      LEFT JOIN EmployeeDesignation ED ON ED.EmployeeId = E.Id AND E.InActiveDateTime IS NULL
					  LEFT JOIN Designation DD ON DD.Id = ED.DesignationId AND DD.InActiveDateTime IS NULL
					  LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					  LEFT JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND (CONVERT(DATE,ES.ActiveFrom) < cast(GETDATE() as date)) AND (ES.ActiveTo IS NULL OR (CONVERT(DATE,ES.ActiveTo) > cast(GETDATE() as date)))
					  WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, GETDATE())
  )
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],
			    [Description] =  Source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

 MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This Month Company Productivity Percent'),'1','This Month Company Productivity Percent_kpi','kpi',NULL,NULL,'','This Month Company Productivity Percent',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Project Report'),'1','table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goal Report'),'1','table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Headcount Report'),'1','table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sprint Report'),'1','table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND  Target.[VisualizationName] = Source.[VisualizationName]
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

    MERGE INTO [dbo].[CustomTags] AS Target
USING ( VALUES
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This Month Company Productivity Percent' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Sprint Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Headcount Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'HR' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'This Month Company Productivity Percent' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Sprint Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Headcount Report' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Users' AND CompanyId =  @CompanyId),GETDATE(),@UserId)

)
	AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
	ON Target.[ReferenceId] = Source.[ReferenceId] AND Target.[TagId] = Source.[TagId]
	WHEN MATCHED THEN
	UPDATE SET [ReferenceId] = Source.[ReferenceId],
			   [TagId] = Source.[TagId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.ReferenceId IS NOT NULL THEN  
	INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES
	([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);

   MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'ExpectedProductivityFromEmployeePerMonth', N'160',N'Expected productivity from the employee per month', GETDATE() , @UserId,1)
	)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],IsVisible)
	ON Target.CompanyId = Source.CompanyId AND Target.[Key] = Source.[key] 
	WHEN MATCHED THEN
	UPDATE SET [value] = Source.[value]
	WHEN NOT MATCHED  BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);

    MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Sprint Report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='This Month Company Productivity Percent' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Goal Report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Headcount Report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'HR Management' ),@UserId,GETDATE())
 )
AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
WHEN MATCHED THEN 
UPDATE SET
		   [WidgetId] = Source.[WidgetId],
		   [ModuleId] = Source.[ModuleId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	

DECLARE @WidgetCount INT = (SELECT COUNT(1) FROM [dbo].[Widget] WHERE WidgetName = 'Projects' AND CompanyId = @CompanyId)
 IF(@WidgetCount = 0)
 BEGIN
    MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app user can access projects list', N'Projects', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
 )
AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [WidgetName] = Source.[WidgetName],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] =  Source.[CompanyId],
           [Description] =  Source.[Description],
           [UpdatedDateTime] =  Source.[UpdatedDateTime],
           [UpdatedByUserId] =  Source.[UpdatedByUserId],
           [InActiveDateTime] =  Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;
 END
 
END