CREATE TABLE [dbo].[WorkFlowStatusHistory]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
	[OldValue] NVARCHAR(MAX), 
    [NewValue] NVARCHAR(MAX),
    [Description] NVARCHAR(MAX),
	[WorkFlowStatusReferenceId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL
)
