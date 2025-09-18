CREATE TABLE [dbo].[ShipToAddress]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NULL,
	[AddressName] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	[Comments] [nvarchar](250) NULL,
	[IsShiptoAddress] BIT NULL,
	[IsVerified] BIT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
	CONSTRAINT [PK_ShipToAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

