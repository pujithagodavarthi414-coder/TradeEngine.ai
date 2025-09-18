CREATE TABLE [dbo].[ClientAddress](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NOT NULL,
	[CountryId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[Zipcode] [nvarchar](150) NULL,
	[Street] [nvarchar](150) NULL,
	[City] [nvarchar](150) NULL,
	[State] [nvarchar](150) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ClientAddress] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClientAddress] WITH CHECK ADD CONSTRAINT [FK_Client_ClientAddress_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([Id])
GO

ALTER TABLE [dbo].[ClientAddress] CHECK CONSTRAINT [FK_Client_ClientAddress_ClientId]
GO

ALTER TABLE [dbo].[ClientAddress] WITH CHECK ADD CONSTRAINT [FK_Country_ClientAddress_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[ClientAddress] CHECK CONSTRAINT [FK_Country_ClientAddress_CountryId]
GO
