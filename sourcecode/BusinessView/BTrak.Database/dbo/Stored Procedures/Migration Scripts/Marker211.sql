CREATE PROCEDURE [dbo].[Marker211]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Start time', N'This app displays the start time of the employee',
	N'select CAST(CONVERT(char(5), T.InTime, 108) AS NVARCHAR) +'' ''+ TZ.TimeZoneAbbreviation[Start Time] from timesheet T 
			INNER JOIN TimeZone TZ ON TZ.Id = T.InTimeTimeZone
			where userid=''@OperationsPerformedBy'' and [date] = CONVERT(date,getdate())', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))

	,(NEWID(), N'Finish time', N'This app displays the finish time of the employee',
	N'select CASE 
				WHEN T.OutTime IS NULL THEN ''Online''
				ELSE CAST(CONVERT(char(5), T.OutTime, 108) AS NVARCHAR) +'' ''+ TZ.TimeZoneAbbreviation  END[Finish Time]
									from timesheet T 
									LEFT JOIN TimeZone TZ ON TZ.Id = T.OutTimeTimeZone
									where userid=''@OperationsPerformedBy'' and [date] = CONVERT(date,getdate())', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
	,(NEWID(), N'Productive time', N'This app displays the productive time of the employee',
	N'SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Productive Time] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
                                          FROM UserActivityTime AS UA 
                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''Productive'')
                                          UNION ALL
                  SELECT UserId,CreatedDateTime,SpentTime
                  FROM UserActivityHistoricalData UAH
                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''Productive''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
	,(NEWID(), N'Idle time', N'This app displays the idle time of the employee',
	N'SELECT CASE WHEN NOT EXISTS(SELECT T.TotalIdleTIme) THEN ''0h 0m'' ELSE  IIF(T.TotalIdleTIme < 60,
				CAST(T.TotalIdleTIme AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalIdleTIme,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalIdleTIme,0)%60 AS INT) AS VARCHAR(100))+''m'')) END [Idle Time] 
                          FROM [User] U 
						  LEFT JOIN (SELECT * FROM [dbo].[Ufn_GetUserIdleTimeForMultipleDates](CONVERT(DATE,GETDATE()),CONVERT(DATE,GETDATE()),''@CompanyId'')) T ON T.[UserId] = U.Id  AND T.TrackedDateTime = CONVERT(DATE,GETDATE())
                           where U.Id = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
	,(NEWID(), N'Unproductive time', N'This app displays the Unproductive time of the employee',
	N'SELECT IIF(T.TotalTIme < 60,CAST(T.TotalTime AS NVARCHAR(50)) + ''m'', CAST(CAST(ISNULL(T.TotalTime,0)/60.0 AS int) AS varchar(100))+''h''+IIF(CAST(ISNULL(T.TotalTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(T.TotalTime,0)%60 AS INT) AS VARCHAR(100))+''m'')) [Unproductive Time] 
	from [User] UDD 
	LEFT JOIN 
	(SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime
                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (SELECT UserId,CreatedDateTime,SpentTime 
                                          FROM UserActivityTime AS UA 
                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                                                AND UA.InActiveDateTime IS NULL AND ApplicationTypeId = (SELECT Id FROM ApplicationType WHERE ApplicationTypeName = ''Unproductive'')
                                          UNION ALL
                  SELECT UserId,CreatedDateTime,SpentTime
                  FROM UserActivityHistoricalData UAH
                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,GETDATE()) AND CONVERT(DATE,GETDATE())
                        AND UAH.CompanyId = ''@CompanyId'' AND ApplicationTypeName = ''Unproductive''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime) T ON UDD.Id = T.UserId WHERE UDD.Id=''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
	,(NEWID(), N'Weekly activity', N'This app displays the weekly productive, unproductive, neutral time of the employee',
	N'SELECT Da.[Date],ISNULL(P.Productive,0)Productive,ISNULL(P.UnProductive,0)UnProductive,ISNULL(P.Neutral,0)Neutral FROM
(SELECT CONVERT(DATE,DATEADD(DAY,NUMBER+1,DATEADD(DAY,-7,GETDATE()))) AS [Date] 
        FROM Master..SPT_VALUES WHERE number < DATEDIFF(DAY,DATEADD(DAY,-7,GETDATE()),GETDATE()) AND [type] = ''p'') Da
LEFT JOIN
(SELECT CONVERT(DATE,CreatedDateTime) AS [Date]
,productive AS Productivemin
,IIF(Productive/60 > 0,CONVERT(DECIMAl(10,2),Productive/60),0) Productive
,IIF(UnProductive/60 > 0,CONVERT(DECIMAl(10,2),UnProductive/60),0) UnProductive
,IIF(Neutral/60 > 0,CONVERT(DECIMAl(10,2),Neutral/60),0) Neutral
FROM
(SELECT CreatedDateTime,ApplicationTypeName
,CONVERT(DECIMAL,ISNULL(T.TotalTime,0)) AS TotalTime
	from (SELECT UM.Id AS UserId,UAT.CreatedDateTime AS CreatedDateTime,ApplicationTypeName
                        ,FLOOR(SUM(( DATEPART(HH, UAT.SpentTime) * 3600000 ) + (DATEPART(MI, UAT.SpentTime) * 60000 ) + DATEPART(SS, UAT.SpentTime)*1000  + DATEPART(MS, UAT.SpentTime)) * 1.0 / 60000 * 1.0) AS TotalTime
						FROM [User] AS UM
                           INNER JOIN (SELECT UserId,UA.CreatedDateTime,SpentTime,ApplicationTypeName
                                          FROM UserActivityTime AS UA
										  JOIN ApplicationType [AT] ON [AT].Id = UA.ApplicationTypeId
                                          WHERE UA.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,GETDATE())) AND CONVERT(DATE,GETDATE())
                                                AND UA.InActiveDateTime IS NULL
                                          UNION ALL
                  SELECT UserId,CreatedDateTime,SpentTime,ApplicationTypeName
                  FROM UserActivityHistoricalData UAH
                  WHERE UAH.CreatedDateTime BETWEEN CONVERT(DATE,DATEADD(DAY,-7,GETDATE())) AND CONVERT(DATE,GETDATE())
                        AND UAH.CompanyId = ''@CompanyId''
                                        ) UAT ON UAT.UserId = UM.Id
                        GROUP BY UM.Id,UAT.CreatedDateTime,ApplicationTypeName) T WHERE T.UserId=''@OperationsPerformedBy''
						) Pvt
						PIVOT( SUM([TotalTime])
				        FOR ApplicationTypeName IN ([Neutral],[Productive],[UnProductive]))PivotTab) P ON P.[Date] = Da.[Date]', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
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
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Start time'),'1','Start time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Start Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Start Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Finish time'),'1','Finish time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Finish Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Finish Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productive time'),'1','Productive time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Productive Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Productive Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Idle time'),'1','Productive time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Idle Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Idle Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Unproductive time'),'1','Productive time_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Unproductive Time</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Unproductive Time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Weekly activity'),'1','Weekly activity_stacked column chart','stackedcolumn',NULL,'','Date','Productive,UnProductive,Neutral',GETDATE(),@UserId)
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

	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
	  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Start time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Finish time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productive time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Idle time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Unproductive time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Weekly activity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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
	
	MERGE INTO [dbo].[WorkSpace] AS Target 
    USING ( VALUES 
    (NEWID(), N'Customized_ActivityTrackerMyDashboard',0, GETDATE(), @UserId, @CompanyId, 'activity_tracker_MyDashboard')
    )
    AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
        [IsHidden] = Source.[IsHidden],
        [CompanyId] = Source.[CompanyId], 
        [CreatedDateTime] = Source.[CreatedDateTime],
        [CreatedByUserId] = Source.[CreatedByUserId],
        [IsCustomizedFor] = Source.[IsCustomizedFor]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

	MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
    USING ( VALUES 
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  0,0,10,5,5,5, 1 ,'Start time','Start time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Start time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Start time' AND VisualizationName = 'Start time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  10,0,10,5,5,5, 2 ,'Finish time','Finish time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Finish time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Finish time' AND VisualizationName = 'Finish time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  20,0,10,5,5,5, 3 ,'Productive time' ,'Productive time' ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productive time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Productive time' AND VisualizationName = 'Productive time_kpi'      AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  40,0,10,5,5,5, 4 ,'Idle time' ,'Idle time'  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Idle time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Idle time' AND VisualizationName = 'Idle time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  30,0,10,5,5,5, 5 ,'Unproductive time','Unproductive time' ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Unproductive time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Unproductive time'  AND VisualizationName = 'Unproductive time_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerMyDashboard' AND CompanyId = @CompanyId),  0,5,50,16,5,5, 6 ,'Weekly activity','Weekly activity' ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Weekly activity' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Weekly activity'  AND VisualizationName = 'Weekly activity_stacked column chart' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
      
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			    [X] = Source.[X],	
    			    [Y] = Source.[Y],	
    			    [Col] = Source.[Col],	
    			    [Order] = Source.[Order],	
    			    [Row] = Source.[Row],	
    			    [MinItemCols] = Source.[MinItemCols],	
    			    [MinItemRows] = Source.[MinItemRows],	
                    [DashboardName] = Source.[DashboardName],
    			    [Name] = Source.[Name],	
    			    [CustomWidgetId] = Source.[CustomWidgetId],	
    			    [IsCustomWidget] = Source.[IsCustomWidget],	
    			    [CreatedDateTime] = Source.[CreatedDateTime],
    			    [CompanyId] = Source.[CompanyId],
    			    [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
              ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);		
END
GO