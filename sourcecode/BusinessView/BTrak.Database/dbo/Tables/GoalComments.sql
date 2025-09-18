CREATE TABLE [dbo].[GoalComments]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [GoalId] UNIQUEIDENTIFIER NULL, 
    [Comments] NVARCHAR(MAX) NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP NULL, 
    [InactiveDateTime] DATETIME NULL, 
    CONSTRAINT [PK_GoalCommenets] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_GoalCommenets_Goal] FOREIGN KEY ([GoalId]) REFERENCES [Goal]([Id]), 
    CONSTRAINT [FK_GoalCommenets_User] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id])
)
