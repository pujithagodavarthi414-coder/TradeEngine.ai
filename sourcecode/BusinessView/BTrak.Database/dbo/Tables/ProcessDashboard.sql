CREATE TABLE [dbo].[ProcessDashboard](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NULL,
	[MileStone] [datetime] NULL,
	[Delay] [int] NULL,
	[DashboardId] [int] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[GeneratedDateTime] [datetimeoffset] NULL,
	[GeneratedDateTimeZoneId][uniqueidentifier] NULL,
	[GoalStatusColor] [nvarchar](50) NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ProcessDashboard] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[ProcessDashboard]  WITH CHECK ADD  CONSTRAINT [FK_Goal_ProcessDashboard_GoalId] FOREIGN KEY([GoalId])
REFERENCES [dbo].[Goal] ([Id])
GO

ALTER TABLE [dbo].[ProcessDashboard] CHECK CONSTRAINT [FK_Goal_ProcessDashboard_GoalId]
GO

CREATE NONCLUSTERED INDEX IX_ProcessDashboard_GoalId 
ON [dbo].[ProcessDashboard] (  GoalId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO