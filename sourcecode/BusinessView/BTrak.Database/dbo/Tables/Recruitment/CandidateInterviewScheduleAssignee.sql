CREATE TABLE [dbo].[CandidateInterviewScheduleAssignee]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    AssignToUserId UNIQUEIDENTIFIER,
	CandidateInterviewScheduleId UNIQUEIDENTIFIER,
	IsApproved BIT,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateInterviewScheduleAssignee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewScheduleAssignee_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee] CHECK CONSTRAINT [FK_CandidateInterviewScheduleAssignee_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewScheduleAssignee_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee] CHECK CONSTRAINT [FK_CandidateInterviewScheduleAssignee_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewScheduleAssignee_CandidateInteviewSchedule_CandidateInteviewScheduleId] FOREIGN KEY([CandidateInterviewScheduleId])
REFERENCES [dbo].[CandidateInterviewSchedule] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewScheduleAssignee] CHECK CONSTRAINT [FK_CandidateInterviewScheduleAssignee_CandidateInteviewSchedule_CandidateInteviewScheduleId]
GO

