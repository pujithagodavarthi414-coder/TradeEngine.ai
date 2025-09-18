CREATE TABLE [dbo].[Supplier](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[SupplierName] [nvarchar](250) NULL,
	[CompanyName] [nvarchar](250) NULL,
	[ContactPerson] [nvarchar](250) NULL,
	[ContactPosition] [nvarchar](250) NULL,
	[CompanyPhoneNumber] [nvarchar](250) NULL,
	[ContactPhoneNumber] [nvarchar](250) NULL,
	[VendorIntroducedBy] [nvarchar](250) NULL,
	[StartedWorkingFrom] [datetime] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Supplier] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
