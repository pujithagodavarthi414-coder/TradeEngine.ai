CREATE TABLE [dbo].[IdentityResourceClaims]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[Type] NVARCHAR(250) NOT NULL,
	IdentityResourceId INT NOT NULL,
	CONSTRAINT [PK_IdentityResourceClaims] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
)
GO

ALTER TABLE [dbo].[IdentityResourceClaims]  WITH NOCHECK ADD  CONSTRAINT [FK_IdentityResourceClaims_IdentityResources_IdentityResourceId] FOREIGN KEY([IdentityResourceId])
REFERENCES [dbo].[IdentityResources] ([Id])
GO