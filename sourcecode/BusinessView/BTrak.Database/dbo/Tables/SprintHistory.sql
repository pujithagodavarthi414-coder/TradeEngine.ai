CREATE TABLE [dbo].[SprintHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[SprintId] [uniqueidentifier] NOT NULL,
	[OldValue]  [nvarchar](800)  NULL,
	[NewValue]  [nvarchar](800)  NULL,
	[FieldName]  [nvarchar](100)  NULL,
	[Description]  [nvarchar](800)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_SprintHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[SprintHistory]  WITH NOCHECK ADD CONSTRAINT [FK_Sprint_SprintHistory_SprintId] FOREIGN KEY ([SprintId])
REFERENCES [dbo].[Sprints] ([Id])
GO

ALTER TABLE [dbo].[SprintHistory]  CHECK CONSTRAINT [FK_Sprint_SprintHistory_SprintId]
GO