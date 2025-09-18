CREATE TABLE [dbo].[RoomVideoSetup]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
	[RoomUniqueName] NVARCHAR(250) NOT NULL,
	[RoomSid] NVARCHAR(1000) NULL,
	[ReferenceId] [uniqueidentifier] NOT NULL,
	[Status] NVARCHAR(50) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP
)
