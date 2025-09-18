CREATE TABLE [dbo].[ApiResources]
(
	[Id] INT NOT NULL,
	[Enabled] BIT,
	[Name] NVARCHAR(250),
	DisplayName NVARCHAR(250),
	[Description] NVARCHAR(800) NULL,
	AllowedAccessTokenSigningAlgorithms NVARCHAR(250),
	ShowInDiscoveryDocument BIT,
	Created DATETIME,
	Updated DATETIME  NULL,
	LastAccessed DATETIME NULL,
	NonEditable BIT,
	CONSTRAINT [PK_ApiResource] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
)
