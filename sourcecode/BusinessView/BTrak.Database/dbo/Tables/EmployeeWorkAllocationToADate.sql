CREATE TABLE [dbo].[EmployeeWorkAllocationToADate](
    [UserId] [uniqueidentifier] NOT NULL,
    [ProjectId] [uniqueidentifier] NOT NULL,
    [GoalId] [uniqueidentifier] NOT NULL,
    [UserStoryId] [uniqueidentifier] NOT NULL,
    [Date] [datetime] NULL,
    [AllocatedWork] [float] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
) ON [PRIMARY]