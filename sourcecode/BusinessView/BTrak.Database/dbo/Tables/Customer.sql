CREATE TABLE [dbo].[Customer](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CustomerName] [nvarchar](800) NOT NULL,
	[ContactEmail] [nvarchar](250) NOT NULL,
	[AddressLine1] [nvarchar](800) NULL,
	[AddressLine2] [nvarchar](800) NULL,
	[City] [nvarchar](250) NULL,
	[StateId] [uniqueidentifier] NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[PostalCode] [nvarchar](250) NULL,
	[MobileNumber] [nvarchar](250) NOT NULL,
	[Notes] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Customer] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_Customer_CustomerName_CompanyId] UNIQUE ([CompanyId], [CustomerName])
)
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_Country_Customer_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_Country_Customer_CountryId]
GO
GO
ALTER TABLE [dbo].[Customer]  WITH CHECK ADD  CONSTRAINT [FK_State_Customer_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[State] ([Id])
GO

ALTER TABLE [dbo].[Customer] CHECK CONSTRAINT [FK_State_Customer_StateId]
GO