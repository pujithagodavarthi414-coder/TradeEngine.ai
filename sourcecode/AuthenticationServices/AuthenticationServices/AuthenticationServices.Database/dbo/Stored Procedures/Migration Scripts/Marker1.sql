CREATE PROCEDURE [dbo].[Marker1]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId  AND IndustryId ='744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71'))
	BEGIN
		MERGE INTO [dbo].[Role] AS Target 
		USING ( VALUES 
				(NEWID(), @CompanyId, N'Consultant', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'HR Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'HR Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, 1	),
				(NEWID(), @CompanyId, N'Software Trainee', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
				(NEWID(), @CompanyId, N'Analyst Developer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
				(NEWID(), @CompanyId, N'CEO', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, 1),
				(NEWID(), @CompanyId, N'Goal Responsible Person', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Digital Sales Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Director', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Lead Generation Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Recruiter', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Hr Consultant', CAST(N'2018-09-06T11:21:49.207' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Senior Software Engineer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
				(NEWID(), @CompanyId, N'Business Development Executive', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Temp Grp', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Lead Developer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
				(NEWID(), @CompanyId, N'Manager', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'QA', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Freelancer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Software Engineer', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, 1, NULL),
				(NEWID(), @CompanyId, N'COO', CAST(N'2018-08-24T15:18:26.297' AS DateTime), @UserId, NULL, NULL, NULL, 1),
				(NEWID(), @CompanyId, N'Business Analyst', CAST(N'2018-09-26T12:12:37.043' AS DateTime), @UserId, NULL, NULL, NULL, NULL),
				(NEWID(), @CompanyId, N'Client', CAST(N'2018-09-26T12:12:37.043' AS DateTime), @UserId, NULL, NULL, NULL, NULL)
				)
		AS Source ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]) 
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [CompanyId] = Source.[CompanyId],
					[RoleName] = Source.[RoleName],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[CreatedByUserId] = Source.[CreatedByUserId],
					[UpdatedDateTime] = Source.[UpdatedDateTime],
					[UpdatedByUserId] = Source.[UpdatedByUserId],
					[IsDeveloper] = Source.[IsDeveloper],
					[IsAdministrator] =  Source.[IsAdministrator]
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]) VALUES ([Id], [CompanyId], [RoleName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[IsDeveloper],[IsAdministrator]);	      
	END

  -- Marker5
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'47813006-C1BA-4F74-AB00-621CC82828AC', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker13
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'656502D8-3898-4451-8609-5F9BBCF23463', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	 MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'3631B1E9-B9CA-4CE4-B33B-3DDBA2B2459E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker20
	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
         (NEWID(),@RoleId, N'C1FB7F26-C9F3-42C7-8ADE-2848B7597F97', CAST(N'2019-09-17 11:13:53.230' AS DateTime), @UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'6AAEC58E-DE60-4ED4-A923-65644D76A7C2', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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
    
    MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'40AC6FAE-794D-47E9-B968-1B7E175EE93B', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker31
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'E50D0E15-8A69-488B-9391-27659FA2AB4A', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'83B1EF70-F371-42AF-A8C5-A1632033D4B7', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'7CD55073-755E-4126-A4B7-E880BA223AC3', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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
	
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
		(NEWID(), @RoleId, N'2DDDBEBA-63F7-423D-B522-1181B5782DDE', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
			   (NEWID(), @RoleId, N'7E12ED2E-0A76-450F-95DF-16EB35A3EA23', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
			   (NEWID(), @RoleId, N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
			   (NEWID(), @RoleId, N'D9FDF976-5055-42CA-87F6-644EA5BF1F2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'D0AE20C9-BF9C-4389-8904-E9557D7B498F', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
			   (NEWID(), @RoleId, N'7A11C52B-30C2-4923-977C-3C4D0F87A4CC', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker48
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

	-- Marker59
	IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId AND IndustryId = '744DF8FD-C7A7-4CE9-8390-BB0DB1C79C71'))
	BEGIN
		MERGE INTO [dbo].[RoleFeature] AS Target 
		USING ( VALUES 
					(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Consultant'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'HR Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'HR Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Software Trainee'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Analyst Developer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Goal Responsible Person'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Digital Sales Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Director'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Lead Generation Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Recruiter'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Hr Consultant'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Senior Software Engineer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Business Development Executive'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Temp Grp'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Lead Developer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Manager'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'QA'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Freelancer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Software Engineer'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'COO'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
					,(NEWID(), (SELECT Id From [Role] where CompanyId = @CompanyId AND RoleName = 'Business Analyst'), N'2FC44829-C576-47A0-8FC8-BA6FA3AEFA9D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		)
		AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [RoleId] = Source.[RoleId],
					[FeatureId] = Source.[FeatureId],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET AND Source.[RoleId] IS NOT NULL THEN 
		INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
	END

	-- Marker67
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'EB5AF322-1502-4F00-92B0-A2EADA7D08EA', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker101
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'58822DB6-B5DF-4431-A851-45AF8D9AEC1E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker109
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'87ABB450-990F-4D24-94FC-739C1A664C7B', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker128
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'7517DF07-DEEC-4329-B080-A3F3ABAC620D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker137
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'5C7980DA-71DB-45BA-988E-BB0E5528AF58', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'49C8F995-EE29-4E55-B136-B2A6D7219D6A', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'117299CA-8FC4-4EE0-83DD-EAAA0B10505F', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'BD446D02-EFE4-4E63-B83B-C5463B395640', GETDATE(),@UserId)
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

	-- Marker163
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'38CED01C-DB50-4999-ABC3-EAE960DD51DB', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
			  ,(NEWID(), @RoleId, N'2B447F3A-8022-43A7-B145-731D5F6678F6', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
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
	
	-- Marker172
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
		(NEWID(), @RoleId, N'E019ECCC-E398-40DC-A95C-EC0F3771C258', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
	)
	AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
	ON Target.[RoleId] = Source.[RoleId]  AND Target.[FeatureId] = Source.[FeatureId]  
	WHEN MATCHED THEN 
	UPDATE SET [RoleId] = Source.[RoleId],
				[FeatureId] = Source.[FeatureId],
   			[CreatedDateTime] = Source.[CreatedDateTime],
   			[CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
	VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);

	-- Marker183
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'B50D9A50-06CB-4D9B-8227-617CDAF016FD', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'38CED01C-DB50-4999-ABC3-EAE960DD51DB', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
			  ,(NEWID(), @RoleId, N'2B447F3A-8022-43A7-B145-731D5F6678F6', CAST(N'2020-10-06T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker205
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'6C966874-025C-465B-9D9E-C69546DC58D9', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'E467AA34-60DD-4821-95DF-989DB2E1B7B1', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'83D2EE67-0359-44DF-A1D3-9B9CE3F4F4EC', GETDATE(),@UserId),
	           (NEWID(), @RoleId, N'EE98BB8F-E5A6-40B8-A3C4-49AA57CC0061', GETDATE(),@UserId)
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

	-- Marker240
	IF(EXISTS(SELECT * FROM Company WHERE Id = @CompanyId))
	BEGIN
		MERGE INTO [dbo].[RoleFeature] AS Target 
		USING ( VALUES 
			(NEWID(), @RoleId, N'8B154265-6F3D-4222-BF8F-89A6BBB3AD29', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
			,(NEWID(), @RoleId, N'6098A309-B0CB-4A22-A586-7B1D743DFCB1', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
			,(NEWID(), @RoleId, N'7E498DC2-F0A4-4DA4-A457-6741EADE5A33', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
			,(NEWID(), @RoleId, N'25FC903D-3D8B-4DE3-8514-E5BED581F866', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
			,(NEWID(), @RoleId, N'48BD5E94-1E22-423D-98E4-BDA63427D0E5', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
			,(NEWID(), @RoleId, N'AB8838C6-14A1-499E-BA0C-79B39904D2B4', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		)
		AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id  
		WHEN MATCHED THEN 
		UPDATE SET [RoleId] = Source.[RoleId],
					[FeatureId] = Source.[FeatureId],
					[CreatedDateTime] = Source.[CreatedDateTime],
					[CreatedByUserId] = Source.[CreatedByUserId]
		WHEN NOT MATCHED BY TARGET AND Source.[RoleId] IS NOT NULL THEN 
		INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
		VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);
	END

	-- Marker241
	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'47DA5B02-11CC-4B83-B20A-78C08DDCDE2E', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'D3C8C1AD-7DE2-42A9-A67C-54E4DAF075E2', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker281
	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'7EBFBDB0-EE66-4A16-902E-18A62CD0E8C9', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'86762993-C543-43D1-9034-647B1095CA5A', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker290
	MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
			   (NEWID(), @RoleId, N'7EEE0735-9D75-49D9-88FE-710B2B466107', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

	-- Marker318
	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'7AA105DD-6C7C-4878-B0EA-DDCC80D37C12', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
		
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

	MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'C8D9C9F2-BFA4-4619-9F96-C3A7177947EF', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'4B068355-DAFF-412C-A6B4-3133BEB75C6D', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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

END
GO