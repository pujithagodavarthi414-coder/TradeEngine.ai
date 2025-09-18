CREATE PROCEDURE [dbo].[Marker265]
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
	(NEWID(), N'My web usage', N'This app displays the information of a user how much time spend on each website. It will display data in hours format',
		N'SELECT TOP(1000) * FROM (SELECT UA.UserId,ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
      ( DATEPART(MI, SpentTime) * 60000 )
      + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime))/ 3600000.0,3) AS SpentInHours
      ,UA.AbsoluteAppName AS AppUrlName
	  FROM UserActivityTime UA
	      LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId
	  WHERE UserId = ''@OperationsPerformedBy''
	    AND IsApp = 0
	    AND UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'') AND UA.InActiveDateTime IS NULL
	  GROUP BY UA.UserId,UA.AbsoluteAppName) T ORDER BY SpentInHours DESC', @CompanyId, @UserId, CAST(N'2020-12-14T06:25:06.300' AS DateTime))

	,(NEWID(), N'My app usage', N'This app displays the information of a user how much time spend on each application. It will display data in hours format',
	N'SELECT TOP(1000) * FROM (SELECT UA.UserId,ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
      ( DATEPART(MI, SpentTime) * 60000 )
      + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime))/ 3600000.0,3) AS SpentInHours
      ,UA.AbsoluteAppName AS AppUrlName
	FROM UserActivityTime UA
	    LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId
	WHERE UserId = ''@OperationsPerformedBy''
	  AND IsApp = 1
	  AND UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'') AND UA.InActiveDateTime IS NULL
	GROUP BY UA.UserId,UA.AbsoluteAppName) T ORDER BY SpentInHours DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

	,(NEWID(), N'Team app usage', N'This app displays the information of team members how much time spend on each application based on permission.  If permission exists it will display app usage of all employees else reporting members only',
	N'SELECT TOP(1000)* FROM (SELECT ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
      ( DATEPART(MI, SpentTime) * 60000 )
      + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)) / 3600000.0,3) AS SpentInHours
      ,UA.AbsoluteAppName AS AppUrlName
		FROM UserActivityTime UA
		    INNER JOIN [User] U ON U.Id = UA.UserId AND U.InActiveDateTime IS NULL
		    LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId
		WHERE IsApp = 1
		AND U.CompanyId = ''@CompanyId''
		  AND UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'')
		  AND UA.InActiveDateTime IS NULL
		  AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
		          AND UR.InactiveDateTime IS NULL
		          AND RF.InactiveDateTime IS NULL
		           WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
		     OR
		UA.UserId IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
		)
		AND UA.AbsoluteAppName <> ''''
		GROUP BY UA.AbsoluteAppName) T ORDER BY SpentInHours DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

	,(NEWID(), N'Team web usage', N'This app displays the information of team members how much time spend on each website based on permission.  If permission exists it will display app usage of all employees else reporting members only',
	N'SELECT TOP(1000) * FROM (SELECT ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
      ( DATEPART(MI, SpentTime) * 60000 )
      + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime)) / 3600000.0 ,3) AS SpentInHours
      ,UA.AbsoluteAppName AS AppUrlName
		FROM UserActivityTime UA
		    INNER JOIN [User] U ON U.Id = UA.UserId AND U.InActiveDateTime IS NULL
		    LEFT JOIN ActivityTrackerApplicationUrl A ON A.Id = UA.ApplicationId
		WHERE IsApp = 0
		AND U.CompanyId = ''@CompanyId''
		  AND UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'')
		  AND UA.InActiveDateTime IS NULL
		  AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
		          AND UR.InactiveDateTime IS NULL
		          AND RF.InactiveDateTime IS NULL
		           WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
		     OR
		UA.UserId IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
		)
		GROUP BY UA.AbsoluteAppName) T ORDER BY SpentInHours DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Team members productivity rating', N'This app displays the information of team members productivity based on permission.  If permission exists it will display app usage of all employees else reporting members only',
			N'SELECT TOP(1000)* FROM (SELECT U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name],U.Id AS UserId,Productivity
			FROM [User] U
			LEFT JOIN (
			SELECT UA.UserId,
			  SUM(ProductivityIndex) AS Productivity
			FROM [ProductivityIndex] UA
			    --INNER JOIN [User] U ON U.Id = UA.UserId AND U.InActiveDateTime IS NULL
			WHERE UA.CompanyId = ''@CompanyId''
			 AND [Date] >= DATEADD(DAY,1,EOMONTH(DATEADD(MONTH,-1,''@CurrentDateTime'')))
			 AND [Date] <= CONVERT(DATE,''@CurrentDateTime'')
			GROUP BY UA.UserId
			) T ON U.Id = T.UserId
			WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL
			AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			          AND UR.InactiveDateTime IS NULL
			          AND RF.InactiveDateTime IS NULL
			           WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
			     OR
			U.Id IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
			)) T ORDER BY Productivity DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))


			,(NEWID(), N'Team members productive hours rating', N'This app displays the information of team members productive hours based on permission.  If permission exists it will display app usage of all employees else reporting members only',
			N'SELECT TOP(1000)* FROM (SELECT U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name],U.Id AS UserId,Productivity
			FROM [User] U
			LEFT JOIN (
			SELECT UA.UserId,
			  ROUND(SUM(( DATEPART(HH, SpentTime) * 3600000 ) +
			 ( DATEPART(MI, SpentTime) * 60000 )
			 + DATEPART(SS, SpentTime)*1000  + DATEPART(MS, SpentTime))/ 3600000.0,3) AS Productivity
			FROM UserActivityTime UA
			    INNER JOIN [User] U ON U.Id = UA.UserId AND U.InActiveDateTime IS NULL
			AND U.CompanyId = ''@CompanyId''
			    INNER JOIN ApplicationType A ON A.Id = UA.ApplicationTypeId
			WHERE UA.CreatedDateTime = CONVERT(DATE,''@CurrentDateTime'')
			 AND UA.InActiveDateTime IS NULL
			 AND A.ApplicationTypeName = ''Productive''
			GROUP BY UA.UserId
			) T ON U.Id = T.UserId
			WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL
			AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
			          AND UR.InactiveDateTime IS NULL
			          AND RF.InactiveDateTime IS NULL
			           WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
			     OR
			U.Id IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
			)) T ORDER BY Productivity DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

			,(NEWID(), N'Team members hours rating', N'This app displays the information that how much time users spent based on permission.  If permission exists it will display app usage of all employees else reporting members only',
			N'SELECT TOP(1000)* FROM (SELECT  U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name],U.Id AS UserId,ROUND((T.SpentTime - ISNULL(B.Breaks,0)) / 60.0,3) AS SpentTime
				FROM [User] U
				LEFT JOIN (
				SELECT DATEDIFF(MINUTE,SWITCHOFFSET(TS.Intime, ''+00:00''),ISNULL(SWITCHOFFSET(TS.OutTime, ''+00:00''),GETUTCDATE()))
				      - ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'')
				                           ,ISNULL(SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00''),GETUTCDATE())),0) AS SpentTime
				,TS.UserId
				FROM TimeSheet TS
				INNER JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
				AND U.CompanyId = ''@CompanyId''
				WHERE [Date] = CONVERT(DATE,''@CurrentDateTime'')
				) T ON T.UserId = U.Id
				LEFT JOIN (
				SELECT UB.UserId,SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00''),ISNULL(SWITCHOFFSET(UB.BreakOut, ''+00:00''),GETUTCDATE()))) AS Breaks
				FROM UserBreak UB
				INNER JOIN [User] U ON U.Id = UB.UserId AND U.InActiveDateTime IS NULL
				AND U.CompanyId = ''@CompanyId''
				WHERE [Date] = CONVERT(DATE,''@CurrentDateTime'')
				GROUP BY UB.UserId
				) B ON B.UserId = U.Id
				WHERE U.CompanyId = ''@CompanyId''
				AND U.InActiveDateTime IS NULL
				AND ((SELECT COUNT(1) FROM UserRole UR INNER JOIN RoleFeature RF ON RF.RoleId = UR.RoleId
				          AND UR.InactiveDateTime IS NULL
				          AND RF.InactiveDateTime IS NULL
				           WHERE UR.UserId = ''@OperationsPerformedBy'' AND RF.FeatureId = ''AE34EE14-7BEB-4ECB-BCE8-5F6588DF57E5'') > 0
				     OR
				U.Id IN (SELECT ChildId FROM dbo.Ufn_GetEmployeeReportedMembers(''@OperationsPerformedBy'',''@CompanyId''))
				)) T ORDER BY SpentTime DESC', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
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
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'My web usage'),'1','My web usage_donut','donut',NULL,'','AppUrlName','SpentInHours',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'My app usage'),'1','My app usage_donut','donut',NULL,'','AppUrlName','SpentInHours',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team app usage'),'1','Team app usage_donut','donut',NULL,'','AppUrlName','SpentInHours',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team web usage'),'1','Team web usage_donut','donut',NULL,'','AppUrlName','SpentInHours',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team members productivity rating'),'1','Team members productivity rating_bar','bar',NULL,'','Name','Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team members productive hours rating'),'1','Team members productive hours rating_bar','bar',NULL,'','Name','Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team members hours rating'),'1','Team members productive hours rating_bar','bar',NULL,'','Name','SpentTime',GETDATE(),@UserId)
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
	  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='My web usage' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='My app usage' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team app usage' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team web usage' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team members productivity rating' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team members productive hours rating' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team members hours rating' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
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
END
GO
