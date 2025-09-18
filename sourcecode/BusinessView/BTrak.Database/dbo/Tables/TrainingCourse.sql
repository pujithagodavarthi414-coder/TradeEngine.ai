CREATE TABLE [dbo].[TrainingCourse]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [CourseName] NVARCHAR(100) NOT NULL, 
    [CourseDescription] NVARCHAR(800) NOT NULL, 
    [ValidityInMonths] INT NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [IsArchived] BIT NOT NULL DEFAULT 0, 
    [CreatedDateTime] DATETIME2 NOT NULL DEFAULT GETDATE(), 
    [UpdatedDateTime] DATETIME2 NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    CONSTRAINT [PK_TrainingCourse] PRIMARY KEY CLUSTERED ([Id] ASC), 
    CONSTRAINT [FK_Company_TrainingCourse_CompanyId] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]), 
    CONSTRAINT [FK_User_TrainingCourse_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [User]([Id])
)
