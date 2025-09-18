CREATE TABLE UserActivityAppSummary
(
	UserId UNIQUEIDENTIFIER
	,AppUrlImage NVARCHAR(MAX)
	,ApplicationId UNIQUEIDENTIFIER
	,ApplicationName NVARCHAR(MAX)
	,[ApplicationTypeName] [nvarchar](100)
	--,[AbsoluteAppName] [nvarchar](MAX) NULL
	,[SpentTime] [time](7)
	,[TimeInMillisecond] BIGINT NOT NULL DEFAULT 0
	,IsApp BIT DEFAULT 0
	,CreatedDateTime DATETIME
	,CompanyId UNIQUEIDENTIFIER
)
GO

CREATE NONCLUSTERED INDEX IX_UserActivityAppSummary_UserId_CompanyId ON UserActivityAppSummary([UserId],[CompanyId])
GO

--TODO : Remove date range in summary page we no need this index
CREATE NONCLUSTERED INDEX [IX_UserActivityAppSummary_AppUrlImage_ApplicationName_TimeInMillisecond]
ON [dbo].[UserActivityAppSummary] ([UserId],[CompanyId],[CreatedDateTime])
INCLUDE ([AppUrlImage],[ApplicationName],[TimeInMillisecond])
GO