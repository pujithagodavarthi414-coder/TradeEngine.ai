CREATE PROCEDURE [dbo].[Marker84]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'Planned and actual burned  cost','SELECT ISNULL(SUM(PlannedRate),0)PlannedRate FROM RosterActualPlan RAP
           WHERE  PlanDate >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AND PlanDate  <=
		   ISNULL(@DateTo,EOMONTH(GETDATE())) AND  RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
		    AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')',@CompanyId)
,(NEWID(),'Week wise roster plan vs actual rate','SELECT T.Date,PlannedRate = ISNULL((SELECT	SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate<= T.Date)
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 ),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(@DateTo,EOMONTH(GETDATE()))))T ',@CompanyId)
                  	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

UPDATE CustomAppDetails SET XCoOrdinate ='Date',YCoOrdinate ='PlannedRate'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId= @CompanyId AND CustomWidgetName = 'Week wise roster plan vs actual rate')

END