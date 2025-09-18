CREATE TABLE [dbo].[GoalReplan](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NOT NULL,
	[GoalReplanTypeId] [uniqueidentifier] NULL,
	[Reason] [varchar](800) NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZone] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZone] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    [GoalReplanCount] INT NULL, 
    CONSTRAINT [PK_GoalReplan] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[GoalReplan]  WITH CHECK ADD  CONSTRAINT [FK_GoalReplan_GoalReplanType_GoalReplanTypeId] FOREIGN KEY([GoalReplanTypeId])
REFERENCES [dbo].[GoalReplanType] ([Id])
GO
ALTER TABLE [dbo].[GoalReplan] CHECK CONSTRAINT [FK_GoalReplan_GoalReplanType_GoalReplanTypeId]
GO

CREATE NONCLUSTERED INDEX IX_GoalReplan_GoalId
ON [dbo].[GoalReplan] (  GoalId ASC  )   
INCLUDE ( CreatedDateTime ) 
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  )
ON [PRIMARY] 
GO