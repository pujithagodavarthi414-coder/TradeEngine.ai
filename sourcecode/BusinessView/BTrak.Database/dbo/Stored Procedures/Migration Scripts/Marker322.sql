CREATE PROCEDURE [dbo].[Marker322]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES (NEWID(), N'User App Usage Detailes',N'Displays all app usage detailes of an user in a pirticular date'
	, N'SELECT TOP(10000) UA.UserId,CONCAT(U.FirstName,'' '',U.SurName) AS [Name]
       ,ISNULL(AbsoluteAppName,OtherApplication) AS AppName
	   ,IIF(DATEDIFF(SECOND,''00:00:00.0000000'',UA.SpentTime) > 60
	        ,CONVERT(VARCHAR,DATEDIFF(MINUTE,''00:00:00.0000000'',UA.SpentTime)) + '' Min''
			,CONVERT(VARCHAR,DATEDIFF(SECOND,''00:00:00.0000000'',UA.SpentTime)) + '' Sec'') TimeSpent
			,CONVERT(VARCHAR,DATEADD(MILLISECOND,(DATEDIFF(MILLISECOND,GETUTCDATE(),''@CurrentdateTime'')),ApplicationStartTime)) AS ''Start Time''
			,CONVERT(VARCHAR,DATEADD(MILLISECOND,(DATEDIFF(MILLISECOND,GETUTCDATE(),''@CurrentdateTime'')),ApplicationEndTime)) AS ''End Time''
			,ApplicationStartTime
			,ApplicationEndTime
FROM UserActivityTime UA
	 INNER JOIN [User] U ON U.Id = UA.UserId 
	            AND U.InActiveDateTime IS NULL
				AND UA.InActiveDateTime IS NULL
WHERE U.CompanyId = ''@CompanyId''
	 AND (UA.UserId =IIF(''@UserId'' = '''',''@OperationsPerformedBy'',''@UserId''))
	 AND UA.CreatedDateTime = ISNULL(@Date,CONVERT(DATE,GETDATE()))
	 AND DATEDIFF(SECOND,''00:00:00.0000000'',UA.SpentTime) > 0
ORDER BY ApplicationStartTime', @CompanyId, @UserId, GETDATE())
 ,(NEWID(), N'User kayboard and Mouse Usage Detailes',N'Displays all kaystrokes and mouse movements detailes of an user in a pirticular date'
 , N'SELECT TOP(10000) UA.UserId, CONCAT(U.FirstName,'' '',U.SurName) AS [Name]
	   ,UA.KeyStroke
	   ,UA.MouseMovement
	   ,CONVERT(VARCHAR,DATEADD(MILLISECOND,(DATEDIFF(MILLISECOND,GETUTCDATE(),''@CurrentdateTime'')),TrackedDateTime)) AS ''Tracked Time''
	   ,TrackedDateTime
FROM UserActivityTrackerStatus UA
INNER JOIN [User] U ON U.Id = UA.UserId AND U.InActiveDateTime IS NULL
WHERE U.CompanyId = ''@CompanyId''
	 AND (UA.UserId =IIF(''@UserId'' = '''',''@OperationsPerformedBy'',''@UserId''))
	 AND CONVERT(DATE,UA.TrackedDateTime) = ISNULL(@Date,CONVERT(DATE,GETDATE()))
ORDER BY TrackedDateTime', @CompanyId, @UserId,GETDATE())
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
 (NEWID(),  (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'User App Usage Detailes' AND CompanyId = @CompanyId), 1, N'User App Usage Detailes_Table', N'Table', NULL, NULL,GETDATE(), @UserId)
 ,(NEWID(),  (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId), 1, N'User kayboard and Mouse Usage Detailes_Table', N'Table', NULL, NULL,GETDATE(), @UserId)
)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns],[CreatedDateTime], [CreatedByUserId]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns],[CreatedDateTime], [CreatedByUserId]);
	
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'UserId','uniqueidentifier',@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'Name','nvarchar',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'AppName','nvarchar',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'Start Time','datetime',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'End Time','datetime',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'TimeSpent','varchar',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'ApplicationStartTime','datetime',@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User App Usage Detailes' AND CompanyId = @CompanyId),'ApplicationEndTime','datetime',@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'UserId','uniqueidentifier',@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'Name','nvarchar',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'KeyStroke','int',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'MouseMovement','Int',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'Tracked Time','datetime',@CompanyId,@UserId,GETDATE(),0)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'User kayboard and Mouse Usage Detailes' AND CompanyId = @CompanyId),'TrackedDateTime','datetime',@CompanyId,@UserId,GETDATE(),1)
)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND Target.[ColumnType] = Source.[ColumnType]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);
	
END
GO