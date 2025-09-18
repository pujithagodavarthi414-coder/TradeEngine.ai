CREATE  TABLE [dbo].[PayrollRunStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollRunId]  [uniqueidentifier] NOT NULL,
	[PayrollStatusId]  [uniqueidentifier] NOT NULL,
	[StatusChangeDateTime] [datetime] NULL,
	[Comments] [NVARCHAR](1000) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    [WorkflowProcessInstanceId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_PayrollRunStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRunStatus]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunStatus_PayrollRun_PayrollRunId] FOREIGN KEY([PayrollRunId])
REFERENCES [dbo].[PayrollRun] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunStatus] CHECK CONSTRAINT [FK_PayrollRunStatus_PayrollRun_PayrollRunId]
GO

ALTER TABLE [dbo].[PayrollRunStatus]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollRunStatus_PayrollStatus_PayrollStatusId] FOREIGN KEY([PayrollStatusId])
REFERENCES [dbo].[PayrollStatus] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunStatus] CHECK CONSTRAINT [FK_PayrollRunStatus_PayrollStatus_PayrollStatusId]
GO


ALTER TABLE [dbo].[PayrollRunStatus]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunStatus_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunStatus] CHECK CONSTRAINT [FK_PayrollRunStatus_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollRunStatus]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRunStatus_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRunStatus] CHECK CONSTRAINT [FK_PayrollRunStatus_User_UpdatedByUserId]
GO
