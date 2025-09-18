CREATE TABLE [dbo].[PayFrequency](
	[Id] [uniqueidentifier] NOT NULL,
	[PayFrequencyName] [nvarchar](250) NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[CronExpression] [nvarchar](1000) NULL,

	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayFrequency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO