CREATE TABLE [dbo].[InvoiceCategory](
	[Id] [uniqueidentifier] NOT NULL,
	CompanyId [uniqueidentifier]  NULL,
	[InvoiceCategoryName] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP NULL,
 CONSTRAINT [PK_InvoiceCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_InvoiceCategory_CompanyId_InvoiceCategoryName] UNIQUE ([CompanyId],[InvoiceCategoryName])
)
GO