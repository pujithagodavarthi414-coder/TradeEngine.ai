CREATE TABLE [dbo].[User]
(
	[Id] [uniqueidentifier] NOT NULL,
	[SurName] [nvarchar](250) NULL,
	[FirstName] [nvarchar](250) NOT NULL,
	[UserName] [nvarchar](250) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[IsPasswordForceReset] [bit] NULL,
	[IsActive] [bit] NOT NULL,
	[TimeZoneId] [uniqueidentifier] NULL,
	[DesktopId] [uniqueidentifier] NULL,
	[MobileNo] [nvarchar](250) NULL,
	[IsAdmin] [bit] NULL,
	[IsActiveOnMobile] [bit] NOT NULL,
	[ProfileImage] [nvarchar](800) NULL,
	[ProfileImageLocalPath] [nvarchar](2000) NULL,
	[RegisteredDateTime] [datetime] NULL,
	[LastConnection] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[CurrencyId] [uniqueidentifier] NULL,
	[Language] [nvarchar](10) NULL,
	[LatestScreenShotId] [uniqueidentifier] NULL,
	[IsExternal] BIT NULL, 
	CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)