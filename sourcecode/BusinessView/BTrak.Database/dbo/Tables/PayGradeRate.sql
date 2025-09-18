CREATE TABLE [dbo].[PayGradeRate]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [PayGradeId] [uniqueidentifier] NOT NULL,
    [RateId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP
)
GO

ALTER TABLE [dbo].[PayGradeRate]  WITH NOCHECK ADD CONSTRAINT [FK_PayGrade_PayGradeRate_PayGradeId] FOREIGN KEY ([PayGradeId])
REFERENCES [dbo].[PayGrade] ([Id])
GO

ALTER TABLE [dbo].[PayGradeRate] CHECK CONSTRAINT [FK_PayGrade_PayGradeRate_PayGradeId]
GO

ALTER TABLE [dbo].[PayGradeRate]  WITH NOCHECK ADD CONSTRAINT [FK_RateType_PayGradeRate_RateId] FOREIGN KEY ([RateId])
REFERENCES [dbo].[RateType] ([Id])
GO

ALTER TABLE [dbo].[PayGradeRate] CHECK CONSTRAINT [FK_RateType_PayGradeRate_RateId]
GO