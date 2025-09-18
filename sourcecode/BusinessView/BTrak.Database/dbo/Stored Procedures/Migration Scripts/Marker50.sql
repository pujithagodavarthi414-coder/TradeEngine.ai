CREATE PROCEDURE [dbo].[Marker50]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	
	UPDATE PayrollComponent SET IsVisible = 0
    WHERE ComponentName IN ('Salary','Tax','Office Loan EMI')

    DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Reference type' AND CompanyId = @CompanyId)
    
    DELETE FROM Widget WHERE Widgetname = N'Reference type' AND CompanyId = @CompanyId

    DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Reference type' AND CompanyId = @CompanyId)

    DELETE FROM UserStory WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Reference type' AND CompanyId = @CompanyId)

    DELETE FROM WorkspaceDashboards WHERE [Name] = N'Reference type' AND CompanyId = @CompanyId

    DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Work item sub type' AND CompanyId = @CompanyId)
    
    DELETE FROM Widget WHERE Widgetname = N'Work item sub type' AND CompanyId = @CompanyId

    DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Work item sub type' AND CompanyId = @CompanyId)

    DELETE FROM UserStory WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Work item sub type' AND CompanyId = @CompanyId)

    DELETE FROM WorkspaceDashboards WHERE [Name] = N'Work item sub type' AND CompanyId = @CompanyId

	DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Board type api' AND CompanyId = @CompanyId)
    
    DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Board type api' AND CompanyId = @CompanyId)

    DELETE FROM UserStory WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Board type api' AND CompanyId = @CompanyId)

    DELETE FROM Widget WHERE Widgetname = N'Board type api' AND CompanyId = @CompanyId

	DELETE FROM [WorkspaceDashboards] WHERE [Name] = N'Board type api' AND CompanyId = @CompanyId

	IF EXISTS (SELECT 1 FROM [dbo].[Widget] WHERE WidgetName = 'System app' AND CompanyId = @CompanyId)
	BEGIN
	UPDATE [dbo].[Widget] SET WidgetName = N'All apps', UpdatedByUserId = @UserId, UpdatedDateTime = GETDATE() WHERE WidgetName = N'System app' AND CompanyId = @CompanyId
	END

	DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Custom app' AND CompanyId = @CompanyId)
    
    DELETE FROM Widget WHERE Widgetname = N'Custom app' AND CompanyId = @CompanyId

	DELETE FROM [dbo].[DashboardPersistance]  WHERE [DashboardId] IN (SELECT Id FROM [WorkspaceDashboards] WHERE [Name] = N'Custom app' AND CompanyId = @CompanyId)

	DELETE FROM [WorkspaceDashboards] WHERE [Name] = N'Custom app' AND CompanyId = @CompanyId


    MERGE INTO [dbo].[CustomWidgets] AS TARGET
    USING( VALUES
        (NEWID(),'Section details for all scenarios','','SELECT TSS.TestSuiteId Id,TSS.SectionName [Section name],
		   COUNT(1) [Cases count],
		   ISNULL(P0Bugs,0)[P0 bugs],
		   ISNULL(P1Bugs,0)[P1 bugs],
		   ISNULL(P2Bugs,0)[P2 bugs],
		   ISNULL(P3Bugs,0)[P3 bugs],
		   ISNULL(TotalBugs,0)[Total bugs],
		    CAST(CAST(ISNULL(ISNULL((SUM(TC.Estimate))/(60*60.0),0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT)AS VARCHAR(100))+''m'') Estimate
	         FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TSS.TestSuiteId = TS.Id AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
	                           INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
							   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
							LEFT JOIN  (SELECT COUNT(CASE WHEN BP.IsCritical = 1THEN 1 END) P0Bugs,
			                                   COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END) P1Bugs,
					                           COUNT(CASE WHEN BP.IsMedium = 1THEN 1 END)P2Bugs,
					                           COUNT(CASE WHEN BP.IsLow = 1THEN 1 END)P3Bugs,
											   COUNT(1) TotalBugs,
					                           TC.SectionId
					                           FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.TaskStatusId NOT IN (''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.IsBugBoard = 1 
				LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId AND BT1.IsBugBoard = 1 
				WHERE ((US.SprintId IS NULL AND BT1.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND BT.Id IS NOT NULL))
				GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
				GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs,TSS.TestSuiteId ',@CompanyId,@UserId,GETDATE())
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];
	
END
GO
