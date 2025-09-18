CREATE TABLE [dbo].[LeaveEncashmentSettings]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Percentage] [decimal](18,4) NULL,
	[PayRollComponentId] [uniqueidentifier] NULL,
	[BranchId] [uniqueidentifier] NULL,
	[IsCtcType] [bit] NULL DEFAULT 0,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[Amount] [decimal](18,4) NULL
    CONSTRAINT [PK_LeaveEncashmentSettings] PRIMARY KEY ([Id]),
)
GO
ALTER TABLE [dbo].[LeaveEncashmentSettings]  WITH CHECK ADD  CONSTRAINT [FK_LeaveEncashmentSettings_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[LeaveEncashmentSettings] CHECK CONSTRAINT [FK_LeaveEncashmentSettings_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[LeaveEncashmentSettings]  WITH CHECK ADD  CONSTRAINT [FK_LeaveEncashmentSettings_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[LeaveEncashmentSettings] CHECK CONSTRAINT [FK_LeaveEncashmentSettings_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[LeaveEncashmentSettings]  WITH NOCHECK ADD CONSTRAINT [FK_LeaveEncashmentSettings_PayRollComponent_PayRollComponentId] FOREIGN KEY([PayRollComponentId])
REFERENCES [dbo].[PayRollComponent] ([Id])
GO

ALTER TABLE [dbo].[LeaveEncashmentSettings] CHECK CONSTRAINT [FK_LeaveEncashmentSettings_PayRollComponent_PayRollComponentId]
GO
ALTER TABLE [dbo].[LeaveEncashmentSettings]  WITH NOCHECK ADD CONSTRAINT [FK_LeaveEncashmentSettings_PayRollComponent_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[LeaveEncashmentSettings] CHECK CONSTRAINT [FK_LeaveEncashmentSettings_PayRollComponent_BranchId]
GO