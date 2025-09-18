CREATE TABLE [dbo].[EmployeeEntityBranch]
(
	[Id] UNIQUEIDENTIFIER NOT NULL ,
	[EmployeeId] UNIQUEIDENTIFIER NOT NULL, 
    [BranchId] UNIQUEIDENTIFIER NULL,
	[InactiveDateTime] DATETIME NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    CONSTRAINT [PK_EmployeeEntityBranch] PRIMARY KEY ([Id])
)
GO

ALTER TABLE [dbo].[EmployeeEntityBranch]  WITH NOCHECK ADD CONSTRAINT [FK_Employee_EmployeeEntityBranch_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee]([Id])
GO

ALTER TABLE [dbo].[EmployeeEntityBranch] CHECK CONSTRAINT [FK_Employee_EmployeeEntityBranch_EmployeeId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeEntityBranch_InactiveDateTime
ON [dbo].[EmployeeEntityBranch] ([InactiveDateTime])
GO

CREATE NONCLUSTERED INDEX IX_EmployeeEntityBranch_BranchId
ON [dbo].[EmployeeEntityBranch] ([EmployeeId],[InactiveDateTime])
INCLUDE ([BranchId])
GO