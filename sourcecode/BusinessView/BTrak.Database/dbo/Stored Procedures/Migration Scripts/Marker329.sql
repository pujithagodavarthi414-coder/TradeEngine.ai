
CREATE PROCEDURE [dbo].[Marker329]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
     UPDATE CustomHtmlApp SET [HtmlCode]= '<div style="position: absolute; min-height: calc(100% - (45px + 24px)); height:100%;width:100%">
    <iframe src="https://meet.nxusworld.com/b/" title="Workflow debugger " style="width:100%;height:100%"  allow="camera;microphone"></iframe>
    </div>' WHERE [CustomHtmlAppName] = 'Meet'

      UPDATE [CustomWidgets] SET [WidgetQuery]= N'SELECT U.FirstName + '' '' + ISNULL(U.Surname,'' '') AS UserName,ISNULL(SUM(ProductivityIndex),0) AS ProductivityIndex FROM ProductivityIndex AS PRI
								INNER JOIN [User] U ON U.Id = PRI.UserId
								WHERE PRI.CompanyId = ''@CompanyId''
									  AND PRI.CreatedDateTime BETWEEN DATEADD(DAY,1,EOMONTH(GETDATE(),-1)) AND EOMONTH(GETDATE())
									  AND ((SELECT COUNT(1) FROM Feature AS F
												JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
												JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
												JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
												WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0 OR 
									 [UserId] IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
												 (''@OperationsPerformedBy'',''@CompanyId'') WHERE (ChildId <> ''@OperationsPerformedBy'')))
												 Group by userid, U.FirstName, U.Surname' WHERE [CustomWidgetName] = 'Team productivity' AND [CompanyId] = @CompanyId

     /*--Delete widget which is not used--*/

     DELETE FROM CustomAppDetails WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Review notifications' AND CompanyId = @CompanyId) 

	 DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Review notifications' AND CompanyId = @CompanyId)

	 DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Scripts' AND CompanyId = @CompanyId)

	 DELETE FROM CustomWidgetRoleConfiguration WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Review notifications' AND CompanyId = @CompanyId)

     DELETE FROM Widget  WHERE CompanyId = @CompanyId AND WidgetName = 'Scripts'

	 DELETE FROM Widget  WHERE CompanyId = @CompanyId AND WidgetName = 'Review notifications'

     DELETE FROM [CustomWidgets]  WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Review notifications'


END