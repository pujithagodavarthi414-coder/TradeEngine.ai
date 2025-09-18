CREATE TABLE [dbo].[TrainingAssignment]
(
	[Id] UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID() , 
    [UserId] UNIQUEIDENTIFIER NOT NULL, 
    [TrainingCourseId] UNIQUEIDENTIFIER NOT NULL , 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [StatusId] UNIQUEIDENTIFIER NULL, 
    [StatusGivenDate] DATETIME2 NULL, 
    [CreatedDateTime] DATETIME2 NOT NULL DEFAULT GETUTCDATE(), 
    [UpdatedDateTime] DATETIME2 NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [ValidityEndDate] DATETIME2 NULL, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
    CONSTRAINT [FK_UserId_TrainingAssignment_User] FOREIGN KEY ([UserId]) REFERENCES [User]([Id]),
    CONSTRAINT [FK_CompanyId_TrainingAssignment_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]),
    CONSTRAINT [FK_StatusId_TrainingAssignment_AssignmentStatus] FOREIGN KEY ([StatusId]) REFERENCES [AssignmentStatus]([Id]),
    CONSTRAINT [FK_TrainingCourseId_TrainingAssignment_TrainingCourse] FOREIGN KEY ([TrainingCourseId]) REFERENCES [TrainingCourse]([Id]), 
    CONSTRAINT [PK_TrainingAssignment] PRIMARY KEY ([Id])
)
