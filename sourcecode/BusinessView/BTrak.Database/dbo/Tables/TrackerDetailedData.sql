CREATE TABLE [dbo].[TrackerDetailedData]
(
	UserId UNIQUEIDENTIFIER
	,[Name] NVARCHAR(500)
	,AppUrlImage NVARCHAR(MAX)
	,ApplicationId UNIQUEIDENTIFIER
	,ApplicationName NVARCHAR(MAX)
	,[ApplicationTypeName] [nvarchar](100)
	,[AbsoluteAppName] [nvarchar](1000) NULL
	,[SpentTime] [time](7)
	,IsApp BIT DEFAULT 0
	,CreatedDateTime DATETIME
	,CompanyId UNIQUEIDENTIFIER
)
GO
