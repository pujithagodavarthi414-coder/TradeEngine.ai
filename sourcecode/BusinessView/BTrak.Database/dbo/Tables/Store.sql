CREATE TABLE [dbo].[Store]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
	[StoreName] [nvarchar](50)  NULL,
	[IsDefault] BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL, 
    [IsCompany] BIT NULL, 
    [StoreSize] BIGINT NULL, 
    [Description] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_Store] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_Store_Company_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]),
)
