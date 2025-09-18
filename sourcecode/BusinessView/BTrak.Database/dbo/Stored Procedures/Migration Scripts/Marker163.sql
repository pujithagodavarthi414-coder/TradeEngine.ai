CREATE PROCEDURE [dbo].[Marker163]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'38CED01C-DB50-4999-ABC3-EAE960DD51DB', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
		  ,(NEWID(), @RoleId, N'2B447F3A-8022-43A7-B145-731D5F6678F6', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
)
AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
ON Target.Id = Source.Id  
WHEN MATCHED THEN 
UPDATE SET [RoleId] = Source.[RoleId],
           [FeatureId] = Source.[FeatureId],
	       [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

UPDATE CompanyModule SET IsEnabled = 1 WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND IsActive = 1

            INSERT INTO CompanyModule([Id],[CompanyId],[ModuleId],[IsActive],[IsEnabled],[CreatedDateTime],[CreatedByUserId])
            SELECT NEWID(),@CompanyId,M.Id,0,0,GETDATE(),@UserId FROM Module M WHERE M.InactiveDateTime IS NULL
		    AND Id NOT IN (SELECT ModuleId FROM CompanyModule WHERE InActiveDateTime IS NULL AND CompanyId = @CompanyId)

	    DECLARE @NewRoleId UNIQUEIDENTIFIER = NEWID()                     
		DECLARE @NewUserId UNIQUEIDENTIFIER = NEWID() 
		DECLARE @NewCompanyId UNIQUEIDENTIFIER= @CompanyId
		DECLARE @DefaultUserId UNIQUEIDENTIFIER = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')
        
		IF(NOT EXISTS (SELECT U.Id FROM [User]U INNER JOIN  UserRole UR  ON U.Id = UR.UserId  AND U.CompanyId = @CompanyId
		                                            INNER JOIN [Role] R ON R.Id = UR.RoleId AND ISNULL(R.IsHidden,0) = 1 AND R.CompanyId = @CompanyId))
		BEGIN

		DECLARE @CompanyName NVARCHAR(500) = (SELECT CompanyName FROM Company WHERE Id = @CompanyId)

   INSERT INTO [Role](Id,RoleName,CompanyId,CreatedByUserId,CreatedDateTime,IsHidden)
             SELECT @NewRoleId,'Support',@NewCompanyId,@DefaultUserId,GETDATE(),1
             
             INSERT INTO [User]([Id],CompanyId,[SurName],[FirstName],[UserName],[Password],[IsActive],[TimeZoneId],[MobileNo],[IsActiveOnMobile],[RegisteredDateTime],[CreatedDateTime],InActiveDateTime,[CreatedByUserId])
                         SELECT @NewUserId,@NewCompanyId,'Support','Snovasys',cast(LEFT(NEWID(),10) as nvarchar(100))+'@'+ cast(ABS(CAST(CAST(NEWID() AS VARBINARY) AS INT)) as nvarchar(max))+'.com','h+gnivgGtsN/T8UPfcCD3lf5SLgEKAjxlSpZg5ZrgBgbiNIN',1,NULL,'20158633','20158633',GETDATE(),GETDATE(),GETDATE(),@DefaultUserId
                                   
             INSERT INTO UserRole(Id,UserId,RoleId,CreatedByUserId,CreatedDateTime)
             SELECT NEWID(),@NewUserId,@NewRoleId,@DefaultUserId,GETDATE()
             
             DECLARE @NewEmployeeId UNIQUEIDENTIFIER = NEWID()
             
             DECLARE @NewUserActiveDetailsId UNIQUEIDENTIFIER = NEWID()
             
             INSERT INTO UserActiveDetails(Id,UserId,ActiveFrom,ActiveTo,CreatedDateTime,CreatedByUserId)
             SELECT @NewUserActiveDetailsId,@NewUserId,GETDATE(),NULL,GETDATE(),@DefaultUserId
             
             INSERT INTO Employee([Id],[UserId],[EmployeeNumber],[CreatedDateTime],[CreatedByUserId])
             SELECT NEWID(),@NewUserId,'EM ' + CAST((SELECT COUNT(1) + 1 FROM Employee) AS NVARCHAR(100)),GETDATE(),@DefaultUserId
             
             	INSERT INTO [RoleFeature]([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
             	SELECT NEWID(),@NewRoleId,F.Id,GETDATE(),@NewUserId FROM Feature F WHERE F.InActiveDateTime IS NULL
             	      AND F.Id IN (SELECT FeatureId FROM FeatureModule FM INNER JOIN CompanyModule CM ON CM.ModuleId = FM.ModuleId AND CM.CompanyId = @NewCompanyId)
   
        END

DELETE DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE CustomWidgetId = 
(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Feedback type') AND ISNULL(IsCustomWidget,0) = 0 )

DELETE WorkspaceDashboards WHERE CustomWidgetId = 
(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Feedback type') AND ISNULL(IsCustomWidget,0) = 0 

DELETE FROM WidgetModuleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Feedback type')

DELETE FROM WidgetRoleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Feedback type')

DELETE FROM Widget  WHERE CompanyId = @CompanyId AND WidgetName = 'Feedback type'

DELETE DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE CustomWidgetId = 
(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'App settings') AND ISNULL(IsCustomWidget,0) = 0 )

DELETE WorkspaceDashboards WHERE CustomWidgetId = 
(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'App settings') AND ISNULL(IsCustomWidget,0) = 0 

DELETE FROM WidgetModuleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'App settings')

DELETE FROM WidgetRoleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'App settings')

DELETE FROM Widget  WHERE CompanyId = @CompanyId AND WidgetName = 'App settings'

END
GO