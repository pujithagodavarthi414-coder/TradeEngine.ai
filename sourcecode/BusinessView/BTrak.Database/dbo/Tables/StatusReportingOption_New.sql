CREATE TABLE [dbo].[StatusReportingOption_New]
(	
    [Id] [uniqueidentifier] NOT NULL,
	[OptionName] [nvarchar](250) NOT NULL,
	[DisplayName] NVARCHAR(250) NULL, 
    [SortOrder] INT NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_StatusReportingOption_New] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[StatusReportingOption_New]  WITH NOCHECK ADD  CONSTRAINT [FK_Company_StatusReportingOption_New_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[StatusReportingOption_New] CHECK CONSTRAINT [FK_Company_StatusReportingOption_New_CompanyId]
GO
