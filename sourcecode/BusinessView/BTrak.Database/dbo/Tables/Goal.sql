CREATE TABLE [dbo].[Goal](
	[Id] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[BoardTypeId] [uniqueidentifier] NOT NULL,
	[GoalName] [nvarchar](800) NOT NULL,
	[GoalUniqueName] [nvarchar](250) NULL,
	[GoalBudget] [money] NULL,
	[OnboardProcessDate] DATETIMEOFFSET NULL,
	[OnboardProcessDateTimeZoneId]  [uniqueidentifier] NULL,
	[IsLocked] [bit] NULL,
	[GoalShortName] [nvarchar](800) NULL,
	[GoalResponsibleUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[GoalStatusId] [uniqueidentifier] NULL,
	[OldGoalStatusId] [uniqueidentifier] NULL,
	[ConfigurationId] [uniqueidentifier] NULL,
	[ConsiderEstimatedHoursId] [uniqueidentifier] NULL,
	[TestSuiteId] [uniqueidentifier] NULL,
	[GoalStatusColor] [varchar](250) NULL,
	[IsProductiveBoard] [bit] NULL,
	[IsApproved] [bit] NULL,
	[ConsiderEstimatedHours] [bit] NULL,
	[IsToBeTracked] [bit] NULL,
	[BoardTypeApiId] [uniqueidentifier] NULL,
	[Version] [NVARCHAR](500) NULL,
	[ParkedDateTime] DATETIMEOFFSET NULL,
	[ParkedDateTimeZoneId] [uniqueidentifier] NULL,
    [IsCompleted] BIT NULL, 
    [InActiveDateTime] DATETIMEOFFSET NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
    [Tag] NVARCHAR(MAX) NULL,  
    [Description] NVARCHAR(MAX) NULL, 
	[GoalEstimatedTime] [decimal](18, 2) NULL,
	[EndDate] DATETIMEOFFSET NULL
    CONSTRAINT [PK_Goal] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[Goal]  WITH CHECK ADD  CONSTRAINT [FK_GoalStatus_Goal_GoalStatusId] FOREIGN KEY([GoalStatusId])
REFERENCES [dbo].[GoalStatus] ([Id])
GO

ALTER TABLE [dbo].[Goal] CHECK CONSTRAINT [FK_GoalStatus_Goal_GoalStatusId]
GO
ALTER TABLE [dbo].[Goal]  WITH CHECK ADD  CONSTRAINT [FK_Project_Goal_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[Goal] CHECK CONSTRAINT [FK_Project_Goal_ProjectId]
GO
ALTER TABLE [dbo].[Goal]  WITH CHECK ADD  CONSTRAINT [FK_TestSuite_Goal_TestSuiteId] FOREIGN KEY([TestSuiteId])
REFERENCES [dbo].[TestSuite] ([Id])
GO

ALTER TABLE [dbo].[Goal] CHECK CONSTRAINT [FK_TestSuite_Goal_TestSuiteId]
GO

ALTER TABLE [dbo].[Goal] WITH NOCHECK ADD CONSTRAINT [FK_ConsiderHours_Goal_ConsiderEstimatedHoursId] FOREIGN KEY ([ConsiderEstimatedHoursId])
REFERENCES [dbo].[ConsiderHours] ([Id])
GO
ALTER TABLE [dbo.[Goal] CHECK CONSTRAINT [FK_ConsiderHours_Goal_ConsiderEstimatedHoursId]
GO

ALTER TABLE [dbo].[Goal]  WITH CHECK ADD CONSTRAINT [FK_Goal_BoardType_BoardTypeId] FOREIGN KEY([BoardTypeId])
REFERENCES [dbo].[BoardType] ([Id])
GO
ALTER TABLE [dbo].[Goal] CHECK CONSTRAINT [FK_Goal_BoardType_BoardTypeId]
GO

CREATE NONCLUSTERED INDEX IX_Goal_BoardTypeId_IsProductiveBoard 
ON [dbo].[Goal] (  BoardTypeId ASC  , IsProductiveBoard ASC  )   
INCLUDE ( ConsiderEstimatedHoursId , GoalStatusId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_Goal_ProjectId_GoalStatusId 
ON [dbo].[Goal] (  ProjectId ASC  , GoalStatusColor ASC  , ParkedDateTime ASC  , InActiveDateTime ASC  )   
INCLUDE ( GoalStatusId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 100  ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE INDEX [IX_Goal_GoalStatusId_ParkedDateTime_InActiveDateTime] 
ON [dbo].[Goal] ([GoalStatusId], [ParkedDateTime], [InActiveDateTime]) 
INCLUDE ([Id], [ProjectId], [BoardTypeId], [GoalName])
GO

CREATE INDEX [IX_Goal_GoalStatusId_ParkedDateTime_InActiveDateTime_Id] 
ON [dbo].[Goal] ([GoalStatusId], [ParkedDateTime], [InActiveDateTime]) 
INCLUDE ([Id], [ProjectId], [GoalName])
GO

CREATE INDEX [IX_Goal_ProjectId_ParkedDateTime_InActiveDateTime] 
ON [dbo].[Goal] ([ProjectId], [ParkedDateTime], [InActiveDateTime])
GO

CREATE INDEX [IX_Goal_ProjectId_InActiveDateTime_ParkedDateTime] 
ON [dbo].[Goal] ([ProjectId], [InActiveDateTime],[ParkedDateTime])
GO

CREATE INDEX [IX_Goal_GoalStatusId_ParkedDateTime_InActiveDateTime_Id_ProjectId] 
ON [dbo].[Goal] ([GoalStatusId], [ParkedDateTime], [InActiveDateTime]) 
INCLUDE ([Id], [ProjectId], [BoardTypeId])
GO

CREATE INDEX [IX_Goal_GoalResponsibleUserId_IsToBeTracked_ParkedDateTime_InActiveDateTime] 
ON [dbo].[Goal] ([GoalResponsibleUserId], [IsToBeTracked], [ParkedDateTime], [InActiveDateTime])
GO
CREATE NONCLUSTERED  INDEX [IX_UserStory_ParkedDateTime_InActiveDateTime]
ON[dbo].[UserStory] ([ParkedDateTime],[InActiveDateTime])
INCLUDE([GoalId],[UserStoryStatusId],[ParentUserStoryId])