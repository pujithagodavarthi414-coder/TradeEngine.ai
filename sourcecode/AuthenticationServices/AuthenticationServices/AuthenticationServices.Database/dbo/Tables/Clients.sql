CREATE TABLE [dbo].[Clients]
(
	[Id] INT IDENTITY(1,1) NOT NULL,
	UserCompanyId UNIQUEIDENTIFIER NOT NULL,
	[Enabled] BIT NOT NULL,
	ClientId NVARCHAR(250) NOT NULL,
	ProtocolType NVARCHAR(50) NOT NULL,
	RequireClientSecret BIT NOT NULL,
	ClientName NVARCHAR(250) NULL,
	[Description] NVARCHAR(250) NULL,
	ClientUri NVARCHAR(250) NULL,
	LogoUri	NVARCHAR(250) NULL,
	RequireConsent BIT,
	AllowRememberConsent BIT,
	AlwaysIncludeUserClaimsInIdToken BIT,
	RequirePkce BIT,
	AllowPlainTextPkce BIT,
	RequireRequestObject BIT,
	AllowAccessTokensViaBrowser BIT,
	FrontChannelLogoutUri NVARCHAR(250) NULL,
	FrontChannelLogoutSessionRequired BIT,
	BackChannelLogoutUri NVARCHAR(250) NULL,
	BackChannelLogoutSessionRequired BIT,
	AllowOfflineAccess BIT,
	IdentityTokenLifetime INT,
	AllowedIdentityTokenSigningAlgorithms NVARCHAR(250) NULL,
	AccessTokenLifetime INT,
	AuthorizationCodeLifetime INT,
	ConsentLifetime INT NULL,
	AbsoluteRefreshTokenLifetime INT,
	SlidingRefreshTokenLifetime INT,
	RefreshTokenUsage INT,
	UpdateAccessTokenClaimsOnRefresh BIT,
	RefreshTokenExpiration INT,
	AccessTokenType INT,
	EnableLocalLogin BIT,
	IncludeJwtId BIT,
	AlwaysSendClientClaims BIT,
	ClientClaimsPrefix NVARCHAR(250),
	PairWiseSubjectSalt NVARCHAR(250),
	Created DATETIME,
	Updated DATETIME  NULL,
	LastAccessed DATETIME NULL,
	UserSsoLifetime INT NULL,
	UserCodeType NVARCHAR(250) NULL,
	DeviceCodeLifetime INT,
	NonEditable BIT,
	CONSTRAINT [PK_Clients] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[Clients]  WITH NOCHECK ADD  CONSTRAINT [FK_Clients_UserComapny_UserComapnyId] FOREIGN KEY([UserCompanyId])
REFERENCES [dbo].[UserCompany] ([Id])
GO
