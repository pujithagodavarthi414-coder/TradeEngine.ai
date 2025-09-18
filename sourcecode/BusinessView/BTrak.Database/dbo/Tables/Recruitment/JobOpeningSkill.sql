CREATE TABLE [dbo].[JobOpeningSkill]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    JobOpeningId UNIQUEIDENTIFIER NOT NULL, 
	SkillId UNIQUEIDENTIFIER NOT NULL,
	MinExperience FLOAT,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_JobOpeningSkill] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[JobOpeningSkill]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningSkill_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningSkill] CHECK CONSTRAINT [FK_JobOpeningSkill_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[JobOpeningSkill]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningSkill_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningSkill] CHECK CONSTRAINT [FK_JobOpeningSkill_User_UpdatedByUserId]
GO

ALTER TABLE [dbo].[JobOpeningSkill]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningSkill_JobOpening_JobOpeningId] FOREIGN KEY([JobOpeningId])
REFERENCES [dbo].[JobOpening] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningSkill] CHECK CONSTRAINT [FK_JobOpeningSkill_JobOpening_JobOpeningId]
GO

ALTER TABLE [dbo].[JobOpeningSkill]  WITH CHECK ADD  CONSTRAINT [FK_JobOpeningSkill_Skill_SkillId] FOREIGN KEY([SkillId])
REFERENCES [dbo].[Skill] ([Id])
GO

ALTER TABLE [dbo].[JobOpeningSkill] CHECK CONSTRAINT [FK_JobOpeningSkill_Skill_SkillId]
GO