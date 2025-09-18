CREATE PROCEDURE [dbo].[Marker38]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Monday Leave Report', N'This app provides the information of monday leaves of an employee'
          ,'USP_GetLeaves',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monday Leave Report'),'1','Monday Leave Report_heat map','Heat map',GETDATE(),@UserId,'date','leavesCount')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
   
   INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monday Leave Report'),'USP_GetLeaves',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":0},{"ParameterName":"@Day","DataType":"nvarchar","InputData":"Monday"}]','[{field: "date", filter: "datetime"}, {field: "leavesCount", filter: "int"}]')


	--Sick Leave Report
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Sick Leave Report', N'This app provides the information of sick leaves of an employee'
          ,'USP_GetLeaves',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sick Leave Report'),'1','Sick Leave Report_heat map','Heat map',GETDATE(),@UserId,'date','leavesCount')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
    
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Sick Leave Report'),'USP_GetLeaves',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":1},{"ParameterName":"@Day","DataType":"nvarchar","InputData":null}]','[{field: "date", filter: "datetime"}, {field: "leavesCount", filter: "int"}]')


	--Leaves report
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employee Leaves Report', N'This app provides the information of leaves of an employee'
          ,'USP_GetLeaves',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Leaves Report'),'1','Employee Leaves Report_heat map','Heat map',GETDATE(),@UserId,'date','leavesCount','{"legend":[{"legendName":"Full  day leave","value":"1"},{"legendName":"Half day leave","value":"0.5"},{"legendName":"Working day","value":"0"}],"cellSize":null,"showDataInCell":null}')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate], [HeatMapMeasure])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate], [HeatMapMeasure]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate], [HeatMapMeasure]);
      
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Leaves Report'),'USP_GetLeaves',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":0},{"ParameterName":"@Day","DataType":"nvarchar","InputData":null}]','[{field: "date", filter: "datetime"}, {field: "leavesCount", filter: "int"}]')

    

	--Employee office spent time
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employee Office Spent Time Report', N'This app provides the information of employee spent time details'
          ,'USP_GetSpentTimeDetails',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Spent Time Report'),'1','Employee Office Spent Time Report_heat map','Heat map',GETDATE(),@UserId,'date','spentTime')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
       
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Spent Time Report'),'USP_GetSpentTimeDetails',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]','[{field: "date", filter: "datetime"}, {field: "spentTime", filter: "int"}]')

	
    
	--Employee office break time
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employee Office Break Time Report', N'This app provides the information of employee break time details'
          ,'USP_GetBreakTimings',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Break Time Report'),'1','Employee Office Break Time Report_heat map','Heat map',GETDATE(),@UserId,'date','breakInMinutes')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
       
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Office Break Time Report'),'USP_GetBreakTimings',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]','[{field: "date", filter: "datetime"}, {field: "breakInMinutes", filter: "int"}]')
	
	
    
	--Employee Morning Late
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employee Morning Late Report', N'This app provides the information of employee morning late details'
          ,'USP_GetMorningLateDates',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Morning Late Report'),'1','Employee Morning Late Report_heat map','Heat map',GETDATE(),@UserId,'date','morningLate')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
       
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Morning Late Report'),'USP_GetMorningLateDates',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]','[{field: "date", filter: "datetime"}, {field: "morningLate", filter: "int"}]')
	
	
    
	--Employee Afternoon Late
	MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
          (NEWID(), N'Employee Afternoon Late Report', N'This app provides the information of employee afternoon late details'
          ,'USP_GetMorningLateDates',1, @CompanyId, @UserId, GETDATE())
    )
    AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
    VALUES  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
        
    MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Afternoon Late Report'),'1','Employee Afternoon Late Report_heat map','Heat map',GETDATE(),@UserId,'date','lunchBreakLate')
    )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate])
    ON Target.Id = Source.Id
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]) 
    VALUES  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId], [XCoOrdinate], [YCoOrdinate]);
    
    INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    VALUES 
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Afternoon Late Report'),'USP_GetMorningLateDates',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"}]','[{field: "date", filter: "datetime"}, {field: "lunchBreakLate", filter: "int"}]')

END
GO