CREATE TABLE [dbo].[WorkflowStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[WorkflowId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[UserStoryStatusId] [uniqueidentifier] NOT NULL,
	[OrderId] [int] NULL,
	[CanAdd] BIT NULL DEFAULT 0,
	[CanDelete] BIT NULL DEFAULT 0,
	[CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetimeoffset] NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_WorkflowStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_WorkflowStatus_Company_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id])
)
GO

ALTER TABLE [dbo].[WorkflowStatus]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStatus_Workflow_WorkflowId] FOREIGN KEY([WorkflowId])
REFERENCES [dbo].[Workflow] ([Id])
GO
ALTER TABLE [dbo].[WorkflowStatus] CHECK CONSTRAINT [FK_WorkflowStatus_Workflow_WorkflowId]
GO

ALTER TABLE [dbo].[WorkflowStatus]  WITH CHECK ADD  CONSTRAINT [FK_WorkflowStatus_UserStoryStatus_UserStoryStatusId] FOREIGN KEY([UserStoryStatusId])
REFERENCES [dbo].[UserStoryStatus] ([Id])
GO
ALTER TABLE [dbo].[WorkflowStatus] CHECK CONSTRAINT [FK_WorkflowStatus_UserStoryStatus_UserStoryStatusId]
GO

CREATE NONCLUSTERED INDEX IX_WorkflowStatus_WorkflowId_UserStoryStatusId
ON [dbo].[WorkflowStatus] ([WorkflowId],[UserStoryStatusId])
INCLUDE ([Id])
GO