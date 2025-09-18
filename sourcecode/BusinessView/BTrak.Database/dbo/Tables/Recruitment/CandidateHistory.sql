CREATE TABLE [dbo].[CandidateHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[CandidateId] [uniqueidentifier]  NULL,
	[JobOpeningId] [uniqueidentifier] NULL,
	[OldValue]  [nvarchar](250)  NULL,
	[NewValue]  [nvarchar](250)  NULL,
	[FieldName]  [nvarchar](50)  NULL,
	[Description]  [nvarchar](800)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIME NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CandidateHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CandidateHistory]  WITH NOCHECK ADD CONSTRAINT [FK_Candidate_CandidateHistory_CandidateId] FOREIGN KEY ([CandidateId])
REFERENCES [dbo].[Candidate] ([Id])
GO

ALTER TABLE [dbo].[CandidateHistory]  CHECK CONSTRAINT [FK_Candidate_CandidateHistory_CandidateId]
GO

CREATE NONCLUSTERED INDEX IX_CandidateHistory_CandidateId ON [dbo].[CandidateHistory] (  CandidateId ASC  )