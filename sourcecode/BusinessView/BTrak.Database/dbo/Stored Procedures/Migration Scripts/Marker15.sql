CREATE PROCEDURE [dbo].[Marker15]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
    (NEWID(),N'This app provides the list of all expenses and the details related to each single expense in the list.User can also search and sort the details of the expense and the deatils are persisted. ', N'All Expenses', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	(NEWID(),N'This app provides the list of expenses created by current user and the details related to each single expense in the list.User can also search and sort the details of the expense and the deatils are persisted. ', N'My Expenses', CAST(N'2020-02-26 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

END
GO