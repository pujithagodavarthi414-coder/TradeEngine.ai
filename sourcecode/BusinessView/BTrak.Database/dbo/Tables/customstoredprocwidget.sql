CREATE TABLE [dbo].[CustomStoredProcWidget]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [CustomWidgetId] UNIQUEIDENTIFIER NOT NULL, 
    [ProcName] NCHAR(250) NOT NULL, 
    [Inputs] NVARCHAR(MAX) NULL, 
    [Outputs] NVARCHAR(MAX) NULL, 
    [Legends] NVARCHAR(MAX) NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP NOT NULL
)
