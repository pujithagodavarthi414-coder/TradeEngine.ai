CREATE TABLE [dbo].[TrackerData]
(
	UserId UNIQUEIDENTIFIER
	,[Name] NVARCHAR(500)
	,AppUrlImage NVARCHAR(MAX)
	,ApplicationId UNIQUEIDENTIFIER
	,[ApplicationTypeName] [nvarchar](100)
	,[AbsoluteAppName] [nvarchar](MAX) NULL
	,[SpentTime] [time](7)
	,SpentValue INT
	,IsApp BIT DEFAULT 0
	,CreatedDateTime DATETIME
	,CompanyId UNIQUEIDENTIFIER
	,MinTrackedDateTime	DATETIME
	,MaxTrackedDateTime	DATETIME
	,IdleTimeInMin INT
	,IsIdleTime BIT DEFAULT 0
)
