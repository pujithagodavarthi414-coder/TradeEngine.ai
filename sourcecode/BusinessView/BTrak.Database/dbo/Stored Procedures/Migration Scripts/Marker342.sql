CREATE PROCEDURE [dbo].[Marker342]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
        MERGE INTO [dbo].[Widget] AS Target 
        USING ( VALUES 
	         (NEWID(),N'This app is used to save the solar logs. In this application we can save date, solar log value, site, and confirm. And also we can attach files to the records',N'Solar log', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	     )
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
        VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);


        INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
        VALUES (NEWID(),@Roleid,'2C9ACE2E-2E40-4DB1-9393-13AF7FFF9380',@UserId,GETUTCDATE())

        INSERT INTO WidgetRoleConfiguration(Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
        VALUES (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Solar log'),@RoleId,GETDATE(),@UserId)

        --INSERT INTO CustomTags(Id,ReferenceId,TagId,CreatedByUserId,CreatedDateTime)
        --VALUES (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Solar log'),(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR'),@UserId,GETUTCDATE())
END