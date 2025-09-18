CREATE PROCEDURE [dbo].[Marker78]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
    
    --N'Archive message'
    DELETE FROM [FeatureModule] WHERE FeatureId = '7e1925c3-2ed3-4295-a0e2-db47af9214e7'
    DELETE FROM RoleFeature WHERE FeatureId  = '7e1925c3-2ed3-4295-a0e2-db47af9214e7'
    DELETE FROM FeatureProcedureMapping WHERE FeatureId = '7e1925c3-2ed3-4295-a0e2-db47af9214e7'
    DELETE FROM ControllerApiFeature WHERE FeatureId = '7e1925c3-2ed3-4295-a0e2-db47af9214e7'
    DELETE FROM Feature WHERE Id = '7e1925c3-2ed3-4295-a0e2-db47af9214e7'
    --N'Chat file upload'
    DELETE FROM [FeatureModule] WHERE FeatureId = 'C7F4B971-1B74-440D-9253-FEC951CC77D1'
    DELETE FROM RoleFeature WHERE FeatureId  = 'C7F4B971-1B74-440D-9253-FEC951CC77D1'
    DELETE FROM FeatureProcedureMapping WHERE FeatureId = 'C7F4B971-1B74-440D-9253-FEC951CC77D1'
    DELETE FROM ControllerApiFeature WHERE FeatureId = 'C7F4B971-1B74-440D-9253-FEC951CC77D1'
    DELETE FROM Feature WHERE Id = 'C7F4B971-1B74-440D-9253-FEC951CC77D1'
    --N'Direct messaging'
    DELETE FROM [FeatureModule] WHERE FeatureId = '6197E40B-427B-475B-96B1-306CDF2E5E38'
    DELETE FROM RoleFeature WHERE FeatureId  = '6197E40B-427B-475B-96B1-306CDF2E5E38'
    DELETE FROM FeatureProcedureMapping WHERE FeatureId = '6197E40B-427B-475B-96B1-306CDF2E5E38'
    DELETE FROM ControllerApiFeature WHERE FeatureId = '6197E40B-427B-475B-96B1-306CDF2E5E38'
    DELETE FROM Feature WHERE Id = '6197E40B-427B-475B-96B1-306CDF2E5E38'
    --N'Edit message'
    DELETE FROM [FeatureModule] WHERE FeatureId = 'ede27321-9f6c-4491-a96f-23aefed646ee'
    DELETE FROM RoleFeature WHERE FeatureId  = 'ede27321-9f6c-4491-a96f-23aefed646ee'
    DELETE FROM FeatureProcedureMapping WHERE FeatureId = 'ede27321-9f6c-4491-a96f-23aefed646ee'
    DELETE FROM ControllerApiFeature WHERE FeatureId = 'ede27321-9f6c-4491-a96f-23aefed646ee'
    DELETE FROM Feature WHERE Id = 'ede27321-9f6c-4491-a96f-23aefed646ee'

    --Ratesheet Widget delete script
    DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Ratesheet' AND CompanyId = @CompanyId)
    DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Ratesheet' AND CompanyId = @CompanyId)
    DELETE FROM UserStory WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Ratesheet' AND CompanyId = @CompanyId)
    DELETE FROM Widget WHERE Widgetname = N'Ratesheet' AND CompanyId = @CompanyId
	DELETE FROM [WorkspaceDashboards] WHERE [Name] = N'Ratesheet' AND CompanyId = @CompanyId
	DELETE FROM FavouriteWidgets WHERE WidgetId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Ratesheet' AND CompanyId = @CompanyId)
	DELETE FROM WidgetModuleConfiguration WHERE WidgetId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Ratesheet' AND CompanyId = @CompanyId)

     --Employee rate sheet Widget delete script
    DELETE FROM WidgetRoleConfiguration WHERE WidgetId IN (SELECT Id FROM Widget WHERE WidgetName = N'Employee rate sheet' AND CompanyId = @CompanyId)
    DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Employee rate sheet' AND CompanyId = @CompanyId)
    DELETE FROM UserStory WHERE WorkspaceDashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Employee rate sheet' AND CompanyId = @CompanyId)
    DELETE FROM Widget WHERE Widgetname = N'Employee rate sheet' AND CompanyId = @CompanyId
	DELETE FROM [WorkspaceDashboards] WHERE [Name] = N'Employee rate sheet' AND CompanyId = @CompanyId
	DELETE FROM FavouriteWidgets WHERE WidgetId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Employee rate sheet' AND CompanyId = @CompanyId)
	DELETE FROM WidgetModuleConfiguration WHERE WidgetId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = N'Employee rate sheet' AND CompanyId = @CompanyId)

END
GO