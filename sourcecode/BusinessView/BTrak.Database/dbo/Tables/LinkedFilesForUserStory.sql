
CREATE TABLE [dbo].[LinkedFilesForUserStory](
	[Id] [uniqueidentifier] NOT NULL,
	[FileIds] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[UserStoryId] [uniqueidentifier] NULL
)