CREATE TABLE [dbo].[ConsiderHours](
    [Id] [uniqueidentifier] NOT NULL,
    [ConsiderHourName] [Nvarchar](250) NOT NULL,
    [IsEsimatedHours] [BIT] NULL,
    [IsLoggedHours] [BIT] NULL,
    [CompanyId] [uniqueidentifier] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_ConsiderHours] PRIMARY KEY CLUSTERED
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

CREATE NONCLUSTERED INDEX IX_ConsiderHours_CompanyId 
ON [dbo].[ConsiderHours] (  CompanyId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO