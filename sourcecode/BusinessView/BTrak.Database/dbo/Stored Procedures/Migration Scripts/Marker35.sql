CREATE PROCEDURE [dbo].[Marker35]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

	--MERGE INTO [dbo].[Project] AS Target 
	--USING (VALUES 
	--		 (NEWID(),@CompanyId,@UserId, N'Audit compliance',CAST(N'2020-05-29T12:12:41.667' AS DateTime), @UserId,NULL)
	--		)
	--AS Source ([Id], [CompanyId],[ProjectResponsiblePersonId], [ProjectName], [CreatedDateTime], [CreatedByUserId], [InactiveDateTime])
	--ON Target.Id = Source.Id  
	--WHEN MATCHED THEN 
	--UPDATE SET
	--		   [CompanyId] = Source.[CompanyId],
	--		   [ProjectResponsiblePersonId] = Source.[ProjectResponsiblePersonId],
	--		   [ProjectName] = Source.[ProjectName],
	--		   [CreatedDateTime] = Source.[CreatedDateTime],
	--		   [CreatedByUserId] = Source.[CreatedByUserId],
	--		   [InactiveDateTime] = Source.[InactiveDateTime]
	--WHEN NOT MATCHED BY TARGET THEN 
	--INSERT ([Id], [CompanyId],[ProjectResponsiblePersonId], [ProjectName], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime]) 
	--VALUES ([Id], [CompanyId],[ProjectResponsiblePersonId], [ProjectName],[CreatedDateTime], [CreatedByUserId],[InactiveDateTime]);

	--MERGE INTO [dbo].[Goal] AS Target 
	--USING (VALUES 
	--		 (NEWID(), (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Audit compliance'), (SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'Kanban' AND CompanyId = @CompanyId), N'Compliance Action', N'Compliance Action',NULL, DATEADD(DAY,-3,GetDate()), NULL, NULL, GETDATE(), @UserId, '7a79ab9f-d6f0-40a0-a191-ced6c06656de', NULL, (SELECT Id FROM [ConsiderHours] WHERE CompanyId = @CompanyId AND IsEsimatedHours = 1), N'#04fe02', 1, NULL, 1, 1, 1, NULL, NULL, NULL, 'Compliance')
	--		 --(NEWID(), (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Audit compliance project'),(SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'Kanban' AND CompanyId = @CompanyId), N'Compliance Action Goal',N'Compliance Action Goal', 0,@UserId, GETDATE(),@UserId, NULL,'Compliance Action')
	--		)
	--AS Source ([Id], [ProjectId], [BoardTypeId], [GoalName],[GoalShortName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
	--			[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsParked], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
	--			[Version], [ParkedDateTime],[GoalUniqueName])
	--ON Target.Id = Source.Id  
	--WHEN MATCHED THEN 
	--UPDATE SET
	--	   [ProjectId] = Source.[ProjectId],
	--	   [BoardTypeId] = Source.[BoardTypeId],
	--	   [GoalName] = Source.[GoalName],
	--	   [GoalShortName] = Source.[GoalShortName],
	--	   [GoalBudget] = Source.[GoalBudget],
	--	   [OnboardProcessDate] = Source.[OnboardProcessDate],
	--	   [IsLocked] = Source.[IsLocked],
	--	   [GoalResponsibleUserId] = Source.[GoalResponsibleUserId],
 --          [CreatedDateTime] = Source.[CreatedDateTime],
 --          [CreatedByUserId] = Source.[CreatedByUserId],
	--	   [GoalStatusId] = Source.[GoalStatusId],
	--	   [ConfigurationId] = source.[ConfigurationId],
	--	   [ConsiderEstimatedHoursId] = Source.[ConsiderEstimatedHoursId],
	--	   [GoalStatusColor] = Source.[GoalStatusColor],
	--	   [IsProductiveBoard] = Source.[IsProductiveBoard],
	--	   [IsApproved] = Source.[IsApproved],
	--	   [ConsiderEstimatedHours] = Source.[ConsiderEstimatedHours],
	--	   [IsToBeTracked] = Source.[IsToBeTracked],
	--	   [BoardTypeApiId] = Source.[BoardTypeApiId],
	--	   GoalUniqueName = Source.GoalUniqueName,
	--	   [Version] = Source.[Version],
	--	   [ParkedDateTime] = Source.[ParkedDateTime]
	--WHEN NOT MATCHED BY TARGET THEN 
	--INSERT ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
	--		[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
	--		[Version], [ParkedDateTime],[GoalUniqueName]) 
	--VALUES ([Id], [ProjectId], [BoardTypeId], [GoalName], [GoalBudget], [OnboardProcessDate], [IsLocked], [GoalShortName], [GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[GoalStatusId], [ConfigurationId], 
	--		[ConsiderEstimatedHoursId], [GoalStatusColor], [IsProductiveBoard], [IsApproved], [ConsiderEstimatedHours], [IsToBeTracked], [BoardTypeApiId], 
	--		[Version], [ParkedDateTime],[GoalUniqueName]);

	--MERGE INTO [dbo].[GoalWorkFlow] AS Target
	--USING ( VALUES
	--        (NEWID(), (SELECT G.Id FROM Goal G WHERE GoalName = N'Compliance Action' AND CreatedByUserId = @UserId), (SELECT Id FROM WorkFlow WHERE CompanyId = @CompanyId AND Workflow = 'Kanban'),GETDATE(),@UserId)
	--)
	--AS Source ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) 
	--ON Target.Id = Source.Id
	--WHEN MATCHED THEN
	--UPDATE SET [GoalId] = source.[GoalId],
	--		   [WorkFlowId] = source.[WorkFlowId],
	--           [CreatedDateTime] = Source.[CreatedDateTime],
	--           [CreatedByUserId] = Source.[CreatedByUserId]
	--WHEN NOT MATCHED BY TARGET THEN
	--INSERT ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id], [GoalId],[WorkFlowId],[CreatedDateTime],[CreatedByUserId]);

	--INSERT INTO [dbo].[UserProject] ([Id], [UserId], [ProjectId], [GoalId], [EntityRoleId], [CreatedDateTime], [CreatedByUserId])
	--SELECT NEWID(), @UserId, (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Audit compliance'), NULL, (SELECT Id FROM [EntityRole] WHERE EntityRoleName = 'Project manager' AND CompanyId = @CompanyId), GetDate(), @UserId

	MERGE INTO [dbo].[UserStoryType] AS Target 
	USING ( VALUES 
			(NEWID(),@CompanyId, N'Action', CAST(N'2020-05-29 13:50:10.967' AS DateTime), @UserId, NULL, NULL, N'ACTION', NULL, NULL, NULL, 1, 1, 1, N'#FEB702')
	) 
	AS Source ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId], [ShortName], [IsBug], [IsUserStory], [IsFillForm], [IsQaRequired], [IsLogTimeRequired], [IsAction], [Color]) 
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
			   [IsLogTimeRequired] = Source.IsLogTimeRequired,
			   [IsAction] = Source.IsAction
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsAction],[Color]) 
	VALUES ([Id],[CompanyId], [UserStoryTypeName], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[ShortName],[IsBug],[IsUserStory],[IsFillForm],[IsQaRequired],[IsLogTimeRequired],[IsAction],[Color]);

END
GO