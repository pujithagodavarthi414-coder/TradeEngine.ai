CREATE TABLE [dbo].[TestRailReportOption](
	[Id] [uniqueidentifier] NOT NULL,
	[OptionName] [nvarchar](250) NOT NULL,	
	[CompanyId] [uniqueidentifier] NOT NULL,
	[IsMilstone] [bit] NULL,
	[IsTestPlan] [bit] NULL,
	[IsTestRun] [BIT] NULL,
	[IsPoject] [BIT] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,	
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_TestRailReportOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO