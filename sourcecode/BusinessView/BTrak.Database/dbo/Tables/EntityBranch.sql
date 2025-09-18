CREATE TABLE [dbo].[EntityBranch]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[BranchId] UNIQUEIDENTIFIER NOT NULL, 
    [EntityId] UNIQUEIDENTIFIER NOT NULL,
	[InactiveDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_EntityBranch] PRIMARY KEY ([Id]) 
)
GO

ALTER TABLE [dbo].[EntityBranch]  WITH NOCHECK ADD CONSTRAINT [FK_Entity_EntityBranch_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity]([Id])
GO

ALTER TABLE [dbo].[EntityBranch] CHECK CONSTRAINT [FK_Entity_EntityBranch_EntityId]
GO
CREATE NONCLUSTERED  INDEX IX_EntityBranch_BranchId_EmployeeId
ON [dbo].[EntityBranch](EntityId,BranchId)   
GO