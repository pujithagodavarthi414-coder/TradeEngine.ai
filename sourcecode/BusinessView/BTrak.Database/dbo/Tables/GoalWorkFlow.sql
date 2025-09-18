CREATE TABLE [dbo].[GoalWorkFlow](
	[Id] [uniqueidentifier] NOT NULL,
	[GoalId] [uniqueidentifier] NOT NULL,
	[WorkflowId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_GoalWorkFlow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
	