CREATE PROCEDURE [dbo].[Marker29]
(
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
     (NEWID(),N'This app displays the time sheet submissions of an employee. The time Sheet submission will be fall based on time sheet frequency in company settings', N'Time sheet submission', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
     (NEWID(),N'This app displays the time sheet submissions of an employee. The time Sheet submission will be fall based on time sheet frequency in company settings', N'Time sheets waiting for approval', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL))
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
	
MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES (NEWID(), N'Plan vs Actual rate date wise', NULL, N'SELECT T.[Date],ISNULL(PlannedRate,0)PlannedRate,ISNULL(ActualRate,0) ActualRate FROM
(SELECT  CAST(DATEADD( day,number-1,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(day, @DateFrom, @DateTo))T 
	LEFT JOIN (SELECT CAST(PlanDate AS date) PlanDate,SUM(PlannedRate)PlannedRate,SUM(ActualRate)ActualRate
 FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND RAP.InActiveDateTime IS NULL
                                   AND E.InActiveDateTime  IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
								   INNER JOIN [USER]U ON U.Id  = E.UserId AND U.InActiveDateTime IS NULL
 WHERE CAST(PlanDate AS date) >= @DateFrom
    AND CAST(PlanDate AS date)<=  @DateTo
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
 GROUP BY CAST(PlanDate AS date))Rinner ON T.Date = Rinner.PlanDate', @CompanyId, @UserId, CAST(N'2020-04-23T07:20:38.990' AS DateTime) )
 ,(NEWID(), N'Employee wise planned vs actual rates', NULL, N'SELECT U.FirstName+ '' ''+U.SurName EmployeeName ,ISNULL(SUM(PlannedRate),0)PlannedRate,ISNULL(SUM(ActualRate),0)ActualRate
 FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND RAP.InActiveDateTime IS NULL
                                   AND E.InActiveDateTime  IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
								   INNER JOIN [USER]U ON U.Id  = E.UserId AND U.InActiveDateTime IS NULL
 WHERE CAST(PlanDate AS date) >= @DateFrom
    AND CAST(PlanDate AS date)<= @DateTo
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
 GROUP BY U.FirstName+ '' ''+U.SurName', @CompanyId, @UserId, CAST(N'2020-04-23T08:05:16.493' AS DateTime) )

  ,(NEWID(), N'Shift wise spent amount', NULL, N'
SELECT ShiftName,SUM(ISNULL(PlannedRate,0))PlannedRate,SUM(ISNULL(ActualRate,0))ActualRate FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
                                              AND RAP.InActiveDateTime IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
                                     INNER JOIN [User]U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
									 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
									 INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
							      WHERE PlanDate >= @DateFrom AND PlanDate = @DateTo
						  AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') GROUP BY ShiftName', @CompanyId, @UserId, CAST(N'2020-04-23T08:07:29.263' AS DateTime) )
 , (NEWID(), N'Week wise roster plan vs actual rate', N'', N'SELECT T.Date,PlannedRate = ISNULL((SELECT	SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate<= T.Date)
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 ),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,@DateFrom) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, @DateFrom, @DateTo))T ', @CompanyId, @UserId, CAST(N'2020-04-23T09:02:05.280' AS DateTime) )
 ,(NEWID(), N'Planned and actual burned  cost', NULL, N'SELECT	ISNULL(PlannedRate,0)PlannedRate FROM RosterActualPlan RAP
           WHERE  PlanDate >= @DateFrom AND PlanDate  <= @DateTo AND  RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
		    AND RAP.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2020-04-23T09:10:09.247' AS DateTime) )
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
 (NEWID(),  (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Plan vs Actual rate date wise' AND CompanyId = @CompanyId), 1, N'Plane vs actual rate line graph', N'line', NULL, NULL, N'[]', N'Date', N'PlannedRate,ActualRate', CAST(N'2020-04-23T07:20:38.990' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Employee wise planned vs actual rates'  AND CompanyId = @CompanyId), 1, N'Employee wise planned vs unpla', N'bar', NULL, NULL, N'[]', N'EmployeeName', N'PlannedRate,ActualRate', CAST(N'2020-04-23T08:05:16.493' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Shift wise spent amount' AND CompanyId = @CompanyId), 1, N'Shift wise spent amount', N'stackedbar', NULL, NULL, N'[]', N'ShiftName', N'PlannedRate,ActualRate', CAST(N'2020-04-23T08:07:29.263' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  N'Planned and actual burned  cost' AND CompanyId = @CompanyId) ,1, N'Planned and actual burned  cost', N'radialgauge', NULL, NULL, N'[]', N'PlannedRate',NULL, CAST(N'2020-04-23T09:10:09.247' AS DateTime), @UserId)
,(NEWID(), (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Week wise roster plan vs actual rate' AND CompanyId = @CompanyId), 1, N'WeekName ', N'bar', NULL, NULL, N'[]', N'WeekName', N'PlannedRate', CAST(N'2020-04-23T09:02:05.280' AS DateTime), @UserId)
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
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

END
GO