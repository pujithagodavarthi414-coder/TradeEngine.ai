CREATE TABLE [dbo].[RateSheetFor]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	[CompanyId] [uniqueidentifier] NULL,
    [RateSheetForName] NVARCHAR(250) NOT NULL,
	IsShift BIT NULL,
	IsAllowance BIT NULL,
	IsTraining BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime]  DATETIME          NULL,
    [UpdatedByUserId]  UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP
CONSTRAINT [PK_RateSheetFor] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
