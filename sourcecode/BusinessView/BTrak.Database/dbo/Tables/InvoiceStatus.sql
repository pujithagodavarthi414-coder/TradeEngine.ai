CREATE TABLE [dbo].[InvoiceStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[InvoiceStatusName] [nvarchar](250) NOT NULL,
	[InvoiceStatusColor] [nvarchar](50) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_InvoiceStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[InvoiceStatus] WITH CHECK ADD CONSTRAINT [FK_Company_InvoiceStatus_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[InvoiceStatus] CHECK CONSTRAINT [FK_Company_InvoiceStatus_CompanyId]
GO