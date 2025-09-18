CREATE PROCEDURE [dbo].[Marker168]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
USING ( VALUES 
 ((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee shift details','7')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Comments app','22')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee personal details','1')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee salary details','19')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee education details','9')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee rate sheet','12')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee identification details','4')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee membership details','11')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Custom fields','21')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee badges earned','16')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee skill details','8')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee work experience details','5')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee bank details','17')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee dependent details','13')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee resignation details','20')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee account details','18')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee report to','15')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee language details','6')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee immigration details','14')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee contact details','2')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee job details','10')
,((SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_profileDashboard' AND CompanyId = @CompanyId),@CompanyId,'Employee emergency contact details','3')
)
AS Source  ([WorkspaceId],[CompanyId],[Name],[Order])
ON Target.WorkspaceId = Source.WorkspaceId AND Target.CompanyId = Source.CompanyId AND Target.[Name] = Source.[Name]
WHEN MATCHED THEN
UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
		   [Name] = Source.[Name],	
		   [CompanyId] = Source.[CompanyId],
		   [Order] = Source.[Order];
		 
END
GO
