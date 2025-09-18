CREATE TABLE [dbo].[WebHook]
(
	[Id] [uniqueidentifier] NOT NULL,
	[WebHookUrl] [nvarchar](max) NOT NULL,
	[WebHookName] [nvarchar](800) NULL,
	[ProjectId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_WebHook] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO

ALTER TABLE [dbo].[WebHook]  WITH CHECK ADD  CONSTRAINT [FK_User_WebHook] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[WebHook] CHECK CONSTRAINT [FK_User_WebHook]
GO

ALTER TABLE [dbo].[WebHook]  WITH CHECK ADD  CONSTRAINT [FK_Project_WebHook] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[WebHook] CHECK CONSTRAINT [FK_Project_WebHook]
GO