CREATE TABLE [dbo].[PolicyCategory] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [CategoryName]    NVARCHAR (400)   NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PolicyCategory] PRIMARY KEY CLUSTERED ([Id] ASC), 
    CONSTRAINT [AK_PolicyCategory_CategoryName] UNIQUE ([CategoryName])
);