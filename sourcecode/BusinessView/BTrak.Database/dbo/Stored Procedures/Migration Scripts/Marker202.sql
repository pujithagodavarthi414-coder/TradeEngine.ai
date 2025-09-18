CREATE PROCEDURE [dbo].[Marker202]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[SoftLabelConfigurations] AS Target
    USING ( VALUES
     (NEWID(), GETDATE(), @UserId, @CompanyId, N'Audit', N'Audits', N'Conduct', N'Conducts', N'Action', N'Actions',N'Audit report', N'Audit reports', N'Timeline', N'Audit activity', N'Audit analytics')
    )
    AS Source ([Id], [CreatedDateTime], [CreatedByUserId], [CompanyId],[AuditLabel],[AuditsLabel],[ConductLabel],[conductsLabel],[ActionLabel],[ActionsLabel],[AuditReportLabel],[AuditReportsLabel],[TimelineLabel],[AuditActivityLabel],[AuditAnalyticsLabel])
    ON Target.CompanyId = Source.CompanyId
    WHEN MATCHED THEN
    UPDATE SET 
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId]       = Source.[CompanyId],
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
               [AuditAnalyticsLabel] = Source.[AuditAnalyticsLabel];


MERGE INTO [dbo].[WorkFlow] AS Target 
    USING ( VALUES             
            (NEWID(),@CompanyId, N'Workflow status', CAST(N'2018-08-13 06:19:17.517' AS DateTime), 
            @UserId, NULL, NULL, NULL)
    )
    AS Source ([Id],CompanyId, [Workflow], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[InactiveDateTime]) 
    ON Target.Workflow = Source.Workflow AND Target.CompanyId = Source.CompanyId
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

        
MERGE INTO [dbo].[UserStoryStatus] AS Target 
    USING ( VALUES 
        (NEWID(),@CompanyId,16, N'Accepted', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#70ad47','FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'),
        (NEWID(),@CompanyId,17, N'Rejected', CAST(N'2018-08-13 06:20:28.687' AS DateTime), @UserId,  N'#ead1dd','166DC7C2-2935-4A97-B630-406D53EB14BC')
    ) 
    AS Source ([Id],CompanyId,[LookUpKey], [Status], [CreatedDateTime], [CreatedByUserId], [StatusHexValue],[TaskStatusId]) 
    ON Target.[Status] = Source.[Status] AND Source.CompanyId = Target.CompanyId
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


MERGE INTO [dbo].[WorkflowStatus] AS Target
    USING ( VALUES 
            (NEWID() , (SELECT Id FROM WorkFlow WHERE Workflow = 'Workflow status' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), 1,0,0,  CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId ,@CompanyId)
            ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Workflow status' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Accepted' AND CompanyId = @CompanyId), 2,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
           ,(NEWID() , (SELECT Id FROM WorkFlow WHERE WorkFlow = 'Workflow status' AND CompanyId = @CompanyId),(SELECT Id FROM UserStoryStatus WHERE [Status] = 'Rejected' AND CompanyId = @CompanyId), 3,0,0, CAST(N'2018-08-13 06:19:17.517' AS DateTime), @UserId,@CompanyId)
    ) 
    AS Source ([Id], [WorkflowId], [UserStoryStatusId], [OrderId] ,[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
    ON Target.WorkFlowId = Source.WorkFlowId AND Source.CompanyId = Target.CompanyId AND Source.UserStoryStatusId = Target.UserStoryStatusId
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
    WHEN NOT MATCHED BY TARGET AND Source.UserStoryStatusId IS NOT NULL THEN 
    INSERT ([Id], [WorkflowId], [UserStoryStatusId], [OrderId],[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]) 
    VALUES ([Id], [WorkflowId], [UserStoryStatusId], [OrderId],[CanAdd], [CanDelete], [CreatedDateTime], [CreatedByUserId],[CompanyId]);


MERGE INTO [dbo].[WorkflowEligibleStatusTransition] AS Target 
    USING ( VALUES 
             (NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Accepted' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Workflow status' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL, @CompanyId)
            ,(NEWID(), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Todo' AND CompanyId = @CompanyId), (SELECT Id FROM UserStoryStatus WHERE [Status] = 'Rejected' AND CompanyId = @CompanyId), NULL, NULL, (SELECT Id FROM WorkFlow WHERE Workflow = 'Workflow status' AND CompanyId = @CompanyId), GETDATE(), @UserId, NULL, NULL,@CompanyId)
    )
    AS Source ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],CompanyId) 
    ON Target.FromWorkflowUserStoryStatusId = Source.FromWorkflowUserStoryStatusId AND Source.CompanyId = Target.CompanyId AND Source.ToWorkflowUserStoryStatusId = Target.ToWorkflowUserStoryStatusId
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
    WHEN NOT MATCHED BY TARGET AND Source.FromWorkflowUserStoryStatusId IS NOT NULL THEN 
    INSERT ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[CompanyId]) VALUES ([Id], [FromWorkflowUserStoryStatusId], [ToWorkflowUserStoryStatusId], [Deadline], [DisplayName], [WorkflowId], [CreatedDateTime], [CreatedByUserId], [UpdatedDateTime], [UpdatedByUserId],[CompanyId]);
  
END
GO


