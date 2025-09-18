CREATE TABLE [dbo].[CronExpression]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CronExpressionName] [nvarchar](800) NULL,
    [CronExpression] [nvarchar](800) NOT NULL,
    [CronExpressionDescription] [nvarchar](800) NULL,
    [CompanyId] [uniqueidentifier] NOT NULL,
	[CustomWidgetId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP, 
    [SelectedChartIds] NVARCHAR(800) NULL, 
    [TemplateType] NVARCHAR(800) NULL, 
    [TemplateUrl] NVARCHAR(800) NULL, 
    [JobId] BIGINT, 
    [ChartsUrls] NVARCHAR(MAX) NULL,
	[EndDate] [datetime] NULL,
	[ConductEndDate] [datetime] NULL,
	[IsPaused] BIT NULL, 
    [ConductStartDate] DATETIME NULL,
    [ResponsibleUserId] UNIQUEIDENTIFIER  NULL, 
    [IsTimesheetInterval] BIT NULL
)
GO

ALTER TABLE [dbo].[CronExpression]  WITH NOCHECK ADD CONSTRAINT [FK_Company_CronExpression_CompanyId] FOREIGN KEY ([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[CronExpression] CHECK CONSTRAINT [FK_Company_CronExpression_CompanyId]
GO
