CREATE PROCEDURE [dbo].[Marker188]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON


  MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
USING ( VALUES 
 (NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,48,50,5,5,5,'Configure employee bonus',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId,23)
,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,25,25,7,5,5,'Employee tax allowance details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId,24)
,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,85,31,6,5,5,'Employee payroll details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId,25)
,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,53,50,6,5,5,'Employee rate tag',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId,26)	
)
AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId],[Order])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
			   [X] = Source.[X],	
			   [Y] = Source.[Y],	
			   [Col] = Source.[Col],	
			   [Row] = Source.[Row],	
			   [MinItemCols] = Source.[MinItemCols],	
			   [MinItemRows] = Source.[MinItemRows],	
			   [Name] = Source.[Name],	
			   [Component] = Source.[Component],	
			   [CustomWidgetId] = Source.[CustomWidgetId],	
			   [IsCustomWidget] = Source.[IsCustomWidget],	
			   [UpdatedDateTime] = Source.[UpdatedDateTime],	
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [InActiveDateTime] = Source.[InActiveDateTime],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CompanyId] = Source.[CompanyId],
			   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId],[Order]) VALUES
([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId],[Order]);	
	
		
END
GO