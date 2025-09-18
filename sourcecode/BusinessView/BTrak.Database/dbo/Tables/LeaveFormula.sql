CREATE TABLE [dbo].[LeaveFormula]
(
	[Id] [uniqueidentifier] NOT NULL, 
    [Formula] NVARCHAR(200) NULL, 
    [SalaryTypeId] [uniqueidentifier] NULL, 
    [NoOfdays] INT NULL, 
    [NoOfLeaves] INT NULL,
    [TimeStamp] TIMESTAMP,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
	[UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InactiveDateTime] DATETIME NULL, 
    [PayroleId] UNIQUEIDENTIFIER NULL, 
    CONSTRAINT [PK_LeaveFormaula] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_LeaveFormula_Company] FOREIGN KEY ([CompanyId]) REFERENCES [Company]([Id]), 
)
GO