CREATE TABLE [dbo].[CustomField]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [FieldName] NVARCHAR(100) NULL, 
    [FormJson] NVARCHAR(MAX) NULL, 
    [FormKeys] NVARCHAR(MAX) NULL, 
    [ModuleTypeId] INT NOT NULL, 
    [ReferenceTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [ReferenceId] UNIQUEIDENTIFIER NOT NULL, 
    [TimeStamp] TIMESTAMP NOT NULL, 
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [InactiveDateTime] DATETIME NULL
CONSTRAINT [PK_CustomField] PRIMARY KEY CLUSTERED ([Id] ASC) 
    --CONSTRAINT [FK_Expense_MasterTableCurrencyId] FOREIGN KEY ([CurrencyId]) REFERENCES [MasterTable]([Id]),
, 
    [CompanyId] UNIQUEIDENTIFIER NOT NULL)
GO
