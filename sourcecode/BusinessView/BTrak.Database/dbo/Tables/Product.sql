CREATE TABLE [dbo].[Product](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[ProductName] [varchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[TimeStamp] TIMESTAMP,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [InactiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_Product] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)
GO
