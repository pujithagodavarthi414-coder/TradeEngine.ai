CREATE   TABLE [dbo].[PayrollBranchConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[PayrollTemplateId]  [uniqueidentifier] NOT NULL,
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollBranchConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollBranchConfiguration_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration] CHECK CONSTRAINT [FK_PayrollBranchConfiguration_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollBranchConfiguration]  WITH CHECK ADD  CONSTRAINT [FK_PayrollBranchConfiguration_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration] CHECK CONSTRAINT [FK_PayrollBranchConfiguration_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollBranchConfiguration_Branch_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration] CHECK CONSTRAINT [FK_PayrollBranchConfiguration_Branch_BranchId]
GO
ALTER TABLE [dbo].[PayrollBranchConfiguration]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollBranchConfiguration_PayrollTemplate_PayrollTemplateId] FOREIGN KEY([PayrollTemplateId])
REFERENCES [dbo].[PayrollTemplate] ([Id])
GO

ALTER TABLE [dbo].[PayrollBranchConfiguration] CHECK CONSTRAINT [FK_PayrollBranchConfiguration_PayrollTemplate_PayrollTemplateId]
GO