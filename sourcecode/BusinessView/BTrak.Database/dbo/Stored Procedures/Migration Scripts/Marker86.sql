CREATE PROCEDURE [dbo].[Marker86]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'Week wise roster plan vs actual rate','SELECT T.Date,PlannedRate = ISNULL((SELECT	SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 )),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(@DateTo,EOMONTH(GETDATE()))))T   ',@CompanyId)
  ,(NEWID(),'Planned and actual burned  cost','SELECT ISNULL(SUM(PlannedRate),0)PlannedRate,ISNULL(SUM(ActualRate),0)ActualRate
 FROM RosterActualPlan RAP 
 WHERE CAST(PlanDate AS date) >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))
    AND CAST(PlanDate AS date)<= ISNULL(@DateTo,EOMONTH(GETDATE()))
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')',@CompanyId)           	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

UPDATE CustomAppDetails SET XCoOrdinate ='Date',YCoOrdinate ='PlannedRate'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId= @CompanyId AND CustomWidgetName = 'Week wise roster plan vs actual rate')

DELETE CustomAppDetails WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId
	 AND CustomWidgetName = 'Planned and actual burned  cost')

  MERGE INTO [dbo].[CustomAppDetails] AS Target 
  USING ( VALUES 
   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned and actual burned  cost'),'1','Planned and actual burned  cost','column',NULL,NULL,'','PlannedRate,ActualRate',GETDATE(),@UserId)
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
  WHEN NOT MATCHED BY TARGET AND Source.CustomApplicationId IS NOT NULL THEN 
  INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);
	
END