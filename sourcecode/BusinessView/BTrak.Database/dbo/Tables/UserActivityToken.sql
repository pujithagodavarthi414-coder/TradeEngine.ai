CREATE TABLE [dbo].[UserActivityToken]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[UserId] UNIQUEIDENTIFIER NULL,
	[ActivityToken] NVARCHAR(800) NOT NULL,
	[DesktopId] UNIQUEIDENTIFIER NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] DATETIME NULL, 
    CONSTRAINT [FK_UserActivityToken_ActivityTrackerDesktop] FOREIGN KEY ([DesktopId]) REFERENCES [ActivityTrackerDesktop]([Id])
)
