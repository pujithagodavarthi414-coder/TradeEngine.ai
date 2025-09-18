CREATE TABLE [dbo].[PolicyFileData] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [PolicyId]        UNIQUEIDENTIFIER NOT NULL,
    [Version]         NVARCHAR(100) NULL,
    [FileName]         NVARCHAR(250) NULL,
    [FilePath]         NVARCHAR(MAX) NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME         NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_dbo.PolicyFileData] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PolicyFileData_Policy] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([Id])
);
