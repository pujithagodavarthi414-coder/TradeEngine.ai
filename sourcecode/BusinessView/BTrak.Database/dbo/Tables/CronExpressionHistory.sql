CREATE TABLE [dbo].[CronExpressionHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	CronExpressionId [uniqueidentifier] NULL,
	[CustomWidgetId] [uniqueidentifier] NULL,
	[OldValue]  [nvarchar](250)  NULL,
	[NewValue]  [nvarchar](250)  NULL,
	[FieldName]  [nvarchar](50)  NULL,
	[Description]  [nvarchar](800)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 [CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_CronExpressionHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX IX_CronExpressionHistory_CustomWidgetId ON [dbo].[CronExpressionHistory] (  CustomWidgetId ASC  )