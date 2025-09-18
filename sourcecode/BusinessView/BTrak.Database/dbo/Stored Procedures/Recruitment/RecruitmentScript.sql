CREATE PROCEDURE [dbo].[RecruitmentScript]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
BEGIN TRY

---Master script----
--MERGE INTO [dbo].[Module] AS Target 
--        USING ( VALUES 
--		(N'5A31FC4E-BA93-4BED-B914-E44A5176C673',0, N'Recruitment management', GETDATE(), @DefaultUserId, NULL, NULL)
--) 
--        AS Source ([Id], [IsSystemModule] ,[ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) 
--        ON Target.Id = Source.Id  
--        WHEN MATCHED THEN 
--        UPDATE SET [ModuleName] = Source.[ModuleName],
--        		   [IsSystemModule] = Source.[IsSystemModule],
--        	       [CreatedDateTime] = Source.[CreatedDateTime],
--        		   [CreatedByUserId] = Source.[CreatedByUserId],
--        		   [UpdatedDateTime] = Source.[UpdatedDateTime],
--        		   [UpdatedByUserId] = Source.[UpdatedByUserId]
--        WHEN NOT MATCHED BY TARGET THEN 
--        INSERT ([Id],[IsSystemModule], [ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES ([Id], [IsSystemModule],[ModuleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);   

---Marker script----

--MERGE INTO [dbo].[Widget] AS Target 
--	USING ( VALUES
--	(NEWID(),N'By using this app user can see all the  Job opening status for the site,can add Job opening status and edit the Job opening status.Also users can view the archived Job opening status and can search and sort the Job opening status from the list.', N'Job opening status', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	,(NEWID(),N'By using this app user can see all the  Hiring status for the site,can add Hiring status and edit the Hiring status.Also users can view the archived Hiring status and can search and sort the Hiring status from the list.', N'Hiring status', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	,(NEWID(),N'By using this app user can see all the  Sources for the site,can add Sources and edit the Sources.Also users can view the archived Sources and can search and sort the Sources from the list.', N'Sources', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	,(NEWID(),N'By using this app user can see all the  Interview types for the site,can add Interview types and edit the Interview types.Also users can view the archived Interview types and can search and sort the Interview types from the list.', N'Interview types', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	,(NEWID(),N'By using this app user can see all the  Interview ratings for the site,can add Interview ratings and edit the Interview ratings.Also users can view the archived Interview ratings and can search and sort the Interview ratings from the list.', N'Interview ratings', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	,(NEWID(),N'By using this app user can see all the  Document type for the site,can add Document type and edit the Document type.Also users can view the archived Document type and can search and sort the Document type from the list.', N'Document type', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
--	)
--	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
--	ON Target.Id = Source.Id 
--	WHEN MATCHED THEN 
--	UPDATE SET [WidgetName] = Source.[WidgetName],
--		       [CreatedDateTime] = Source.[CreatedDateTime],
--			   [CreatedByUserId] = Source.[CreatedByUserId],
--			   [CompanyId] =  Source.[CompanyId],
--			   [Description] =  Source.[Description],
--			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
--			   [UpdatedByUserId] =  Source.[UpdatedByUserId],
--			   [InActiveDateTime] =  Source.[InActiveDateTime]
--	WHEN NOT MATCHED BY TARGET THEN 
--	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
--	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

--MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
--	USING (VALUES 
--	(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Job opening status' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Hiring status' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Sources' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Interview types' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Interview ratings' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Document type' AND CompanyId = @CompanyId),'5A31FC4E-BA93-4BED-B914-E44A5176C673',@UserId,GETDATE())
--	)
--	AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
--WHEN MATCHED THEN 
--UPDATE SET
--		   [WidgetId] = Source.[WidgetId],
--		   [ModuleId] = Source.[ModuleId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
--INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);	


MERGE INTO [dbo].[JobOpeningStatus] AS Target 
USING (VALUES 
(NEWID(),'Open','1',@CompanyId, @UserId,GETDATE())
,(NEWID(),'In Progress','2',@CompanyId, @UserId,GETDATE())
,(NEWID(),'On Hold','3',@CompanyId, @UserId,GETDATE())
,(NEWID(),'Filled','4',@CompanyId, @UserId,GETDATE())
,(NEWID(),'Cancelled','5',@CompanyId, @UserId,GETDATE())
)
AS Source ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Status] = Source.[Status] 
WHEN MATCHED THEN 
UPDATE SET
		   [Id] = Source.[Id],
		   [Status] = Source.[Status],
		   [Order] = Source.[Order],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Status], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

MERGE INTO [dbo].[HiringStatus] AS Target 
	USING (VALUES 
	(NEWID(),'New','#33BBFF','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Waiting-for-Evaluation','#FFC733','2',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Contact in Future','#33FFFF','3',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Junk candidate','#FF6833','4',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Contacted','#FFFF33','5',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Not Contacted','#FF3380','6',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Attempted to Contact','#33FFC4','7',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Submitted-to-recruiter','#36E801','8',@CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Status] = Source.[Status] 
WHEN MATCHED THEN 
UPDATE SET
		   [Id] = Source.[Id],
		   [Status] = Source.[Status],
		   [Color] = Source.[Color],
		   [Order] = Source.[Order],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Status], [Color], [Order], [CompanyId], [CreatedByUserId],[CreatedDateTime]);

MERGE INTO [dbo].[Source] AS Target 
	USING (VALUES 
	(NEWID(),'Added by User','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Career Site','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Employee Referral','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'External Referral','1',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Facebook','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Twitter','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Search Engine','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Naukari','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Linked In','0',@CompanyId, @UserId,GETDATE())
	,(NEWID(),'Walk In','0',@CompanyId, @UserId,GETDATE())
	)
	AS Source ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime])
ON Target.[Name] = Source.[Name] 
WHEN MATCHED THEN 
UPDATE SET
		   [Id] = Source.[Id],
		   [Name] = Source.[Name],
		   [IsReferenceNumberNeeded] = Source.[IsReferenceNumberNeeded],
		   [CompanyId] = Source.[CompanyId],
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
VALUES ([Id], [Name], [IsReferenceNumberNeeded], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewType] AS Target 
--	USING (VALUES 
--	(NEWID(),'Basic','#01D3E8',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Group Discussion','#FCC819',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Technical','#F5FC19',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Final-HR','#19FC1C',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[InterviewTypeName] = Source.[InterviewTypeName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [Id] = Source.[Id],
--		   [InterviewTypeName] = Source.[InterviewTypeName],
--		   [Color] = Source.[Color],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [InterviewTypeName], [Color], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewRating] AS Target 
--	USING (VALUES 
--	(NEWID(),'Average','50',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Good','75',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Excellent','100',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Not Eligible','35',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[InterviewRatingName] = Source.[InterviewRatingName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [Id] = Source.[Id],
--		   [InterviewRatingName] = Source.[InterviewRatingName],
--		   [Value] = Source.[Value],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [InterviewRatingName], [Value], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	


--MERGE INTO [dbo].[DocumentType] AS Target 
--	USING (VALUES 
--	(NEWID(),'SSC',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'Intermediate',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'B.Tech',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'M.Tech',@CompanyId, @UserId,GETDATE())
--	,(NEWID(),'M.B.A',@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime])
--ON Target.[DocumentTypeName] = Source.[DocumentTypeName] 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [Id] = Source.[Id],
--		   [DocumentTypeName] = Source.[DocumentTypeName],
--		   [CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [DocumentTypeName], [CompanyId], [CreatedByUserId],[CreatedDateTime]);	

--MERGE INTO [dbo].[InterviewTypeRoleCofiguration] AS Target 
--	USING (VALUES 
--	(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='Software Engineer'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Basic'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='HR'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Group Discussion'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='Software Engineer'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Technical'),@CompanyId, @UserId,GETDATE())
--	,(NEWID(),(SELECT Id FROM [Role] WHERE CompanyId=@CompanyId AND RoleName='HR'),(SELECT Id FROM InterviewRating WHERE  CompanyId=@CompanyId AND InterviewRatingName='Final-HR'),@CompanyId, @UserId,GETDATE())
--	)
--	AS Source ([Id], [RoleId], [InterviewTypeId],
--	--[CompanyId], 
--	[CreatedByUserId],[CreatedDateTime])
--ON Target.Id = Source.Id 
--WHEN MATCHED THEN 
--UPDATE SET
--		   [Id] = Source.[Id],
--		   [RoleId] = Source.[RoleId],
--		   [InterviewTypeId] = Source.[InterviewTypeId],
--		   --[CompanyId] = Source.[CompanyId],
--		   [CreatedDateTime] = Source.[CreatedDateTime],
--		   [CreatedByUserId] = Source.[CreatedByUserId]
--WHEN NOT MATCHED BY TARGET THEN 
--INSERT ([Id], [RoleId], [InterviewTypeId], 
----[CompanyId],
--[CreatedByUserId],[CreatedDateTime]) 
--VALUES ([Id], [RoleId], [InterviewTypeId], 
----[CompanyId], 
--[CreatedByUserId],[CreatedDateTime]);	

--ALTER TABLE InterviewType
--ADD IsVideoCalling BIT NULL;
--ALTER TABLE InterviewType
--ADD IsPhoneCalling BIT NULL;

END TRY  
BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

END CATCH
END
GO