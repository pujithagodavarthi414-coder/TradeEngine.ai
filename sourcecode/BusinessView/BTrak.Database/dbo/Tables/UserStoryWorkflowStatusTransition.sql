CREATE TABLE [dbo].[UserStoryWorkflowStatusTransition](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[WorkflowEligibleStatusTransitionId] [uniqueidentifier] NOT NULL,
	[TransitionDateTime] DATETIMEOFFSET NOT NULL,
	[TransitionTimeZone] UNIQUEIDENTIFIER NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZone] UNIQUEIDENTIFIER NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserStoryWorkflowStatusTransition] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
    CONSTRAINT [FK_UserStoryWorkflowStatusTransition_Company_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id])
)
GO

CREATE NONCLUSTERED INDEX IX_UserStoryWorkflowStatusTransition_UserStoryId 
ON [dbo].[UserStoryWorkflowStatusTransition] (  UserStoryId ASC  , InActiveDateTime ASC  )   
INCLUDE ( TransitionDateTime , WorkflowEligibleStatusTransitionId )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX [IX_UserStoryWorkflowStatusTransition_CreatedByUserId]
ON [dbo].[UserStoryWorkflowStatusTransition] ([CreatedByUserId])
INCLUDE ([UserStoryId],[WorkflowEligibleStatusTransitionId],[TransitionDateTime])