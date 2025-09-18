CREATE TABLE [dbo].[Branch](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[BranchName] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[IsHeadOffice] [bit] NULL, 
    [Address] NVARCHAR(1000) NULL, 
	[TimeZoneId] [UNIQUEIDENTIFIER] NULL,
	[CurrencyId] UNIQUEIDENTIFIER NULL, 
    [PayrollTemplateId] UNIQUEIDENTIFIER NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
    CONSTRAINT [PK_Branch] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO

--ALTER TABLE [dbo].[Branch]  WITH NOCHECK ADD  CONSTRAINT [FK_Country_Branch_CountryId] FOREIGN KEY([CountryId])
--REFERENCES [dbo].[Country] ([Id])
--GO

--ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_Country_Branch_CountryId]
--GO

CREATE NONCLUSTERED INDEX IX_Branch_CompanyId 
ON [dbo].[Branch] (  CompanyId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO
ALTER TABLE [dbo].[Branch]  WITH NOCHECK ADD  CONSTRAINT [FK_TimeZone_Branch_TimeZoneId] FOREIGN KEY([TimeZoneId])
REFERENCES [dbo].[TimeZone] ([Id])
GO
ALTER TABLE [dbo].[Branch] CHECK CONSTRAINT [FK_TimeZone_Branch_TimeZoneId]
GO