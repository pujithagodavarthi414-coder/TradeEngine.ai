CREATE TABLE [dbo].[Holiday](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[Reason] [nvarchar](500) NOT NULL,
	[Date] [datetime] NOT NULL,
	[CountryId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsWeekOff] BIT NULL, 
    [DateFrom] DATETIME NULL,
    [DateTo] DATETIME NULL, 
    [WeekOffDays] NVARCHAR(100) NULL, 
    [BranchId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_Holiday] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
    CONSTRAINT [FK_Holiday_Branch] FOREIGN KEY ([BranchId]) REFERENCES [Branch]([Id]) 
) ON [PRIMARY]
GO

--TO DO
--ALTER TABLE [dbo].[Holiday]  WITH NOCHECK ADD CONSTRAINT [FK_Country_Holiday_CountryId] FOREIGN KEY([CountryId])
--REFERENCES [dbo].[Country] ([Id])
--GO

--ALTER TABLE [dbo].[Holiday] CHECK CONSTRAINT [FK_Country_Holiday_CountryId]
--GO

CREATE NONCLUSTERED INDEX IX_Holiday_Date 
ON [dbo].[Holiday] (  Date ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO