CREATE TABLE [dbo].[TrainingWorkflow]
(
	[Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() , 
    [AssignmentId] UNIQUEIDENTIFIER NOT NULL, 
    [StatusId] UNIQUEIDENTIFIER NOT NULL, 
    [StatusGivenDate] DATETIME2 NULL, 
    [CreatedDateTime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(), 
    [UpdatedDateTime] DATETIME2 NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [ValidityEndDate] DATETIME2 NULL, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
    CONSTRAINT [FK_StatusId_TrainingWorkflow_AssignmentStatus] FOREIGN KEY ([StatusId]) REFERENCES [AssignmentStatus]([Id]),
    CONSTRAINT [FK_AssignmentId_TrainingWorkflow_TrainingAssignment] FOREIGN KEY ([AssignmentId]) REFERENCES [TrainingAssignment]([Id]),
    CONSTRAINT [PK_TrainingWorkflow] PRIMARY KEY ([Id])
)
