CREATE TABLE [dbo].[CandidateInterviewFeedBackComments]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
	CandidateInterviewScheduleId UNIQUEIDENTIFIER,
	AssigneeComments NVARCHAR(MAX),
	AssigneeId UNIQUEIDENTIFIER,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateInterviewFeedBackComments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments] CHECK CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments] CHECK CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewFeedBackComments_CandidateInteviewSchedule_CandidateInteviewScheduleId] FOREIGN KEY([CandidateInterviewScheduleId])
REFERENCES [dbo].[CandidateInterviewSchedule] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments] CHECK CONSTRAINT [FK_CandidateInterviewFeedBackComments_CandidateInteviewSchedule_CandidateInteviewScheduleId]
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments]  WITH CHECK ADD  CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_AssigneeId] FOREIGN KEY([AssigneeId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[CandidateInterviewFeedBackComments] CHECK CONSTRAINT [FK_CandidateInterviewFeedBackComments_User_AssigneeId]
GO