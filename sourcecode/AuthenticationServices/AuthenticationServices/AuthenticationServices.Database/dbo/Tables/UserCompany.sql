CREATE TABLE [dbo].[UserCompany]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[UserId] UNIQUEIDENTIFIER NOT NULL,
	[CompanyId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL
	CONSTRAINT [PK_UserCompany] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[UserCompany]  WITH NOCHECK ADD  CONSTRAINT [FK_User_UserCompany_UserId] FOREIGN KEY(UserId)
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserCompany] CHECK CONSTRAINT [FK_User_UserCompany_UserId]
GO

ALTER TABLE [dbo].[UserCompany]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_UserCompany_CompanyId] FOREIGN KEY(CompanyId)
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[UserCompany] CHECK CONSTRAINT [FK_Company_UserCompany_CompanyId]
GO