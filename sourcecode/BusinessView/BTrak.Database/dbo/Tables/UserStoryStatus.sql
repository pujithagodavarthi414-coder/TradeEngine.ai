CREATE TABLE [dbo].[UserStoryStatus](
	[Id] [uniqueidentifier] NOT NULL,	
	[Status] [nvarchar](250) NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[StatusHexValue] [varchar](250) NULL,
	[StatusColor] [varchar](250) NULL,
	[IsOwnerEditable] [bit] NULL,
	[IsUserStoryEditable] [bit] NULL,
	[IsEstimatedTimeEditable] [bit] NULL,
	[IsDeadLineEditable] [bit] NULL,
	[IsStatusEditable] [bit] NULL,
	[IsBugPriorityEditable] [bit] NULL,
	[IsBugCausedUserEditable] [bit] NULL,
	[IsDependencyEditable] [bit] NULL,
	[CanArchive] [bit] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedDateTime] DATETIMEOFFSET NULL,
	[CanPark] [bit] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
    --[IsBlocked] BIT NULL, 
    --[IsInprogress] BIT NULL, 
    --[IsAnalysisCompleted] BIT NULL, 
    --[IsDevInprogress] BIT NULL, 
    --[IsCompleted] BIT NULL, 
    --[IsSignedOff] BIT NULL, 
    --[IsDevCompleted] BIT NULL, 
    --[IsNotStarted] BIT NULL, 
    --[IsDeployed] BIT NULL, 
    --[IsQAApproved] BIT NULL, 
    --[IsNew] BIT NULL, 
    --[IsVerified] BIT NULL, 
    --[IsResolved] BIT NULL, 
    --[IsUnderReview] BIT NULL, 
    [TimeStamp] TIMESTAMP, 
    --[IsToDo] BIT NULL, 
    [LookUpKey] INT NULL, 
	[TaskStatusId] [uniqueidentifier] NULL,
    CONSTRAINT [PK_UserStoryStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    --CONSTRAINT [AK_UserStoryStatus_Status_CompanyId] UNIQUE ([Status], [CompanyId])
)
GO
ALTER TABLE [dbo].[UserStoryStatus]  WITH NOCHECK ADD CONSTRAINT [FK_TaskStatus_UserStoryStatus_TaskStatusId] FOREIGN KEY (TaskStatusId)
REFERENCES [dbo].[TaskStatus] ([Id])
GO

ALTER TABLE [dbo].[UserStoryStatus] CHECK CONSTRAINT [FK_TaskStatus_UserStoryStatus_TaskStatusId]
GO

CREATE NONCLUSTERED INDEX IX_UserStoryStatus_CompanyId
ON [dbo].[UserStoryStatus] ([CompanyId])
GO
CREATE NONCLUSTERED INDEX [IX_UserStoryStatus_InActiveDateTime_TaskStatusId]
ON [dbo].[UserStoryStatus] ([InActiveDateTime],[TaskStatusId])
INCLUDE ([Id])
GO