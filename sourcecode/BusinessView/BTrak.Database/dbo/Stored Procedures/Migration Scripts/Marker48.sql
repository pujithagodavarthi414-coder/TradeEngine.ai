CREATE PROCEDURE [dbo].[Marker48]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
    (NEWID(), N'This app allows to manage the rate tags', N'Rate tag library',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
   ,(NEWID(), N'By using this app user can manage the Pay rates of the employee. User can configure the pay rates for a particular date range with different currencies.User can also edit the pay rates.Users can search data from the rate sheet and can sort each column.',N'Employee rate tag', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

MERGE INTO [dbo].[RoleFeature] AS Target 
USING ( VALUES 
           (NEWID(), @RoleId, N'2CCA224D-9693-450A-B47B-7B1142350A07', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		   (NEWID(), @RoleId, N'12E01F5C-3064-415A-BE33-EAB6DE261F8C', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
       (NEWID(), @CompanyId, N'LoanTermsDocument','https://bviewstorage.blob.core.windows.net/96da99f6-1fda-4013-a0d2-8583d3bcc431/hrm/bc94a162-dd15-43fc-8425-255761a9ffb8/employeeloan-c7185755-cd02-4669-ab5c-76999d6fda4c.doc', N'Is add or edit custom apps', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId,1)
	   )
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsVisible] = Source.[IsVisible]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId],[IsVisible]);

END
GO
