CREATE PROCEDURE [dbo].[Marker8]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[Status] AS Target 
	USING ( VALUES 
	     (NEWID(), 'Pending for submission' ,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL,'#04FEFE')
		,(NEWID(), 'Draft' ,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL,'#FFD966')
		,(NEWID(), 'Waiting for approval' ,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL,'#B7B7B7')
		,(NEWID(), 'Approved' ,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL,'#04FE02')
		,(NEWID(), 'Rejected' ,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL,'#F95959')
	)
	AS Source ([Id], [StatusName], [CreatedDateTime],[CreatedByUserId],[Companyid],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [StatusName] = Source.[StatusName],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] =  Source.[CreatedByUserId],
	           [Companyid] =  Source.[Companyid],
	           [InActiveDateTime] =  Source.[InActiveDateTime],
	           [UpdatedDateTime] =  Source.[UpdatedDateTime],
	           [UpdatedByUserId] =  Source.[UpdatedByUserId],
	           [StatusColour] =  Source.[StatusColour]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [StatusName], [CreatedDateTime],[CreatedByUserId],[Companyid],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]) 
	VALUES ([Id], [StatusName], [CreatedDateTime],[CreatedByUserId],[Companyid],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId],[StatusColour]);


    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
        (NEWID(), 'This app allows to manage the rate sheets', N'Ratesheet',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
        (NEWID(), 'This app allows to manage the peak hours', N'Peak hour',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
    
END
GO