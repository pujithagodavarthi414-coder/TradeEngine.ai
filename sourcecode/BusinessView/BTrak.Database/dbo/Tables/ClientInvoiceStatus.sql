CREATE TABLE [dbo].[ClientInvoiceStatus]
(
	[Id] [uniqueidentifier] NOT NULL,	
	[StatusName] [nvarchar](250) NOT NULL,
	[InvoiceStatusName] [nvarchar](250) NOT NULL,
	[StatusColor] [varchar](250) NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InactiveDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP
	CONSTRAINT [PK_ClientInvoiceStatus] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
