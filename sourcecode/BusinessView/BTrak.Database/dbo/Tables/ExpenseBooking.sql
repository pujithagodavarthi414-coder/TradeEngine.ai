CREATE TABLE [dbo].[ExpenseBooking]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Type] [nvarchar](250) NOT NULL,
	EntryDate DATETIME NULL,
	[Month] DATETIME NULL,
	[Year] DATETIME NULL,
	Term NVARCHAR(20) NULL,
	SiteId UNIQUEIDENTIFIER NULL,
	AccountId UNIQUEIDENTIFIER NULL,
	[VendorName] [nvarchar](250) NULL,
	[InvoiceNo] [nvarchar](250) NULL,
	[Description] [nvarchar](250) NULL,
	InvoiceDate DATETIME NULL,
	[IsTVAApplied] BIT NULL,
	[Comments] [nvarchar](250) NULL,
	[InvoiceValue] DECIMAL(18,2) NULL,
	[TVA] DECIMAL(18,2) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_ExpenseBooking] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO