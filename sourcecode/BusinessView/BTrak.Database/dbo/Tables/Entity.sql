CREATE TABLE [dbo].[Entity]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
    [EntityName] NVARCHAR(250) NOT NULL,
	[InactiveDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL,
    [IsGroup] BIT NOT NULL DEFAULT 0,
    [IsEntity] BIT NOT NULL DEFAULT 0,
    [IsCountry] BIT NOT NULL DEFAULT 0,
    [IsBranch] BIT NOT NULL DEFAULT 0,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [Description] NVARCHAR(1000) NULL,
    [ParentEntityId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_Entity] PRIMARY KEY ([Id])
)
GO

ALTER TABLE [dbo].[Entity]  WITH NOCHECK ADD CONSTRAINT [FK_Entity_Entity_ParentEntityId] FOREIGN KEY([ParentEntityId])
REFERENCES [dbo].[Entity]([Id])
GO

ALTER TABLE [dbo].[Entity] CHECK CONSTRAINT [FK_Entity_Entity_ParentEntityId]
GO