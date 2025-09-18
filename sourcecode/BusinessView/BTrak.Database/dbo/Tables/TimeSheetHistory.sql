CREATE TABLE [dbo].[TimeSheetHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[TimeSheetId] [uniqueidentifier]  NULL,
	[UserBreakId]  [uniqueidentifier]  NULL,
	[OldValue] [nvarchar](100) NULL,
	[NewValue] [nvarchar](100) NULL,
	[FieldName] [nvarchar](50) NULL,
	[Description] [nvarchar](500) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_TimeSheetHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TimeSheetHistory]  WITH NOCHECK ADD  CONSTRAINT [FK_TimeSheet_TimeSheetHistory_TimeSheetId] FOREIGN KEY([TimeSheetId])
REFERENCES [dbo].[TimeSheet] ([Id])
GO

ALTER TABLE [dbo].[TimeSheetHistory] CHECK CONSTRAINT [FK_TimeSheet_TimeSheetHistory_TimeSheetId]
GO
