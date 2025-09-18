CREATE TABLE [dbo].[LeadInvoices]
(
	[Id] [uniqueidentifier] NOT NULL,	
	[LeadId] [uniqueidentifier] NULL,	
	[InvoiceNumber] [nvarchar](250) NOT NULL,
	[PaidAmount] DECIMAL(18,2) NULL,
	[TotalAmount] DECIMAL(18,2) NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InactiveDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP
	CONSTRAINT [PK_LeadInvoices] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

