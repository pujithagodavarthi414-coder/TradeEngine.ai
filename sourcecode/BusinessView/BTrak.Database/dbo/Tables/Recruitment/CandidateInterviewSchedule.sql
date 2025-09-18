CREATE TABLE [dbo].[CandidateInterviewSchedule]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    InterviewTypeId UNIQUEIDENTIFIER,
	CandidateId UNIQUEIDENTIFIER,
	JobOpeningId UNIQUEIDENTIFIER,
	StatusId UNIQUEIDENTIFIER NULL,
	StartTime DATETIMEOFFSET NULL,
	EndTime DATETIMEOFFSET NULL,
	InterviewDate DATE,
	IsConfirmed BIT,
	IsCancelled BIT,
	IsRescheduled BIT,
	ScheduleComments NVARCHAR(MAX),
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
	[Assignee] UNIQUEIDENTIFIER,
	[ScheduleCancelComment] NVARCHAR(MAX)
 CONSTRAINT [PK_CandidateInterviewSchedule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_Candidate_CandidateId] FOREIGN KEY([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_Candidate_CandidateId]
GO
ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_JobOpening_JobOpeningId] FOREIGN KEY([JobOpeningId])
REFERENCES [dbo].[JobOpening] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_JobOpening_JobOpeningId]
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_InterviewType_InterviewTypeId] FOREIGN KEY([InterviewTypeId])
REFERENCES [dbo].[InterviewType] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_InterviewType_InterviewTypeId]
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewSchedule_ScheduleStatus_StatusId] FOREIGN KEY(StatusId)
REFERENCES [dbo].[ScheduleStatus] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewSchedule] CHECK CONSTRAINT [FK_CandidateInterviewSchedule_ScheduleStatus_StatusId]
GO