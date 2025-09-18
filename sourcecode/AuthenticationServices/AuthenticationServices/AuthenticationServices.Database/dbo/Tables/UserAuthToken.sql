CREATE TABLE [dbo].[UserAuthToken](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](50) NOT NULL,
	[DateCreated] [datetime] NULL,
	[AuthToken] [nvarchar](MAX) NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserAuthToken] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[UserAuthToken]  WITH CHECK ADD  CONSTRAINT [FK_User_AuthToken_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserAuthToken] CHECK CONSTRAINT [FK_User_AuthToken_UserId]
GO

ALTER TABLE [dbo].[UserAuthToken]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_UserAuthToken_CompanyId] FOREIGN KEY(CompanyId)
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[UserAuthToken] CHECK CONSTRAINT [FK_Company_UserAuthToken_CompanyId]
GO