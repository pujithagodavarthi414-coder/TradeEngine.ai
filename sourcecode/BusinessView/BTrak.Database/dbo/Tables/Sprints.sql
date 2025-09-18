CREATE TABLE [dbo].[Sprints]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ProjectId] UNIQUEIDENTIFIER NOT NULL, 
    [SprintName] NVARCHAR(1000) NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL,
	[InActiveDateTime] DATETIME NULL,
	[SprintStartDate] DATETIME NULL,
	[SprintStartDateTimeZoneId] UNIQUEIDENTIFIER NULL,
	[IsNameEdit] BIT NULL DEFAULT 0
CONSTRAINT [PK_Sprints] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [Description] NVARCHAR(800) NULL, 
    [SprintEndDate] DATETIME NULL, 
	[SprintEndDateTimeZoneId] UNIQUEIDENTIFIER NULL,
    [IsReplan] BIT NULL DEFAULT 0, 
    [ActualSprintEndDate] DATETIME NULL, 
    [BoardTypeId] UNIQUEIDENTIFIER NULL, 
    [BoardTypeApiId] UNIQUEIDENTIFIER NULL, 
    [Version] NVARCHAR(50) NULL, 
    [TestSuiteId] UNIQUEIDENTIFIER NULL, 
    [IsComplete] BIT NULL,
	[SprintUniqueName] NVARCHAR(1000), 
    [SprintResponsiblePersonId] UNIQUEIDENTIFIER NULL, 
    [SprintCompletedDate] DATETIMEOFFSET NULL,
    [SprintCompletedDateTimeZoneId] UNIQUEIDENTIFIER NULL, 
)
GO

ALTER TABLE [dbo].[Sprints]  WITH CHECK ADD  CONSTRAINT [FK_Project_Sprints_ProjectId] FOREIGN KEY([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO