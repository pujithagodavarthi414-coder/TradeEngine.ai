CREATE TABLE [dbo].[GoalStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalStatusName] [nvarchar](250) NOT NULL,
	--[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[IsOwnerEditable] [bit] NULL,
	[IsUserStoryEditable] [bit] NULL,
	[IsEstimatedTimeEditable] [bit] NULL,
	[IsDeadLineEditable] [bit] NULL,
	[IsDependencyEditable] [bit] NULL,
	[IsStatusEditable] [bit] NULL,
	[CanArchive] [bit] NULL,
	[CanPark] [bit] NULL,
	[IsParked] [bit] NULL,
	[IsArchived] [bit] NOT NULL DEFAULT 0,
	[CanReorder] [bit] NULL,
    [IsNotNeeded] BIT NULL, 
    [IsGaveUp] BIT NULL, 
    [IsCompleted] BIT NULL, 
    [IsBackLog] BIT NULL, 
    [IsActive] BIT NULL, 
    [IsReplan] BIT NULL,  
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_GoalStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    --CONSTRAINT [AK_GoalStatus_GoalStatusName_CompanyId] UNIQUE ([GoalStatusName],[CompanyId]) 
)
GO