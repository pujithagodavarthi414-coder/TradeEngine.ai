CREATE TABLE [dbo].[AssignmentStatus]
(
	[Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
    [StatusName] NVARCHAR(100) NOT NULL, 
    [StatusDescription] NVARCHAR(800) NOT NULL, 
    [StatusColor] NVARCHAR(10) NULL, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
    [IsSelectable] BIT NOT NULL, 
    [Icon] NVARCHAR(800) NOT NULL, 
    [AddsValidity] BIT NOT NULL, 
    [IsActive] BIT NOT NULL DEFAULT 1, 
    [IsDefaultStatus] BIT NOT NULL DEFAULT 0,
    [IsExpiryStatus] BIT NOT NULL DEFAULT 0, 
    CONSTRAINT [FK_CompanyId_AssignmentStatus_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id])
)
