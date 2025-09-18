CREATE TABLE [dbo].[IdentityResources]
(
	[Id] INT NOT NULL,
	[Enabled] BIT,
	[Name] NVARCHAR(250),
	DisplayName NVARCHAR(250),
	[Description] NVARCHAR(800) NULL,
	[Required] BIT,
	Emphasize BIT,
	ShowInDiscoveryDocument BIT,
	Created DATETIME,
	Updated DATETIME  NULL,
	NonEditable BIT,
	CONSTRAINT [PK_IdentityResources] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
)
