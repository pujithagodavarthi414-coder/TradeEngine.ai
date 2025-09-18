CREATE PROCEDURE [dbo].[Marker156]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Expenses To Be Paid','This app provides the counts of expenses which are apprved but not yet paid.Users can download the information in the app 
and can change the visualization of the app and they can filter data in the app', 
   N' SELECT COUNT(1)[Expenses To Be Paid] FROM Expense E INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId AND E.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
                                       WHERE (ES.IsApproved = 1 AND (IsPaid IS NULL OR IsPaid = 0)) AND E.CompanyId = ''@CompanyId''
         AND ((@DateFrom IS NULL OR CAST(E.ExpenseDate AS date) >= CAST(@DateFrom AS date))
         AND ((@DateTo IS NULL OR CAST(E.ExpenseDate AS date) <= CAST(@DateTo AS date))))', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Employees Joined Today','','SELECT COUNT(1)[Employees Joined Today]  FROM [User] U INNER JOIN [Employee]E ON E.UserId = U.Id   
    INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()) 
    WHERE CAST(RegisteredDateTime AS date) = CAST(GETDATE() AS date) AND U.CompanyId = ''@CompanyId''
    AND  (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
	,(NEWID(), N'Employees Count Vs Join Date','','SELECT FORMAT(T.Date,''MMM-yy'')[Date],SUM(ISNULL([Employees Count],0)) [Employees Count]
                , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                FROM(SELECT  CAST(DATEADD( MONTH,number,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date)) AS date) [Date]         
               FROM master..spt_values
               WHERE Type = ''P'' and number between 1 
               and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date), 
               CAST(ISNULL(@DateTo,GETDATE()) AS date)))T LEFT JOIN	
                ( SELECT COUNT(1)[Employees Count] ,FORMAT(U.RegisteredDateTime,''MMM-yy'') RegisterDate 
                FROM [User] U INNER JOIN [Employee]E ON E.UserId = U.Id   
               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()) 
               Where U.CompanyId = ''@CompanyId''
               AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
               GROUP BY FORMAT(U.RegisteredDateTime,''MMM-yy''))Z ON Z.RegisterDate = FORMAT(T.Date,''MMM-yy'')
                GROUP BY  FORMAT(T.Date,''MMM-yy''),T.Date ', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
	,(NEWID(), N'Invoices Due','','SELECT COUNT(1)[Invoices Due] FROM Invoice_New I INNER JOIN InvoiceStatus SS ON I.InvoiceStatusId = SS.Id AND I.InactiveDateTime IS NULL AND SS.InActiveDateTime IS NULL
                                            WHERE I.CompanyId = ''@CompanyId'' AND SS.InvoiceStatusName <> ''Paid''
                                             AND ((@DateFrom IS NULL OR CAST(I.DueDate AS date) >= CAST(@DateFrom AS date))
                                              AND ((@DateTo IS NULL OR  CAST(I.DueDate AS date)  <= CAST(@DateTo AS date)))) ', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
,(NEWID(), N'Invoices Overdue','','SELECT COUNT(1)[Invoices Overdue] FROM Invoice_New I INNER JOIN InvoiceStatus SS ON I.InvoiceStatusId = SS.Id AND I.InactiveDateTime IS NULL AND SS.InActiveDateTime IS NULL
                                  WHERE I.CompanyId = ''@CompanyId''
                                  AND SS.InvoiceStatusName <> ''Paid''
                                  AND CAST(I.DueDate AS date) < CAST(GETDATE() AS date)
                                   AND ((@DateFrom IS NULL OR CAST(I.DueDate AS date) >= CAST(@DateFrom AS date))
                                   AND ((@DateTo IS NULL OR  CAST(I.DueDate AS date)  <= CAST(@DateTo AS date))))', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))

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
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Expenses To Be Paid'),'1','Expenses to be paid_kpi','kpi',NULL,NULL,'','Expenses To Be Paid',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employees Joined Today'),'1','Employees Joined Today_kpi','kpi',NULL,NULL,'','Employees Joined Today',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Invoices Due'),'1','Invoices Due_kpi','kpi',NULL,NULL,'','Invoices Due',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Invoices Overdue'),'1','Invoices Overdue_kpi','kpi',NULL,NULL,'','Invoices Overdue',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Employees Count Vs Join Date'),'1','Employees Count Vs Join Date','line',NULL,NULL,'Date','Employees Count',GETDATE(),@UserId)		
		)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
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

MERGE INTO [dbo].[Tags] AS Target
USING ( VALUES
(NEWID(),NULL,'Invoices Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Invoices' ),@CompanyId,@UserId,GETDATE())
)
AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
ON Target.[TagName] = Source.[TagName] AND Target.[CompanyId] = Source.[CompanyId]
WHEN MATCHED THEN
UPDATE SET [TagName] = Source.[TagName],
		   [CompanyId] = Source.[CompanyId],	
		   [ParentTagId] = Source.[ParentTagId],	
		   [Order] = Source.[Order],	
		   [CreatedDateTime] = Source.[CreatedDateTime],	
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);

UPDATE WorkspaceDashboards SET [Name] = 'Expenses To Be Approved' WHERE CustomWidgetId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Pending expenses count' 
AND CompanyId = @CompanyId) AND [Name] ='Pending expenses count'  AND InActiveDateTime IS NULL

UPDATE CustomAppDetails SET YCoOrdinate = 'Expenses To Be Approved' WHERE  CustomApplicationId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Pending expenses count' AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Expenses To Be Approved] FROM Expense E INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
                             AND E.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
							 WHERE IsPending = 1 
							 AND E.CompanyId = ''@CompanyId''
							  AND ((@DateFrom IS NULL OR CAST(E.ExpenseDate AS date) >= CAST(@DateFrom AS date))
                                   AND ((@DateTo IS NULL OR  CAST(E.ExpenseDate AS date)  <= CAST(@DateTo AS date))))' WHERE CustomWidgetName ='Pending expenses count' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Expenses To Be Approved' WHERE CustomWidgetName = 'Pending expenses count' AND CompanyId = @CompanyId

						
UPDATE WorkspaceDashboards SET [Name] = 'Work Items Due Soon' WHERE CustomWidgetId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Imminent deadline work items count' 
AND CompanyId = @CompanyId) AND [Name] ='Imminent deadline work items count'  AND InActiveDateTime IS NULL

UPDATE CustomAppDetails SET YCoOrdinate = 'Work Items Due Soon' WHERE  CustomApplicationId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Imminent deadline work items count' AND CompanyId = @CompanyId)

UPDATE CustomAppColumns SET ColumnName ='Work Items Due Soon' WHERE ColumnName ='Imminent deadline work items count' AND CompanyId = @CompanyId
AND  CustomWidgetId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Imminent deadline work items count' 
AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Work Items Due Soon] FROM
                  (SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
                      AND US.OwnerUserId =  ''@OperationsPerformedBy'' AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                  	AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                  	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
                  	   AND USS.CompanyId = ''@CompanyId''
                  	INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
                  	LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                  	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
                  	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
                  	WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL 
					AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
                  				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
                  				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL
								  AND CAST(S.SprintEndDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)))	
                  				  GROUP BY US.Id)T' WHERE CustomWidgetName ='Imminent deadline work items count' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName = 'Work Items Due Soon'  WHERE CustomWidgetName = 'Imminent deadline work items count' AND CompanyId = @CompanyId

END



										