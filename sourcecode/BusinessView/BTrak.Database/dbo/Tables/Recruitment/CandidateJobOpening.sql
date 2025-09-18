CREATE TABLE [dbo].[CandidateJobOpening]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    CandidateId UNIQUEIDENTIFIER NOT NULL, 
	JobOpeningId UNIQUEIDENTIFIER,
	AppliedDateTime DATETIME,
	InterviewProcessId UNIQUEIDENTIFIER,
	HiringStatusId UNIQUEIDENTIFIER,
	[Description] NVARCHAR(MAX),
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateJobOpening] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_Candidate_CandidateId] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_Candidate_CandidateId]
GO

ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_JobOpening_JobOpeningId] FOREIGN KEY([JobOpeningId])
REFERENCES [dbo].[JobOpening] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_JobOpening_JobOpeningId]
GO

ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_InterviewProcess_InterviewProcessId] FOREIGN KEY([InterviewProcessId])
REFERENCES [dbo].[InterviewProcess] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_InterviewProcess_InterviewProcessId]
GO

ALTER TABLE [dbo].[CandidateJobOpening]  WITH CHECK ADD  CONSTRAINT [FK_CandidateJobOpening_HiringStatus_HiringStatusId] FOREIGN KEY([HiringStatusId])
REFERENCES [dbo].[HiringStatus] ([Id])
GO

ALTER TABLE [dbo].[CandidateJobOpening] CHECK CONSTRAINT [FK_CandidateJobOpening_HiringStatus_HiringStatusId]
GO