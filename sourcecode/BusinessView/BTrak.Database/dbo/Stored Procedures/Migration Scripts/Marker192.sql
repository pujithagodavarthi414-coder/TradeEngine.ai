CREATE PROCEDURE [dbo].[Marker192]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetProjectCustomReport' WHERE CustomWidgetName = 'Project Report' AND CompanyId = @CompanyId

	MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
    USING ( VALUES 
	  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Project Report'),'USP_GetProjectCustomReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]',null)
	 )
  AS SOURCE (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
  ON  Target.CustomWidgetId = Source.CustomWidgetId  AND Target.ProcName =Source.ProcName AND Target.CompanyId =Source.CompanyId 
    WHEN MATCHED THEN
    UPDATE SET Inputs  = SOURCE.Inputs
    WHEN NOT MATCHED BY TARGET  AND  SOURCE.CustomWidgetId IS NOT NULL THEN 
    INSERT  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs) 
    VALUES  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs);
   
   MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (NEWID(),'By using this app, user can add different type''s categories for actions', N'Action category', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	  	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[WidgetName] = Source.[WidgetName]
		AND Target.[CompanyId] = Source.[CompanyId]

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
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

			
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM Widget WHERE WIdgetName =N'Action category' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Audits' ),@UserId,GETDATE())
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


 UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetSprintCustomReport' WHERE CustomWidgetName = 'Sprint Report' AND CompanyId = @CompanyId
 UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetGoalCustomReport' WHERE CustomWidgetName = 'Goal Report' AND CompanyId = @CompanyId
 UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetEmployeeDetailsCustomReport' WHERE CustomWidgetName = 'Employees Overview Details' AND CompanyId = @CompanyId
 UPDATE CustomWidgets SET WidgetQuery = NULL ,IsProc =1,ProcName = 'USP_GetEmployeeDetailsProjectWise' WHERE CustomWidgetName = 'Employees Details Project Wise' AND CompanyId = @CompanyId


	MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
    USING ( VALUES 
	   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sprint Report'),'USP_GetSprintCustomReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]',null)
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goal Report'),'USP_GetGoalCustomReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]',null)
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees Overview Details'),'USP_GetEmployeeDetailsCustomReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',null)
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employees Details Project Wise'),'USP_GetEmployeeDetailsProjectWise',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',null)
	 )
  AS SOURCE (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
  ON  Target.CustomWidgetId = Source.CustomWidgetId  AND Target.ProcName =Source.ProcName AND Target.CompanyId =Source.CompanyId 
    WHEN MATCHED THEN
    UPDATE SET Inputs  = SOURCE.Inputs
    WHEN NOT MATCHED BY TARGET  AND  SOURCE.CustomWidgetId IS NOT NULL THEN 
    INSERT  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs) 
    VALUES  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs);
   
UPDATE CustomWidgets SET WidgetQuery = 'SELECT CAST(CAST((Cast(ISNULL(SUM(ISNULL(Z.ProductivityIndex,0)),0) as decimal(10,2))/
      CAST(CASE WHEN CAST(((SELECT COUNT(1) EmployeesCount FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
	                      WHERE CompanyId = ''@CompanyId'')* (SELECT CAST(ISNULL([Value],0) AS decimal(10,2)) 
						  FROM CompanySettings WHERE CompanyId = ''@CompanyId'' AND [Key] =  ''ExpectedProductivityFromEmployeePerMonth'')) AS INT) = 0 
						  THEN 1 ELSE ((SELECT COUNT(1) EmployeesCount FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
	                      WHERE CompanyId = ''@CompanyId'')* (SELECT CAST(ISNULL([Value],0) AS decimal(10,2)) 
						  FROM CompanySettings WHERE CompanyId = ''@CompanyId'' AND [Key] =  ''ExpectedProductivityFromEmployeePerMonth'')) END AS DECIMAL(10,2))* 1.00)*100 AS decimal(10,2)) AS NVARCHAR(100))+''%'' AS [This Month Company Productivity Percent] 						     
 FROM dbo.[ProductivityIndex] Z 
  WHERE Z.[Date] BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
        AND Z.CompanyId = ''@CompanyId''' WHERE CustomWidgetName ='This Month Company Productivity Percent' AND CompanyId = @CompanyId 

	--INSERT INTO WidgetRoleConfiguration(Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
	--SELECT NEWID(),W.Id,@RoleId,GETDATE(),@UserId FROM Widget W INNER JOIN WidgetModuleConfiguration WM  ON W.Id = WM.WidgetId AND W.InActiveDateTime IS NULL AND WM.InActiveDateTime IS NULL
 --                                                               INNER JOIN CompanyModule CM ON CM.ModuleId = WM.ModuleId  AND CM.InActiveDateTime IS NULL 
	--				            AND CM.CompanyId = @CompanyId AND CM.IsActive = 1
 --                      LEFT JOIN WidgetRoleConfiguration WR ON WR.WidgetId = W.Id  AND  WR.InActiveDateTime IS NULL AND WR.RoleId = @RoleId
	--				   WHERE   WR.Id IS NULL AND W.CompanyId =@CompanyId
	--				   GROUP BY  W.Id 
					
	--			INSERT INTO CustomWidgetRoleConfiguration(Id,CustomWidgetId,RoleId,CreatedDateTime,CreatedByUserId)
	--			SELECT NEWID(),W.Id,@RoleId,GETDATE(),@UserId  FROM CustomWidgets W INNER JOIN WidgetModuleConfiguration WM  
	--				                          ON W.Id = WM.WidgetId AND W.InActiveDateTime IS NULL AND WM.InActiveDateTime IS NULL
 --                      INNER JOIN CompanyModule CM ON CM.ModuleId = WM.ModuleId  AND CM.InActiveDateTime IS NULL 
	--				   AND CM.CompanyId = @CompanyId AND CM.IsActive = 1
 --                      LEFT JOIN CustomWidgetRoleConfiguration WR ON WR.CustomWidgetId = W.Id AND  WR.InActiveDateTime IS NULL  AND WR.RoleId = @RoleId
	--				   WHERE   WR.Id IS NULL AND W.CompanyId =@CompanyId
	--				   GROUP BY  W.Id 

END