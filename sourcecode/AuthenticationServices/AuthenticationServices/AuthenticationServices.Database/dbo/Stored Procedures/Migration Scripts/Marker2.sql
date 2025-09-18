CREATE PROCEDURE [dbo].[Marker2]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
    
    DECLARE @RoleIds NVARCHAR(MAX)

	IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71')
	BEGIN
		SELECT @RoleIds = COALESCE(@RoleIds + ',','') + CONVERT(NVARCHAR(40),Id)
		FROM Role WHERE RoleName IN ('Super Admin')
	END
	ELSE
	BEGIN
		SELECT @RoleIds = COALESCE(@RoleIds + ',','') + CONVERT(NVARCHAR(40),Id)
		FROM Role WHERE RoleName IN ('Software Trainee','Analyst Developer','Goal Responsible Person','Senior Software Engineer','Lead Developer','Software Engineer')
	END

	DECLARE @Val CHAR(1) = IIF((SELECT IndustryId FROM Company WHERE Id = @CompanyId) = (SELECT Id FROM Industry WHERE IndustryName LIKE '%Remote Working%') , 1, 0)

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
			 (NEWID(), @CompanyId, N'IsLoggingMandatory', N'0',N'Log the time is mandatory or not', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'SpentTime', N'9',N'SpentTime', GETDATE() , @UserId),
	         (NEWID(), @CompanyId, N'IsDeveloperRole', @RoleIds, N'SpentTime', GETDATE() , @UserId),
			 (NEWID(), @CompanyId, N'MainLogo',N'https://bviewstorage.blob.core.windows.net/6671cd0d-5b91-4044-bdcc-e1f201c086c5/projects/d72d1c2f-dfbe-4d48-9605-cd3b7e38ed17/Main-Logo-9277cc4b-0c1f-4093-a917-1a65e874b3c9.png',N'Main logo of the company which displays in login screen and main screen',GETDATE(),@UserId),
			 (NEWID(), @CompanyId, N'MiniLogo',N'https://bviewstorage.blob.core.windows.net/4afeb444-e826-4f95-ac41-2175e36a0c16/hrm/0b2921a9-e930-4013-9047-670b5352f308/Logo-favicon-6b9022d6-7175-4f55-b4da-d5b2e5c98d4e.png',N'Mini logo of the company',GETDATE(),@UserId),
			 (NEWID(), @CompanyId, N'SMTP mail', N'apikey',N'SMTP mail', GETDATE() , @UserId),
	         (NEWID(), @CompanyId, N'SMTP password', N'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', N'SMTP password', GETDATE() , @UserId),
	         (NEWID(), @CompanyId, N'Theme', '752471EB-94F4-4A33-8C3B-6E0A8D42F0D1', N'Theme of the company', GETDATE() , @UserId),
			 (NEWID(), @CompanyId, N'MaxFileSize', N'20971520', N'Maximum file size in bytes', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'FileExtensions', N'image/*,application/*,text/*', N'File extensions', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'MaxStoreSize', N'1073741824', N'Maximum store size for the company in bytes', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'ConsiderMACAddressInEmployeeScreen', @Val,N'Considering MAC address from employee ', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'AdminMails', N'saiteja.pinnamaneni@snovasys.co.uk',N'Admin emails', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'PubnubPublishKey', N'',N'Key to publish pubnub', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'PubnubSubscribeKey', N'',N'Key to pubnub subscription', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'IsAuditEnable',N'0',N'Key for enable or disable Audit', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'DocumentsSizeLimit', N'1073741824',N'Describes the maximum limit to upload files for a company', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'StorageAccountName', N'',N'Storage account name', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'StorageAccountAccessKey', N'',N'Storage account access key', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'iformFileuploadpath', N'',N'Iform file upload path', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'iformFilesize', N'10',N'Iform file size', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'FromMailAddress', N'',N'From mail address', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'SmtpServer', N'',N'Smtp server', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'SmtpServerPort', N'',N'Smtp server port', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'UseSsl', N'1',N'Use SSL', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'AcceptableGoogleDomains', N'',N'Domains accepted for google login', GETDATE(), @UserId),
  			 (NEWID(), @CompanyId, N'DefaultGoogleUserRole', N'',N'Default role for user logged in via google', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'SpentTime', N'9h',N'SpentTime', GETDATE() , @UserId),
			 (NEWID(), @CompanyId, N'EnableLoginWithGoogle', N'0',N'Enable login with google', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'EmailLimitPerDay', N'1000',N'Mail restriction', GETDATE() , @UserId),
			 (NEWID(), @CompanyId, N'FromName',N'Snovasys Business Suite',N'Snovasys Business Suite', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'MaximumWorkingHours', N'16',N'Maximum office working hours', GETDATE() , @UserId),
			 (NEWID(), @CompanyId, N'IncludeYTD', N'1', N'Include YTD', CAST(N'2021-03-10T11:37:09.943' AS DateTime), @UserId),
			 (NEWID(), @CompanyId, N'NoOfBugs', N'20',N'Number of bugs per employee', GETDATE(), @UserId),
			 (NEWID(), @CompanyId, N'PayslipLogo', N'https://bviewstorage.blob.core.windows.net/6671cd0d-5b91-4044-bdcc-e1f201c086c5/projects/d72d1c2f-dfbe-4d48-9605-cd3b7e38ed17/Main-Logo-9277cc4b-0c1f-4093-a917-1a65e874b3c9.png', N'Pay slip logo', GETDATE(), @UserId)
	)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
			   [Key] = source.[Key],
			   [Value] = Source.[Value],
			   [Description] = source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

	IF(NOT EXISTS(SELECT Id FROM [dbo].[CompanySettings] WHERE [Key] = 'IsWorkItemStartFunctionalityRequired' AND CompanyId = @CompanyId))
	BEGIN
	  MERGE INTO [dbo].[CompanySettings] AS Target
		USING ( VALUES
		   (NEWID(), @CompanyId, N'IsWorkItemStartFunctionalityRequired ', N'0', N'Is work item auto start functionality required ', GETDATE(), @UserId)
		)
		AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
		ON Target.Id = Source.Id
		WHEN MATCHED THEN
		UPDATE SET CompanyId = Source.CompanyId,
				   [Key] = source.[Key],
				   [Value] = Source.[Value],
				   [Description] = source.[Description],
				   [CreatedDateTime] = Source.[CreatedDateTime],
				   [CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
		VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

	END

	DECLARE @Value VARCHAR(10)=N'1'
	DECLARE @IsVisible BIT =1
	IF NOT EXISTS(SELECT * FROM Company WHERE Id=@CompanyId AND IndustryId='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71')
	BEGIN
		SET @Value=N'0'
		SET @IsVisible = 0
	END

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
		(NEWID(), @CompanyId, N'IsAddOrEditCustomApps ',@Value, N'Is add or edit custom apps', GETDATE(), @UserId,@IsVisible)
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
	
	IF NOT EXISTS(SELECT * FROM CompanySettings WHERE [Key]='ConsiderMACAddressInEmployeeScreen' AND CompanyId=@CompanyId)
	BEGIN

	SET @Val = IIF((SELECT IndustryId FROM Company WHERE Id = @CompanyId) = (SELECT Id FROM Industry WHERE IndustryName LIKE '%Remote Working%') , 1, 0)

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
				(NEWID(), @CompanyId, N'ConsiderMACAddressInEmployeeScreen', @Val,N'Considering MAC address from employee ', GETDATE(), @UserId)
			)
	AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET CompanyId = Source.CompanyId,
				[Key] = source.[Key],
				[Value] = Source.[Value],
				[Description] = source.[Description],
				[CreatedDateTime] = Source.[CreatedDateTime],
				[CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

	END

	DECLARE @SettingValue VARCHAR(10)=N'1'
    DECLARE @SettingIsVisible BIT =1

	DECLARE  @IsSoftWare BIT = (SELECT IsSoftWare FROM [dbo].[Company] WHERE Id = @CompanyId)
	
	IF(@IsSoftWare = 0)
	BEGIN
	 SET @SettingValue = N'0'
	END

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
	   (NEWID(), @CompanyId, N'EnableSprints ',@SettingValue, N'Enable Sprints', GETDATE(), @UserId,@SettingIsVisible),
	   (NEWID(), @CompanyId, N'EnableTestcaseManagement ',@SettingValue, N'Enable test case management', GETDATE(), @UserId,@SettingIsVisible),
	   (NEWID(), @CompanyId, N'EnableBugBoard ',@SettingValue, N'Enable bug board', GETDATE(), @UserId,@SettingIsVisible)

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

	MERGE INTO [dbo].[CompanySettings] AS Target
	USING ( VALUES
       (NEWID(), @CompanyId, N'LoanTermsDocument','https://bviewstorage.blob.core.windows.net/96da99f6-1fda-4013-a0d2-8583d3bcc431/hrm/bc94a162-dd15-43fc-8425-255761a9ffb8/employeeloan-c7185755-cd02-4669-ab5c-76999d6fda4c.doc', N'Is add or edit custom apps', GETDATE(), @UserId,1),
	   (NEWID(), @CompanyId, N'DefaultLanguage','en', N'Default language for user', GETDATE(), @UserId,1),
	   (NEWID(), @CompanyId, N'ExpectedProductivityFromEmployeePerMonth', N'160',N'Expected productivity from the employee per month', GETDATE() , @UserId,1),
	   (NEWID(), @CompanyId, N'FileSystem','Local', N'Default storage type for the company', GETUTCDATE(), @UserId,1),
	   (NEWID(), @CompanyId, N'LocalFileSystemPath','C://Snovasys//LOCAL_STORAGE', N'Default path where the uploadedf files will save', GETUTCDATE(), @UserId,0)
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
	
	MERGE INTO [dbo].[CompanySettings] AS Target
    USING ( VALUES
       (NEWID(), @CompanyId, N'EnableAuditManagement', N'0',N'Key for enable or disable Audit', 1, GETDATE(), '242B3B99-CC2E-4967-997E-20DA8A253D8D')
        )
    AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] , [IsVisible],[CreatedDateTime] ,[CreatedByUserId])
    ON Target.Id = Source.Id
    WHEN MATCHED THEN
    UPDATE SET CompanyId = Source.CompanyId,
         [Value] = Source.[Value],
         [Description] = Source.[Description],
         [IsVisible] = Source.[IsVisible]
    WHEN NOT MATCHED BY TARGET THEN
    INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] , [IsVisible],[CreatedDateTime] ,[CreatedByUserId]) 
    VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] , [IsVisible],[CreatedDateTime] ,[CreatedByUserId]);

	MERGE INTO [dbo].[CompanySettings] AS Target 
	USING ( VALUES 
	 (NEWID(),'RecruitmentScheduleRemindFrequency','2','Recruitment schedule remind frequency',@CompanyId,GETDATE(),@UserId)
	)
	AS Source ([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId])
	ON Target.[Key] = Source.[Key] AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [Key] = Source.[Key]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId]) VALUES
	([Id], [Key], [Value],[Description],[CompanyId],[CreatedDateTime], [CreatedByUserId]);

END