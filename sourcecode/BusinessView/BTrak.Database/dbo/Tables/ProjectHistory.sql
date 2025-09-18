CREATE TABLE [dbo].[ProjectHistory]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ProjectId] [uniqueidentifier] NOT NULL,
	[ReferenceId] [uniqueidentifier] NULL,
	[OldValue]  [nvarchar](250)  NULL,
	[NewValue]  [nvarchar](250)  NULL,
	[FieldName]  [nvarchar](50)  NULL,
	[Description]  [nvarchar](800)  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId]  [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ProjectHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ProjectHistory]  WITH NOCHECK ADD CONSTRAINT [FK_Project_ProjectHistory_ProjectId] FOREIGN KEY ([ProjectId])
REFERENCES [dbo].[Project] ([Id])
GO

ALTER TABLE [dbo].[ProjectHistory]  CHECK CONSTRAINT [FK_Project_ProjectHistory_ProjectId]
GO

CREATE NONCLUSTERED INDEX IX_ProjectHistory_ProjectId ON [dbo].[ProjectHistory] (  ProjectId ASC  )