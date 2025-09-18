CREATE TABLE [dbo].[GoalHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NOT NULL,
	[OldValue]  [nvarchar](250)  NULL,
	[NewValue]  [nvarchar](250)  NULL,
	[FieldName]  [nvarchar](50)  NULL,
	[Description]  [nvarchar](800)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_GoalHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[GoalHistory]  WITH NOCHECK ADD CONSTRAINT [FK_Goal_GoalHistory_GoalId] FOREIGN KEY ([GoalId])
REFERENCES [dbo].[Goal] ([Id])
GO

ALTER TABLE [dbo].[GoalHistory]  CHECK CONSTRAINT [FK_Goal_GoalHistory_GoalId]
GO

CREATE NONCLUSTERED INDEX IX_GoalHistory_GoalId 
ON [dbo].[GoalHistory] (  GoalId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO