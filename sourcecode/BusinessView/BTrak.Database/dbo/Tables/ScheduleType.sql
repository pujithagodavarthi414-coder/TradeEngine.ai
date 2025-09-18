CREATE TABLE [dbo].[ScheduleType](
	[Id] [uniqueidentifier] NOT NULL,
	[ScheduleType] [nvarchar](100) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[TimeStamp] [timestamp] NULL,
	[InactiveDateTime] [datetime] NULL,
	[AsAtInactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ScheduleType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ScheduleType]  WITH NOCHECK ADD  CONSTRAINT [FK_ScheduleType_ScheduleType_OriginalId] FOREIGN KEY([OriginalId])
REFERENCES [dbo].[ScheduleType] ([Id])
GO

ALTER TABLE [dbo].[ScheduleType] CHECK CONSTRAINT [FK_ScheduleType_ScheduleType_OriginalId]
GO