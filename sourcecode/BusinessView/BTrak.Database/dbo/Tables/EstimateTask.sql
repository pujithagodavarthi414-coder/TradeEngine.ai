CREATE TABLE [dbo].[EstimateTask](
	[Id] [uniqueidentifier] NOT NULL,
	[EstimateId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[TaskName] [nvarchar](150) NULL,
	[TaskDescription] [nvarchar](800) NULL,
	[Rate] float NULL,
	[Hours] float NULL,
	[Order] int NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_EstimateTask] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[EstimateTask] WITH CHECK ADD CONSTRAINT [FK_Estimate_EstimateTask_EstimateId] FOREIGN KEY([EstimateId])
REFERENCES [dbo].[Estimate] ([Id])
GO

ALTER TABLE [dbo].[EstimateTask] CHECK CONSTRAINT [FK_Estimate_EstimateTask_EstimateId]
GO