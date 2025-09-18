CREATE TABLE [dbo].[WorkflowCronExpression](
	[Id] [uniqueidentifier] NOT NULL,
	[CronExpression] [nvarchar](800) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[WorkflowId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[ResponsibleUserId] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
