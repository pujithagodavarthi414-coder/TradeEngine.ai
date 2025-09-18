CREATE PROCEDURE [dbo].[Marker33]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
    INSERT INTO [dbo].[RoleFeature]([Id],[RoleId],[FeatureId],[CreatedByUserId],[CreatedDateTime])
	SELECT NEWID(),@RoleId,'09900C86-081A-4584-8237-0DB406A6D7BA',@UserId,GETDATE()


    MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
          (NEWID(), N'BirthDays Report', N'This app provides birthdays of employees in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_BirthDaysReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Day Wise Leave Transaction Report', N'This app provides day wise leave transactions.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_DayWiseLeaveTransactionReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Hold Salary Report', N'This app provides employees salary hold details.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_HoldSalaryReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Joining Anniversary Report', N'This app provides joining dates of employees in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_JoiningAnniversaryReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Leave Availed Report', N'This app provides leaves history in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_LeaveAvailedReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Leave Backdated Report', N'This app provides backdated leaves of employees in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_LeaveBackdatedReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Leave Encashment Report', N'This app provides leave encashment details.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_LeaveEncashmentReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Leave Transaction Report', N'This app provides leave transaction details.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_LeaveTransactionReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Marriage Anniversary Report', N'This app provides marriage anniversaries of employees in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_MarriageAnniversaryReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Quick Salary Report', N'This app provides quick salary report in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_QuickSalaryReport',1, @CompanyId, @UserId, GETDATE())
	     ,(NEWID(), N'Negative Leave Balance Report', N'This app provides negative leave balance of employees in given date range.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_NegativeLeaveBalanceReport',1, @CompanyId, @UserId, GETDATE())
		 ,(NEWID(), N'Year Wise Leave Summary Report', N'This app provides year wise leave summary in selected year.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_YearWiseLeaveSummaryReport',1, @CompanyId, @UserId, GETDATE())
		 ,(NEWID(), N'Leave Summary Report', N'This app provides year wise leave summary in selected year.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_LeaveSummaryReport',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Proof of Investment Declaration Report', N'This app provides Proof of Investment Declarations.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetProofofInvestmentDeclaration',1, @CompanyId, @UserId, GETDATE())
		  , (NEWID(), N'ESI Monthly Summary Report', N'This app provides monthly ESI summary for selected month.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_ESIMonthlySummaryReport',1, @CompanyId, @UserId, GETDATE())
		  , (NEWID(), N'PF Monthly Statement', N'This app provides monthly PF summary for selected month.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_PFMonthlyStatement',1, @CompanyId, @UserId, GETDATE())
		   , (NEWID(), N'IT Savings Report', N'This app provides IT savings report.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetITSavingsReport',1, @CompanyId, @UserId, GETDATE())
		   , (NEWID(), N'Income Tax Monthly Statement', N'This app provides Income Tax for selected month.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetIncomeTaxMonthlyStatement',1, @CompanyId, @UserId, GETDATE())
	)
	AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
	VALUES	([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
		
	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'BirthDays Report'),'1','BirthDays Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Day Wise Leave Transaction Report'),'1','Day Wise Leave Transaction Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Hold Salary Report'),'1','Hold Salary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Joining Anniversary Report'),'1','Joining Anniversary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Availed Report'),'1','Leave Availed Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Backdated Report'),'1','Leave Backdated Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Encashment Report'),'1','Leave Encashment Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Transaction Report'),'1','Leave Transaction Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Marriage Anniversary Report'),'1','Marriage Anniversary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Quick Salary Report'),'1','QuickSalaryReport_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Negative Leave Balance Report'),'1','Negative Leave Balance Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Year Wise Leave Summary Report'),'1','Year Wise Leave Summary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Summary Report'),'1','Leave Summary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Proof of Investment Declaration Report'),'1','Proof of Investment Declaration Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'ESI Monthly Summary Report'),'1','ESI Monthly Summary Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'PF Monthly Statement'),'1','PF Monthly Statement_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'IT Savings Report'),'1','IT Savings Report_table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Income Tax Monthly Statement'),'1','Income Tax Monthly Statement_table','table',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]) 
	VALUES	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]);
	
		INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
	VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'BirthDays Report'),'USP_BirthDaysReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Day Wise Leave Transaction Report'),'USP_DayWiseLeaveTransactionReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@Date","DataType":"DATETIME","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Hold Salary Report'),'USP_HoldSalaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Joining Anniversary Report'),'USP_JoiningAnniversaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Availed Report'),'USP_LeaveAvailedReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Backdated Report'),'USP_LeaveBackdatedReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Encashment Report'),'USP_LeaveEncashmentReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Transaction Report'),'USP_LeaveTransactionReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Marriage Anniversary Report'),'USP_MarriageAnniversaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":null},{"ParameterName":"@DateTo","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Quick Salary Report'),'USP_QuickSalaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Negative Leave Balance Report'),'USP_NegativeLeaveBalanceReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Year Wise Leave Summary Report'),'USP_YearWiseLeaveSummaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leave Summary Report'),'USP_LeaveSummaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@ColumnString","DataType":"nvarchar","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Proof of Investment Declaration Report'),'USP_GetProofofInvestmentDeclaration',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@IsFinantialYearBased","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'ESI Monthly Summary Report'),'USP_ESIMonthlySummaryReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'PF Monthly Statement'),'USP_PFMonthlyStatement',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'IT Savings Report'),'USP_GetITSavingsReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@IsFinantialYearBased","DataType":"BIT","InputData":null}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Income Tax Monthly Statement'),'USP_GetIncomeTaxMonthlyStatement',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@Date","DataType":"datetime","InputData":null},{"ParameterName":"@EntityId","DataType":"uniqueidentifier","InputData":null},{"ParameterName":"@IsActiveEmployeesOnly","DataType":"BIT","InputData":null},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":null}]',NULL)
	
	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	      (NEWID(), N'UserStory Report By Using Pivot Tables', N'To get user-stories along with different count by using a pivot table '
		  ,' SELECT P.ProjectName AS [Project Name],G.GoalName AS [Goal Name],GS.GoalStatusName AS [Goal Status],T.TagName AS [Tag Name],UST.UserStoryTypeName AS [Work Item Type],U.Firstname + '' '' + ISNULL(U.SurName,'''') AS [Assigned To],USS.[Status] AS [WorkitemStatus],BP.PriorityName AS [Priority],COUNT(1) AS [Count]
		      FROM Project P INNER JOIN Goal G ON G.ProjectId = P.Id AND P.InActiveDateTime IS NULL   AND G.InActiveDateTime IS NULL 
			       INNER JOIN UserStory US ON US.GoalId = G.Id AND US.InActiveDateTime IS NULL INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
				   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
				   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				   LEFT JOIN [User] U ON U.Id = US.OwneruserId 
				   LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				   LEFT JOIN (SELECT UST.Id AS TagName,US.Id AS UserStoryId            
				               FROM Project P INNER JOIN Goal G ON G.ProjectId = P.Id INNER JOIN UserStory US ON US.GoalId = G.Id CROSS APPLY [dbo].[UfnSplit](US.Tag) UST 
							   WHERE CompanyId = ''4AFEB444-E826-4F95-AC41-2175E36A0C16''     
							          AND P.Id = ''1AA0CF26-4147-4874-BC62-6EB82B2FC674''     
									  AND G.Id = ''C834139F-D4CA-4993-99A4-59D8D53952FE''           
									  AND US.Tag IS NOT NULL            
							  GROUP BY UST.Id,US.Id ) T ON  T.UserStoryId = US.Id 
			     WHERE P.CompanyId = ''4AFEB444-E826-4F95-AC41-2175E36A0C16''     
				       AND P.Id = ''1AA0CF26-4147-4874-BC62-6EB82B2FC674''    
					   AND G.Id = ''C834139F-D4CA-4993-99A4-59D8D53952FE''                    
					   AND USS.TaskStatusId <> ''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'' 
					   GROUP BY P.ProjectName,G.GoalName,GS.GoalStatusName,T.TagName,UST.UserStoryTypeName,U.Firstname + '' '' + ISNULL(U.SurName,''''),USS.[Status],BP.PriorityName', @CompanyId, @UserId, GETDATE())
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
	VALUES	([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime]);
		
	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	       (NEWID(),(SELECT Id FROM CustomWidgets WHERE [CustomWidgetName] = N'UserStory Report By Using Pivot Tables' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL),1,'UserStory Report For Tags - Pivot','pivot','[{"measurerField":"Count","measurerName":"Total","aggregateFunction":"sum"}]'
		  , GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[PivotMeasurersToDisplay],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[PivotMeasurersToDisplay],[CreatedDateTime], [CreatedByUserId]) 
	VALUES	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[PivotMeasurersToDisplay],[CreatedDateTime], [CreatedByUserId]);
	
	INSERT INTO [Persistance]( [Id],[ReferenceId],[IsUserLevel],[PersistanceJson],[CreatedByUserId],[CreatedDateTime])
	SELECT NEWID(),(SELECT Id FROM CustomWidgets WHERE [CustomWidgetName] = N'UserStory Report By Using Pivot Tables' AND CompanyId = @CompanyId AND InactiveDateTime IS NULL),0,'{"columns":[{"name":["Priority"],"expand":false}],"rows":[{"name":["Assigned To"],"expand":false},{"name":["Work Item Type"],"expand":false}],"measurers":[{"name":"Total"}]}',@UserId,GETDATE()
END