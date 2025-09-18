CREATE PROCEDURE [dbo].[Marker36]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES
		(NEWID(), 'This app provides the list of all training courses and the details related to each single course in the list. User can also search and sort the details of the training courses and the deatils are persisted. ', N'Training courses',CAST(N'2020-05-29 00:00:00.000' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
		(NEWID(), 'This app helps user to assign or unassign courses to employees ', N'Training Assignments',CAST(N'2020-06-02 00:00:00.000' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
		(NEWID(), 'This app helps user to view training matrix of courses assigned to users along with status of the assignemnts and also user can assign, un-assign and update status', N'Training matrix',CAST(N'2020-06-09 00:00:00.000' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
		(NEWID(), 'This app helps user to view training record of user', N'Training record',CAST(N'2020-06-19 00:00:00.000' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[CompanyId] = Source.[CompanyId] AND Target.[CreatedDateTime] = Source.[CreatedDateTime]
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
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;
	

	MERGE INTO [dbo].[AssignmentStatus] AS Target
	USING ( VALUES     
			(NEWID(), N'Due', N'Assigned but no status given', N'#FFA500', @CompanyId, 0, N'info-circle', 0, 1, 0),
			(NEWID(), N'Completed', N'training is completed', N'#008000', @CompanyId, 1, N'check', 1, 0, 0),
			(NEWID(), N'Expired', N'training assignment validity expired', N'#FF0000', @CompanyId, 0, N'times', 0, 0, 1),
			(NEWID(), N'Not completed', N'training is not completed', N'#FF0000', @CompanyId, 1, N'times', 0, 0, 0)
	)
	AS Source ([Id], [StatusName], [StatusDescription], [StatusColor], [CompanyId], [IsSelectable], [Icon], [AddsValidity], [IsDefaultStatus], [IsExpiryStatus]) 
	ON Target.[CompanyId] = Source.[CompanyId] AND Target.[StatusName] = Source.[StatusName]
	WHEN MATCHED THEN
	UPDATE SET
				[StatusName] = Source.[StatusName],
				[StatusDescription] = Source.[StatusDescription],
				[StatusColor] =  Source.[StatusColor],
				[CompanyId] =  Source.[CompanyId],
				[IsSelectable] = Source.[IsSelectable],
				[Icon] = Source.[Icon],
				[AddsValidity] = Source.[AddsValidity],
				[IsDefaultStatus] = Source.[IsDefaultStatus],
				[IsExpiryStatus] = Source.[IsExpiryStatus]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [StatusName], [StatusDescription], [StatusColor], [CompanyId], [IsSelectable], [Icon], [AddsValidity], [IsDefaultStatus] ,[IsExpiryStatus]) 
	VALUES ([Id], [StatusName], [StatusDescription], [StatusColor], [CompanyId], [IsSelectable], [Icon], [AddsValidity], [IsDefaultStatus], [IsExpiryStatus]);

END