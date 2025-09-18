CREATE PROCEDURE [dbo].[Marker282]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

UPDATE CustomWidgets SET WidgetQuery = 'SELECT Id,[Goal name],[Goal responsible person] FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
) from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')
		   AND (''@UserId'' = '''' OR G.GoalResponsibleUserId = ''@UserId'')
            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))T WHERE T.DeadLineDate < GETDATE()'
	WHERE CustomWidgetName = 'Red goals list' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT TRR.[Name]  [Report name], U.FirstName+'' ''+U.SurName [Created by],
 FORMAT(TRR.CreatedDateTime,''dd MMM yyyy'') [Created on],
 TRR.PdfUrl
   FROM TestRailReport TRR INNER JOIN [User]U ON TRR.CreatedByUserId = U.Id AND TRR.InActiveDateTime IS NULL AND (''@UserId'' = '''' OR TRR.CreatedByUserId = ''@UserId'')
	          INNER JOIN Project P ON P.Id =  TRR.ProjectId AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	 WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')'
	WHERE CustomWidgetName = 'Reports details' AND CompanyId = @CompanyId
    
  UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(T.Date,''dd MMM yyyy'') AS Date,PlannedRate = ISNULL((SELECT  SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date
	 AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = ''@CompanyId''
	 )),0) 
	 ,ActualRate = ISNULL((SELECT  SUM(ISNULL(ActualRate,0))ActualRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date
	 AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = ''@CompanyId''
	 )),0)
	 FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))T'
	WHERE CustomWidgetName = 'Week wise roster plan vs actual rate' AND CompanyId = @CompanyId
                    
	UPDATE CustomAppDetails SET YCoOrdinate = 'PlannedRate,ActualRate' WHERE CustomApplicationId = 
	(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Week wise roster plan vs actual rate' AND CompanyId = @CompanyId)

END
GO