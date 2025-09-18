CREATE TABLE [dbo].[EmployeeBadge]
(   [Id] [uniqueidentifier] NOT NULL,
	[BadgeId] [Uniqueidentifier] NOT NULL,
	[AssignedTo] [uniqueidentifier] NOT NULL,
	[BadgeDescription] [nvarchar](250) NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetime] NULL,
    CONSTRAINT [PK_EmployeeBadge] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[EmployeeBadge]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBadge_Badge] FOREIGN KEY([BadgeId])
REFERENCES [dbo].[Badge] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBadge] CHECK CONSTRAINT [FK_EmployeeBadge_Badge]
GO

ALTER TABLE [dbo].[EmployeeBadge]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBadge_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBadge] CHECK CONSTRAINT [FK_EmployeeBadge_User]
GO

ALTER TABLE [dbo].[EmployeeBadge]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeBadge_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeBadge] CHECK CONSTRAINT [FK_EmployeeBadge_User1]
GO

