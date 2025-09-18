CREATE PROCEDURE [dbo].[Marker25]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Monthly expenses', ' This app displays the overall company status wise expenses amount for last twelve months. Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],ISNULL([Approved amount],0) [Approved amount],
              ISNULL([Paid amount],0)[Paid amount],
			  ISNULL([Rejected amount],0)[Rejected amount] FROM(SELECT  FORMAT(DATEADD(MONTH,-(number-1),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)),''yy-MMM'') [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and 12)T LEFT JOIN
				   (SELECT FORMAT(E.ExpenseDate, ''yy-MMM'')CreatedOn,
				            SUM(CASE WHEN ES.IsApproved = 1 THEN ECC.Amount END)[Approved amount],
				            SUM(CASE WHEN ES.IsPaid = 1 THEN ECC.Amount END)[Paid amount],
				            SUM(CASE WHEN ES.IsRejected = 1 THEN ECC.Amount END)[Rejected amount]

				                       FROM Expense E
				  INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id AND  E.InActiveDateTime IS NULL
							 AND ECC.InActiveDateTime IS NULL
							 INNER JOIN ExpenseCategory EC ON EC.Id = ECC.ExpenseCategoryId 
							 AND EC.InActiveDateTime IS NULL
							 INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
							WHERE E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY  FORMAT(E.ExpenseDate, ''yy-MMM'')
							 )R ON T.[Date] = R.CreatedOn', @CompanyId, @UserId, CAST(N'2020-04-24T06:16:07.533' AS DateTime))

 ,(NEWID(), N'Approved category wise expenses', 'This app displays the overall company category wise expenses. 
Users can download the information in the app and can change the visualization of the app.', N'SELECT EC.CategoryName,ISNULL(SUM(Amount),0)Amount FROM Expense E
				  INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id 
							 AND ECC.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
							 INNER JOIN ExpenseCategory EC ON EC.Id = ECC.ExpenseCategoryId 
							 INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId AND (ES.IsApproved = 1 OR ES.IsPaid = 1)
							 AND EC.InActiveDateTime IS NULL
						    WHERE E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY CategoryName
					', @CompanyId, @UserId, CAST(N'2020-04-24T06:10:38.943' AS DateTime))
,(NEWID(), N'Expenses pivot table',' This app displays the overall company expenses and also user can see the status wise expenses Users can download the information in the app and can change the visualization of the app.', N'SELECT E.ExpenseName [Expense name],ES.Name [Expense status name],EC.CategoryName [Category name],ISNULL(SUM(Amount),0)Amount FROM Expense E
				  INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id 
							 AND ECC.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
							 INNER JOIN ExpenseCategory EC ON EC.Id = ECC.ExpenseCategoryId 
							 INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
							 AND EC.InActiveDateTime IS NULL
						     WHERE E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY  E.ExpenseName ,ES.Name ,EC.CategoryName
					', @CompanyId, @UserId, CAST(N'2020-04-24T06:25:09.930' AS DateTime))
)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
 (NEWID(), (SELECT Id FROM CustomWidgets W WHERE CustomWidgetName =N'Monthly expenses' AND CompanyId = @CompanyId), 1, N'Monthly expenses', N'column', NULL, NULL, N'"\"\\\"\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"[]\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\"\\\\\\\\\\\\\\\"\\\\\\\"\\\"\""', N'Date', N'Approved amount,Paid amount,Rejected amount', CAST(N'2020-04-24T06:16:07.533' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets W WHERE CustomWidgetName = N'Expenses pivot table' AND CompanyId = @CompanyId), 1, N'Expenses pivot table', N'pivot', NULL, NULL, N'[{"measurerField":"Amount","measurerName":"SUM","aggregateFunction":"sum"}]', NULL, NULL, CAST(N'2020-04-24T06:38:58.733' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets W WHERE CustomWidgetName = N'Approved category wise expenses' AND CompanyId = @CompanyId), 1, N'Approved category wise expenses', N'pie', NULL, NULL, N'[]', N'CategoryName', N'Amount', CAST(N'2020-04-24T06:10:38.943' AS DateTime), @UserId)
)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns],[PivotMeasurersToDisplay], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [PivotMeasurersToDisplay] = Source.[PivotMeasurersToDisplay],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime],[PivotMeasurersToDisplay]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime],[PivotMeasurersToDisplay]);

	--INSERT INTO CustomWidgetRoleConfiguration(Id,CustomWidgetId,RoleId,CreatedDateTime,CreatedByUserId)
	--SELECT NEWID(),C.Id,(SELECT Id FROM [Role] WHERE RoleName = 'CEO' AND CompanyId = @CompanyId),GETDATE(),@UserId FROM CustomWidgets C WHERE C.CompanyId = @CompanyId AND CustomWidgetName IN (N'Monthly expenses',
	--N'Expenses pivot table',N'Approved category wise expenses')


	INSERT INTO Persistance(Id,ReferenceId,IsUserLevel,PersistanceJson,CreatedByUserId,CreatedDateTime,UserId)
 SELECT NEWID(),(SELECT CA.Id FROM CustomAppDetails CA INNER JOIN CustomWidgets CW ON CW.Id = CA.CustomApplicationId 
 WHERE CompanyId = @CompanyId AND CustomWidgetName = N'Expenses pivot table' 
 AND VisualizationName ='Expenses pivot table'),0,
 '{"columns":[{"name":["Expense status name"],"expand":false}],"rows":[{"name":["Expense name"],"expand":false}],"measurers":[{"name":"SUM"}]}'
 ,@UserId,GETDATE(),NULL

    MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
  (NEWID(), N'Pending expenses count', 'This app displays the overall company wise pending expenses count.Users can download the information in the app and can change the visualization of the app.', 
N'SELECT COUNT(1)[Pending expenses count] FROM Expense E INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
                             AND E.InActiveDateTime IS NULL AND ES.InActiveDateTime IS NULL
							 WHERE IsPending = 1 
							 AND E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
							  AND InActiveDateTime IS NULL)
', @CompanyId, @UserId, 
CAST(N'2020-05-01T14:41:04.893' AS DateTime))
)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
(NEWId(), (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Pending expenses count' AND CompanyId = @CompanyId), 1, N'Pending expenses count', N'kpi', NULL, NULL, N'[]', NULL, N'Pending expenses count', CAST(N'2020-05-01T14:41:04.893' AS DateTime), @UserId)

)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns],[PivotMeasurersToDisplay], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [PivotMeasurersToDisplay] = Source.[PivotMeasurersToDisplay],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime],[PivotMeasurersToDisplay]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime],[PivotMeasurersToDisplay]);

	UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker22' WHERE AppSettingsName = 'Marker'
END
GO