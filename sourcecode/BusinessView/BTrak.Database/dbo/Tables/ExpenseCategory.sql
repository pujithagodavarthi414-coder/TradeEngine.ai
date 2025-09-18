CREATE TABLE [dbo].[ExpenseCategory] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    CompanyId [uniqueidentifier]  NULL,
    [CategoryName]    NVARCHAR (250)   NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [IsSubCategory]   BIT              NULL,
    [AccountCode]     NVARCHAR(250)    NULL,
    [Image]           NVARCHAR(250)    NULL,
    [Description]     NVARCHAR(1000)   NULL,
    [InActiveDateTime] [datetime] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP NULL, 
    CONSTRAINT [PK_ExpenseCategory] PRIMARY KEY CLUSTERED ([Id] ASC), 
);
GO