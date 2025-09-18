CREATE TABLE [dbo].[InductionConfiguration](
	[Id] [uniqueidentifier] NOT NULL,
	[InductionName] [nvarchar](250) NOT NULL,
	[IsShow] BIT,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_InductionConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[InductionConfiguration]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_InductionConfiguration_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[InductionConfiguration] CHECK CONSTRAINT [FK_Company_InductionConfiguration_CompanyId]
GO