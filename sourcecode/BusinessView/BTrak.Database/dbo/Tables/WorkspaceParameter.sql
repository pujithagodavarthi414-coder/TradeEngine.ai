CREATE TABLE [dbo].[WorkspaceParameter]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	ReferenceId UNIQUEIDENTIFIER NOT NULL,
	ParameterName NVARCHAR(250) NOT NULL,
	ParameterLabel NVARCHAR(250) NULL,
	IsSystemFilter BIT NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
CONSTRAINT [PK_WorkspaceParameter] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
))
GO

ALTER TABLE [dbo].[WorkspaceParameter] ADD CONSTRAINT [FK_User_WorkspaceParameter_CreatedByUserId] FOREIGN KEY ([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO