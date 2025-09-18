CREATE TABLE [dbo].[ActivityTrackerHistory]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [UserId] UNIQUEIDENTIFIER NULL, 
    [Category] NCHAR(100) NULL, 
    [OldValue] NVARCHAR(MAX) NULL, 
    [NewValue] NVARCHAR(MAX) NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [Description] NVARCHAR(100) NULL, 
    [FieldName] NVARCHAR(100) NULL, 
    [TimeStamp] TIMESTAMP NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL 
)
