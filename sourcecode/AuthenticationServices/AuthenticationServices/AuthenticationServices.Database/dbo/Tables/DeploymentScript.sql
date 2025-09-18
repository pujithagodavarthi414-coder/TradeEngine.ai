CREATE TABLE [dbo].[DeploymentScript]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
    [ScriptFileId] NVARCHAR(250) NOT NULL,
    [ScriptFileExecutionOrder] INT NOT NULL,
    [ScriptFileAddedByDeveloper] NVARCHAR(100) NOT NULL,
    [ScriptFileAppliedDateTime] DATETIME NULL,
    CONSTRAINT [PK_DeploymentScript] PRIMARY KEY ([Id])
)
