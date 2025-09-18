CREATE PROCEDURE [dbo].[Marker335]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    INSERT INTO RoleFeature(Id,RoleId,FeatureId,CreatedByUserId,CreatedDateTime)
    VALUES (NEWID(),@Roleid,'C521DB70-B7C1-4751-B41A-CD6C5108E366',@UserId,GETUTCDATE())
          ,(NEWID(),@Roleid,'0AA22480-9E86-4254-82CE-64E530E6A8BB',@UserId,GETUTCDATE())
          ,(NEWID(),@Roleid,'B921C1DE-3B10-4D33-B538-578DC1D99BCC',@UserId,GETUTCDATE())
          ,(NEWID(),@Roleid,'552395B3-AEB2-41C2-A07F-89B27B1DF8B4',@UserId,GETUTCDATE())

    INSERT INTO WidgetRoleConfiguration(Id,WidgetId,RoleId,CreatedDateTime,CreatedByUserId)
    VALUES (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Time sheet submission status'),@RoleId,GETDATE(),@UserId)
          ,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Probation configurations'),@RoleId,GETDATE(),@UserId)

    INSERT INTO CustomTags(Id,ReferenceId,TagId,CreatedByUserId,CreatedDateTime)
    VALUES (NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Time sheet submission status'),(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR'),@UserId,GETUTCDATE())
          ,(NEWID(),(SELECT Id FROM Widget WHERE CompanyId = @CompanyId AND WidgetName = 'Probation configurations'),(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'HR'),@UserId,GETUTCDATE())

    UPDATE [Widget] SET [Description] = 'This app is used to configure the color of timesheet submission status. These colors are used to identify the status easily, so that we can see those configured colors in timesheet, timesheet submission apps'
                    WHERE WidgetName = 'Time sheet submission status' AND CompanyId = @CompanyId
END