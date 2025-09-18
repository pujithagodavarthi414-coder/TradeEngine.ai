CREATE TABLE [dbo].[ClientPostLogoutRedirectUris]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	PostLogoutRedirectUri NVARCHAR(800) NOT NULL,
	ClientId INT NOT NULL,
	CONSTRAINT [PK_ClientPostLogoutRedirectUris] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[ClientPostLogoutRedirectUris]  WITH NOCHECK ADD  CONSTRAINT [FK_ClientPostLogoutRedirectUris_Clients_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Clients] ([Id])
GO