CREATE TABLE [dbo].[CompanyAlias](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
    [DomainName] [NVARCHAR](1000) NULL, 
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [DATETIME] NULL 
 CONSTRAINT [PK_CompanyAlias] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[CompanyAlias]  WITH CHECK ADD CONSTRAINT [FK_Company_CompanyAlias_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO