CREATE TABLE [dbo].[UserActivityTimeSummary]
(
	UserId UNIQUEIDENTIFIER
	,[IdleInMinutes] INT NOT NULL DEFAULT 0
	,[Neutral] BIGINT NOT NULL DEFAULT 0 --Millisecond
	,[UnProductive] BIGINT NOT NULL DEFAULT 0 --Millisecond
	,[Productive] BIGINT NOT NULL DEFAULT 0 --Millisecond
	,CreatedDateTime DATETIME
	,CompanyId UNIQUEIDENTIFIER
)
GO

ALTER TABLE [UserActivityTimeSummary] ADD CONSTRAINT UK_UserActivityTimeSummary_UserId_CreatedDateTime UNIQUE (UserId,CreatedDateTime) 
GO