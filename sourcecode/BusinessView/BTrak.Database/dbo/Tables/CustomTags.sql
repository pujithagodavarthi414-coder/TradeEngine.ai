CREATE TABLE [dbo].[CustomTags](
	[Id] [uniqueidentifier] NOT NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[TagId] [uniqueidentifier]  NULL,
	--[Tags] [nvarchar](max)  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL
    CONSTRAINT [PK_CustomTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomTags]  WITH CHECK ADD  CONSTRAINT [FK_CustomTags_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomTags] CHECK CONSTRAINT [FK_CustomTags_User]
GO

ALTER TABLE [dbo].[CustomTags]  WITH CHECK ADD  CONSTRAINT [FK_CustomTags_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CustomTags] CHECK CONSTRAINT [FK_CustomTags_User1]
GO

CREATE NONCLUSTERED INDEX [IX_CustomTags_ReferenceId_TagId]
ON [dbo].[CustomTags] ([ReferenceId])
INCLUDE ([TagId])
GO