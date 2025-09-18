CREATE TABLE [dbo].[Component]
(
	[Id] [uniqueidentifier] NOT NULL,
    [ComponentName] NVARCHAR(100) NOT NULL, 
    CONSTRAINT [PK_Component] PRIMARY KEY ([Id])
)
