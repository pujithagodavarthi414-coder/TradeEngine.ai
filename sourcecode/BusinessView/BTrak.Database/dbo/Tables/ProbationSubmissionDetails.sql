CREATE TABLE [dbo].[ProbationSubmissionDetails]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ProbationSubmissionId] UNIQUEIDENTIFIER NOT NULL, 
    [SubmissionFrom] INT NOT NULL, 
    [FormData] NVARCHAR(MAX) NULL, 
	[IsCompleted] BIT NULL,
    [SubmittedBy] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL,
)
