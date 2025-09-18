CREATE TABLE [dbo].[SpecificDay]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[Reason] [nvarchar](500) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_SpecificDay] PRIMARY KEY ([Id])
)
GO
ALTER TABLE [dbo].[SpecificDay]  WITH CHECK ADD  CONSTRAINT [FK_SpecificDay_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[SpecificDay] CHECK CONSTRAINT [FK_SpecificDay_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[SpecificDay]  WITH CHECK ADD  CONSTRAINT [FK_SpecificDay_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[SpecificDay] CHECK CONSTRAINT [FK_SpecificDay_User_UpdatedByUserId]
GO
