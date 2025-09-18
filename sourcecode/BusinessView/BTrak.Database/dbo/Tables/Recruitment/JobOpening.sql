CREATE TABLE [dbo].[JobOpening]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	JobOpeningTitle NVARCHAR(500),
	JobDescription NVARCHAR(MAX),
	JobOpeningUniqueName NVARCHAR(250) NULL,
	NoOfOpenings INT,
	DateFrom DATETIME,
	DateTo DATETIME,
	MinExperience INT,
	MaxExperience INT,
	Qualification NVARCHAR(500),
	Certification NVARCHAR(500),
	MinSalary FLOAT,
	MaxSalary FLOAT,
	JobTypeId UNIQUEIDENTIFIER,
	JobOpeningStatusId UNIQUEIDENTIFIER,
	InterviewProcessId UNIQUEIDENTIFIER,
	DesignationId UNIQUEIDENTIFIER,
	HiringManagerId UNIQUEIDENTIFIER,
	CompanyId UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_JobOpening] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_EmploymentStatus_JobTypeId] FOREIGN KEY([JobTypeId])
REFERENCES [dbo].[EmploymentStatus] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_EmploymentStatus_JobTypeId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_JobOpeningStatus_JobOpeningStatusId] FOREIGN KEY([JobOpeningStatusId])
REFERENCES [dbo].[JobOpeningStatus] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_JobOpeningStatus_JobOpeningStatusId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_InterviewProcess_InterviewProcessId] FOREIGN KEY([InterviewProcessId])
REFERENCES [dbo].[InterviewProcess] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_InterviewProcess_InterviewProcessId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_Designation_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[Designation] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_Designation_DesignationId]
GO

ALTER TABLE [dbo].[JobOpening]  WITH CHECK ADD  CONSTRAINT [FK_JobOpening_User_HiringManagerId] FOREIGN KEY([HiringManagerId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpening] CHECK CONSTRAINT [FK_JobOpening_User_HiringManagerId]
GO