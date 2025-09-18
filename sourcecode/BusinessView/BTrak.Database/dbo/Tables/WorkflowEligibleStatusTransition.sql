CREATE TABLE [dbo].[WorkflowEligibleStatusTransition] (
    [Id]                            UNIQUEIDENTIFIER NOT NULL,
    [FromWorkflowUserStoryStatusId] UNIQUEIDENTIFIER NOT NULL,
    [ToWorkflowUserStoryStatusId]   UNIQUEIDENTIFIER NOT NULL,
	[CompanyId]                     UNIQUEIDENTIFIER  NULL,
    [Deadline]                      NVARCHAR (500)   NULL,
    [DisplayName]                   VARCHAR (250)    NULL,
    [WorkflowId]                    UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime]               DATETIME         NOT NULL,
    [CreatedByUserId]               UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime]               DATETIME         NULL,
    [UpdatedByUserId]               UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_WorkflowEligibleStatusTransition] PRIMARY KEY CLUSTERED ([Id] ASC), 
    CONSTRAINT [FK_WorkflowEligibleStatusTransition_Company_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]),
);
GO
ALTER TABLE [dbo].[WorkflowEligibleStatusTransition]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkflowEligibleStatusTransition_UserStoryStatus_FromWorkflowUserStoryStatusId] FOREIGN KEY([FromWorkflowUserStoryStatusId])
REFERENCES [dbo].[UserStoryStatus] ([Id])
GO

ALTER TABLE [dbo].[WorkflowEligibleStatusTransition] CHECK CONSTRAINT [FK_WorkflowEligibleStatusTransition_UserStoryStatus_FromWorkflowUserStoryStatusId]
GO

ALTER TABLE [dbo].[WorkflowEligibleStatusTransition]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkflowEligibleStatusTransition_UserStoryStatus_ToWorkflowUserStoryStatusId] FOREIGN KEY([ToWorkflowUserStoryStatusId])
REFERENCES [dbo].[UserStoryStatus] ([Id])
GO

ALTER TABLE [dbo].[WorkflowEligibleStatusTransition] CHECK CONSTRAINT [FK_WorkflowEligibleStatusTransition_UserStoryStatus_ToWorkflowUserStoryStatusId]
GO

ALTER TABLE [dbo].[WorkflowEligibleStatusTransition]  WITH NOCHECK ADD  CONSTRAINT [FK_WorkflowEligibleStatusTransition_Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([Id])
GO

ALTER TABLE [dbo].[WorkflowEligibleStatusTransition] CHECK CONSTRAINT [FK_WorkflowEligibleStatusTransition_Workflow_WorkflowId]
GO


CREATE NONCLUSTERED INDEX [IX_WorkflowEligibleStatusTransition_FromWorkflowUserStoryStatusId]
ON [dbo].[WorkflowEligibleStatusTransition] (FromWorkflowUserStoryStatusId,ToWorkflowUserStoryStatusId)
GO
