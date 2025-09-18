CREATE TABLE [dbo].[EmployeeEntity]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
	[EmployeeId] UNIQUEIDENTIFIER NOT NULL, 
    [EntityId] UNIQUEIDENTIFIER NULL,
	[InactiveDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_EmployeeEntity] PRIMARY KEY ([Id])
)
GO

ALTER TABLE [dbo].[EmployeeEntity]  WITH NOCHECK ADD CONSTRAINT [FK_Employee_EmployeeEntity_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee]([Id])
GO

ALTER TABLE [dbo].[EmployeeEntity] CHECK CONSTRAINT [FK_Employee_EmployeeEntity_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeEntity]  WITH NOCHECK ADD CONSTRAINT [FK_Entity_EmployeeEntity_EntityId] FOREIGN KEY([EntityId])
REFERENCES [dbo].[Entity]([Id])
GO

ALTER TABLE [dbo].[EmployeeEntity] CHECK CONSTRAINT [FK_Entity_EmployeeEntity_EntityId]
GO