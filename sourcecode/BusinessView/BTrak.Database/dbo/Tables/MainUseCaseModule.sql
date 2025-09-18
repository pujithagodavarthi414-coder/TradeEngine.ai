CREATE TABLE [dbo].[MainUseCaseModule]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [ModuleId] UNIQUEIDENTIFIER NULL, 
    [MainUseCaseId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [OriginalId] UNIQUEIDENTIFIER NULL, 
    [AsAtInactiveDateTime] DATETIME NULL, 
    [InactiveDateTime] DATETIME NULL, 
    [VersionNumber] INT NULL DEFAULT 1, 
    [TimeStamp] TIMESTAMP NULL, 
    CONSTRAINT [PK_MainUseCaseModule] PRIMARY KEY ([Id]), 
    CONSTRAINT [FK_MainUseCaseModule_Module] FOREIGN KEY ([ModuleId]) REFERENCES [Module]([Id]), 
    CONSTRAINT [FK_MainUseCaseModule_MainUseCase] FOREIGN KEY ([MainUseCaseId]) REFERENCES [MainUseCase]([Id])
)
