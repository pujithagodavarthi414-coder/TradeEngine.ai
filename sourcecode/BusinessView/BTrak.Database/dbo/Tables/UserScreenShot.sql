CREATE TABLE [dbo].[UserScreenShot]
(
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[ScreenshotName] [nvarchar](200) NOT NULL,
	[OperationDateTime] [datetime] NOT NULL,
	[OriginalId] [uniqueidentifier] NULL,
	[VersionNumber] [int] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[AsAtInactiveDateTime] [datetime] NULL
) ON [PRIMARY]
GO
