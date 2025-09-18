CREATE PROCEDURE [dbo].[Marker18]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
	@RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
		(NEWID(), N'This app is used to manage Badges',N'Badges', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app is used to display the badges earned by employee. By using this app we can also award badges to a employee or to a list of employees',N'Badges earned',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	   ,(NEWID(), N'This app is to check the announcement passed to an employee. By using this app we can also pass an announcement to an employee or a branch or to whole company',N'Announcements',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	  )
	AS Source ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
			   [Description] = Source.[Description],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CompanyId] =  Source.[CompanyId],
	           [UpdatedDateTime] =  Source.[UpdatedDateTime],
	           [UpdatedByUserId] =  Source.[UpdatedByUserId],
	           [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	VALUES ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);
	
END
GO
