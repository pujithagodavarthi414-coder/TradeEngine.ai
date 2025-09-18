CREATE PROCEDURE [dbo].[Marker1]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[JobCategory] AS Target 
	USING (VALUES 
			 (NEWID(),@CompanyId, N'Laborers and Helpers', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Service Workers', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Operatives', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Professionals', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Officials and Managers', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Sales Workers', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			,(NEWID(),@CompanyId, N'Office and Clerical Workers', 1, CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId)
			)
	AS Source ([Id], [CompanyId], [JobCategoryType], [IsActive], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [CompanyId] = Source.[CompanyId],
			   [JobCategoryType] = Source.[JobCategoryType],
			   [IsActive] = Source.[IsActive],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [JobCategoryType], [IsActive], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [JobCategoryType], [IsActive], [CreatedDateTime], [CreatedByUserId]);	
	
	--MERGE INTO [dbo].[Country] AS Target
	--USING ( VALUES 
	--		(NEWID(),@CompanyId, N'Belgium',  N'+32', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Antarctica', N'+672', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Albania', N'+335', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'France', N'+33', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'India', N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Brazil', N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Bangladesh', N'+880', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Japan', N'+81', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Dhaka', N'DH', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'England',  N'+91', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Canada', N'+1', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'China', N'+86', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Algola', N'+244', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Europe', N'+45', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Afganisthan', N'+93', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId),
	--		(NEWID(),@CompanyId, N'Uk', N'+44', CAST(N'2018-08-13 08:20:52.540' AS DateTime), @UserId)
	--		) 
	--AS Source ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId])
	--ON Target.Id = Source.Id  
	--WHEN MATCHED THEN 
	--UPDATE SET [CompanyId]  = Source.[CompanyId],
	--           [CountryName] = Source.[CountryName],
	--           [CreatedDateTime] = Source.[CreatedDateTime],
	--           [CreatedByUserId] = Source.[CreatedByUserId],
	--           [CountryCode] = Source.[CountryCode]
	--WHEN NOT MATCHED BY TARGET THEN 
	--INSERT([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]) 
	--VALUES ([Id], [CompanyId], [CountryName], [CountryCode], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[Currency] AS Target
	USING ( VALUES
	 (NEWID(),@CompanyId, N'Albanian Lek', N'ALL', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Canadian Dollar', N'CAD', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Nepalese Rupee', N'NPR', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Fiji Dollar', N'FJD', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Hongkong Dollar', N'HKD', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Indonesian Rupaiah', N'IDR', NULL, CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Bolivian Boliviano', N'BOB', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Hungarian Forient', N'HUF', NULL, CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Indian Rupee', N'INR', NULL,CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Australian Dollar', N'AUD', NULL, CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Euro', N'EUR', NULL, CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Brazilian Real', N'BRL', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Afganisthan Afgani', N'AFN', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Iceland Krona', N'ISK', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Algerian Dinar', N'DZD', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Pound Sterling', N'GBP', NULL,  CAST(N'2019-05-07T19:05:05.863' AS DateTime), @UserId)
	
	)
	AS Source ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CompanyId] = Source.[CompanyId],
			   [CurrencyName] = source.[CurrencyName],
			   [CurrencyCode] = source.[CurrencyCode],
			   [Symbol] = source.[Symbol],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [CurrencyName], [CurrencyCode], [Symbol], [CreatedDateTime], [CreatedByUserId]);
	
	--IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId  AND IndustryId ='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71'))
	--BEGIN
	--	MERGE INTO [dbo].[Role] AS Target 
	--		USING ( VALUES 
	--				(NEWID(), @CompanyId, N'Consultant', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'HR Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'HR Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, 1	),
	--				(NEWID(), @CompanyId, N'Software Trainee', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
	--				(NEWID(), @CompanyId, N'Analyst Developer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
	--				(NEWID(), @CompanyId, N'CEO', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, 1),
	--				(NEWID(), @CompanyId, N'Goal Responsible Person', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Digital Sales Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Director', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Lead Generation Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Recruiter', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Hr Consultant', CAST(N'2018-09-06T11:21:49.207' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Senior Software Engineer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
	--				(NEWID(), @CompanyId, N'Business Development Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Temp Grp', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Lead Developer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
	--				(NEWID(), @CompanyId, N'Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'QA', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Freelancer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Software Engineer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
	--				(NEWID(), @CompanyId, N'COO', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, 1),
	--				(NEWID(), @CompanyId, N'Business Analyst', CAST(N'2018-09-26T12:12:37.043' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
	--				(NEWID(), @CompanyId, N'Client', CAST(N'2018-09-26T12:12:37.043' AS DateTime), @UserId, NULL, NULL, NULL, NULL)
	--				)
	--		AS Source ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]) 
	--		ON Target.Id = Source.Id  
	--		WHEN MATCHED THEN 
	--		UPDATE SET [CompanyId] = Source.[CompanyId],
	--					[RoleName] = Source.[RoleName],
	--					[CreatedDateTime] = Source.[CreatedDateTime],
	--					[CreatedByUserId] = Source.[CreatedByUserId],
	--					[UpdatedDateTime] = Source.[UpdatedDateTime],
	--					[UpdatedByUserId] = Source.[UpdatedByUserId],
	--					[IsDeveloper] = Source.[IsDeveloper],
	--					[IsAdministrator] =  Source.[IsAdministrator]
	--		WHEN NOT MATCHED BY TARGET THEN 
	--		INSERT ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]) VALUES ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]);	      
 -- END

	MERGE INTO [dbo].[LeaveStatus] AS Target 
	USING ( VALUES 
			(NEWID(), @CompanyId, N'Approved', CAST(N'2018-08-13 06:17:55.183' AS DateTime), @UserId, NULL,NULL,1,NULL,NULL, N'#31E804'),
			(NEWID(), @CompanyId, N'Rejected', CAST(N'2018-08-13 06:17:55.183' AS DateTime), @UserId, NULL,NULL,NULL,1,NULL,N'#F95959'),
			(NEWID(), @CompanyId, N'Waiting for approval', CAST(N'2018-08-13 06:17:55.183' AS DateTime), @UserId, NULL,NULL,NULL,NULL,1,N'#B3B09E')
	)
	AS Source ([Id], [CompanyId], [LeaveStatusName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsApproved],[IsRejected],[IsWaitingForApproval],[LeaveStatusColour]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [LeaveStatusName] = Source.[LeaveStatusName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [IsApproved] = Source.[IsApproved],
			   [IsRejected] = Source.[IsRejected],
			   [IsWaitingForApproval] = Source.[IsWaitingForApproval],
			   [LeaveStatusColour] = Source.[LeaveStatusColour]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [LeaveStatusName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsApproved],[IsRejected],[IsWaitingForApproval],[LeaveStatusColour]) 
	VALUES ([Id], [CompanyId], [LeaveStatusName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsApproved],[IsRejected],[IsWaitingForApproval],[LeaveStatusColour]);
	
	MERGE INTO [dbo].[LeaveSession] AS Target 
	USING ( VALUES 
			(NEWID(), @CompanyId, N'Second Half', CAST(N'2018-08-13 06:17:58.240' AS DateTime), @UserId, NULL, NULL,NULL,1,NULL),
			(NEWID(), @CompanyId, N'Full Day', CAST(N'2018-08-13 06:17:58.240' AS DateTime), @UserId, NULL, NULL,1,NULL,NULL),
			(NEWID(), @CompanyId, N'First Half', CAST(N'2018-08-13 06:17:58.240' AS DateTime), @UserId, NULL, NULL,NULL,NULL,1)
	) 
	AS Source ([Id], [CompanyId], [LeaveSessionName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsFullDay],[IsSecondHalf],[IsFirstHalf]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [LeaveSessionName] = Source.[LeaveSessionName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [IsFullDay] = Source.[IsFullDay],
			   [IsSecondHalf] = Source.[IsSecondHalf],
			   [IsFirstHalf] = Source.[IsFirstHalf]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [LeaveSessionName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsFullDay],[IsSecondHalf],[IsFirstHalf]) VALUES ([Id], [CompanyId], [LeaveSessionName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsFullDay],[IsSecondHalf],[IsFirstHalf]);	   
	
	MERGE INTO [dbo].[BoardType] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'Kanban',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8', CAST(N'2018-08-13 06:19:11.740' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'SuperAgile',N'D0C55A82-303C-4976-8884-026441BA75BF', CAST(N'2018-08-13 06:19:11.740' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'Kanban Bugs',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8', CAST(N'2018-09-29 09:21:09.353' AS DateTime), @UserId, NULL, NULL, 1),
			(NEWID(),@CompanyId, N'Templates Workflow',N'E3F924E2-9858-4B8D-BB30-16C64860BBD8', CAST(N'2018-08-13 06:19:11.740' AS DateTime), @UserId, NULL, NULL, NULL)
	) 
	AS Source ([Id],CompanyId, [BoardTypeName], [BoardTypeUIId],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsBugBoard]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.CompanyId,
		       [BoardTypeName] = Source.[BoardTypeName],
			   [BoardTypeUIId] = Source.[BoardTypeUIId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [IsBugBoard] = Source.[IsBugBoard]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],CompanyId, [BoardTypeName],[BoardTypeUIId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsBugBoard])
	VALUES ([Id],CompanyId, [BoardTypeName],[BoardTypeUIId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsBugBoard]);	   
	
	MERGE INTO [dbo].[WorkFlow] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'SuperAgile', CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'Kanban', CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'Kanban Bugs', CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'Adhoc Workflow', CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId, NULL, NULL, NULL),
			(NEWID(),@CompanyId, N'Templates Workflow', CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId, NULL, NULL, NULL)
	)
	AS Source ([Id],CompanyId, [Workflow], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InactiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET CompanyId = Source.CompanyId,
			   [Workflow] = Source.[Workflow],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [InactiveDateTime] = Source.[InactiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],CompanyId, [Workflow], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InactiveDateTime]) 
	VALUES ([Id],CompanyId, [Workflow], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InactiveDateTime]); 
	
	INSERT INTO [BoardTypeWorkFlow] ([Id], [BoardTypeId], [WorkFlowId], [CreatedDateTime], [CreatedByUserId])
	SELECT NEWID(),T.BoardTypeId,T.WorkFlowId,GETDATE(),@UserId
	FROM (SELECT BT.Id AS BoardTypeId,WF.Id AS WorkFlowId FROM BoardType BT
	INNER JOIN WorkFlow WF ON BT.BoardTypeName = WF.WorkFlow AND BT.CompanyId = WF.CompanyId AND BT.CompanyId = @CompanyId AND WF.CompanyId = @CompanyId) T
	
	MERGE INTO [dbo].[UserStoryStatus] AS Target 
	USING ( VALUES 
		(NEWID(),@CompanyId,1, N'Blocked', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#ead1dd','166DC7C2-2935-4A97-B630-406D53EB14BC'),
		(NEWID(),@CompanyId,2, N'Inprogress', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#33B2FF','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'),
		(NEWID(),@CompanyId,3, N'Analysis Completed', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#04fefe','F2B40370-D558-438A-8982-55C052226581'),
		(NEWID(),@CompanyId,4, N'Dev Inprogress', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#33B2FF','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'),
		(NEWID(),@CompanyId,5, N'Completed', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#70ad47','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'),
		(NEWID(),@CompanyId,6, N'Signed Off', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#04fe02','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'),
		(NEWID(),@CompanyId,7, N'Dev Completed', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#70ad47','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'),
		(NEWID(),@CompanyId,8, N'Not Started', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#b7b7b7','F2B40370-D558-438A-8982-55C052226581'),
		(NEWID(),@CompanyId,9, N'Deployed', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#36c2c4','5C561B7F-80CB-4822-BE18-C65560C15F5B'),
		(NEWID(),@CompanyId,10, N'QA Approved', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#ffd966','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'),
		(NEWID(),@CompanyId,11, N'New', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#04fefe','F2B40370-D558-438A-8982-55C052226581'),
		(NEWID(),@CompanyId,12, N'Verified', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#ffd966','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'),
		(NEWID(),@CompanyId,13, N'Resolved', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#70ad47','5C561B7F-80CB-4822-BE18-C65560C15F5B'),
		(NEWID(),@CompanyId,14, N'Under Review', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#ffe599','6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'),
		(NEWID(),@CompanyId,15, N'Todo', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#33B2FF','F2B40370-D558-438A-8982-55C052226581')
	) 
	AS Source ([Id],CompanyId,[LookUpKey], [Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue],[TaskStatusId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET CompanyId = Source.CompanyId,
		       [Status] = Source.[Status],
			   [TaskStatusId] = Source.[TaskStatusId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [StatusHexValue] = Source.[StatusHexValue],
			   [LookUpKey] = Source.[LookUpKey]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],CompanyId,[LookUpKey], [Status], [CreatedDateTime], [CreatedByUserId],[StatusHexValue],[TaskStatusId]) 
	VALUES ([Id],CompanyId, [LookUpKey],[Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue],[TaskStatusId]);
	
	MERGE INTO [dbo].[ProcessDashboardStatus] AS Target 
	USING ( VALUES 
			(NEWID(), N'Waiting on dependencies', N'Waiting on dependencies', N'#ead1dd', CAST(N'2018-08-13 06:20:28.687' AS DateTime),@UserId, NULL, NULL,@CompanyId),
			(NEWID(), N'Process is not started yet',N'Process is not started yet', N'#04fefe', CAST(N'2018-08-13 06:20:28.687' AS DateTime),@UserId, NULL, NULL,@CompanyId),
			(NEWID(), N'Serious issue. Need urgent attention ', N'Serious issue. Need urgent attention ', N'#ff141c', CAST(N'2018-08-13 06:20:28.687' AS DateTime),@UserId, NULL, NULL,@CompanyId),
			(NEWID(), N'Everything is absolutely spot on',N'Everything is absolutely spot on', N'#04fe02', CAST(N'2018-08-13 06:20:28.687' AS DateTime),@UserId, NULL, NULL,@CompanyId)
	) 
	AS Source ([Id], [StatusName],[ShortName], [HexaValue], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],CompanyId) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [StatusName] = Source.[StatusName],
		       [HexaValue] = Source.[HexaValue],
		       [ShortName] = Source.[ShortName],
		       [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [StatusName],[ShortName], [HexaValue], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],CompanyId) 
	VALUES ([Id], [StatusName],[ShortName], [HexaValue], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],CompanyId);	   
	
	MERGE INTO [dbo].[WorkflowStatus] AS Target
	USING ( VALUES 
		    (NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), 6,0,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId ,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Not Started' AND CompanyId = @CompanyId), 1,1,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), 5,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), 7,0,1,CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), 8,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), 3,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), 4,0,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), 2,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Not Started' AND CompanyId = @CompanyId), 1,1,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), 2,0,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), 3,0,1, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban Bugs' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'New' AND CompanyId = @CompanyId), 1,1,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban Bugs' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), 2,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban Bugs' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Resolved' AND CompanyId = @CompanyId), 3,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Kanban Bugs' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Verified' AND CompanyId = @CompanyId), 4,0,1, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
		   ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Adhoc Workflow' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), 1,1,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Adhoc Workflow' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), 2,0,1, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
		   ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Templates Workflow' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), 1,1,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	       ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Templates Workflow' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), 2,0,1, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
	) 
	AS Source ([Id], [WorkflowId], [UserStoryStatusId], [OrderId] ,[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	ON Target.Id = Source.Id
	WHEN MATCHED THEN 
	UPDATE SET [WorkflowId] = Source.[WorkflowId],
		       [UserStoryStatusId] = Source.[UserStoryStatusId],
		       [OrderId] = Source.[OrderId],
		       [CanAdd] = Source.[CanAdd],
		       [CanDelete] = Source.[CanDelete],
		    --   [IsCompleted] = Source.[IsCompleted],
		    --   [IsBlocked] = Source.[IsBlocked],
			   --[IsArchived] = Source.[IsArchived],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkflowId], [UserStoryStatusId], [OrderId],[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
	VALUES ([Id], [WorkflowId], [UserStoryStatusId], [OrderId],[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]);	
	
	MERGE INTO [dbo].[FoodOrderStatus] AS Target 
	USING ( VALUES 
		    (NEWID(), N'Approved',@CompanyId, CAST(N'2018-08-13 06:53:59.130' AS DateTime), @UserId, 1, NULL, NULL),
			(NEWID(), N'Rejected',@CompanyId, CAST(N'2018-08-13 06:53:59.127' AS DateTime), @UserId, NULL, 1, NULL),
			(NEWID(), N'Pending', @CompanyId, CAST(N'2018-08-13 06:53:59.130' AS DateTime), @UserId, NULL, NULL, 1)
	) 
	AS Source ([Id], [Status],[CompanyId], [CreatedDateTime], [CreatedByUserId], [IsApproved],[IsRejected],[IsPending]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [Status] = Source.[Status],
		       [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsApproved] = Source.[IsApproved],
			   [IsRejected] = Source.[IsRejected],
			   [IsPending] = Source.[IsPending]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [Status],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsApproved],[IsRejected],[IsPending]) VALUES ([Id], [Status],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsApproved],[IsRejected],[IsPending]);
	
	MERGE INTO [dbo].[Designation] AS Target 
	USING ( VALUES 
			(N'Project Manager', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Business Development Job ', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId, NEWID())
			,(N'HR Executive', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Recruiter', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'COO', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Lead Generation Manager', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Software Engineer', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Director', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Lead Developer', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'QA', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Employee And Office Care Taker', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Digital Sales Executive', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Analyst Developer', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'CEO', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
			,(N'Consultant', CAST(N'2018-08-13T08:20:07.710' AS DateTime), @UserId,@CompanyId,NEWID())
	)
	AS Source ([DesignationName], [CreatedDateTime], [CreatedByUserId],[CompanyId],[Id]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [DesignationName] = Source.[DesignationName],
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([DesignationName], [CreatedDateTime], [CreatedByUserId],[CompanyId],[Id])  
	VALUES([DesignationName], [CreatedDateTime], [CreatedByUserId],[CompanyId],[Id]) ;	 
	
	MERGE INTO [dbo].[GoalReplanType] AS Target 
	USING ( VALUES 
		    (@CompanyId, N'Developer', CAST(N'2018-08-13 13:49:44.087' AS DateTime), @UserId, NULL, NULL, 1, NULL, NULL, NULL,NEWID()),
			(@CompanyId, N'Office Administration', CAST(N'2018-08-13 13:49:44.090' AS DateTime), @UserId, NULL, NULL, NULL, 1, NULL, NULL,NEWID()),
			(@CompanyId, N'Customer', CAST(N'2018-08-13 13:49:44.090' AS DateTime), @UserId, NULL, NULL, NULL, NULL, 1, NULL,NEWID()),
			(@CompanyId, N'Unplanned Leaves', CAST(N'2018-12-13 10:26:14.340' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, 1 ,NEWID())
	) 
	AS Source ([CompanyId], [GoalReplanTypeName],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsOfficeAdministration],[IsCustomer],[IsUnplannedLeaves],[Id]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [GoalReplanTypeName] = Source.[GoalReplanTypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [IsDeveloper] = Source.[IsDeveloper],
			   [IsOfficeAdministration] = Source.[IsOfficeAdministration],
			   [IsCustomer] = Source.[IsCustomer],
			   [IsUnplannedLeaves] = Source.[IsUnplannedLeaves]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([CompanyId], [GoalReplanTypeName],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsOfficeAdministration],[IsCustomer],[IsUnplannedLeaves],[Id]) VALUES ([CompanyId], [GoalReplanTypeName],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsOfficeAdministration],[IsCustomer],[IsUnplannedLeaves],[Id]);	   
	
	MERGE INTO [dbo].[AccessisbleIpAdresses] AS Target 
	USING ( VALUES 
		     (@CompanyId, N'Ongole Office IP', N'103.49.206.154', CAST(N'2018-08-13 06:15:46.710' AS DateTime), @UserId, NULL, NULL ,NEWID()),
	        (@CompanyId, N'Local', N'::1', CAST(N'2018-08-13 06:15:46.710' AS DateTime), @UserId, NULL, NULL,NEWID()),
	        (@CompanyId, N'Ongole Office IP2', N'182.18.177.106', CAST(N'2018-08-13 06:15:46.710' AS DateTime), @UserId, NULL, NULL,NEWID()),
	        (@CompanyId, N'Hyderabad Office IP', N'14.143.15.70', CAST(N'2018-08-13 06:15:46.710' AS DateTime), @UserId, NULL, NULL,NEWID())
	) 
	AS Source  ([CompanyId], [Name], [IpAddress], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Id]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [Name] = Source.[Name],
		       [IpAddress] = Source.[IpAddress],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([CompanyId], [Name], [IpAddress], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Id]) VALUES ([CompanyId], [Name], [IpAddress], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Id]);              
	
	MERGE INTO [dbo].[WorkflowEligibleStatusTransition] AS Target 
	USING ( VALUES 
			 (NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), N'D', NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), N'Nearest([Saturday, Wednesday], D) +2', NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Not Started' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), N'Nearest([Saturday, Wednesday], D)', NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), N'D', NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Not Started' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Not Started' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Blocked' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Analysis Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'QA Approved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Signed Off' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Resolved' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban Bugs' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Resolved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'New' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban Bugs' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Resolved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban Bugs' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL, @CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Resolved' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Verified' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban Bugs' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'New' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Kanban Bugs' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Under Review' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Under Review' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Deployed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL, @CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Under Review' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Dev Inprogress' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'SuperAgile' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
			,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Adhoc Workflow' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL, @CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Adhoc Workflow' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
			,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Templates Workflow' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL, @CompanyId)
	        ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Completed' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Templates Workflow' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
	)
	AS Source ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],CompanyId) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FromWorkflowUserStoryStatusId] = Source.[FromWorkflowUserStoryStatusId],
		       [ToWorkflowUserStoryStatusId] = Source.[ToWorkflowUserStoryStatusId],
		       [Deadline] = Source.[Deadline],
		       [DisplayName] = Source.[DisplayName],
		       [WorkflowId] = Source.[WorkflowId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[CompanyId]) VALUES ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[CompanyId]);
	
	MERGE INTO [dbo].[ProjectType] AS Target 
	USING ( VALUES 
		    (NEWID(),'Windows Application',@CompanyId, CAST(N'2019-01-24 13:20:55.540' AS DateTime), @UserId, NULL, NULL),
			(NEWID(),'Mobile Application',@CompanyId, CAST(N'2019-01-24 13:20:55.540' AS DateTime), @UserId, NULL, NULL),
			(NEWID(),'Web Application',@CompanyId, CAST(N'2019-01-24 13:20:55.540' AS DateTime), @UserId, NULL, NULL)
	) 
	AS Source ([Id],[ProjectTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedByUserId],[UpdatedDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [ProjectTypeName] = Source.[ProjectTypeName],
		       [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[ProjectTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedByUserId],[UpdatedDateTime]) VALUES ([Id],[ProjectTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[UpdatedByUserId],[UpdatedDateTime]);	
	
	MERGE INTO [dbo].[UserStoryType] AS Target 
	USING ( VALUES 
		    (NEWID(),@CompanyId, N'Bug', CAST(N'2018-08-13 13:50:10.967' AS DateTime), @UserId, NULL, NULL,N'BUG',1,NULL,NULL,1,1,N'#FE0204'),
		    (NEWID(),@CompanyId, N'Work item', CAST(N'2018-08-13 13:50:10.967' AS DateTime), @UserId, NULL, NULL,N'WI',NULL,1,NULL,1,1,N'#FE7E02'),
			(NEWID(),@CompanyId, N'Fill Form', CAST(N'2018-08-13 13:50:10.967' AS DateTime), @UserId, NULL, NULL,N'FF',NULL,NULL,1,1,1,N'#7B7B7B')
	) 
	AS Source ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[Color]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [UserStoryTypeName] = Source.[UserStoryTypeName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [ShortName] = Source.[ShortName],
			   [IsBug] = Source.[IsBug],
			   [IsUserStory] = Source.[IsUserStory],
			   [IsFillForm] = Source.[IsFillForm],
			   [IsQaRequired] = Source.IsQaRequired,
			   [IsLogTimeRequired] = Source.IsLogTimeRequired
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[Color]) 
	VALUES ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[Color]);	   
	
	MERGE INTO [dbo].[TestCaseAutomationType] AS Target 
	USING ( VALUES 
		    (NEWID(), N'None', CAST(N'2018-11-17T13:20:35.990' AS DateTime), @UserId, @CompanyId,1),
			(NEWID(), N'Renorex', CAST(N'2018-11-17T13:20:36.013' AS DateTime), @UserId, @CompanyId,NULL)
	) 
	AS Source ([Id], [AutomationType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [AutomationType] = Source.[AutomationType],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId],
			   [IsDefault] = Source.[IsDefault]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [AutomationType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]) VALUES ([Id], [AutomationType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]);	   
	
	MERGE INTO [dbo].[TestCasePriority] AS Target 
	USING ( VALUES 
		    (NEWID(), N'Medium', CAST(N'2018-11-17T13:18:44.227' AS DateTime), @UserId, @CompanyId,1),
			(NEWID(), N'High', CAST(N'2018-11-17T13:18:41.277' AS DateTime), @UserId, @CompanyId,NULL),
			(NEWID(), N'Low', CAST(N'2018-11-17T13:18:46.330' AS DateTime), @UserId, @CompanyId,NULL),
			(NEWID(), N'Critical', CAST(N'2018-11-17T13:18:37.710' AS DateTime), @UserId, @CompanyId,NULL)
	) 
	AS Source ([Id], [PriorityType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [PriorityType] = Source.[PriorityType],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId],
			   [IsDefault] = Source.[IsDefault]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [PriorityType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]) VALUES ([Id], [PriorityType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]);	   
	
	MERGE INTO [dbo].[TestCaseStatus] AS Target 
	USING ( VALUES 
		    (NEWID(), N'Failed',N'Failed', CAST(N'2018-11-29T17:03:13.240' AS DateTime), @UserId,  N'#d97373', @CompanyId,1,NULL,NULL,NULL,NULL  ),
			(NEWID(), N'Passed',N'Passed', CAST(N'2018-11-29T17:03:13.220' AS DateTime), @UserId,  N'#65bb63', @CompanyId,NULL,1,NULL,NULL,NULL  ),
			(NEWID(), N'Retest',N'Retest', CAST(N'2018-11-29T17:03:13.240' AS DateTime), @UserId,  N'#c6c634', @CompanyId,NULL,NULL,1,NULL,NULL  ),
			(NEWID(), N'Blocked',N'Blocked', CAST(N'2018-11-29T17:03:13.240' AS DateTime), @UserId,  N'#909090', @CompanyId,NULL,NULL,NULL,1,NULL ),
			(NEWID(), N'Untested',N'Untested', CAST(N'2018-11-29T17:01:29.127' AS DateTime), @UserId,  N'#b0b0b0', @CompanyId,NULL,NULL,NULL,NULL,1)
	) 
	AS Source ([Id], [StatusShortName],[Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue], [CompanyId],[IsFailed],[IsPassed],[IsReTest],[IsBlocked],[IsUntested])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [Status] = Source.[Status],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [StatusHexValue] = Source.[StatusHexValue],
			   [CompanyId] = Source.[CompanyId],
			   [IsFailed] = Source.[IsFailed],
			   [IsPassed] = Source.[IsPassed],
			   [IsReTest] = Source.[IsReTest],
			   [IsBlocked] = Source.[IsBlocked],
			   [IsUntested] = Source.[IsUntested],
			   [StatusShortName] = Source.[StatusShortName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [StatusShortName],[Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue], [CompanyId],[IsFailed],[IsPassed],[IsReTest],[IsBlocked],[IsUntested]) VALUES ([Id], [StatusShortName],[Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue], [CompanyId],[IsFailed],[IsPassed],[IsReTest],[IsBlocked],[IsUntested]);	   
	
	MERGE INTO [dbo].[TestCaseTemplate] AS Target 
	USING ( VALUES 
			(NEWID(), N'Test Case (Steps)', CAST(N'2018-11-15T15:53:48.533' AS DateTime), @UserId,  @CompanyId,1,1,NULL,NULL),
			(NEWID(), N'Test Case (Text)', CAST(N'2018-11-15T15:53:48.533' AS DateTime), @UserId,  @CompanyId,NULL,NULL,1,NULL),
			(NEWID(), N'Exploratory Session', CAST(N'2018-11-15T15:53:48.533' AS DateTime), @UserId,  @CompanyId,NULL,NULL,NULL,1)
	) 
	AS Source ([Id], [TemplateType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault],[IsTestCaseSteps],[IsTestCaseText],[IsExploratorySession])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [TemplateType] = Source.[TemplateType],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId],
			   [IsDefault] = Source.[IsDefault],
			   [IsTestCaseSteps] = Source.[IsTestCaseSteps],
			   [IsTestCaseText] = Source.[IsTestCaseText],
			   [IsExploratorySession] = Source.[IsExploratorySession]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [TemplateType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault],[IsTestCaseSteps],[IsTestCaseText],[IsExploratorySession]) VALUES ([Id], [TemplateType], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault],[IsTestCaseSteps],[IsTestCaseText],[IsExploratorySession]);
	
	MERGE INTO [dbo].[TestCaseType] AS Target 
	USING ( VALUES 
			(NEWID(), N'Other', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,1),
			(NEWID(), N'Performance', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Functional', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Destructive', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Acceptance', CAST(N'2018-11-15T15:49:38.237' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Accessibilty', CAST(N'2018-11-15T15:52:09.263' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Regression', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Security', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Usabilty', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Automated', CAST(N'2018-11-15T15:52:09.263' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Compatibility', CAST(N'2018-11-15T15:52:09.263' AS DateTime), @UserId,  @CompanyId,NULL),
			(NEWID(), N'Smoke & Sanity', CAST(N'2018-11-15T15:52:09.267' AS DateTime), @UserId,  @CompanyId,NULL)
	) 
	AS Source ([Id], [TypeName], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [TypeName] = Source.[TypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId],
			   [IsDefault] = Source.[IsDefault]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [TypeName], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]) VALUES ([Id], [TypeName], [CreatedDateTime], [CreatedByUserId], [CompanyId],[IsDefault]);
	
	MERGE INTO [dbo].[BugPriority] AS Target 
	USING ( VALUES 
				(NEWID(), N'P3', N'#7b7b7b','arrow-down',@CompanyId, CAST(N'2018-10-08T15:24:22.370' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d', NULL, NULL, N'Low',4,NULL,NULL,NULL,1),
				(NEWID(), N'P1', N'#fe7e02','arrow-up',@CompanyId, CAST(N'2018-10-08T15:23:38.610' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d', NULL, NULL, N'High',2,NULL,1,NULL,NULL),
				(NEWID(), N'P2', N'#00bfff','arrow-down',@CompanyId, CAST(N'2018-10-08T15:24:22.370' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d', NULL, NULL, N'Medium',3,NULL,NULL,1,NULL),
	       	    (NEWID(), N'P0', N'#fe0204','arrow-up',@CompanyId, CAST(N'2018-10-08T15:23:14.800' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d', NULL, NULL, N'Critical',1,1,NULL,NULL,NULL)
				)
	AS Source ([Id], [PriorityName],[Color],[Icon],[CompanyId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Description],[Order],[IsCritical],[IsHigh],[IsMedium],[IsLow]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [PriorityName] = Source.[PriorityName],
	           [Color] = Source.[Color],
			   [Icon] = Source.[Icon],
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [Description] = Source.[Description],
			   [Order] = Source.[Order],
			   [IsCritical] = Source.[IsCritical],
			   [IsHigh] = Source.[IsHigh],
			   [IsMedium] = Source.[IsMedium],
			   [IsLow] = Source.[IsLow]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [PriorityName], [Color], [Icon],[CompanyId],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Description],[Order],[IsCritical],[IsHigh],[IsMedium],[IsLow]) VALUES ([Id], [PriorityName], [Color],[Icon] ,[CompanyId],[CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Description],[Order],[IsCritical],[IsHigh],[IsMedium],[IsLow]);  
	
	MERGE INTO [dbo].[Field] AS Target 
	USING ( VALUES 
	        (@CompanyId, N'Bug Priority', NULL, CAST(N'2018-12-24T15:08:16.700' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Status', NULL, CAST(N'2018-11-29T11:41:50.400' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Dependency', NULL, CAST(N'2018-11-29T11:41:50.400' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Owner', NULL, CAST(N'2018-11-29T11:41:50.400' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Deadline', NULL, CAST(N'2018-11-29T11:41:50.400' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Estimated Time', NULL, CAST(N'2018-11-29T11:41:50.400' AS DateTime), @UserId, NULL, NULL ,NEWID())
		   ,(@CompanyId, N'Bug Caused User', NULL, CAST(N'2018-12-24T15:08:16.700' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story', NULL, CAST(N'2018-11-29T11:41:50.370' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Archive', NULL, CAST(N'2018-12-26T10:57:45.233' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Park', NULL, CAST(N'2018-12-26T10:57:30.207' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'Project Feature', NULL, CAST(N'2018-12-31T16:09:56.310' AS DateTime), @UserId, NULL, NULL,NEWID())
		   ,(@CompanyId, N'User Story Reorder', NULL, CAST(N'2018-12-26T10:56:46.107' AS DateTime), @UserId, NULL, NULL,NEWID())
	)
	AS Source ([CompanyId], [FieldName], [FieldAliasName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[Id]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [FieldName] = Source.[FieldName],
		       [FieldAliasName] = Source.[FieldAliasName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([CompanyId], [FieldName], [FieldAliasName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [Id]) VALUES ([CompanyId], [FieldName], [FieldAliasName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [Id]);	   
	
	MERGE INTO [dbo].[PermissionReason] AS Target 
	USING ( VALUES 
	          (@CompanyId, N'Coming to office', CAST(N'2018-09-28T04:06:18.533' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Bus Late', CAST(N'2018-09-26T06:50:00.350' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Lunch break late', CAST(N'2018-10-09T07:55:06.910' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Last night late', CAST(N'2018-09-26T11:49:26.637' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Health Problem', CAST(N'2018-09-26T11:50:27.870' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Personal Work', CAST(N'2018-09-26T14:08:32.240' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Due to traffic', CAST(N'2018-09-26T11:49:55.927' AS DateTime), @UserId, NULL, NULL, 0,NEWID()),
	          (@CompanyId, N'Train late', CAST(N'2018-09-26T11:49:41.327' AS DateTime), @UserId, NULL, NULL, 0,NEWID())
	)
	AS Source ([CompanyId], [ReasonName], [CreatedDateTime], [CreatedByUserId], [UpdatedBYUserId], [UpdatedDateTime], [IsDeleted],[Id]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [ReasonName] = Source.[ReasonName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [IsDeleted] = Source.[IsDeleted],
			   [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([CompanyId], [ReasonName], [CreatedDateTime], [CreatedByUserId], [UpdatedBYUserId], [UpdatedDateTime], [IsDeleted],[Id]) 
	VALUES ([CompanyId], [ReasonName], [CreatedDateTime], [CreatedByUserId], [UpdatedBYUserId], [UpdatedDateTime], [IsDeleted],[Id]);	   
	
	MERGE INTO [dbo].[ButtonType] AS Target 
	USING ( VALUES 
		 (NEWID(),N'Start',N'Start',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, 1, NULL, NULL, NULL, NULL, NULL, 'START')
		,(NEWID(),N'Finish', N'Finish', @CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, 1, NULL, NULL, NULL, 'FINISH')
		,(NEWID(),N'Lunch Start',N'Lunch',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, 1, NULL, NULL, 'LUNCHSTART')
		,(NEWID(),N'Lunch End',N'Lunch',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, NULL, 1, NULL, 'LUNCHEND')
		,(NEWID(),N'Break Out',N'Break',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 'BREAKOUT')
		,(NEWID(),N'Break In', N'Break', @CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, 1, NULL, NULL, NULL, NULL, 'BREAKIN')
		--,(NEWID(),N'Lunch',N'Lunch',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'LUNCH')
		--,(NEWID(),N'Break',N'Break',@CompanyId, CAST(N'2018-08-13T06:15:46.710' AS DateTime), @UserId, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'BREAK')
	
	) 
	AS Source ([Id],[ButtonTypeName], [ShortName],[CompanyId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId] ,[IsStart], [IsBreakIn], [IsFinish], [IsLunchStart], [IsLunchEnd], [BreakOut], [ButtonCode])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [ButtonTypeName] = Source.[ButtonTypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
	           [IsStart] = Source.[IsStart],
	           [IsBreakIn] = Source.[IsBreakIn],
	           [IsFinish] = Source.[IsFinish],
			   [IsLunchStart] = Source.[IsLunchStart],
			   [IsLunchEnd] = Source.[IsLunchEnd],
			   [BreakOut] = Source.[BreakOut],
			   [ButtonCode] = Source.[ButtonCode],
			   [ShortName] = Source.[ShortName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[ButtonTypeName], [ShortName],[CompanyId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [IsStart], [IsBreakIn], [IsFinish], [IsLunchStart], [IsLunchEnd], [BreakOut], [ButtonCode]) 
	VALUES ([Id],[ButtonTypeName], [ShortName],[CompanyId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsStart], [IsBreakIn], [IsFinish], [IsLunchStart], [IsLunchEnd], [BreakOut], [ButtonCode]);	   
	
	MERGE INTO [dbo].[UserStoryPriority] AS Target 
	USING ( VALUES 
				(NEWID(), N'Low', @CompanyId, CAST(N'2018-10-08T15:24:22.370' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d',NULL,NULL,1,3 ),
				(NEWID(), N'High', @CompanyId, CAST(N'2018-10-08T15:23:38.610' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d',1,NULL,NULL,1),
				(NEWID(), N'Medium', @CompanyId, CAST(N'2018-10-08T15:24:22.370' AS DateTime), N'c8399a84-be18-4133-8e1a-65fee4b82c3d',NULL,1,NULL,2)
				)
	AS Source ([Id], [PriorityName],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsHigh],[IsMedium],[IsLow],[Order]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [PriorityName] = Source.[PriorityName],
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsHigh] = Source.[IsHigh],
			   [IsMedium] = Source.[IsMedium],
			   [IsLow] = Source.[IsLow],
			   [Order] = SOURCE.[Order]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [PriorityName],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsHigh],[IsMedium],[IsLow],[Order]) VALUES ([Id], [PriorityName],[CompanyId], [CreatedDateTime], [CreatedByUserId],[IsHigh],[IsMedium],[IsLow],[Order]);	 
	 
	MERGE INTO [dbo].[CompanyLocation] AS Target 
	USING ( VALUES
	(NEWID(),@CompanyId, N'Ongole', N'Brundavan Nagar, Pandaripuram, Ongole, Andhra Pradesh ', 15.5121, 80.0389, CAST(N'2019-04-01T12:57:34.193' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036970')
	,(NEWID(),@CompanyId, N'Hyderabad', N'Jntu Road, 407, 4th Floor, Manjeera Majestic, K P H B Phase 1, Kukatpally, Hyderabad, Telangana  ', 17.4882,78.3912, CAST(N'2019-04-01T12:58:47.620' AS DateTime), N'127133f1-4427-4149-9dd6-b02e0e036970')
	)
	AS Source ([Id], [CompanyId], [LocationName], [Address], [Latitude], [Longitude], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]        = Source.[CompanyId],
	           [LocationName]        = Source.[LocationName],
			   [Address]        = Source.[Address],
			   [Latitude]        = Source.[Latitude],
	           [Longitude]        = Source.[Longitude],
			   [CreatedDateTime] = Source.[CreatedDateTime],
		       [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [LocationName], [Address], [Latitude], [Longitude], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [LocationName], [Address], [Latitude], [Longitude], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[UserStorySubType] AS Target 
	USING ( VALUES 
	 (NEWID(),@CompanyId, N'UI Integration', CAST(N'2019-03-13T06:19:56.113' AS DateTime), @UserId, NULL, NULL)
	,(NEWID(),@CompanyId, N'Api definition', CAST(N'2018-10-26T11:36:20.480' AS DateTime), @UserId, NULL, NULL)
	,(NEWID(),@CompanyId, N'UI definition', CAST(N'2018-10-26T11:36:20.480' AS DateTime), @UserId, NULL, NULL)
	,(NEWID(),@CompanyId, N'DB', CAST(N'2018-10-26T11:36:20.480' AS DateTime), @UserId, NULL, NULL)
	,(NEWID(),@CompanyId, N'API', CAST(N'2018-10-26T11:36:20.480' AS DateTime), @UserId, NULL, NULL)
	,(NEWID(),@CompanyId, N'UI', CAST(N'2018-10-26T11:36:20.480' AS DateTime), @UserId, NULL, NULL)
	)
	AS Source ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId])
	ON Target.Id = Source.Id 
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId], 
	           [UserStorySubTypeName]      = Source.[UserStorySubTypeName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
		       [CreatedByUserId] = Source.[CreatedByUserId],
		       [UpdatedDateTime] = Source.[UpdatedDateTime],
			   [UpdatedByUserId] = Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]) VALUES ([Id], [CompanyId], [UserStorySubTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId]);
	
	MERGE INTO [dbo].[Nationality] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Indian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Chinese', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Dutch', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'British', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Australian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Berlian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId )
	, (NEWID(),@CompanyId, N'Belgian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId )
	, (NEWID(),@CompanyId, N'American', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Algerian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Austrian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Angolian', CAST(N'2018-08-13T13:12:56.550' AS DateTime), @UserId)
			
	)																																										
	AS Source ([Id], [CompanyId], [NationalityName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [NationalityName] = Source.[NationalityName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [NationalityName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [NationalityName], [CreatedDateTime], [CreatedByUserId]);	
	
	MERGE INTO [dbo].[UserStoryReviewStatus] AS Target
	USING ( VALUES    
		    (NEWID(), @CompanyId,N'Approved', CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId),
			(NEWID(), @CompanyId,N'Rejected', CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId)
			)
	AS Source ([Id], [CompanyId], [UserStoryReviewStatusName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
			   [UserStoryReviewStatusName] = source.[UserStoryReviewStatusName],	  
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [CompanyId], [UserStoryReviewStatusName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [UserStoryReviewStatusName], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[ExpenseCategory] AS Target
	USING ( VALUES    
		    (NEWID(), @CompanyId,N'IT and Internet Expenses',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId),
			(NEWID(), @CompanyId,N'Automobile expenses',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId),
			(NEWID(), @CompanyId,N'Office Supplies',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId),
			(NEWID(), @CompanyId,N'Other Expenses',NULL,NULL,NULL, CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId)
			)
	AS Source ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
			   [CategoryName] = source.[CategoryName],	  
			   [Image] = Source.[Image],
			   [AccountCode] = Source.[AccountCode],
			   [Description] = Source.[Description],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [CategoryName],[Image],[AccountCode],[Description], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[ExpenseReportStatus] AS Target
	USING ( VALUES    
		    (NEWID(), @CompanyId,N'Achived',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId ,NULL),
			(NEWID(), @CompanyId,N'Submitted',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId,1),
			(NEWID(), @CompanyId,N'Approved',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId,NULL),
			(NEWID(), @CompanyId,N'Rejected',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId ,NULL),
			(NEWID(), @CompanyId,N'Reimbursed',NULL,CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId,NULL)
			
			)
	AS Source ([Id], [CompanyId], [Name],[Description] ,[CreatedDateTime], [CreatedByUserId],[IsDefault])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
			   [Name]      = source.[Name],	 
			   [Description]      = source.[Description],	 	 
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsDefault]          = Source.[IsDefault]       	   
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId], [IsDefault]) VALUES  ([Id], [CompanyId], [Name], [CreatedDateTime], [CreatedByUserId],[IsDefault]);
	
	MERGE INTO [dbo].[PaymentStatus] AS Target
	USING ( VALUES    
		    (NEWID(), @CompanyId,N'Success',CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId, NULL),
			(NEWID(), @CompanyId,N'Fail',CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId, NULL),
			(NEWID(), @CompanyId,N'Pending',CAST(N'2019-03-04T00:00:00.000' AS DateTime), @UserId ,1)
			)
	AS Source ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
			   [PaymentStatus]   = source.[PaymentStatus],	   	 	 
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsDefault]          = Source.[IsDefault]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault]) VALUES   ([Id], [CompanyId], [PaymentStatus],[CreatedDateTime], [CreatedByUserId],[IsDefault]);

	MERGE INTO [dbo].[MessageType] AS Target 
	USING ( VALUES 
	         (NEWID(),@CompanyId, N'File', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
	        ,(NEWID(),@CompanyId, N'Text', CAST(N'2019-02-21T09:42:59.993' AS DateTime), @UserId)
	)  
	AS Source ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [MessageTypeName] = Source.[MessageTypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]);	  
	
	MERGE INTO [dbo].[EntityRole] AS Target 
	USING ( VALUES 
	        (NEWID(), N'Project manager', @CompanyId,CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,NULL)
	        ,(NEWID(), N'Project developer ', @CompanyId,CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,NULL)
	        ,(NEWID(), N'Project lead', @CompanyId,CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,NULL)
	        ,(NEWID(), N'Project qa', @CompanyId,CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,NULL)
	)        
	AS Source ([Id],[EntityRoleName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [EntityRoleName] = Source.[EntityRoleName],
		       [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
		       [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[EntityRoleName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime])  VALUES ([Id],[EntityRoleName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]) ;
	
	MERGE INTO [dbo].[PayGrade] AS Target 
	USING ( VALUES 
			(NEWID(), @CompanyId, N'Chief Executive Officer (C.E.O)', CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'zxs', CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId),	
			(NEWID(), @CompanyId, N'Executive', CAST(N'2018-08-13 08:22:39.083' AS DateTime), @UserId)
	)        
	AS Source ([Id],CompanyId,[PayGradeName],[CreatedDateTime],[CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET CompanyId = Source.CompanyId,
		       [PayGradeName] = Source.[PayGradeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],CompanyId,[PayGradeName],[CreatedDateTime],[CreatedByUserId])  VALUES ([Id],CompanyId,[PayGradeName],[CreatedDateTime],[CreatedByUserId]) ;
		
	MERGE INTO [dbo].[PayFrequency] AS Target 
	USING ( VALUES 
			(NEWID(), @CompanyId, N'Monthly on First Pay of Month', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Semi Monthly', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Bi Weekly', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Hourly', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Monthly', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId),
			(NEWID(), @CompanyId, N'Weekly', CAST(N'2019-05-13 08:22:55.870' AS DateTime), @UserId)
		)        
	AS Source ([Id],CompanyId,[PayFrequencyName],[CreatedDateTime],[CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET CompanyId = Source.CompanyId,
		       [PayFrequencyName] = Source.[PayFrequencyName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],CompanyId,[PayFrequencyName],[CreatedDateTime],[CreatedByUserId])  VALUES ([Id],CompanyId,[PayFrequencyName],[CreatedDateTime],[CreatedByUserId]) ;
		
	MERGE INTO [dbo].[EmploymentStatus] AS Target 
	USING ( VALUES 
	 (NEWID(),@CompanyId, N'Consultant', 0,  CAST(N'2019-05-07T09:50:17.440' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Part-Time Employee', 0, CAST(N'2019-05-07T10:31:35.093' AS DateTime), @UserId)
	,(NEWID(),@CompanyId, N'Full-Time Employee', 1, CAST(N'2019-05-06T12:50:59.933' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [EmploymentStatusName], [IsPermanent], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [EmploymentStatusName] = Source.[EmploymentStatusName],
			   [IsPermanent] = Source.[IsPermanent]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [EmploymentStatusName], [IsPermanent], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [EmploymentStatusName], [IsPermanent], [CreatedDateTime], [CreatedByUserId]);	  
	
	MERGE INTO [dbo].[Department] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Sales', CAST(N'2019-05-07T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Finance', CAST(N'2019-05-06T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'IT', CAST(N'2019-05-06T12:56:45.820' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Administration', CAST(N'2019-05-07T10:31:35.093' AS DateTime), @UserId)
	
	) 
	AS Source ([Id], [CompanyId], [DepartmentName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [DepartmentName] = Source.[DepartmentName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [DepartmentName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [DepartmentName], [CreatedDateTime], [CreatedByUserId]);	   
	
	MERGE INTO [dbo].[Skill] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Reporting', CAST(N'2019-05-15T09:50:17.440' AS DateTime), @UserId		)
	, (NEWID(),@CompanyId, N'MVC', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId	)
	, (NEWID(),@CompanyId, N'Web Development', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId )
	, (NEWID(),@CompanyId, N'AngularJS', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId		)
	, (NEWID(),@CompanyId, N'AppDevelopment', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId  )
	, (NEWID(),@CompanyId, N'Sql', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId    )
	, (NEWID(),@CompanyId, N'Xamarin', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'UI/UX', CAST(N'2019-05-15T12:56:45.820' AS DateTime), @UserId)
	
	) 
	AS Source ([Id], [CompanyId], [SkillName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [SkillName] = Source.[SkillName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [SkillName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [SkillName], [CreatedDateTime], [CreatedByUserId]);	   
	
	MERGE INTO [dbo].[SubscriptionPaidBy] AS Target 
	USING ( VALUES 
		(NEWID(), @CompanyId, N'Individual', CAST(N'2019-05-18 13:32:49.500' AS DateTime), @UserId),
		(NEWID(), @CompanyId, N'Company', CAST(N'2018-05-18 13:32:49.500' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [SubscriptionPaidByName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [SubscriptionPaidByName] = Source.[SubscriptionPaidByName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [SubscriptionPaidByName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [SubscriptionPaidByName], [CreatedDateTime], [CreatedByUserId]);	   
	
	MERGE INTO [dbo].[LicenceType] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Permanent', CAST(N'2019-05-06T12:56:45.820' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'3 Months', CAST(N'2019-05-06T12:50:59.933' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'1 Year', CAST(N'2019-05-07T10:31:35.093' AS DateTime), @UserId )
	, (NEWID(),@CompanyId, N'5 years', CAST(N'2019-05-06T12:57:47.477' AS DateTime), @UserId )
	, (NEWID(),@CompanyId, N'6 Months', CAST(N'2019-05-07T09:50:17.440' AS DateTime), @UserId)
		
	)
	AS Source ([Id], [CompanyId], [LicenceTypeName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET 
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [LicenceTypeName] = Source.[LicenceTypeName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [LicenceTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES  ([Id], [CompanyId], [LicenceTypeName], [CreatedDateTime], [CreatedByUserId]);	  
	
	MERGE INTO [dbo].[ConsiderHours] AS Target 
	USING ( VALUES 
	(NEWID(), N'Estimated Hours', @CompanyId, CAST(N'2019-05-07T09:50:17.440' AS DateTime),@UserId,1,NULL)
	,(NEWID(), N'Logged Hours', @CompanyId, CAST(N'2019-05-06T12:57:47.477' AS DateTime),@UserId,NULL,1)
		)
	AS Source([Id],[ConsiderHourName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[IsEsimatedHours],[IsLoggedHours])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET 
	           [ConsiderHourName] = Source.[ConsiderHourName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[ConsiderHourName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[IsEsimatedHours],[IsLoggedHours]) VALUES ([Id],[ConsiderHourName],[CompanyId],[CreatedDateTime],[CreatedByUserId],[IsEsimatedHours],[IsLoggedHours]);	  
	
	MERGE INTO [dbo].[StatusReportingOption_New] AS Target
	USING ( VALUES
	       (NEWID(), N'Friday', N'Friday', 5, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Thursday', N'Thursday', 4, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Wednesday', N'Wednesday', 3, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Tuesday', N'Tuesday', 2, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Sunday', N'Sunday', 7, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Monday', N'Monday', 1, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Everyworkingday', N'Every working day', 8, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Saturday', N'Saturday', 6, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
		  ,(NEWID(), N'Lastworkingdayofthemonth', N'Last working day of the month', 9, @CompanyId, CAST(N'2018-10-04T12:44:37.380' AS DateTime), @UserId)
	)
	
	AS Source ([Id], [OptionName], [DisplayName], [SortOrder], [CompanyId], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [OptionName] = Source.[OptionName],
			   [DisplayName] = source.[DisplayName],
			   [SortOrder] = source.[SortOrder],
			   [CompanyId] = source.[CompanyId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
			   
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [OptionName], [DisplayName], [SortOrder], [CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [OptionName], [DisplayName], [SortOrder], [CompanyId], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[RelationShip] AS Target
	USING ( VALUES
	     (NEWID(), N'Child', CAST(N'2018-08-13 08:23:00.393' AS DateTime), @UserId,@CompanyId),
	     (NEWID(), N'Other', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId),
		 (NEWID(), N'Father', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId),
	     (NEWID(), N'Mother', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId),
	     (NEWID(), N'Brother', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId),
	     (NEWID(), N'Sister', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId),
	     (NEWID(), N'Guardian', CAST(N'2018-08-13 13:12:56.550' AS DateTime), @UserId,@CompanyId)
	)
	AS Source ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [RelationShipName] = Source.[RelationShipName],
	         [CreatedDateTime] = Source.[CreatedDateTime],
	         [CreatedByUserId] = Source.[CreatedByUserId],
	         [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId]) VALUES ([Id], [RelationShipName], [CreatedDateTime], [CreatedByUserId], [CompanyId]);
	
	--IF(@KeyValue <> 1)
	--BEGIN
	
	MERGE INTO [dbo].[EducationLevel] AS Target 
	USING ( VALUES 
	        (NEWID(), N'MBA',        @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'B.Tech',     @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'SSC',        @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'Intermediate',@CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'M.Tech',     @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'MCA',        @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	      )
	AS Source ([Id], [EducationLevel],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [EducationLevel] = Source.[EducationLevel],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [EducationLevel],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp]) VALUES ([Id], [EducationLevel],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp]);
	
	MERGE INTO [dbo].[ReportingMethod] AS Target 
	USING ( VALUES 
	        (NEWID(), N'Direct',@CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	      )
	AS Source ([Id], [ReportingMethodType],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [ReportingMethodType] = Source.[ReportingMethodType],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ReportingMethodType],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp]) VALUES ([Id], [ReportingMethodType],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp]);
	
	MERGE INTO [dbo].[MemberShip] AS Target 
	USING ( VALUES 
	        (NEWID(), N'Quaterly',@CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'Yearly',  @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	       ,(NEWID(), N'Monthly', @CompanyId,CAST(N'2019-06-27 17:56:04.940'AS DATETIME),@UserId,NULL)
	      
	      )
	AS Source ([Id], [MemberShipType],[CompanyId], [CreatedDateTime], [CreatedByUserId],[TimeStamp])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [MemberShipType] = Source.[MemberShipType],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CompanyId] = Source.[CompanyId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [MemberShipType],[CompanyId],[CreatedDateTime], [CreatedByUserId],[TimeStamp]) VALUES ([Id], [MemberShipType],[CompanyId],[CreatedDateTime], [CreatedByUserId],[TimeStamp]);
	
	MERGE INTO [dbo].[Language] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Telugu', CAST(N'2019-05-07T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Hindi', CAST(N'2019-05-06T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'English', CAST(N'2019-05-06T12:56:45.820' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [LanguageName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [LanguageName] = Source.[LanguageName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [LanguageName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [LanguageName], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[MaritalStatus] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Single', CAST(N'2019-05-15T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Married', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [MaritalStatus], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [MaritalStatus] = Source.[MaritalStatus],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [MaritalStatus], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [MaritalStatus], [CreatedDateTime], [CreatedByUserId]);       
	
	MERGE INTO [dbo].[Gender] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Female', CAST(N'2019-05-15T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Male', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Other', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [Gender], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [Gender] = Source.[Gender],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [Gender], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [Gender], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[Competency] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Poor', CAST(N'2019-05-15T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Basic', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Mother Tongue', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Good', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [CompetencyName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [CompetencyName] = Source.[CompetencyName],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [CompetencyName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [CompetencyName], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[Fluency] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Speaking', CAST(N'2019-05-15T09:50:17.440' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Reading', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	, (NEWID(),@CompanyId, N'Writing', CAST(N'2019-05-15T12:57:47.477' AS DateTime), @UserId)
	) 
	AS Source ([Id], [CompanyId], [FluencyName], [CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [FluencyName] = Source.[FluencyName],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [FluencyName], [CreatedDateTime], [CreatedByUserId]) VALUES([Id], [CompanyId], [FluencyName], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[ContractType] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'Full-Time',  CAST(N'2019-05-06T12:27:55.420' AS DateTime), @UserId, NULL, NULL)
	, (NEWID(),@CompanyId, N'Part-Time',  CAST(N'2019-05-06T12:28:25.567' AS DateTime), @UserId, NULL, NULL)
	) 
	AS Source ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [ContractTypeName] = Source.[ContractTypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [TerminationDate] = Source.[TerminationDate],
			   [TerminationReason] = Source.[TerminationReason]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason]) VALUES ([Id], [CompanyId], [ContractTypeName], [CreatedDateTime], [CreatedByUserId], [TerminationDate], [TerminationReason]);	   
	
	MERGE INTO [dbo].[PaymentMethod] AS Target 
	USING ( VALUES 
	  (NEWID(),@CompanyId, N'NEFT', CAST(N'2019-05-06T16:40:33.207' AS DateTime), @UserId, NULL)
	, (NEWID(),@CompanyId, N'ATM', CAST(N'2019-05-06T16:38:32.420' AS DateTime), @UserId, NULL)
	) 
	AS Source ([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId]  = Source.[CompanyId],
	           [PaymentMethodName] = Source.[PaymentMethodName],
		       [InActiveDateTime] = Source.[InActiveDateTime],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]) VALUES ([Id], [CompanyId], [PaymentMethodName], [CreatedDateTime], [CreatedByUserId], [InActiveDateTime]);	   
	
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
			 (NEWID(), @CompanyId, N'MaxFileSize', N'20971520', N'Maximum file size in bytes', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId),
			 (NEWID(), @CompanyId, N'FileExtensions', N'image/*,application/*,text/*', N'File extensions', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId),
			 (NEWID(), @CompanyId, N'MaxStoreSize', N'1073741824', N'Maximum store size for the company in bytes', CAST(N'2019-03-21T11:37:09.943' AS DateTime), @UserId)
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
	
	MERGE INTO [dbo].[TestRailConfiguration] AS Target
	USING ( VALUES	      
			(NEWID(), N'Test case status changed', N'TestCaseStatusChanged', 0, CAST(N'2019-09-15T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Run created or updated', N'TestRunCreatedOrUpdated', 0, CAST(N'2019-09-16T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Version created or updated', N'MilestoneCreatedOrUpdated', 0, CAST(N'2019-09-13T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Test case created or updated', N'TestCaseCreatedOrUpdated', 0, CAST(N'2019-09-18T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Scenario created or updated', N'TestSuiteCreatedOrUpdated', 0, CAST(N'2019-09-17T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Test report created or updated', N'TestRepoReportCreatedOrUpdated', 0, CAST(N'2019-09-12T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Test case viewed', N'TestCaseViewed', 0, CAST(N'2019-09-11T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Bugs created', N'BugsCreated', 0, CAST(N'2019-09-14T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	       ,(NEWID(), N'Scenario section created or updated', N'TestSuiteSectionCreatedOrUpdated', 0, CAST(N'2019-09-10T16:21:13.007' AS DateTime), @UserId, @CompanyId)
	)	
	AS Source ([Id], [ConfigurationName],[ConfigurationShortName], [ConfigurationTime],[CreatedDateTime], [CreatedByUserId],[CompanyId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CompanyId] = Source.[CompanyId],
			   [ConfigurationName] = source.[ConfigurationName],
			   [ConfigurationShortName] = source.[ConfigurationShortName],
			   [ConfigurationTime] = source.[ConfigurationTime],
			   [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id],[CompanyId], [ConfigurationName],[ConfigurationShortName], [ConfigurationTime],[CreatedDateTime], [CreatedByUserId]) 
	VALUES ([Id],[CompanyId], [ConfigurationName],[ConfigurationShortName], [ConfigurationTime],[CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[InterviewLevel] AS TARGET
	USING( VALUES
			(NEWID(),N'System test',1,@CompanyId,CAST(N'2019-10-31 06:20:28.687' AS DateTime), @UserId,NULL)
	        ,(NEWID(),N'TR-1',2,@CompanyId,CAST(N'2019-10-31 06:20:28.687' AS DateTime), @UserId,NULL)
	        ,(NEWID(),N'TR-2',3,@CompanyId,CAST(N'2019-10-31 06:20:28.687' AS DateTime), @UserId,NULL)
	        ,(NEWID(),N'HR',4,@CompanyId,CAST(N'2019-10-31 06:20:28.687' AS DateTime), @UserId,NULL)
	)
	AS Source ([Id],[InterviewLevelName],[Order],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [InterviewLevelName] = Source.[InterviewLevelName],
	           [Order] = Source.[Order],
	           [CompanyId] = Source.[CompanyId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id],[InterviewLevelName],[Order],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]) VALUES ([Id],[InterviewLevelName],[Order],[CompanyId],[CreatedDateTime],[CreatedByUserId],[InActiveDateTime]);
	
	MERGE INTO [dbo].[Store] AS Target
USING ( VALUES
        (NEWID(), (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL) , 1, 1, GETDATE(), @UserId, @CompanyId, NULL)
       ,(NEWID(), (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' doc store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL) , 0, 0, GETDATE(), @UserId, @CompanyId, NULL)
)
AS Source ([Id], [StoreName], [IsDefault], [IsCompany], [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime])
ON Target.Id = Source.Id  
WHEN MATCHED THEN
UPDATE SET [StoreName] = Source.[StoreName],
          [IsDefault] = Source.[IsDefault],
          [IsCompany] = Source.[IsCompany],
          [CreatedByUserId] = Source.[CreatedByUserId],
          [CreatedDateTime] = Source.[CreatedDateTime],
          [CompanyId] = Source.[CompanyId],
          [InActiveDateTime] = Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN
INSERT ([Id], [StoreName], [IsDefault], [IsCompany], [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime]) VALUES ([Id], [StoreName], [IsDefault], [IsCompany],  [CreatedDateTime], [CreatedByUserId], [CompanyId], [InActiveDateTime]);

	DECLARE @StoreId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Store WHERE IsDefault = 1 AND IsCompany = 1 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
	
	DECLARE @UserStoreId UNIQUEIDENTIFIER = (SELECT TOP 1 Id FROM Store WHERE IsDefault = 1 AND IsCompany = 0 AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)
	
	MERGE INTO [dbo].[Folder] AS Target 
	USING ( VALUES
			(NEWID(), N'Food order management'	, NULL, GETDATE(), @UserId, @StoreId, NULL)
		  ) 
	AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FolderName] = Source.[FolderName],
	           [ParentFolderId] = Source.[ParentFolderId],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [StoreId] = Source.[StoreId],
			   [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);

	MERGE INTO [dbo].[Folder] AS Target 
	USING ( VALUES
	        (NEWID(), N'Project management'		, NULL, GETDATE(), @UserId, @StoreId, NULL),
			(NEWID(), N'HR management'			, NULL, GETDATE(), @UserId, @StoreId, NULL)
		  ) 
	AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FolderName] = Source.[FolderName],
	           [ParentFolderId] = Source.[ParentFolderId],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [StoreId] = Source.[StoreId],
			   [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);
	
	MERGE INTO [dbo].[Folder] AS Target 
	USING ( VALUES
	        (NEWID(), N'Personal details'           , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Licence details'            , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Emergency contacts details' , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Immigration details'        , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Contract details'           , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Salary details'             , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Work experience details'    , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Education details'          , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Membership details'         , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL),
	        (NEWID(), N'Leaves'                     , (SELECT Id FROM Folder WHERE FolderName ='HR management' AND ParentFolderId IS NULL AND StoreId = @StoreId), GETDATE(), @UserId, @StoreId, NULL)
	) 
	AS Source ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [FolderName] = Source.[FolderName],
	           [ParentFolderId] = Source.[ParentFolderId],
	           [CreatedByUserId] = Source.[CreatedByUserId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [StoreId] = Source.[StoreId],
	           [InActiveDateTime] = Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]) VALUES ([Id], [FolderName], [ParentFolderId], [CreatedDateTime], [CreatedByUserId], [StoreId], [InActiveDateTime]);
	
	--Script to insert adhoc workflow
	
	MERGE INTO [dbo].[Project] AS Target 
	USING (VALUES 
			 (NEWID(),@CompanyId, N'Adhoc project',CAST(N'2019-07-08T12:12:41.667' AS DateTime), @UserId,NULL)
			)
	AS Source ([Id], [CompanyId], [ProjectName], [CreatedDateTime], [CreatedByUserId], [InactiveDateTime])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [CompanyId] = Source.[CompanyId],
			   [ProjectName] = Source.[ProjectName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [InactiveDateTime] = Source.[InactiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [ProjectName], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime]) 
	VALUES ([Id], [CompanyId], [ProjectName],[CreatedDateTime], [CreatedByUserId],[InactiveDateTime]);	
	
	MERGE INTO [dbo].[Goal] AS Target 
	USING (VALUES 
			 (NEWID(), (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Adhoc project'),(SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'SuperAgile' AND CompanyId = @CompanyId), N'Adhoc Goal',N'Adhoc Goal', 0,@UserId, GETDATE(),@UserId, NULL,'Adhoc')
			)
	AS Source ([Id], [ProjectId],[BoardTypeId],[GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [ProjectId] = Source.[ProjectId],
			   [GoalName] = Source.[GoalName],
			   [GoalShortName] = Source.[GoalShortName],
			   [GoalResponsibleUserId] = Source.[GoalResponsibleUserId],
			   [BoardTypeId] = Source.[BoardTypeId],
			   [IsLocked] = Source.[IsLocked],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [InactiveDateTime] = Source.[InactiveDateTime],
			   [GoalUniqueName] = Source.[GoalUniqueName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ProjectId],[BoardTypeId], [GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName]) 
	VALUES ([Id], [ProjectId],[BoardTypeId], [GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId],[CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName]);	
	
	MERGE INTO [dbo].[LinkUserStoryType] AS Target 
	USING ( VALUES 
				(NEWID(), N'Created by', @CompanyId, CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Created', @CompanyId,CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Is duplicated by', @CompanyId, CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Duplicates', @CompanyId,CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Is caused by', @CompanyId, CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Causes', @CompanyId,CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Relates to', @CompanyId, CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Is tested by', @CompanyId,CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Tests', @CompanyId, CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId),
				(NEWID(), N'Is blocked by', @CompanyId,CAST(N'2019-04-09 19:19:02.537' AS DateTime), @UserId)
				)
	AS Source ([Id],[LinkUserStoryTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [LinkUserStoryTypeName] = Source.[LinkUserStoryTypeName],
	           [CompanyId] = Source.[CompanyId],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[LinkUserStoryTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId]) 
	VALUES ([Id],[LinkUserStoryTypeName],[CompanyId],[CreatedDateTime],[CreatedByUserId]);	 
	
	MERGE INTO [dbo].[ApiKey] AS Target 
	USING ( VALUES
	        (NEWID(), N'kU9vRVm9T1lFMbi3duO1', CAST(N'2022-08-13 08:23:00.393' AS DateTime),@CompanyId,CAST(N'2018-08-13 08:23:00.393' AS DateTime),@UserId)		
	) 
	AS Source ([Id], [Key], [ExpiryDate], [CompanyId], [CreatedDateTime], [CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
	           [Key] = Source.[Key],
			   [ExpiryDate] = Source.[ExpiryDate],
	           [CompanyId] = Source.[CompanyId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [Key], [ExpiryDate], [CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [Key], [ExpiryDate], [CompanyId], [CreatedDateTime], [CreatedByUserId]);
	
	MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
	USING ( VALUES
	 (NEWID(),N'Project',N'Goal',N'Work item', CAST(N'2019-07-31T00:00:00.000' AS DateTime), @UserId, @CompanyId,N'Employee', N'Deadline',N'Projects',N'Goals',N'Work items',N'Employees', N'Deadlines', N'Scenario', N'Scenarios', N'Run', N'Runs', N'Version', N'Versions', N'TestReport', N'Test Reports', N'Estimated time', N'Estimation', N'Estimations', N'Audit', N'Audits', N'Conduct', N'Conducts', N'Action', N'Actions',N'Audit report', N'Audit reports', N'Timeline', N'Audit activity', N'Audit analytics')
	)
	AS Source ([Id], [ProjectLabel],[GoalLabel],[UserStoryLabel], [CreatedDateTime], [CreatedByUserId], [CompanyId],[EmployeeLabel],[DeadlineLabel],[ProjectsLabel],[GoalsLabel],[UserStoriesLabel],[EmployeesLabel],[DeadlinesLabel],[ScenarioLabel],[ScenariosLabel],[RunLabel]
	,[RunsLabel],[VersionLabel],[VersionsLabel],[TestReportLabel],[TestReportsLabel],[EstimatedTimeLabel],[EstimationLabel],[EstimationsLabel],[AuditLabel],[AuditsLabel],[ConductLabel],[conductsLabel],[ActionLabel],[ActionsLabel],[AuditReportLabel],[AuditReportsLabel],[TimelineLabel],[AuditActivityLabel],[AuditAnalyticsLabel])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET 
	           [ProjectLabel]         = source.[ProjectLabel],   
	           [GoalLabel]           = source.[GoalLabel],
			   [UserStoryLabel]      = source.[UserStoryLabel],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId]       = Source.[CompanyId],
			   [EmployeeLabel]  = Source.[EmployeeLabel],
			   [DeadlineLabel]  = Source.[DeadlineLabel],
			   [ProjectsLabel]         = source.[ProjectsLabel],   
	           [GoalsLabel]           = source.[GoalsLabel],
			   [UserStoriesLabel]      = source.[UserStoriesLabel],
			   [EmployeesLabel]  = Source.[EmployeesLabel],
			   [DeadlinesLabel]  = Source.[DeadlinesLabel],
			   [ScenarioLabel]  = Source.[ScenarioLabel],
			   [ScenariosLabel]  = Source.[ScenariosLabel],
			   [RunLabel]  = Source.[RunLabel],
			   [RunsLabel]  = Source.[RunsLabel],
			   [VersionLabel]  = Source.[VersionLabel],
			   [VersionsLabel]  = Source.[VersionsLabel],
			   [TestReportLabel]  = Source.[TestReportLabel],
			   [TestReportsLabel]  = Source.[TestReportsLabel],
			   [EstimatedTimeLabel] = Source.[EstimatedTimeLabel],
			   [EstimationLabel] = Source.[EstimationLabel],
			   [EstimationsLabel] = Source.[EstimationsLabel],
			   [AuditLabel] = Source.[AuditLabel],
			   [AuditsLabel] = Source.[AuditsLabel],
			   [ConductLabel] = Source.[ConductLabel],
			   [ConductsLabel] = Source.[ConductsLabel],
			   [ActionLabel] = Source.[ActionLabel],
			   [ActionsLabel] = Source.[ActionsLabel],
			   [AuditReportLabel] = Source.[AuditReportLabel],
			   [AuditReportsLabel] = Source.[AuditReportsLabel],
			   [TimelineLabel] = Source.[TimelineLabel],
			   [AuditActivityLabel] = Source.[AuditActivityLabel],
			   [AuditAnalyticsLabel] = Source.[AuditAnalyticsLabel]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [ProjectLabel],[GoalLabel],[UserStoryLabel], [CreatedDateTime], [CreatedByUserId], [CompanyId],[EmployeeLabel],[DeadlineLabel],[ProjectsLabel],[GoalsLabel],[UserStoriesLabel],[EmployeesLabel],[DeadlinesLabel],[ScenarioLabel],[ScenariosLabel],[RunLabel],[RunsLabel],[VersionLabel],[VersionsLabel],[TestReportLabel],[TestReportsLabel],[EstimatedTimeLabel],[EstimationLabel],[EstimationsLabel],[AuditLabel],[AuditsLabel],[ConductLabel],[conductsLabel],[ActionLabel],[ActionsLabel],[AuditReportLabel],[AuditReportsLabel],[TimelineLabel],[AuditActivityLabel],[AuditAnalyticsLabel])
	VALUES ([Id], [ProjectLabel],[GoalLabel],[UserStoryLabel], [CreatedDateTime], [CreatedByUserId], [CompanyId],[EmployeeLabel],[DeadlineLabel],[ProjectsLabel],[GoalsLabel],[UserStoriesLabel],[EmployeesLabel],[DeadlinesLabel],[ScenarioLabel],[ScenariosLabel],[RunLabel],[RunsLabel],[VersionLabel],[VersionsLabel],[TestReportLabel],[TestReportsLabel],[EstimatedTimeLabel],[EstimationLabel],[EstimationsLabel],[AuditLabel],[AuditsLabel],[ConductLabel],[conductsLabel],[ActionLabel],[ActionsLabel],[AuditReportLabel],[AuditReportsLabel],[TimelineLabel],[AuditActivityLabel],[AuditAnalyticsLabel]);
	
	MERGE INTO EncashmentType AS TARGET
	USING(VALUES
		  (NEWID(), N'Yearly',         @CompanyId, N'2019-08-07 13:16:18.460', @UserId),
		  (NEWID(), N'Lastworkingday',	@CompanyId, N'2019-08-07 13:16:18.460', @UserId),
		  (NEWID(), N'Half-yearly',  	@CompanyId, N'2019-08-07 13:16:18.460', @UserId)
	)
	AS Source(Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId)
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET EncashmentType = Source.EncashmentType,
			   CompanyId      = Source.CompanyId,
		       CreatedDateTime = Source.CreatedDateTime,
		       CreatedByUserId = Source.CreatedByUserId
	WHEN NOT MATCHED THEN
	INSERT (Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId) VALUES (Id,EncashmentType,CompanyId,CreatedDateTime,CreatedByUserId);	
	
	MERGE INTO [dbo].[AutomatedWorkFlow] AS Target 
	USING (VALUES
	(NEWID(),'Task Delay Notification Workflow',N'<?xml version="1.0" encoding="UTF-8"?>
	<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_0i8pmb0" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.5.0">
	  <bpmn:process id="SendTaskDelayEmailActivity" name="SendTaskDelayEmailActivity" isExecutable="true">
	    <bpmn:startEvent id="IntermediateThrowEvent_0e767yu">
	      <bpmn:outgoing>SequenceFlow_0du0wmt</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_003msax">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:startEvent>
	    <bpmn:serviceTask id="Task_0e8bdbh" name="Send email to assignees if their tasks crossed deadlines" camunda:type="external" camunda:topic="SendTaskDelayEmailActivity">
	      <bpmn:extensionElements>
	        <camunda:inputOutput>
	          <camunda:inputParameter name="CompanyName">Snovasys Software Solutions</camunda:inputParameter>
	        </camunda:inputOutput>
	      </bpmn:extensionElements>
	      <bpmn:incoming>SequenceFlow_0du0wmt</bpmn:incoming>
	      <bpmn:incoming>SequenceFlow_0r0zpbf</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_196a3ul</bpmn:outgoing>
	    </bpmn:serviceTask>
	    <bpmn:sequenceFlow id="SequenceFlow_0du0wmt" sourceRef="IntermediateThrowEvent_0e767yu" targetRef="Task_0e8bdbh" />
	    <bpmn:intermediateCatchEvent id="IntermediateThrowEvent_1kxsgx4">
	      <bpmn:incoming>SequenceFlow_196a3ul</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_0r0zpbf</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_03rusg8">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:intermediateCatchEvent>
	    <bpmn:sequenceFlow id="SequenceFlow_196a3ul" sourceRef="Task_0e8bdbh" targetRef="IntermediateThrowEvent_1kxsgx4" />
	    <bpmn:sequenceFlow id="SequenceFlow_0r0zpbf" sourceRef="IntermediateThrowEvent_1kxsgx4" targetRef="Task_0e8bdbh" />
	  </bpmn:process>
	  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
	    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="SendTaskDelayEmailActivity">
	      <bpmndi:BPMNShape id="StartEvent_19aeo96_di" bpmnElement="IntermediateThrowEvent_0e767yu">
	        <dc:Bounds x="152" y="159" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNShape id="ServiceTask_1alc9bi_di" bpmnElement="Task_0e8bdbh">
	        <dc:Bounds x="380" y="150" width="100" height="80" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_0du0wmt_di" bpmnElement="SequenceFlow_0du0wmt">
	        <di:waypoint x="170" y="159" />
	        <di:waypoint x="170" y="120" />
	        <di:waypoint x="430" y="120" />
	        <di:waypoint x="430" y="150" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNShape id="IntermediateCatchEvent_02qdoh5_di" bpmnElement="IntermediateThrowEvent_1kxsgx4">
	        <dc:Bounds x="402" y="302" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_196a3ul_di" bpmnElement="SequenceFlow_196a3ul">
	        <di:waypoint x="430" y="230" />
	        <di:waypoint x="430" y="266" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="420" y="302" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNEdge id="SequenceFlow_0r0zpbf_di" bpmnElement="SequenceFlow_0r0zpbf">
	        <di:waypoint x="420" y="302" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="390" y="266" />
	        <di:waypoint x="390" y="230" />
	      </bpmndi:BPMNEdge>
	    </bpmndi:BPMNPlane>
	  </bpmndi:BPMNDiagram>
	</bpmn:definitions>
	',@CompanyId,CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
	,(NEWID(),'Task Delay Explanation Task Creation WorkFlow',N'<?xml version="1.0" encoding="UTF-8"?>
	<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_0i8pmb0" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.5.0">
	  <bpmn:process id="AssignExplinationTaskActivityForDelayedTaskUsers" name="AssignExplinationTaskActivityForDelayedTaskUsers" isExecutable="true">
	    <bpmn:startEvent id="IntermediateThrowEvent_0e767yu">
	      <bpmn:outgoing>SequenceFlow_0du0wmt</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_003msax">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:startEvent>
	    <bpmn:serviceTask id="Task_0e8bdbh" name="Create a new explination task to the user when the task crosses the deadline" camunda:type="external" camunda:topic="AssignExplinationTaskActivityForDelayedTaskUsers">
	      <bpmn:extensionElements>
	        <camunda:inputOutput>
	          <camunda:inputParameter name="CompanyName">Snovasys Software Solutions</camunda:inputParameter>
	        </camunda:inputOutput>
	      </bpmn:extensionElements>
	      <bpmn:incoming>SequenceFlow_0du0wmt</bpmn:incoming>
	      <bpmn:incoming>SequenceFlow_0r0zpbf</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_196a3ul</bpmn:outgoing>
	    </bpmn:serviceTask>
	    <bpmn:sequenceFlow id="SequenceFlow_0du0wmt" sourceRef="IntermediateThrowEvent_0e767yu" targetRef="Task_0e8bdbh" />
	    <bpmn:intermediateCatchEvent id="IntermediateThrowEvent_1kxsgx4">
	      <bpmn:incoming>SequenceFlow_196a3ul</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_0r0zpbf</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_03rusg8">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:intermediateCatchEvent>
	    <bpmn:sequenceFlow id="SequenceFlow_196a3ul" sourceRef="Task_0e8bdbh" targetRef="IntermediateThrowEvent_1kxsgx4" />
	    <bpmn:sequenceFlow id="SequenceFlow_0r0zpbf" sourceRef="IntermediateThrowEvent_1kxsgx4" targetRef="Task_0e8bdbh" />
	  </bpmn:process>
	  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
	    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="AssignExplinationTaskActivityForDelayedTaskUsers">
	      <bpmndi:BPMNShape id="StartEvent_19aeo96_di" bpmnElement="IntermediateThrowEvent_0e767yu">
	        <dc:Bounds x="152" y="159" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNShape id="ServiceTask_1alc9bi_di" bpmnElement="Task_0e8bdbh">
	        <dc:Bounds x="380" y="150" width="100" height="80" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_0du0wmt_di" bpmnElement="SequenceFlow_0du0wmt">
	        <di:waypoint x="170" y="159" />
	        <di:waypoint x="170" y="120" />
	        <di:waypoint x="430" y="120" />
	        <di:waypoint x="430" y="150" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNShape id="IntermediateCatchEvent_02qdoh5_di" bpmnElement="IntermediateThrowEvent_1kxsgx4">
	        <dc:Bounds x="402" y="302" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_196a3ul_di" bpmnElement="SequenceFlow_196a3ul">
	        <di:waypoint x="430" y="230" />
	        <di:waypoint x="430" y="266" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="420" y="302" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNEdge id="SequenceFlow_0r0zpbf_di" bpmnElement="SequenceFlow_0r0zpbf">
	        <di:waypoint x="420" y="302" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="390" y="266" />
	        <di:waypoint x="390" y="230" />
	      </bpmndi:BPMNEdge>
	    </bpmndi:BPMNPlane>
	  </bpmndi:BPMNDiagram>
	</bpmn:definitions>
	',@CompanyId,CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
	,(NEWID(),'Task Delay Manager Notification Workflow',N'<?xml version="1.0" encoding="UTF-8"?>
	<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_0i8pmb0" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.5.0">
	  <bpmn:process id="SendTaskDelayEscalationEmailActivity" name="SendTaskDelayEscalationEmailActivity" isExecutable="true">
	    <bpmn:startEvent id="IntermediateThrowEvent_0e767yu">
	      <bpmn:outgoing>SequenceFlow_0du0wmt</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_003msax">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:startEvent>
	    <bpmn:serviceTask id="Task_0e8bdbh" name="Send escalation email to project manager if the task delayed" camunda:type="external" camunda:topic="SendTaskDelayEmailActivity">
	      <bpmn:extensionElements>
	        <camunda:inputOutput>
	          <camunda:inputParameter name="CompanyName">Snovasys Software Solutions</camunda:inputParameter>
	        </camunda:inputOutput>
	      </bpmn:extensionElements>
	      <bpmn:incoming>SequenceFlow_0du0wmt</bpmn:incoming>
	      <bpmn:incoming>SequenceFlow_0r0zpbf</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_196a3ul</bpmn:outgoing>
	    </bpmn:serviceTask>
	    <bpmn:sequenceFlow id="SequenceFlow_0du0wmt" sourceRef="IntermediateThrowEvent_0e767yu" targetRef="Task_0e8bdbh" />
	    <bpmn:intermediateCatchEvent id="IntermediateThrowEvent_1kxsgx4">
	      <bpmn:incoming>SequenceFlow_196a3ul</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_0r0zpbf</bpmn:outgoing>
	      <bpmn:timerEventDefinition id="TimerEventDefinition_03rusg8">
	        <bpmn:timeCycle xsi:type="bpmn:tFormalExpression">R1/PT1M</bpmn:timeCycle>
	      </bpmn:timerEventDefinition>
	    </bpmn:intermediateCatchEvent>
	    <bpmn:sequenceFlow id="SequenceFlow_196a3ul" sourceRef="Task_0e8bdbh" targetRef="IntermediateThrowEvent_1kxsgx4" />
	    <bpmn:sequenceFlow id="SequenceFlow_0r0zpbf" sourceRef="IntermediateThrowEvent_1kxsgx4" targetRef="Task_0e8bdbh" />
	  </bpmn:process>
	  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
	    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="SendTaskDelayEscalationEmailActivity">
	      <bpmndi:BPMNShape id="StartEvent_19aeo96_di" bpmnElement="IntermediateThrowEvent_0e767yu">
	        <dc:Bounds x="152" y="159" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNShape id="ServiceTask_1alc9bi_di" bpmnElement="Task_0e8bdbh">
	        <dc:Bounds x="380" y="150" width="100" height="80" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_0du0wmt_di" bpmnElement="SequenceFlow_0du0wmt">
	        <di:waypoint x="170" y="159" />
	        <di:waypoint x="170" y="120" />
	        <di:waypoint x="430" y="120" />
	        <di:waypoint x="430" y="150" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNShape id="IntermediateCatchEvent_02qdoh5_di" bpmnElement="IntermediateThrowEvent_1kxsgx4">
	        <dc:Bounds x="402" y="302" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_196a3ul_di" bpmnElement="SequenceFlow_196a3ul">
	        <di:waypoint x="430" y="230" />
	        <di:waypoint x="430" y="266" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="420" y="302" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNEdge id="SequenceFlow_0r0zpbf_di" bpmnElement="SequenceFlow_0r0zpbf">
	        <di:waypoint x="420" y="302" />
	        <di:waypoint x="420" y="266" />
	        <di:waypoint x="390" y="266" />
	        <di:waypoint x="390" y="230" />
	      </bpmndi:BPMNEdge>
	    </bpmndi:BPMNPlane>
	  </bpmndi:BPMNDiagram>
	</bpmn:definitions>
	',@CompanyId,CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
	,(NEWID(),'Task Assigned To User Workflow','<?xml version="1.0" encoding="UTF-8"?>
	<bpmn:definitions xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1idjlgm" targetNamespace="http://bpmn.io/schema/bpmn" exporter="Camunda Modeler" exporterVersion="3.5.0">
	  <bpmn:process id="Process_0s9s4j8" isExecutable="true">
	    <bpmn:startEvent id="StartEvent_1">
	      <bpmn:outgoing>SequenceFlow_0r1ak6y</bpmn:outgoing>
	    </bpmn:startEvent>
	    <bpmn:sequenceFlow id="SequenceFlow_0r1ak6y" sourceRef="StartEvent_1" targetRef="Task_1j9m5v3" />
	    <bpmn:serviceTask id="Task_1j9m5v3" name="Send Notification to assigned user" camunda:type="external" camunda:topic="SendTaskAssignedNotification">
	      <bpmn:incoming>SequenceFlow_0r1ak6y</bpmn:incoming>
	      <bpmn:outgoing>SequenceFlow_0dg10cp</bpmn:outgoing>
	    </bpmn:serviceTask>
	    <bpmn:endEvent id="EndEvent_0fzw2lx">
	      <bpmn:incoming>SequenceFlow_0dg10cp</bpmn:incoming>
	    </bpmn:endEvent>
	    <bpmn:sequenceFlow id="SequenceFlow_0dg10cp" sourceRef="Task_1j9m5v3" targetRef="EndEvent_0fzw2lx" />
	  </bpmn:process>
	  <bpmndi:BPMNDiagram id="BPMNDiagram_1">
	    <bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Process_0s9s4j8">
	      <bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1">
	        <dc:Bounds x="179" y="102" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_0r1ak6y_di" bpmnElement="SequenceFlow_0r1ak6y">
	        <di:waypoint x="215" y="120" />
	        <di:waypoint x="350" y="120" />
	      </bpmndi:BPMNEdge>
	      <bpmndi:BPMNShape id="ServiceTask_0lgxwb9_di" bpmnElement="Task_1j9m5v3">
	        <dc:Bounds x="350" y="80" width="100" height="80" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNShape id="EndEvent_0fzw2lx_di" bpmnElement="EndEvent_0fzw2lx">
	        <dc:Bounds x="592" y="102" width="36" height="36" />
	      </bpmndi:BPMNShape>
	      <bpmndi:BPMNEdge id="SequenceFlow_0dg10cp_di" bpmnElement="SequenceFlow_0dg10cp">
	        <di:waypoint x="450" y="120" />
	        <di:waypoint x="592" y="120" />
	      </bpmndi:BPMNEdge>
	    </bpmndi:BPMNPlane>
	  </bpmndi:BPMNDiagram>
	</bpmn:definitions>
	',@CompanyId,CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
	)
	AS Source ([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
	           [WorkflowName] = Source.[WorkflowName],
	           [WorkflowXml] = Source.[WorkflowXml],
	           [CompanyId] = Source.[CompanyId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId]);
	
	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Pipeline work', N'This app provides the list of the backlog work items of all the employees in the company with the details like goal name, work item and deadline date.Users can sort the work items from the list, search individual column. Also we can download the information in the app and can change the visualization', N'SELECT G.GoalName [Goal name ],S.SprintName [Sprint name] ,US.UserStoryName [Work item name], DeadLineDate [Deadline date] 
              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
			  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
	                                      AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 1)
							   WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							                    )  AND OwnerUserId = ''@OperationsPerformedBy''
												AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND US.DeadLineDate > GETDATE()) OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))
', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
	, (NEWID(), N'Company productivity', N'This app displays the overall company productivity for the current month and also users can change the visualization', N'					   SELECT ISNULL(SUM(ISNULL(EstimatedTime,0)),0) [ This month company productivity ] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))	', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
	, (NEWID(), N'Goals not ontrack', N'This app displays the count of active goals which are not on track and also users can change the visualization', N'select COUNT(1)[Goals not ontrack] from Goal G INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id 
	                                       AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
								INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	         WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
	, (NEWID(), N'Project wise missed bugs count', N'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N'SELECT ProjectName ,StatusCounts
	                          from(
					SELECT P.ProjectName,COUNT(1) BugsCount FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 AND G.ParkedDateTime IS NULL
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  GROUP BY ProjectName
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BugsCount) 
	                                    )p', @CompanyId, @UserId, CAST(N'2020-01-17T06:57:02.987' AS DateTime))
	, (NEWID(), N'Food orders', N'This app provides the overview of the food order bills for each month. it will display the months on y-axis and bill amount on x-axis.Also users can download the information in the app and can change the visualization of the app.', N'  SELECT T.[Month],SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''MMM-yy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FOS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	  )t GROUP BY T.[Month]', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Active goals', N'This app displays the count of active goals in the company and also users can change the visualization', N'SELECT COUNT(1) [Active goals] FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                     INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	', @CompanyId, @UserId, CAST(N'2020-01-03T09:27:30.840' AS DateTime))
	, (NEWID(), N'Assigned, UnAssigned, Damaged Assets %', N'This app provides the overview of the assigned, unassigned and damaged assets all over the company in a pie chart.Also users can download the information in the app and can change the visualization of the app.', N'
						       SELECT StatusCount ,StatusCounts
	                          from
							  (SELECT CAST((T.[Damaged asssets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END *1.0))*100 AS decimal(10,2)) [Damaged asssets],
	       CAST(([Unassigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Unassigned assets],
		   CAST(([Assigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Assigned assets] 
	   FROM(SELECT COUNT(CASE WHEN A.IsWriteOff = 1 THEN 1 END )[Damaged asssets]
	   ,COUNT(CASE WHEN AE.AssetId IS NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND A.IsEmpty = 1 THEN 1 END )[Unassigned assets],
	    COUNT(CASE WHEN AE.AssetId IS NOT NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) THEN 1 END )[Assigned assets],
		COUNT(1) [Total assets]
			 FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId AND S.InactiveDateTime IS NULL
			              LEFT JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AE.AssignedDateTo IS NULL
	                   WHERE S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						   )T
	                            
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([Damaged asssets],[Unassigned assets],[Assigned assets]) 
	                                    )p', @CompanyId, @UserId, CAST(N'2020-01-17T11:47:29.037' AS DateTime))
	, (NEWID(), N'Canteen Items count', N'This app displays the count of items that are available in the canteen for the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Canteen Items count] FROM CanteenFoodItem 
	WHERE CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL) AND ActiveTo IS NULL		', @CompanyId, @UserId, CAST(N'2020-01-17T03:54:50.633' AS DateTime))
	, (NEWID(), N'Overall activity ', N'This app provides the graphical representation of all the activities performed on the site. It displays the dates on x-axis and the overall activity count on y-axis.Also users can download the information in the app and can change the visualization of the app.', N'SELECT CAST(A.CreatedDateTime AS date) [Date],COUNT(1) ActivityRecordsCount FROM [Audit]A INNER JOIN [USER]U ON U.Id = A.CreatedByUserId AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 WHERE FORMAT(A.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') GROUP BY CAST(A.CreatedDateTime AS date) 
	', @CompanyId, @UserId, CAST(N'2019-12-14T08:00:29.483' AS DateTime))
	, (NEWID(), N'All versions', N'This app displays all the milestones across all the projects in the company with details like number of test cases blocked, Failed,Passed, Retested,Untested with its percentages and can filter, sort the information in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT M.[Title] [Milestone name],
							        CAST(M.CreatedDateTime AS DateTime) [Created on],
							        ZOuter.BlockedCount AS [Blocked count],
							        ZOuter.BlockedPercent AS [Blocked percent],
							        ZOuter.FailedCount AS [Failed count],
							        ZOuter.FailedPercent AS [Failed percent],
							        ZOuter.PassedCount AS [Passed count],
							        ZOuter.PassedPercent AS [Passed percent],
							        ZOuter.RetestCount AS [Retest count],
							        ZOuter.RetestPercent AS [Restest percent],
							        ZOuter.UntestedCount AS [Untested count],
							        ZOuter.UntestedPercent AS [Untested percent]
							 FROM Milestone M INNER JOIN  Project P ON P.Id = M.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND M.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND p.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        LEFT JOIN	
								   (SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
								      T.TotalCount,
									  T.MilestoneId
			                       FROM 
								   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
										  ,TR.MilestoneId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
				                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
				                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
										GROUP BY TR.MilestoneId)T)ZOuter ON M.Id = ZOuter.MilestoneId and M.InActiveDateTime IS NULL
										WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')', @CompanyId, @UserId, CAST(N'2019-12-11T13:04:21.700' AS DateTime))
	, (NEWID(), N'Employee assigned work items', N'This app provides the list of all the employees along with their assigned work items with details like employee name, workitem and goal name.Also users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],US.UserStoryName As [Work item] ,G.GoalName [Goal name],S.SprintName [Sprint name]
	         FROM [User]U INNER JOIN UserStory US ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                      INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId  AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
						  WHERE U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						        AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
									', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'This month credited employees', N'This app displays the count of employees for whom the canteen amount was credited in the current month.Users can  change the visualization of the app.', N'SELECT COUNT(1)[This month credited employees] FROM
	(SELECT CreditedToUserId FROM UserCanteenCredit UCC INNER JOIN [User]U ON U.Id = UCC.CreditedByUserId AND UCC.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	            WHERE FORMAT(UCC.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				GROUP BY CreditedToUserId)T', @CompanyId, @UserId, CAST(N'2020-01-17T04:01:42.033' AS DateTime))
	, (NEWID(), N'Red goals list', N'This app provides the list of all the goals in which the work items are not completed as per the given deadlines. It will display those goal names and corresponding goal responsible person and can filter, sort the information in each column.Also users can download the information in the app.', N'select GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id 
	                                       AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
								INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2019-12-14T04:37:32.503' AS DateTime))
	, (NEWID(), N'Productiviy Index by project', N'This app provides the graphical representation of productivity for all the projects in the company. Users can download the information in the app. ', N'SELECT P.ProjectName , ISNULL(SUM(ISNULL(PID.EstimatedTime,0)),0)[Productiviy Index by project] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId
	                         INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL
							 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							 WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY ProjectName						   
							   ', @CompanyId, @UserId, CAST(N'2020-01-03T09:30:52.910' AS DateTime))
	, (NEWID(), N'This month orders count', N'This app displays the count of food orders of all the employees in the current month.Users can change the visualization of the app.', N'SELECT COUNT(1) [This month orders count] FROM FoodOrder WHERE FORMAT(OrderedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') and CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	', @CompanyId, @UserId, CAST(N'2020-01-17T04:06:30.640' AS DateTime))
	, (NEWID(), N'Talko2  file uploads testrun details', N'This app provides the overview of the testrun for a particular project in a pie chart.Also users can download the information in the app and can change the visualization of the app.', N'       SELECT StatusCount ,StatusCounts
	                          from
	                          (SELECT TR.Name TestRunName,
	                            Zinner.BlockedCount,Zinner.FailedCount,Zinner.PassedCount,Zinner.UntestedCount,Zinner.RetestCount
	                            FROM TestRun TR INNER JOIN Project P ON P.Id = TR.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND  P.InActiveDateTime IS NULL AND TR.[Name] =''Talko2 File Uploads''  AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								 LEFT JOIN (
	                            SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
	                                  T.TotalCount,
	                                  T.TestRunId
	                               FROM 
	                               (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
	                                      ,TR.Id TestRunId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
	                                    INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
	                                    INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
	                                    GROUP BY TR.Id)T)Zinner ON Zinner.TestRunId = TR.Id AND TR.InActiveDateTime IS NULL
	                                    WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                                    ) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BlockedCount,FailedCount,PassedCount,UntestedCount,RetestCount) 
	                                    )p', @CompanyId, @UserId, CAST(N'2019-12-11T12:54:35.020' AS DateTime))
	, (NEWID(), N'Productivity indexes', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime    
	   WHERE CreatedByUserId = U.Id AND FORMAT(CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')),0)  [Spent time],    
	     ISNULL(SUM(Zinner.Productivity),0)Productivity        FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1   
		 THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity 
		     FROM  UserStory US                 
			 INNER JOIN (SELECT US.Id ,MAX(USWFT.TransitionDateTime) AS DeadLine 
			             FROM UserStory US   
			                 JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id 
			                 JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId             
			                 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)     
			                 JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId  
			                 JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId         
			                 JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)              
			                 GROUP BY US.Id) UW ON US.Id = UW.Id               
			 INNER JOIN [User] U ON U.Id = US.OwnerUserId    
			 LEFT JOIN Goal G ON G.Id = US.GoalId 
			 LEFT JOIN Sprints S ON S.Id = US.SprintId            
			 INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId               
			 INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId          
			 INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId            
			 INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId   
			 LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id    													
			WHERE ((S.Id IS NOT NULL) OR BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
			          AND (TS.TaskStatusName IN (N''Done'',N''Verification completed''))
					   AND (TS.[Order] IN (4,6)) AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))   
					             AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))         
								     AND U.IsActive = 1 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
									  AND IsProductiveBoard = 1 AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1) GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL       
									 GROUP BY U.FirstName,U.SurName,U.Id)T', @CompanyId, @UserId, CAST(N'2019-12-12T06:14:07.507' AS DateTime))
	, (NEWID(), N'People without finish yesterday', N'This app displays the count of employees who has not clicked finish button in the time punch card yesterday.Users can can change the visualization of the app.', N'SELECT COUNT(1)[People without finish yesterday] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
	AND InTime IS NOT NULL AND OutTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) ', @CompanyId, @UserId, CAST(N'2020-01-17T04:12:46.987' AS DateTime))
	, (NEWID(), N'Milestone  details', N'This app displays all the milestones across all the projects in the company on Y-axis and the test cases count on X-axis with details like number of test cases blocked, Failed,Passed, Retested,Untested.Also users can download the information in the app and can change the visualization of the app.', N'SELECT M.Title [Milestone name],
	                            Zinner.BlockedCount [Blocked count],Zinner.FailedCount [Failed count],Zinner.PassedCount [Passed count],Zinner.UntestedCount [Untested count],Zinner.RetestCount [Retest count]
	                            FROM Milestone M INNER JOIN Project P ON P.Id = M.ProjectId AND  P.InActiveDateTime IS NULL and P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								 LEFT JOIN (
	                            SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
	                                  T.TotalCount,
	                                  T.MilestoneId
	                               FROM 
	                               (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
	                                      ,TR.MilestoneId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
	                                    INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
	                                    INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
	                                    GROUP BY TR.MilestoneId)T)Zinner ON Zinner.MilestoneId = M.Id AND M.InActiveDateTime IS NULL
	                                    WHERE   (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                                  ', @CompanyId, @UserId, CAST(N'2019-12-19T14:35:06.357' AS DateTime))
	, (NEWID(), N'Regression pack sections details', N'This app provides the list of all the sections in one test suite with its estimate, cases count, runs count, sections count and total bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' SELECT LeftInner.SectionName [Section name],
	        LeftInner.CasesCount [Cases count],
			cast(LeftInner.TotalEstimate/(60*60.0) as decimal(10,2))[Total estimate in hours],
			RightInner.P0BugsCount [P0 bugs count],
			RightInner.P1BugsCount [P1 bugs count],
			RightInner.P2BugsCount [P2 bugs count],
			RightInner.P3BugsCount [P3 bugs count],
			RightInner.TotalBugsCount [Total bugs count]
	 FROM(
	   SELECT SectionName,
	         TSS.Id SectionId,
	 (SELECT COUNT(1) FROM TestCase WHERE SectionId = TSS.Id AND InActiveDateTime IS NULL)CasesCount,
	 (SELECT SUM(ISNULL(TC.Estimate,0)) Estimate 
	     FROM TestCase TC   
	     WHERE  TC.InActiveDateTime IS NULL AND TC.SectionId = TSs.Id) AS TotalEstimate
	FROM TestSuiteSection TSS INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
	                          INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	        WHERE TSS.InActiveDateTime IS NULL AND TS.TestSuiteName  = ''Migration Check-List.''   AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId''))LeftInner LEFT JOIN
	(SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,
	                                                              TSS.Id SectionId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TSS.Id)RightInner on LeftInner.SectionId = RightInner.SectionId
	', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Canteen bill', N'This app is the graphical representation of the canteen amount spent by all the employees in the company for the current.This is a bar chart representation on x-axis we are displaying the purchased date and on Y-axis we are displaying the canteen bill amount.Users can download the information in the app and can change the visualization of the app.', N'SELECT CAST(PurchasedDateTime AS date)PurchasedDate,ISNULL(SUM(ISNULL(FI.Price,0)),0)Price  FROM UserPurchasedCanteenFoodItem CFI INNER JOIN [User]U ON U.Id = CFI.UserId
	                                              INNER JOIN CanteenFoodItem FI ON FI.Id = CFI.FoodItemId
	                     AND fi.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE)))
	GROUP BY  CAST(PurchasedDateTime AS date)
													', @CompanyId, @UserId, CAST(N'2020-01-17T11:19:05.193' AS DateTime))
	, (NEWID(), N'Today''s work items ', N'This app displays the list of work items which are assigned to the logged in user with deadline of today with details like work item and Goal name.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name],S.SprintName [Sprint name]
  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                        AND P.InActiveDateTime IS NULL --AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND SprintEndDate >= GETDATE())OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
							AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T06:10:55.140' AS DateTime))
	, (NEWID(), N'Blocked on me', N'This app provides the list of work items which has logged in user dependency.Users can download the information in the app and can change the visualization of the app.', N'  SELECT US.UserStoryName AS [Work item] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                           INNER JOIN  Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
							   WHERE US.DependencyUserId = ''@OperationsPerformedBy'' AND G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Canteen Credited this month', N'This app displays the canteen amount credited for the logged in user for the current month. Users can change the visualization of the app.', N'SELECT ISNULL(SUM(ISNULL(Amount,0)),0)[Canteen Credited this month] FROM UserCanteenCredit UCC INNER JOIN [User]U ON U.Id = UCC.CreditedByUserId AND UCC.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	            WHERE FORMAT(UCC.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND  CreditedToUserId =  ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2020-01-17T03:59:18.173' AS DateTime))
	, (NEWID(), N'Reports details', N'This app displays all the testrun reports of all the projects with details like report name, created by, created on and the PDF url.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'
		SELECT TRR.[Name]  [Report name],
	       U.FirstName+'' ''+U.SurName [Created by],
		   TRR.CreatedDateTime [Created on],
		   TRR.PdfUrl
	 FROM TestRailReport TRR INNER JOIN [User]U ON TRR.CreatedByUserId = U.Id AND TRR.InActiveDateTime IS NULL
	                         INNER JOIN Project P ON P.Id =  TRR.ProjectId AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')', @CompanyId, @UserId, CAST(N'2019-12-11T12:39:16.553' AS DateTime))
	, (NEWID(), N'Dev wise deployed and bounce back stories count', N'This app displays the deployed work items count and bounced back count for each employee in the company.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'  SELECT U.FirstName+'' ''+U.SurName [Employee name],
		        COUNT(Linner.UserStoryId) [Deployed stories count],
		        COUNT(Rinner.UserStoryId) [Bounced back count] 
	            FROM (SELECT US.Id UserStoryId,US.OwnerUserId 
	                              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
								                             AND US.ParkedDateTime IS NULL  
												 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id =''5C561B7F-80CB-4822-BE18-C65560C15F5B''
												INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
						                          INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
												        AND WFEST.InActiveDateTime IS NULL
						                          INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
						                                     AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
						                          INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
						                                     AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
						                          LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
												  LEFT JOIN  GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
												  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
												  WHERE ((US.SprintId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												  GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   GROUP BY US.Id)Rinner on Linner.UserStoryId= Rinner.UserStoryId GROUP BY U.FirstName,U.SurName	
	', @CompanyId, @UserId, CAST(N'2019-12-19T13:42:12.250' AS DateTime))
	, (NEWID(), N'Planned vs unplanned work percentage', N'This app provides the graphical representation of planned and unplanned work percentage of the company which is logged yesterday.Users can download the information in the app and can change the visualization of the app.', N'			SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work]
	 FROM(SELECT  ISNULL(SUM(CASE WHEN US.SprintId IS NOT NULL OR (G.IsToBeTracked = 1) THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN US.GoalId IS NOT NULL AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS  NULL ) THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
					   FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							    AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   WHERE (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0) AND CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							    AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T		
	
', @CompanyId, @UserId, CAST(N'2020-01-03T06:30:58.023' AS DateTime))
	, (NEWID(), N'Section details for all scenarios', N'This app provides the list of all sections, test cases count, total estimate to execute and the total number of bugs based on priority for all the testsuites in the project.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT 
	       TSS.SectionName [Section name],
		   COUNT(1) [Cases count],
		   ISNULL(P0Bugs,0)[P0 bugs],
		   ISNULL(P1Bugs,0)[P1 bugs],
		   ISNULL(P2Bugs,0)[P2 bugs],
		   ISNULL(P3Bugs,0)[P3 bugs],
		   ISNULL(TotalBugs,0)[Total bugs],
		    CAST(CAST(ISNULL(ISNULL((SUM(TC.Estimate))/(60*60.0),0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT)AS VARCHAR(100))+''m'') Estimate
	         FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TSS.TestSuiteId = TS.Id AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
	                           INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
							   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
							LEFT JOIN  (SELECT COUNT(CASE WHEN BP.IsCritical = 1THEN 1 END) P0Bugs,
			                                   COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END) P1Bugs,
					                           COUNT(CASE WHEN BP.IsMedium = 1THEN 1 END)P2Bugs,
					                           COUNT(CASE WHEN BP.IsLow = 1THEN 1 END)P3Bugs,
											   COUNT(1) TotalBugs,
					                           TC.SectionId
					                           FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
	                                                          AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
								                                INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
									                            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
									                            INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
									                            INNER JOIN TestCase TC on TC.Id = US.TestCaseId GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
																GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs', @CompanyId, @UserId, CAST(N'2019-12-20T16:22:57.367' AS DateTime))
	, (NEWID(), N'Delayed work items', N'This app displays the list of work items whose deadline crossed of the logged in user.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT US.UserStoryName As [Work item] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                           AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
			    LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0) AND S.SprintStartDate IS NOT NULL
				WHERE ((US.GoalId IS NOT NULL AND GS.Id IS  NOT NULL AND CAST(DeadLineDate as date) < cast(GETDATE() as date)) OR (US.SprintId IS NOT NULL AND S.Id IS Not NULL AND S.SprintEndDate < GETDATE())) 
						AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T06:40:41.260' AS DateTime))
	, (NEWID(), N'Yesterday late people count', N'This app displays the count of late employees to the office by the total number of employees attended the office yesterday.Users can change the visualization of the app.', N'							SELECT F.[Late people count] FROM
								(SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN
								          
										  (SELECT [Date],COUNT(CASE WHEN CAST(TS.InTime AS TIME) > Deadline THEN 1 END)[Morning late],COUNT(1)TotalCount FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
											   WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 
											                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F', @CompanyId, @UserId, CAST(N'2020-01-03T06:49:10.483' AS DateTime))
	, (NEWID(), N'Lates trend graph', N'This app provides the graphical representation of late employees in morning and afternoon sessions.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N' SELECT [Date],(SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			             WHERE CAST(TS.InTime AS TIME) > (SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			             GROUP BY TS.[Date])MorningLateEmployeesCount,
					(SELECT COUNT(1) FROM(SELECT   TS.UserId,DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime) AfternoonLateEmployee
		                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
								     AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                            WHERE   TS.[Date] = TS1.[Date]
								   GROUP BY TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.UserId)T WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						   AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						    WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'') GROUP BY TS1.[Date]
			    ', @CompanyId, @UserId, CAST(N'2019-12-12T10:34:19.643' AS DateTime))
	, (NEWID(), N'Pending assets', N'This app displays the count of all the pending assets of the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Pending assets] FROM Asset A INNER JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id
	                      INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId
	                      WHERE A.InactiveDateTime IS NULL AND (IsWriteOff = 0 OR IsWriteOff IS NULL) 
						   AND AE.ApprovedByUserId <> AE.AssignedToEmployeeId
						    AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	', @CompanyId, @UserId, CAST(N'2020-01-03T06:34:26.327' AS DateTime))
	, (NEWID(), N'All test suites', N'This app provides the list of test suites for all the projects with its estimate, cases count, runs count, sections count and total bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT LeftInner.TestSuiteName AS [Testsuite name],
	       CAST(CAST(ISNULL(LeftInner.TotalEstimate/(60*60.0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours],
	       LeftInner.CasesCount AS [Cases count],
	       LeftInner.RunsCount AS [Runs count],
	       CAST(LeftInner.CreatedDateTime  AS DATETIME) AS [Created on],
	       LeftInner.SectionsCount AS [sections count],
	       ISNULL(RightInner.P0BugsCount,0) AS [P0 bugs],
	       ISNULL(RightInner.P1BugsCount,0) AS [P1 bugs],
	       ISNULL(RightInner.P2BugsCount,0) AS [P2 bugs],
	       ISNULL(RightInner.P3BugsCount,0) AS [P3 bugs],
	       ISNULL(RightInner.TotalBugsCount,0) As [Total bugs count] 
	     FROM
	   (SELECT TS.Id TestSuiteId,
	        TestSuiteName,
	      (SELECT COUNT(1) FROM TestSuiteSection TSS INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
	                 WHERE TSS.TestSuiteId = TS.Id) CasesCount,
	     (select COUNT(1) from TestSuiteSection TSS WHERE TSS.TestSuiteId = TS.Id AND TSS.InActiveDateTime IS NULL)SectionsCount,
	     (SELECT COUNT(1) FROM TestRun TR WHERE TR.TestSuiteId = TS.Id AND TR.InActiveDateTime IS NULL)RunsCount,
	    
	    TS.CreatedDateTime,
	    (SELECT SUM(ISNULL(TC.Estimate,0)) Estimate 
	     FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL  AND TC.InActiveDateTime IS NULL
	     WHERE  TC.InActiveDateTime IS NULL AND TC.TestSuiteId = TS.Id) AS TotalEstimate
	FROM TestSuite TS WHERE ProjectId IN (SELECT  Id FROM Project WHERE  (''@ProjectId'' = '''' OR Id = ''@ProjectId'') AND InActiveDateTime IS NULL AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ) AND TS.InActiveDateTime IS NULL
	)LeftInner LEFT JOIN 
	                                                       (SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,
	                                                              TSS.TestSuiteId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TSS.TestSuiteId)RightInner on LeftInner.TestSuiteId = RightInner.TestSuiteId', @CompanyId, @UserId, CAST(N'2019-12-11T12:10:26.510' AS DateTime))
	, (NEWID(), N'Goals vs Bugs count (p0,p1,p2)', N'This app displays the list of bugs based on priority from all the active bug goals with details like goal name, P0 bugs count, P1 bugs count,P2 bugs count, P3 bugs count and the total count if bugs for each goal.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
						                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
							                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
							                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
							                                      COUNT(1)TotalCount 
																  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
																                    INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
																                    INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
																					INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
																					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
																					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
																					GROUP BY G.GoalName', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
	, (NEWID(), N'Spent time VS productive time', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1 
	                                           THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity
				FROM  UserStory US 
					           INNER JOIN (SELECT US.Id
							                     ,MAX(USWFT.TransitionDateTime) AS DeadLine
	                                              FROM UserStory US 
		                                          JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
		                                          JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
												  JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
		                                          JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
		                                          JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
												  GROUP BY US.Id) UW ON US.Id = UW.Id
					           INNER JOIN [User] U ON U.Id = US.OwnerUserId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
							   LEFT JOIN Sprints S ON S.Id = US.SprintId 
					           INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
					           INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
					           INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
					           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
					           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
					WHERE (US.SprintId IS NOT NULL OR BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
						   AND (TS.TaskStatusName IN (N''Done'',N''Verification completed'')) --AND (TS.[Order] IN (4,6))
						   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) 
					       AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
					       AND U.IsActive = 1 					
					       AND IsProductiveBoard = 1  
					     --  AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
					  GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					  GROUP BY U.FirstName,U.SurName,U.Id)T', @CompanyId, @UserId, CAST(N'2019-12-12T10:43:35.773' AS DateTime))
	, (NEWID(), N'Goal wise spent time VS productive hrs list', N'This app displays the list of active goals with its estimated time and spent time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT GoalName [Goal name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL								   
								  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   GROUP BY GoalName)T	', @CompanyId, @UserId, CAST(N'2019-12-14T05:17:22.770' AS DateTime))
	, (NEWID(), N'More replanned goals', N'This app displays the list of replanned goals with the number of times it was replanned.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'	   select G.GoalName [Goal name],COUNT(1) AS [Replan count]
		    from Goal G JOIN GoalReplan GR ON G.Id=GR.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				GROUP BY G.GoalName', @CompanyId, @UserId, CAST(N'2019-12-14T04:54:06.447' AS DateTime))
	, (NEWID(), N'Afternoon late trend graph', N'This app provides the graphical representation of late employees in afternoon session.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N'SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]
	', @CompanyId, @UserId, CAST(N'2020-01-17T04:18:41.617' AS DateTime))
	, (NEWID(), N'Yesterday break time', N'This app displays the sum of break time taken by all the employees yesterday in the company Users can change the visualization of the app.', N'SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS Date) 
	AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ', @CompanyId, @UserId, CAST(N'2020-01-17T04:11:29.523' AS DateTime))
	--, (NEWID(), N'Priority wise bugs count', N'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N'select G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
	--					                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)[P1 bugs count],
	--						                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
	--						                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)[P3 bugs count] ,
	--						                                      COUNT(1)[Total bugs count] 
	--						   from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	--				                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
	--								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
	--								  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
	--								  left JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
	--							WHERE UST.IsBug = 1 AND BT.IsBugBoard = 1 AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
	--							     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	--                                GROUP BY G.GoalName', @CompanyId, @UserId, CAST(N'2019-12-14T05:03:30.307' AS DateTime))
	, (NEWID(), N'Employee Intime VS break < 30 mins', N'This app displays the list of employees who comes to office intime and takes the break less than half an hour.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	 (SELECT U.FirstName+'' ''+U.SurName [Employee name],SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)) [Break time in min]
		FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			 INNER JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.InActiveDateTime IS NULL AND TS.[Date] = cast(UB.[Date] as date)
			 WHERE CAST(TS.InTime AS TIME) <= Deadline AND TS.[Date] = CAST(GETDATE() AS date)
			        AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			 GROUP BY U.FirstName,U.SurName)T WHERE T.[Break time in min]< 30', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Assets count', N'This app displays the list of all assets with assets count for each branch with details like asset name, branch name and assets count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT AssetName AS [Asset name],B.BranchName AS [Branch name],COUNT(1) [Assets count] FROM Asset A
	                 INNER JOIN Branch B ON A.BranchId = B.Id AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	             GROUP BY AssetName,BranchId,B.BranchName
	', @CompanyId, @UserId, CAST(N'2019-12-16T16:14:02.740' AS DateTime))
	, (NEWID(), N'Upcoming birthdays', N'This app displays the list of employees whose birthdays are in the current month with details like employee name and date of birth.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' SELECT U.FirstName+'' ''+U.SurName [Employee name],FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(CAST(E.DateofBirth AS date)),CAST(E.DateofBirth AS date)) as date),''dd-MMMM'')[Date] FROM Employee E INNER JOIN [User]U ON U.Id = E.UserId AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	 WHERE FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(DateofBirth),DateofBirth) as date),''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Yesterday QA raised issues', N'This app provide the count of bugs added by QA yesterday across all projects in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Yesterday QA raised issues] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId 
	                           INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.IsBugBoard = 1
							   INNER JOIN [User]U ON U.Id = US.CreatedByUserId AND U.InActiveDateTime IS NULL
							   INNER JOIN  UserRole UR ON UR.UserId = U.Id
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN [Role]R ON R.Id = UR.RoleId AND RoleName =''QA''
							   WHERE UST.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)', @CompanyId, @UserId, CAST(N'2020-01-17T04:40:19.110' AS DateTime))
	, (NEWID(), N'Damaged assets', N'This app displays the count of all the damaged assets in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Damaged asssets] FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId	              
						  WHERE  IsWriteOff = 1
						        AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	
	', @CompanyId, @UserId, CAST(N'2020-01-03T06:32:32.007' AS DateTime))
	, (NEWID(), N'Morning late employees', N'This app displays the list of late employees to office today with the details like employee name and the date of late.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]          
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	                     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
						                   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
										   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			                       WHERE CAST(TS.InTime AS TIME) > Deadline AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
								                       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName 
	', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Today''s leaves count', N'This app displays the count of leaves taken today by all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Today''s leaves count] FROM LeaveApplication LA INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId  
	AND LA.InActiveDateTime IS NULL AND LT.InActiveDateTime IS NULL    
	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.InActiveDateTime IS NULL 
	WHERE LS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
	AND CAST(LA.LeaveDateFrom AS date) = CAST(GETDATE() AS date)  AND LS.IsApproved = 1', @CompanyId, @UserId, CAST(N'2020-01-28T09:46:54.763' AS DateTime))
	, (NEWID(), N'Intime trend graph', N'This app provides the graphical representation of late employees in morning session.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N'SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) and CAST(TS.InTime AS TIME) > Deadline
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]', @CompanyId, @UserId, CAST(N'2020-01-17T04:17:10.820' AS DateTime))
	, (NEWID(), N'Purchases this month', N'This app provides the total canteen amount in this month', N'SELECT COUNT(1) [Purchases this month] FROM UserPurchasedCanteenFoodItem UPCF INNER JOIN CanteenFoodItem CFI ON CFI.Id = UPCF.FoodItemId 
	    WHERE FORMAT(PurchasedDateTime,''MM-yy'') =  FORMAT(GETDATE(),''MM-yy'') AND UPCF.InActiveDateTime IS NULL
		 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ', @CompanyId, @UserId, CAST(N'2020-01-17T03:56:07.980' AS DateTime))
	, (NEWID(), N'Actively running projects ', N'This app displays the count of active projects in the company.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1)[Actively Running Projects] FROM Project P WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND CompanyId= (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND ProjectName <> ''Adhoc project'' AND InActiveDateTime IS NULL
	', @CompanyId, @UserId, CAST(N'2020-01-03T06:54:36.060' AS DateTime))
	, (NEWID(), N'Planned VS unplanned employee wise', N'This app provides the list of all the employees in the company with their planned and unplanned work percentage and can filter, sort the information in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.EmployeeName [Employee name ] ,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Unplanned work percent] 
		                        FROM     
							    (SELECT  U.FirstName +'' '' +U.SurName EmployeeName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE   TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id)TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL 
										                AND G.InActiveDateTime IS NULL
			                                                                   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                                 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE (IsBugBoard = 1 OR BT.BoardTypeName=''SuperAgile'') AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													       AND US.OwnerUserId = U.Id  
													 ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE  BT.BoardTypeName=''Kanban'' AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                       INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
						                   WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T', @CompanyId, @UserId, CAST(N'2019-12-14T08:16:51.900' AS DateTime))
	, (NEWID(), N'Yesterday team spent time', N'This app displays the sum of spent time by all the employees yesterday in the company Users can download the information in the app and can change the visualization of the app', N'SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)T', @CompanyId, @UserId, CAST(N'2020-01-17T04:14:43.870' AS DateTime))
	, (NEWID(), N'Night late people count', N'This app displays the count of employees who stays late in the office based on the cut off time configured.Users can change the visualization of the app.', N'SELECT COUNT(1)[Night late people count] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	         WHERE CAST(TS.CreatedDateTime AS date)  = CAST(GETDATE() AS date)AND  cast(OutTime as time) >= ''16:30:00.00''
			 AND CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   ', @CompanyId, @UserId, CAST(N'2020-01-17T08:48:37.657' AS DateTime))
	, (NEWID(), N'All testruns ', N'This app provides the list of all the testruns with details like run date, count of each status, status wise percentage and bugs count based on priority.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT TR.[Name]  [Testrun name],
							       TR.CreatedDateTime [Run date],
							        ZOuter.BlockedCount AS [Blocked count],
							        ZOuter.BlockedPercent As [Blocked percent],
							        ZOuter.FailedCount AS [Failed count],
							        ZOuter.FailedPercent AS [Failed percent],
							        ZOuter.PassedCount AS [Passed count],
							        ZOuter.PassedPercent AS [Passed percent],
							        ZOuter.RetestCount AS [Retest count],
							        ZOuter.RetestPercent AS [Retest percent],
							        ZOuter.UntestedCount AS [Untested count],
							        ZOuter.UntestedPercent AS [Untested percent],
									RightInner.P0BugsCount AS [P0 bugs],
									RightInner.P1BugsCount AS [P1 bugs],
									RightInner.P2BugsCount AS [P2 bugs],
									RightInner.P3BugsCount AS [P3 bugs],
									RightInner.TotalBugsCount AS [Total bugs]
							 FROM TestRun TR INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL AND TR.InActiveDateTime IS NULL
							                 INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        LEFT JOIN	
								   (SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
								      T.TotalCount,
									  T.TestRunId
			                       FROM 
								   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
										  ,TR.Id TestRunId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
				                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
				                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
										GROUP BY TR.Id)T)ZOuter ON TR.Id = ZOuter.TestRunId and TR.InActiveDateTime IS NULL
										LEFT JOIN (SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,                                                            
																  TRSC.TestRunId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
															INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TRSC.TestRunId)RightInner ON RightInner.TestRunId = TR.Id
															WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')', @CompanyId, @UserId, CAST(N'2019-12-11T12:34:40.420' AS DateTime))
	, (NEWID(), N'Company level productivity', N'This app is the graphical representation of company productivity of each month for last 12 months.Users can download the information in the app and can change the visualization of the app.', N'  SELECT FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity FROM
	(SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,
	       cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo FROM
	(SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 12
	 )T)Zouter CROSS APPLY [Ufn_ProductivityIndexBasedOnuserId](Zouter.DateFrom,Zouter.DateTo,Null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )ROuter
	 GROUP BY Zouter.DateFrom,Zouter.DateTo	', @CompanyId, @UserId, CAST(N'2019-12-16T10:55:03.043' AS DateTime))
	, (NEWID(), N'Night late employees', N'This app displays the list of employees who stays late in the office with their outtime and spent time.Users can sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time]
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)Z', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Branch wise monthly productivity report', N'This app provides the graphical representation of productivity of all the branches.Users can download the information in the app and can change the visualization of the app.', N'SELECT B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] FROM [Branch]B LEFT JOIN
	                 (SELECT B.Id BranchId, B.BranchName,SUM(ISNULL(PID.EstimatedTime,0))BranchProductivity
					  FROM [User]U INNER JOIN [Employee]E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                      INNER JOIN [EmployeeBranch]EB ON EB.EmployeeId = E.Id 
						  INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						  CROSS APPLY dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,U.CompanyId)PID 
						 WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  AND PID.UserId = U.Id
						 GROUP BY BranchName,B.Id)T	ON B.Id = T.BranchId
						 WHERE B.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	 
			             GROUP BY B.BranchName,BranchProductivity
	', @CompanyId, @UserId, CAST(N'2020-01-03T06:38:36.050' AS DateTime))
	, (NEWID(), N'Imminent deadline work items count', N'This app displays the count of work items which have imminent deadlines of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Imminent deadline work items count]
 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                                                   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
			AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
			       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
				   WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) >= CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > GETDATE())) 
				   	 
', @CompanyId, @UserId, CAST(N'2020-01-03T16:19:01.137' AS DateTime))
	, (NEWID(), N'Goal work items VS bugs count', N'This app displays the list of all active goals with its work items count and bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL))
														GROUP BY G.GoalName', @CompanyId, @UserId, CAST(N'2019-12-14T04:59:57.450' AS DateTime))
	, (NEWID(), N'This month purchased employees', N'This app displays the count of employees who have purchased the items in canteen for the current month. Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1) [This month purchased employees] FROM (SELECT CFI.UserId FROM UserPurchasedCanteenFoodItem CFI INNER JOIN [User]U ON U.Id = CFI.UserId AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE))) GROUP BY UserId)T
				', @CompanyId, @UserId, CAST(N'2020-01-17T04:03:35.777' AS DateTime))
	, (NEWID(), N'Least work allocated peoples list', N'This app displays the list of employees who has work allocation less than 5 hours with details like employee name and estimated time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
	                      LEFT JOIN(SELECT US.OwnerUserId,ISNULL(SUM(US.EstimatedTime),0)EstimatedTime
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				          INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
						  LEFT JOIN Goal G ON G.Id = US.GoalId 
						  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND  GS.IsActive =1 
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
						  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
							 GROUP BY US.OwnerUserId
							)Zinner oN Zinner.OwnerUserId = U.Id
							where ISNULL(Zinner.EstimatedTime,0) < 5
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND U.InActiveDateTime IS NULL
', @CompanyId, @UserId, CAST(N'2019-12-14T05:15:13.823' AS DateTime))
	, (NEWID(), N'Delayed goals', N'This app displays the list of goals which are delayed with details like goal name and the number of days it was delayed.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	(select GoalName AS [Goal name],DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 GROUP BY GoalName)T ', @CompanyId, @UserId, CAST(N'2019-12-14T04:47:01.040' AS DateTime))
	, (NEWID(), N'Leaves waiting approval', N'This app displays the count of  leaves waiting for the approval of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Leaves waiting approval] FROM LeaveApplication LA INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId 
	AND LA.InActiveDateTime IS NULL AND LT.InActiveDateTime IS NULL 
	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.InActiveDateTime IS NULL    
	WHERE LS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
	  AND LS.IsWaitingForApproval = 1', @CompanyId, @UserId, CAST(N'2020-01-28T09:45:11.473' AS DateTime))
	, (NEWID(), N'Long running items', N'This app displays the count of work items whose status was not changed from deployed to any other state after one day.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1)[Long running items] FROM
			(SELECT  US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND CAST(UWET.TransitionDateTime AS date) > CAST(dateadd(day,-1,GETDATE()) AS date)
							   GROUP BY US.Id
							   HAVING CAST(max(UWET.TransitionDateTime) AS date) < CAST(DATEADD(DAY,-1,GETDATE()) AS DATE)
							   )T', @CompanyId, @UserId, CAST(N'2020-01-17T07:07:27.767' AS DateTime))
	, (NEWID(), N'Items deployed frequently', N'This app displays the count of work items whose status was changed to deployed more than one time.Users can change the visualization of the app.', N' SELECT COUNT(1)[Items deployed frequently] FROM
			(SELECT  US.Id,COUNT(1) TransitionCounts FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							    INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
							   INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND CAST(UWET.CreatedDateTime AS date) = CAST(GETDATE() AS date)
							   GROUP BY US.Id)T WHERE T.TransitionCounts > 1', @CompanyId, @UserId, CAST(N'2020-01-17T04:27:45.500' AS DateTime))
	, (NEWID(), N'Yesterday logging compliance', N'This app displays the logging compliance of all the reporting members with details like responsible person name, compliance percentage and the non compliant members..Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM  [dbo].[Ufn_GetCompliance] (''@OperationsPerformedBy'',10,NULL)
	', @CompanyId, @UserId, CAST(N'2019-12-14T07:51:49.497' AS DateTime))
	, (NEWID(), N'Unassigned assets', N'This app displays the count of unassigned assets in the company.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1) [Unassigned assets] FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId
	                      WHERE a.InactiveDateTime IS NULL AND (IsWriteOff = 0 OR IsWriteOff IS NULL) AND (IsEmpty = 1)
						   AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	', @CompanyId, @UserId, CAST(N'2020-01-03T06:33:19.327' AS DateTime))
	, (NEWID(), N'Today''s morning late people count', N'This app displays the count of employees who came late in the morning session.Users can change the visualization of the app.', N'						 SELECT COUNT(1)[Today''s morning late people count] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
											   WHERE TS.[Date] = CAST(GETDATE() AS date) AND CAST(TS.InTime AS TIME) > Deadline
											   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 										                        											   
					', @CompanyId, @UserId, CAST(N'2020-01-17T04:09:39.520' AS DateTime))
	, (NEWID(), N'This week productivity', N'This app displays the overall company productivity for the current week and also users can change the visualization of the app.', N'SELECT ISNULL(T.[This week productivity],0)[This week productivity] FROM
	(SELECT SUM(EstimatedTime) [This week productivity]
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) ) 
	 )T', @CompanyId, @UserId, CAST(N'2020-01-17T12:10:42.913' AS DateTime))
	, (NEWID(), N'More bugs goals list', N'This app displays the list of goals which has more bugs linked to the work items with details like Goal name, Work items count and Bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'	SELECT * FROM(SELECT G.GoalName [Goal name],COUNT(US.Id) [Work items count] ,					(SELECT COUNT(1) FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL
	                           INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL AND US1.GoalId =G.Id
	                           INNER JOIN GoalStatus GS ON GS.Id = G1.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryType UST ON UST.IsBug = 1 AND UST.InActiveDateTime IS NULL AND US.UserStoryTypeId = UST.Id
							   LEFT JOIN UserStoryScenario USS ON USS.TestCaseId = US.TestCaseId AND USS.UserStoryId = US1.Id
							   LEFT JOIN TestCase TC ON TC.Id = US.TestCaseId and TC.InActiveDateTime IS NULL
							   WHERE  (US.TestCaseId IS NULL OR TC.Id IS Not NULL))  [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId  AND P.InActiveDateTime IS NULL AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														GROUP BY G.GoalName,G.Id)Z WHERE Z.[Bugs count] > 0
	', @CompanyId, @UserId, CAST(N'2019-12-14T04:57:31.507' AS DateTime))
	, (NEWID(), N'Branch wise food order bill', N'This app provides the graphical representation of the food order amount for the current month on branch basis.Users can download the information in the app and can change the visualization of the app.', N'SELECT B.BranchName,ISNULL(SUM(ISNULL(Amount,0)),0) Amount  FROM FoodOrder FO INNER JOIN [User]U ON U.Id = FO.ClaimedByUserId AND FO.InActiveDateTime IS NULL
	                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
							   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
							   INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId AND IsApproved =  1
							   INNER JOIN Branch B ON B.Id = EB.BranchId and B.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  WHERE CAST(FO.OrderedDateTime as date)  >=  cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) as date) AND  CAST(FO.OrderedDateTime as date) <= CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) AS date)
							   GROUP BY BranchName
								   ', @CompanyId, @UserId, CAST(N'2020-01-17T04:05:16.493' AS DateTime))
	, (NEWID(), N'Today''s target', N'This app displays the count of work items which are assigned to the logged in user with deadline of today.Users can change the visualization of the app.', N'SELECT COUNT(1)[Today''s target] FROM
	(SELECT US.Id FROM UserStory US INNER JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId 
							  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WET.ToWorkflowUserStoryStatusId
							   INNER JOIN TaskStatus TS1 ON TS.Id = USS.TaskStatusId AND TS1.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE CAST(UST.TransitionDateTime AS date) < CAST(GETDATE() AS date)
							   group by US.Id)T', @CompanyId, @UserId, CAST(N'2020-01-17T04:33:55.280' AS DateTime))
	, (NEWID(), N'Yesterday food order bill', N'This app displays the overall company food order bill of yesterday users change the visualization of the app.', N'SELECT ISNULL(SUM(Amount),0)[Yesterday food frder bill] FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FO.FoodOrderStatusId = FOS.Id AND FOS.IsApproved = 1 WHERE CAST(OrderedDateTime AS date) = CAST(dateadd(day,-1,GETDATE()) AS date) 
	AND FO.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ', @CompanyId, @UserId, CAST(N'2020-01-03T06:51:23.963' AS DateTime))
	, (NEWID(), N'Least spent time employees', N'This app displays the list of employees who spends less time in office with details like spent time and date on which they spent less time for current month.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],[Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))
	', @CompanyId, @UserId, CAST(N'2019-12-12T11:38:06.770' AS DateTime))
	, (NEWID(), N'This month productivity', N'This app displays the overall company productivity for the current month and also users can change the visualization', N'SELECT ISNULL(SUM(EstimatedTime),0) [This month productivity] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,
	(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL))', @CompanyId, @UserId, CAST(N'2020-01-17T12:08:15.717' AS DateTime))
	, (NEWID(), N'Office spent Vs prodictive time', N'This app provides the graphical representation of the spent time and productive time for the current day', N'				  SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],ISNULL(SUM(Rinner.ProductiveHours),0)[Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
												   (SELECT US.OwnerUserId,SUM(CASE WHEN CH.IsEsimatedHours = 1 THEN US.EstimatedTime ELSE UST.SpentTimeInMin/60.0 END) ProductiveHours
	                                                       FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND CAST(UST.CreatedDateTime AS date) =CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							                                                 INNER JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
							                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId', @CompanyId, @UserId, CAST(N'2020-01-03T14:29:53.667' AS DateTime))
	, (NEWID(), N'Total bugs count', N'This app displays the count of all the bugs in the company.Users can download the information in the app and can change the visualization of the app.', N'
	            SELECT COUNT(1) [Total Bugs Count] 
	            FROM UserStory US INNER JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
								  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
	                              INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)						   
							   ', @CompanyId, @UserId, CAST(N'2020-01-03T09:28:22.053' AS DateTime))
	, (NEWID(), N'Bugs list', N'This app displays the list of bugs assigned to the logged in user with its corresponding goal name.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'
			SELECT US.UserStoryName AS Bug ,G.GoalName [Goal name] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                       INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
										   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
										   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
										   INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
										   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2,3)
							               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							               WHERE G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND BT.IsBugBoard = 1 AND UST.IsBug = 1
							                                  AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T06:47:13.743' AS DateTime))
	, (NEWID(), N'Planned work Vs unplanned work team wise', N'This app displays the list of all the leads and their team wise planned and unplanned work percentages.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.LeadName [Lead name],ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Un planned work percent] 
		                        FROM (SELECT T.LeadName,SUM(T.PlannedWork)PlannedWork,SUM(T.UnPlannedWork)UnPlannedWork,SUM(T.TotalWork)TotalWork FROM
								  (SELECT  U1.FirstName +'' ''+U1.SurName LeadName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE    US.OwnerUserId = U.Id)TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL 
										                AND G.InActiveDateTime IS NULL
			                                         LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
						                             LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE (IsBugBoard = 1 OR (G.IsToBeTracked = 1 AND US.GoalId IS NOT NULL)OR US.SprintId IS NOT NULL) AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													       AND US.OwnerUserId = U.Id  
													 ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND US.SprintId IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                                     INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id and ER.InActiveDateTime IS NULL
														 INNER JOIN  Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
														 INNER JOIN [User]U1 ON U1.Id = E1.UserId AND U1.InActiveDateTime IS NULL
						                   WHERE U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T GROUP BY T.LeadName)T', @CompanyId, @UserId, CAST(N'2019-12-14T07:43:31.190' AS DateTime))
	, (NEWID(), N'Productivity of this month', N'This app displays the productivity of the logged in user for the current month and users can change the visualization of the app.', N'SELECT SUM(EstimatedTime) Productivity FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2019-12-14T07:02:55.097' AS DateTime))
	, (NEWID(), N'Afternoon late employees', N'This app displays the list of employees who comes late to the office in afternoon session with date.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],
	    (SELECT  Stuff((SELECT '','' +(FirstName+'' ''+SurName) 
		              FROM [User] WHERE Id = TS.UserId FOR XML PATH(''''),TYPE).value(''text()[1]'',''nvarchar(4000)''),1,1,N''''))
					    [Afternoon late employee] 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)', @CompanyId, @UserId, CAST(N'2019-12-12T07:17:49.130' AS DateTime))
	, (NEWID(), N'Employee lunch out Vs break < 30 mints', N'This app displays the list of employees whose takes correct lunch break and takes the break less than half an hour.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	 (SELECT U.FirstName+'' ''+U.SurName [Employee name],SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)) [Break time in min]
		FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 INNER JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.InActiveDateTime IS NULL AND TS.[Date] = cast(UB.[Date] as date)
			 WHERE  TS.[Date] = CAST(GETDATE() AS date)  
			        AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
			 GROUP BY U.FirstName,U.SurName,LunchBreakStartTime,LunchBreakEndTime
			 HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) <= 70
			 )T WHERE T.[Break time in min]< 30	
		', @CompanyId, @UserId, CAST(N'2019-12-16T10:36:29.580' AS DateTime))
	, (NEWID(), N'Average Exit Time', N'This app displays the average exit time of all the employee for current month with date and the corresponding average exit time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],cast([Avg exit time] as time(0))[Avg exit time] FROM
	(SELECT FORMAT([Date],''dd-MM-yy'') AS [Date],ISNULL(CAST(AVG(CAST(OutTime AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
	 GROUP BY FORMAT([Date],''dd-MM-yy''))T', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Items waiting for QA approval', N'This app provides the count of work items waiting for QA approval.Users can change the visualization of the app.', N'SELECT COUNT(1) [Items waiting for QA approval] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL', @CompanyId, @UserId, CAST(N'2020-01-17T04:20:49.097' AS DateTime))
	, (NEWID(), N'Bugs count on priority basis', N'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N' 		SELECT StatusCount ,StatusCounts
	                          from      (        SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)P0Bugs, 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)P1Bugs,
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2Bugs,
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3Bugs
	            FROM UserStory US INNER JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				                
	                              INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
								  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
	                              INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						 )as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (P0Bugs,P1Bugs,P2Bugs,P3Bugs) 
	                                    )p
	', @CompanyId, @UserId, CAST(N'2020-01-03T09:29:53.233' AS DateTime))
	, (NEWID(), N'Dependency on me', N'This app provides the list of workitems which have dependency on the logged in user with details like project name, goal name and work items. Users can search and sort the work items list', N'      SELECT    US.UserStoryName as [Work item],G.GoalName as [Goal name],S.SprintName [Sprint name]
	 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND US.DependencyUserId = ''@OperationsPerformedBy'' 
		INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
		INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN ( 1,5,2)
		LEFT JOIN Goal G ON G.Id  = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL  
		LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
		LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
		WHERE ((US.SprintId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
', @CompanyId, @UserId, CAST(N'2019-12-14T08:24:48.193' AS DateTime))
	, (NEWID(), N'This month food orders bill', N'This app displays the overall company food order bill of the current month. Users can download the information in the app and can change the visualization of the app.', N'SELECT  isnull(SUM(ISNULL(Amount,0)),0)[This month food orders bill] FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId WHERE FORMAT(OrderedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')	
	AND FO.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND FOS.IsApproved = 1', @CompanyId, @UserId, CAST(N'2020-01-17T10:59:56.580' AS DateTime))
	, (NEWID(), N'Employee blocked work items/dependency analasys', N'This app provides the list of workitems which have dependency on other employees in the company with details like project name, goal name, work item and employee name on whom the dependency is. Users can search and sort the work items list', N'  SELECT US.UserStoryName AS [Work item],
			U.FirstName+'' ''+U.SurName [Owner name],
			UD.FirstName+'' ''+UD.SurName [Dependency user]
		FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
		                    INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
							INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 5
							INNER JOIN [User]U ON U.Id = US.OwnerUserId 
							LEFT JOIN [User]UD ON UD.Id = US.DependencyUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN Goal G ON G.Id  = US.GoalId AND  G.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL
							LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)  AND S.SprintStartDate IS NOT NULL
						WHERE   US.ParkedDateTime IS NULL
								AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2019-12-14T04:43:28.513' AS DateTime))
	, (NEWID(), N'Assets list', N'This app displays the list of assets in the company with details like asset name, branch name, total assets,damaged assets, unused assets and used assets.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT A.AssetName AS [Asset name],B.BranchName AS [Branch name],
					COUNT(1)[Total assets],
					COUNT(CASE WHEN IsWriteOff = 1 THEN 1 END) [Damaged assets],
					COUNT(CASE WHEN IsEmpty = 1 THEN 1 END) [Unused assets],
					COUNT(CASE WHEN IsWriteOff = 0 AND IsEmpty = 0  THEN 1 END) [Used assets]
					FROM Asset A INNER JOIN Branch B ON A.BranchId = B.Id
					 WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					 GROUP BY AssetName,BranchName', @CompanyId, @UserId, CAST(N'2019-12-16T16:10:15.940' AS DateTime))
	, (NEWID(), N'TestCases priority wise', N'This app provides the graphical representation of the test cases based on their priority for all the projects.Users can download the information in the app and can change the visualization of the app.', N'select TestSuiteName as [Testsuite name ],COUNT(CASE WHEN PriorityType=''High'' THEN 1 END) [High priority count],
	       COUNT(CASE WHEN PriorityType=''Low'' THEN 1  END)  [Low priority count],
	       COUNT(CASE WHEN PriorityType=''Critical'' THEN 1  END)  [Critical priority count],
		   COUNT(CASE WHEN PriorityType=''Medium'' THEN 1  END) [Medium priority count]
	           FROM TestCase TC INNER JOIN TestCasePriority TCP ON TC.PriorityId = TCP.Id 
	                                AND TC.InActiveDateTime IS NULL AND TCP.InActiveDateTime IS NULL
								INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
								INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
								INNER JOIN Project P ON P.Id = TS.ProjectId AND P.InActiveDateTime IS NULL
								WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								GROUP BY TS.TestSuiteName', @CompanyId, @UserId, CAST(N'2019-12-11T12:26:55.600' AS DateTime))
	
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);
		
	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	 (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Pipeline work'),'1','Pipeline work_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name </Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>User story name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Deadline date</Field><Filter>datetimeoffset</Filter><Hidden>false</Hidden><MaxLength>10</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company productivity'),'0','Company productivity_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field> This month company productivity </Field><Filter>numeric</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','',' This month company productivity ',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company productivity'),'1','Company productivity_gauge','radialgauge',NULL,'','',' This month company productivity ',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals not ontrack'),'1','Goals not ontrack_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goals not ontrack</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Goals not ontrack',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Project wise missed bugs count'),'1','Project wise missed Bugs count','donut',NULL,'','ProjectName','StatusCounts',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Food orders'),'1','Food orders_bar','bar',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Month</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Amount in rupees</Field><Filter>money</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Month','Amount in rupees',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Active goals'),'1','Active goals_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Active goals</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Active goals',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'All versions'),'1','All milestones_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Milestone name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Created on</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Blocked count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Blocked percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Failed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Failed percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Passed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Passed percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Retest count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Restest percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Untested count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Untested percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Assigned, UnAssigned, Damaged Assets %'),'1','Assigned, UnAssigned, Damaged Assets %','donut',NULL,'','StatusCount','StatusCounts',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Canteen Items count'),'1','Canteen Items count_kpi','kpi',NULL,'','','Canteen Items count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee assigned work items'),'1','Employee assigned work items_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Talko2  file uploads testrun details'),'1','Talko2  file uploads testrun details_pie','pie',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>StatusCount</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>256</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>StatusCounts</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','StatusCount','StatusCount,StatusCounts',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Overall activity '),'1','Overall activity _line','line',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>ActivityRecordsCount</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Date','ActivityRecordsCount',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productivity indexes'),'1','Productivity indexes_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Productivity</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'People without finish yesterday'),'1','People without finish yesterday_kpi','kpi',NULL,'','','People without finish yesterday',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Milestone  details'),'1','Milestone  details_stackedbar','stackedbar',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Milestone name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Blocked count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Failed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Passed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Untested count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Retest count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Milestone name','Blocked count,Failed count,Passed count,Untested count,Retest count',GETDATE(),@UserId)
	--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned VS Unplanned work'),'1','Planned VS Unplanned work_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>FirstName</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>PlannedWorkPercent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>UnPlannedWorkPercent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This month credited employees'),'1','This month credited employees_kpi','kpi',NULL,'','','This month credited employees',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Regression pack sections details'),'1','Regression pack sections details_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Section name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Cases count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total estimate in hours</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Canteen bill'),'1','Canteen bill','column',NULL,'','PurchasedDate','Price',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Red goals list'),'1','Red goals list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Goal responsible person</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productiviy Index by project'),'1','Productiviy Index by project_donut','donut',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>ProjectName</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Productiviy Index by project</Field><Filter>numeric</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','ProjectName','Productiviy Index by project',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This month orders count'),'1','This month orders count_kpi','kpi',NULL,'','','This month orders count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Today''s work items '),'1','Today''s work items _table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Blocked on me'),'1','Blocked on me_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Dev wise deployed and bounce back stories count'),'1','Dev wise deployed and bounce back stories count_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Deployed stories count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Bounced back count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned vs unplanned work percentage'),'1','Planned vs unplanned work percentage_column','column',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Planned work</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Un planned work</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Planned work,Un planned work',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Section details for all scenarios'),'1','Section details for all testsuites_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Section name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Cases count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Estimate</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Canteen Credited this month'),'1','Canteen Credited this month_kpi','kpi',NULL,'','','Canteen Credited this month',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Reports details'),'1','Reports details_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Report name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Created by</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Created on</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>PdfUrl</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Delayed work items'),'1','Delayed work items_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday late people count'),'1','Yesterday late people count_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Late people count</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>122</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Late people count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Lates trend graph'),'1','Lates trend graph_line','line',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>MorningLateEmployeesCount</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>AfternoonLateEmployee</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Date','MorningLateEmployeesCount,AfternoonLateEmployee',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Pending assets'),'1','Pending assets_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Pending assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Pending assets',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'All test suites'),'1','All test suites_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Testsuite name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Estimate in hours</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Cases count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Runs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Created on</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>sections count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),'1','Goals vs Bugs count (p0,p1,p2)_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>GoalName</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>TotalCount</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Spent time VS productive time'),'1','Spent time VS productive time_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>66</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Productivity</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'1','Goal wise spent time VS productive hrs list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Estimated time</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'More replanned goals'),'1','More replanned goals_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Replan count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Afternoon late trend graph'),'1','Afternoon late ','line',NULL,'','Date','Afternoon late count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday break time'),'1','Yesterday break time','kpi',NULL,'','','Yesterday break time',GETDATE(),@UserId)
	--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Priority wise bugs count'),'1','Priority wise bugs count_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal ame</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total bugs count</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee Intime VS break < 30 mins'),'1','Employee Intime VS break < 30 mins_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Break time in min</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Assets count'),'1','Assets count_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Asset name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>100</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Branch name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Assets count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Upcoming birthdays'),'1','Upcoming birthdays_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Date</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday QA raised issues'),'1','Yesterday QA raised issues_gauge','radialgauge',NULL,'','','Yesterday QA raised issues',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Damaged assets'),'1','Damaged assets_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Damaged asssets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Damaged asssets',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Morning late employees'),'1','Morning late employees_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Today''s leaves count'),'1','Today''s leaves count_gauge','radialgauge',NULL,'','','Today''s leaves count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Intime trend graph'),'1','Intime trend graph','line',NULL,'','Date','Morning late',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned VS unplanned employee wise'),'1','Planned VS unplanned employee wise_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name </Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Planned work percent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Unplanned work percent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday team spent time'),'1','Yesterday team spent time_KPI','kpi',NULL,'','','Yesterday team spent time',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Night late people count'),'1','Night late people count','kpi',NULL,'','','Night late people count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'All testruns '),'1','All testruns _table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Testrun name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Run date</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Blocked count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Blocked percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Failed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Failed percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Passed count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Passed percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Retest count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Retest percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Untested count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Untested percent</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P0 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P1 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P2 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>P3 bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total bugs</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company level productivity'),'1','Company level productivity','line',NULL,'','Month','Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company level productivity'),'0','Company level productivity_bar','bar',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Month</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Productivity</Field><Filter>numeric</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Month','Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Night late employees'),'1','Night late employees_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>OutTime</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Purchases this month'),'1','Purchases this moth_kpi','kpi',NULL,'','','Purchases this month',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Branch wise monthly productivity report'),'1','Branch wise monthly productivity report_donut','donut',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>BranchName</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Branch productivity</Field><Filter>numeric</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','BranchName','Branch productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Imminent deadline work items count'),'1','Imminent deadline work items count_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Imminent deadline work items count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Imminent deadline work items count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goal work items VS bugs count'),'1','Goal work items VS bugs count_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>User stories count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Actively running projects '),'1','Actively running projects _kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Actively Running Projects</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Actively Running Projects',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This month purchased employees'),'1','This month purchased employees','kpi',NULL,'','','This month purchased employees',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Least work allocated peoples list'),'1','Least work allocated peoples list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Estimated time</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Delayed goals'),'1','Delayed goals_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Delayed by</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Long running items'),'1','Long running items','kpi',NULL,'','','Long running items',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Items deployed frequently'),'1','Items deployed frequently_KPI','kpi',NULL,'','','Items deployed frequently',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday logging compliance'),'1','Yesterday logging compliance_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Responsible</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Compliance %</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Non Compliant Members</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Assets list'),'1','Assets list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Asset name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>100</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Branch name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Total assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Damaged assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Used assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Unused assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Unassigned assets'),'1','Unassigned assets_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Unassigned assets</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Unassigned assets',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Today''s morning late people count'),'1','Today''s morning late people count_kpi','kpi',NULL,'','','Today''s morning late people count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This week productivity'),'1','This week productivity','kpi',NULL,'','','This week productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'More bugs goals list'),'1','More bugs goals list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>User stories count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Bugs count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Today''s target'),'1','Today''s target_KPI','kpi',NULL,'','','Today''s target',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Yesterday food order bill'),'1','Yesterday food order bill_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Yesterday food frder bill</Field><Filter>money</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Yesterday food frder bill',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Least spent time employees'),'1','Least spent time employees_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This month productivity'),'1','This month productivity','kpi',NULL,'','','This month productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Office spent Vs prodictive time'),'1','Office spent Vs prodictive time_column','column',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Spent time</Field><Filter>decimal</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Productive hours</Field><Filter>float</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Spent time,Productive hours',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Total bugs count'),'1','Total bugs count_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Total Bugs Count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Total Bugs Count',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Bugs list'),'1','Bugs list_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Bug</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned work Vs unplanned work team wise'),'1','Planned work Vs unplanned work team wise_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Lead name</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Planned work percent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Un planned work percent</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>9</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productivity of this month'),'1','Productivity of this month_table','radialgauge',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Productivity</Field><Filter>text</Filter><Hidden>false</Hidden><MaxLength>17</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>',NULL,'Productivity',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Afternoon late employees'),'1','Afternoon late employees_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Date</Field><Filter>date</Filter><Hidden>false</Hidden><MaxLength>3</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Afternoon late employee</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee lunch out Vs break < 30 mints'),'1','Employee lunch out Vs break < 30 mints_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Employee name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Break time in min</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Average Exit Time'),'1','Average Exit Time_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Date</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>8000</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Avg exit time</Field><Filter>datetime</Filter><Hidden>false</Hidden><MaxLength>8</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','AvgExitTime','Month',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Branch wise food order bill'),'1','Branch wise food order bill','donut',NULL,'','BranchName','Amount',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Leaves waiting approval'),'1','Leaves waiting approval_kpi','kpi',NULL,'','','Leaves waiting approval',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Items waiting for QA approval'),'1','Items waiting for QA approval','kpi',NULL,'','','Items waiting for QA approval',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Bugs count on priority basis'),'1','Bugs count on priority basis_donut','donut',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>StatusCount</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>256</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>StatusCounts</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','StatusCount','StatusCounts',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Dependency on me'),'1','Dependency on me_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Goal name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'This month food orders bill'),'1','This month food order bill_gauge','radialgauge',NULL,'','','This month food orders bill',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee blocked work items/dependency analasys'),'1','Employee blocked work items/dependency analasys_table','table',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>User story</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1600</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Owner name</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Dependency user</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>1002</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'TestCases priority wise'),'1','TestCases priority wise_stackedbar','stackedbar',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Testsuite name </Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>500</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>High priority count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Low priority count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Critical priority count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel><CustomWidgetHeaderModel><Field>Medium priority count</Field><Filter>int</Filter><Hidden>false</Hidden><MaxLength>4</MaxLength><IsNullable>true</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','Testsuite name ','High priority count,Low priority count,Critical priority count,Medium priority count',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);
	

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (NEWID(),N'This app provides the list of all the employee assigned work items with details like developer name, work item, estimated time, deadline date and work item status.Users can search and sort work items from the list.Also users can filter the app based on employee name, status and date range.', N'Employee work items', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app plots the employee spent time in the office for the current month by considering the dates on x-axis and employee spent time on y-axis', N'Employee spent time', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items which have imminent deadlines of all the reporting employees in the current week.Also users can sort and search work items from the list.', N'Imminent deadlines', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the purchased items in the canteen with details like username,Item name,Item price,Items count and purchased date.', N'Canteen purchase summary', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app employees can punch their office start time, lunch start ,lunch end, break start ,break end and finish timings.', N'Time punch card', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app is the graphical representation of all the reporting employees work allocation.It will display all the reporting employees on the x-axis and the work allocated on Y-axis. Based on the work allocation hours, colors will be displayed in the work allocation summary app.', N'Work allocation summary', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of goals which are running active across all the projects in the company with their corresponding goal responsible person names.', N'Actively running goals', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items which have dependency on the logged in user with details like project name, goal name and work items. Users can search and sort the work items list', N'Work items dependency on me', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of food item purchased in the canteen for the current month by the logged in user.Users can download the information in the app and can change the visualization of the app.', N'Bill amount on daily basis', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app users can add the new food items to the canteen and can also view the list of food items available in the canteen. Users can search and sort the food items list.', N'Canteen food items list', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of food orders ordered by all the employees with its corresponding order details for the current month. Users can also search and sort the food orders in the list.', N'All food orders', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of all the active and inactive users in the company with user details like full name, email, role name,mobile number,Is active or not. Users can edit the user information and also users can change the password.Users can search and sort the users list in the user management.', N'User management', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the historic information of all the permissions taken by all the employees in the company.Users can edit and delete the permissions from the list.', N'Permission history', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app, users can place food order and can view the full list of food orders of all the employees with its details Also users can claim the food orders.', N'Food order management', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the full list of actively running goals under the goal responsible person', N'Project actively running goals', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app gives an overview of productivity, GRP , The count of completed worked items ,QA approved work items, bounced back counts along with its percentage and number of replans for all the reporting employees for the current month.', N'Productivity index', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of canteen amount credited ,debited and remaining for all the employees in the company and also we can credit the canteen amount to the employees by using this app. Users can search and sort the canteen credits.', N'Canteen credit', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items with the amount of time spend on each of the work item by the corresponding assigned employees in the company. Users can filter the work items based on project, hours, date and users can sort the work items in the list', N'Spent time details', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of all the employees with details like worked days, Leaves, late days, week offs, Holidays and working days for the current month.', N'Employee working days', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of the goals to be archived with its corresponding project name. Also users can sort and search goals from the list.', N'Goals to archive', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of all the employees when the employees entered the office, when the employees left the office and their break timings. This will help to track the employee timings in the office.', N'Time sheet',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the overview of the active and backlog goals across all the projects in the company along with its status color based on the key configuration.We can view the historic snapshot information taken from the live dashboard in this app.', N'Process dashboard',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of bugs that are left, fixed, added and approved by QA on priority basis for all the active goals in the company.Users can filter the bug report based on project,employees,date range and features.', N'Bug report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the pictorial representation of employee attendance with defined status colors. All the employees on the x-axis and the current month dates on the y-axis based on the defined key, colors will be displayed in the app', N'Employee Attendance',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items that an employee has worked on with its corresponding goal and project name.We can see the current status of the work item and also the bounce back count of each work item.We can also filter the app based on date range.', N'Dev quality',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items which have dependency on other employees in the company with details like project name, goal name, work item and employee name on whom the dependency is. Users can search and sort the work items list', N'Work items dependency on others',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app is the graphical representation of employee log time for the current month with defined status colors.All the employees on the x-axis and the current month dates on the y-axis based on the defined key, colors will be displayed.This app gives the overview of number of employees are on holiday or on week off or on onsite', N'Monthly log time report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app gives the overview of eligible leaves, eligible leaves YTD, leaves taken, Onsite leaves, Work from home leaves, Unplanned leaves, Paid leaves and Unpaid leaves of the current year for all the employees in the company.', N'Leaves report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app is one the performance indicator for QA, it gives an overview whether QA is taking action on time or not. This provides details like project name,goal name, work item, current status, QA name, original deployed date, latest deployed date,QA action date and the age', N'Qa performance',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of canteen amount credited for all the employees in the company. Users can search and sort the credits offered from the list', N'Canteen offers credited',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of all the employees when the employees entered the office, when the employees left the office and their break timings. This will help to track the employee timings in the office.', N'Employee feed time sheet',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the differentiation between the target and achieved productivity details', N'Everyday target details',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the overview of the active goals across all the projects in the company along with its status color based on the key configuration.', N'Live dashboard',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the overview of late employees status and who have already taken the permission.It provides details like employee name, date of permission, duration and the reason of permission.User can filter information in the app based on employee and date range and can sort data from the list.', N'Permission register',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of work items assigned for the logged user till current date with details like username, project name, goal name, work item and Estimate.User can sort each column in the app and can search the work items.', N'Employees current work items',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of work items on which the QA need to work on. It provides the details like project name, goal name,work item, deployed date time and developer name. If QA didnt take action on the work item for more than one day then the deployed date time will be displayed in red color.Users can search and sort the work items list.', N'Work items waiting for qa approval',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of recent food orders (current week) with details like Ordered items, Name, Comments and Ordered date.Users can sort and search the columns in the app.', N'Recent individual food orders',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of reporting employees with their office spent time, logged spent time and the status color based on the spent time and logged time.User can filter the data based on branch and line managers and can search for the particular employee from the list', N'Daily log time report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can manage the seating arrangement of the employees. We can record details like employee name, seat code,branch, description, comment. Users can sort each column in the app and can edit and delete the details in the app. Users can filter the app based on employee ,seat code and branch.', N'Location management',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app users can add new vendors and can view the list of vendors that are available in the company.Also users can edit the vendor details and can sort vendors list.', N'Vendor management',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app users can add new products and can edit, delete  the product details. Users can also add vendors and can link vendor details with products.User can filter information in the app based on product name, product code, manufacturer code and vendors and can sort data from the list.', N'Product management',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of assets that are purchased recently which are assigned to the employees in the company with details like asset code, asset name and purchased date. Users can search and sort the purchased assets list.', N'Recently purchased assets',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of assets that are assigned recently to the employees in the company with details like asset code, asset name, assigned to and assigned date. Users can search and sort the assets list.', N'Recently assigned assets',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of assets that are damaged recently which are assigned to the employees in the company with details like asset code, asset name, damaged by and damaged date. Users can search and sort the damaged assets list.', N'Recently damaged assets',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the list of assets assigned for the logged in user with its corresponding asset details. Users can also search and sort the assets in the list.', N'Assets allocated to me',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can see the all loggedin user tasks based on created workflow configuration', N'Review Notifications',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app is the pictorial representation of the QA effective spent time on different QA actions like test case creation/updation, test suite creation/updation, test run creation/updation, test case status updation, bugs creation/updation and reports generation etc. Effective spent time on y-axis and time period on x-axis', N'QA productivity report',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  form types for the site,can add form type and edit the form type.Also users can view the archive form type and can search and sort the form type from the list.', N'Form type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of default apps with details like app and its description and the accesible roles. Users can edit the default app details. Users can archive the default apps and can view the archived default apps.Users can search apps from the list and sort each column in the app', N'System app', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  button types for the site,can edit and can search and sort the button type from the list.', N'Button type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  permission reasons for the site,can add,archive and edit the permission reason.Also users can view the archived permission reason and can search and sort the permission reason from the list.', N'Permission reason', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  feedback types,can add feedback type ,archive feedback type and edit the feedback types.Also users can view the archived feedback type and can search and sort the feedback type from the list.', N'Feedback type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  test case automation types for the site,can add test case automation type and edit the test case automation type.Also users can view the archived test case automation type and can search and sort the test case automation type from the list.', N'Test case automation type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  Test case statuses for the site and you can edit the Test case status.Also users can search and sort the Test case status from the list.', N'Test case status', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  Test case types for the site,can add Test case type and edit  the Test case type.Also users can view the archived Test case type and can search and sort the Test case type from the list.', N'Test case type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the stores,can add store, edit and delete stores.Also users can view the stores and can search and sort stores from the list. Company and user stores will be included by default and we cant delete those stores.', N'Store management', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 --(NEWID(),N'By using this app we can manage the leave type', N'Leave type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  leave statuses for the site edit the leave status.Also users can search and sort the leave status from the list.', N'Leave status', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  leave session for the site,can add leave session and edit the leave session.Also users can search and sort the leave session from the list.', N'Leave session', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  holidays for the site,can add holiday and edit the holiday.Also users can view the archived holiday and can search and sort the holiday from the list.', N'Holiday', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the accessible IP addresses for the site,can add IP address, edit and delete the IP addresses.Also users can view the archived IP addresses and can search and sort the IP addresses from the list.', N'Accessible IP address', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 --(NEWID(),N'By using this app we can manage the role permissions', N'Role permissions', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 --(NEWID(),N'By using this app we can manage the project role permissions', N'Project role permissions', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can manage the settings of the product which will dictate the behavior  and appearance of the product like Marker, app icon etc.Users can search and sort the settings in the app. Also we can see the active and inactive settings.', N'App settings', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app dictates the behavior  and appearance of the product.By using this app users can customize the application with settings like company logo, themes and modules to be enabled and few keys . Users can search the settings. ', N'Company settings', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can configure the productive time for all the activities in the test management. We can add and edit time for different configurations. Also users can search for the configurations and can sort columns in the app.', N'Time configuration settings', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  main use cases for the site,can add main use case and edit the main use case.Also users can view the archived main use case and can search and sort the main use case from the list.', N'Main use case', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  company introduced by options for the site,can add company introduced by option and edit  the company introduced by option.Also users can view the archived company introduced by option and can search and sort the company introduced by option from the list.', N'Company introduced by option', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of configured date formats.Users can add,archive and edit the date formats and can sort and search date formats from the list. When registering a company users can select the required date format from the list of configured date formats', N'Date format', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the number formats for the site,can add,archive and edit  the number formats.Also users can view the archived number formats and can search and sort the number formats from the list.', N'Number Format', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the time formats for the site,can add time format and edit the time format.Also users can view the archived time format and can search and sort the time formats from the list.', N'Time format', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  company locations for the site,can add,archive and edit  the company location.Also users can view the archived company location and can search and sort the company location from the list.', N'Company location', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  project types for the site,can add,archive and edit  the project type.Also users can view the archived project type and can search and sort the project type from the list.', N'Project type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  work item replan type for the site,can add work item replan type and edit the work item replan type.Also users can view the archived work item replan type and can search and sort the work item replan type from the list.', N'Work item replan type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app, we can create dynamic workflow and can configure transitions between work item statuses for the dynamic workflow.User can delete workflow status and transitions.', N'Workflow management', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the Bug priorities,can edit  and can search and sort the bug priorities from the list.', N'Bug priority', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  goal replan types for the site and you can edit the goal replan type.Also users can can search and sort the goal replan type from the list.', N'Goal replan type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app provides the facility of configuration  colors for the goal performance indicator . You can edit the name of goal performance indicator name and also you can sort and search with  goal performance indicator name', N'Manage process dashboard status', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  work item statuses for the site,You can add work item status and edit the work item status.Also users can view the archived work item status and can search and sort the work item status from the list.', N'Work item status', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of all the board types in the system. We can add the new board type with details like board type name, board type UI and its workflow. Users can edit the board types and can sort and search board types from the list.', N'Board type workflow management', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 --(NEWID(),N'By using this app user can see all the  board type apis for the site,can add board type api, edit and can search and sort the board type api from the list.', N'Board type api', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  designations for the site,can add,archive and edit  the designation.Also users can view the archived designation and can search and sort the designation from the list.', N'Designation', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  paygrades for the site,can add,archive and edit the paygrade.Also users can view the archived paygrade and can search and sort the paygrade from the list.', N'Paygrade', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  contract types for the site,can add contract type and edit  the contract type.Also users can view the archived contract type and can search and sort the contract type from the list.', N'Contract type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the currencies for the site,can add,archive and edit the currency.Also users can view the archived currency and can search and sort the currency from the list.', N'Currency', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the departments for the site,can add departments and edit  the department.Also users can view the archived department and can search and sort the department from the list.', N'Department', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  rate types for the site,can add,archive and edit the rate type.Also users can view the archived rate type and can search and sort the rate type from the list.', N'Rate type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  region for the site,can add,archive and edit the region.Also users can view the archived region and can search and sort the region from the list.', N'Region', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  payment methods for the site,can add,archive and edit  the payment method.Also users can view the archived payment method and can search and sort the payment method from the list.', N'Payment method', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  education levels for the site,can add,archive and edit the education level.Also users can view the archived education level and can search and sort the education level from the list.', N'Education levels', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  job categories for the site,can add ,archive and edit  the job category.Also users can view the archived job category and can search and sort the job category from the list.', N'Job category', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  countries for the site,can add,archive and edit the country.Also users can view the archived country and can search and sort the country from the list.', N'Country', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  time zoness for the site,can add time zones and edit the time zones.Also users can view the archived time zones and can search and sort the time zones from the list.', N'Time zone', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  reporting methods for the site,can add reporting method and edit the reporting methods.Also users can view the archived reporting methods and can search and sort the reporting methods from the list.', N'Reporting methods', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  memberships for the site,can add memberships and edit the memberships.Also users can view the archived memberships and can search and sort the memberships from the list.', N'Memberships', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  employment type for the site,can add employment type and edit the employment type.Also users can view the archived employment type and can search and sort the employment type from the list.', N'Employment type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  pay frequencies for the site,can add,archive and edit  the pay frequency.Also users can view the archived pay frequency and can search and sort the pay frequency from the list.', N'Pay frequency', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  nationalities for the site,can add,archive and edit the nationalities.Also users can view the archived nationalities and can search and sort the nationalities from the list.', N'Nationalities', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  languages for the site,can add languages and edit the languages.Also users can view the archived languages and can search and sort the languages from the list.', N'Languages', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  skills for the site,can add skills, edit and delete the skills.Also users can view the archived skills and can search and sort the skills from the list.', N'Skills', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  shift timings for the site,can add shift timing and edit the shift timing.Also users can search and sort the shift timing from the list.', N'Shift timing', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  branches for the site,can add,archive and edit the branch.Also users can view the archived branch and can search and sort the branch from the list.', N'Branch', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  payment types for the site,can add payment type and edit the payment type.Also users can view the archived payment type and can search and sort the payment type from the list.', N'Payment type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the license types for the site,can add license type and edit the license type.Also users can view the archived license type and can search and sort the license type from the list.', N'License type', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  states for the site,can add state and edit the state.Also users can view the archived state and can search and sort the state from the list.', N'State', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  crud operations for the site,can add crud operation and edit  the crud operation.Also users can view the archived crud operation and can search and sort the crud operation from the list.', N'Crud operation', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  transition deadlines for the site,can add transition deadline, edit and delete the transition deadline.Also users can view the archived transition deadline and can search and sort the transition deadline from the list.', N'Manage transition deadline', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can configure the settings related to activity tracker like track apps and urls,screenshot frequency,delete screenshots,record activity,Ideal time and manual time.', N'Activity tracker configuration', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app, we can configure the applications whether it is a productive or not by providing details like App name, app icon,application type and we can assign the application for roles. Also we can view the list of applications added. Users can edit the applications and can sort each column in the application.', N'Productivity apps', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  restriction type for the site,can add,archive and edit the restriction type.Also users can view the archived restriction type and can search and sort the restriction type from the list.', N'Restriction type',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  Leave formulas for the site,can add Leave formula and edit the Leave formula.Also users can view the archived Leave formula and can search and sort the Leave formula from the list.', N'Leave formula',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of late employees to office today with the details like employee name and the date of late.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'Morning late employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of employees who comes late to the office in afternoon session with date.Users can sort the employee data and can filter data based on date ranges.', N'Lunch break late employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of more spent time employees in the company(top 5) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'More spent time employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of most spent time employees in the company(top fifty percent) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'Top fifty percent spent employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of least spent time employees in the company(bottom fifty percent) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'Bottom fifty percent spent employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app you can see the count of day employees who came late at morning and afternoon. In this data you can search , order  and you can filter the data', N'Morning and afternoon late employee', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the graphical representation of morning late employees count for each date in this month. User can use the filer the data with help of filters like branch,department,designation and date', N'Morning late employee count Vs date', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the count of employees who comes late to the office in afternoon session with date.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app', N'Lunch break late employee count Vs date',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of all the default and configured dashboards and its accessible roles like default roles, view roles, edit roles and delete roles. Users can sort and search the dashboards from the list. Users can also update the permissions for each dashboard.', N'Dashboard configuration',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'Project, Goal, Work item, Deadline, Employee,Scenario, Run,Version,Testreport,Estimated time, Estimation and it plurals can be customised to match the company naming conventions.', N'Soft label configuration', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the  work item type for the site,can add work item type and edit the work item type.Also users can view the archived work item type and can search and sort the work item type from the list.', N'Work item type', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app we can manage the all forms details',N'Forms', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the details of the form that was selected in the Forms app. Users can edit the form details and can navigate to other dashboard or any analytical dashboard.',N'Form details',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the form history details like field name, field value, value changed by and value edited date time. Users can sort each column in the app.',N'Form history',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'By using this app user can see all the observation types,can add observation types, edit and delete observation types.Also users can search and sort the observation types from the list.Users can submit the observations for each observation type in form observations app',N'Observation Types',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the list of observations with details like observation name, submitted by and created on time. Users can create the new observations by selecting the observation type. Also users can sort the columns in the app.',N'Form observations',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),N'This app displays the work items which are not assigned to any of the person and can add new adhoc work items.Users can view the work items in calendar view when deadlines are included for the work items.Users can search the work items and can filter based on work item tags, status, work item type ,bug priority and unassigned work items.', N'All work items', CAST(N'2020-02-03 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
	
	INSERT INTO [RoleFeature]([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
	SELECT NEWID(),@RoleId,F.Id,GETDATE(),@UserId 
	FROM Feature F 
	WHERE F.InActiveDateTime IS NULL
	      AND F.Id IN (SELECT FeatureId 
		               FROM FeatureModule FM
	                        INNER JOIN CompanyModule CM ON CM.ModuleId = FM.ModuleId 
					                   AND CM.CompanyId = @CompanyId)
	
	INSERT INTO [EntityRoleFeature] ([Id], [EntityFeatureId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId]) 
	SELECT NEWID(),EF.Id,(SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId),GETDATE(),@UserId 
	FROM EntityFeature EF
	
    
END
GO