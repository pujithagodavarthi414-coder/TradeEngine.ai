CREATE TABLE [dbo].[IdentityResourceProperties]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[Key] NVARCHAR(250) NOT NULL,
	[Value] NVARCHAR(250) NOT NULL,
	IdentityResourceId INT NOT NULL,
	CONSTRAINT [PK_IdentityResourceProperties] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
)
GO

ALTER TABLE [dbo].[IdentityResourceProperties]  WITH NOCHECK ADD  CONSTRAINT [FK_IdentityResourceProperties_IdentityResources_IdentityResourceId] FOREIGN KEY([IdentityResourceId])
REFERENCES [dbo].[IdentityResources] ([Id])
GO