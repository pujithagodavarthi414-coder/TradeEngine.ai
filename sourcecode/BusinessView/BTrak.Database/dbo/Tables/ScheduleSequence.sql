CREATE TABLE [dbo].[ScheduleSequence](
	[Id] [uniqueidentifier] NOT NULL,
	[ScheduleSequenceName] [nvarchar](100) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[TimeStamp] [timestamp] NULL,
	[InactiveDateTime] [datetime] NULL,
	[AsAtInactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ScheduleSequence] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ScheduleSequence]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduleSequence_ScheduleSequence_OriginalId] FOREIGN KEY([OriginalId])
REFERENCES [dbo].[ScheduleSequence] ([Id])
GO

ALTER TABLE [dbo].[ScheduleSequence] CHECK CONSTRAINT [FK_ScheduleSequence_ScheduleSequence_OriginalId]
GO