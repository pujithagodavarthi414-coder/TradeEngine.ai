CREATE TABLE [dbo].[IdleTimeHistoricalData]
(
	UserId	UNIQUEIDENTIFIER
	,[Name] NVARCHAR(500)
	,MinTrackedDateTime	DATETIME
	,MaxTrackedDateTime	DATETIME
	,CreatedDateTime DATETIME
	,IdleTimeInMin INT NULL
	,CompanyId UNIQUEIDENTIFIER
	,[IsLogged] BIT NULL DEFAULT 0
	,[AbsoluteAppName] [nvarchar](MAX) NULL
	,[TrackedUrl] [nvarchar](MAX) NULL
)
GO