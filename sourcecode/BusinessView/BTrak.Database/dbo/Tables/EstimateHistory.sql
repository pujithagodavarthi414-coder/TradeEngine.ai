CREATE TABLE [dbo].[EstimateHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[EstimateId] [uniqueidentifier] NOT NULL,
	[EstimateTaskId] [uniqueidentifier] NULL,
	[EstimateItemId] [uniqueidentifier] NULL,
	[OldValue] [nvarchar](max) NULL,
	[NewValue] [nvarchar](max) NULL,
	[Description] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_EstimateHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[EstimateHistory]  WITH CHECK ADD CONSTRAINT [FK_EstimateHistory_Estimate_EstimateId] FOREIGN KEY([EstimateId])
REFERENCES [dbo].[Estimate] ([Id])
GO

ALTER TABLE [dbo].[EstimateHistory] CHECK CONSTRAINT [FK_EstimateHistory_Estimate_EstimateId]
GO

ALTER TABLE [dbo].[EstimateHistory]  WITH CHECK ADD CONSTRAINT [FK_EstimateHistory_EstimateTask_EstimateTaskId] FOREIGN KEY([EstimateTaskId])
REFERENCES [dbo].[EstimateTask] ([Id])
GO

ALTER TABLE [dbo].[EstimateHistory] CHECK CONSTRAINT [FK_EstimateHistory_EstimateTask_EstimateTaskId]
GO

ALTER TABLE [dbo].[EstimateHistory]  WITH CHECK ADD CONSTRAINT [FK_EstimateHistory_EstimateItem_EstimateItemId] FOREIGN KEY([EstimateItemId])
REFERENCES [dbo].[EstimateItem] ([Id])
GO

ALTER TABLE [dbo].[EstimateHistory] CHECK CONSTRAINT [FK_EstimateHistory_EstimateItem_EstimateItemId]
GO