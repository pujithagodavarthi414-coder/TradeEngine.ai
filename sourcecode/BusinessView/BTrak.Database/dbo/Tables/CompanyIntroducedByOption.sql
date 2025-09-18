CREATE TABLE [dbo].[CompanyIntroducedByOption](
	[Id] [uniqueidentifier] NOT NULL,
	[Option] [nvarchar](250) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CompanyIntroducedByOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CompanyIntroducedByOption]  WITH NOCHECK ADD CONSTRAINT [FK_Company_CompanyIntroducedByOption_CompanyId] FOREIGN KEY ([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[CompanyIntroducedByOption] CHECK CONSTRAINT [FK_Company_CompanyIntroducedByOption_CompanyId]
GO