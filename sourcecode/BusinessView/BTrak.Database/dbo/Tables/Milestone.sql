CREATE TABLE [dbo].[Milestone] (
    [Id]                UNIQUEIDENTIFIER NOT NULL,
    [ProjectId]         UNIQUEIDENTIFIER NOT NULL,
    [Title]             NVARCHAR (250)   NOT NULL,
    [ParentMilestoneId] UNIQUEIDENTIFIER NULL,
    [Description]       NVARCHAR (500)   NULL,
    [StartDate]         DATETIMEOFFSET         NULL,
    [EndDate]           DATETIMEOFFSET         NULL,
    [IsCompleted]       BIT              NULL,
    [IsStarted]         BIT              NULL,
    [CreatedDateTime]   DATETIME         NOT NULL,
    [CreatedByUserId]   UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime]   DATETIME          NULL,
    [UpdatedByUserId]   UNIQUEIDENTIFIER  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_MileStone] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_MileStone_Project] FOREIGN KEY ([ProjectId]) REFERENCES [dbo].[Project] ([Id]) 
);
GO

CREATE NONCLUSTERED INDEX [IX_Milestone_ProjectId_InActiveDateTime]
ON [dbo].[Milestone] ([ProjectId],[InActiveDateTime])
GO