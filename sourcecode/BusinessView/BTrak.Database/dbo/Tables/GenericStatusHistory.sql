CREATE TABLE [dbo].[GenericStatusHistory]
(
	[Id] [UNIQUEIDENTIFIER] NOT NULL PRIMARY KEY,
	[Description] [NVARCHAR](MAX) NULL,
	[CreatedByUserId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDateTime] [DATETIME] NOT NULL,
	[GenericStatusReferenceId] [UNIQUEIDENTIFIER] NOT NULL,
	[OldValue] [NVARCHAR](MAX) NULL,
	[NewValue] [NVARCHAR](MAX) NULL
)
