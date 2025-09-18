CREATE TABLE [dbo].[UserTags](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[TagId] [uniqueidentifier] NOT NULL,
	[Order] [int] NOT NULL,
	[CreatedDateTime] [datetimeoffset](7) NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset](7) NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_UserTags] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserTags]  WITH CHECK ADD  CONSTRAINT [FK_Tags_UserTags_TagId] FOREIGN KEY([TagId])
REFERENCES [dbo].[Tags] ([Id])
GO

ALTER TABLE [dbo].[UserTags] CHECK CONSTRAINT [FK_Tags_UserTags_TagId]
GO

ALTER TABLE [dbo].[UserTags]  WITH CHECK ADD  CONSTRAINT [FK_User_UserTags_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserTags] CHECK CONSTRAINT [FK_User_UserTags_UserId]
GO