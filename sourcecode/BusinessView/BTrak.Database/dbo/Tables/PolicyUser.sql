CREATE TABLE [dbo].[PolicyUser]
(
	[Id]              UNIQUEIDENTIFIER NOT NULL,
    [PolicyId]        UNIQUEIDENTIFIER NOT NULL,
    [Role]            NVARCHAR(MAX) NULL,
    [User]            NVARCHAR(MAX) NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME         NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_dbo.PolicyUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PolicyUser_Policy] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([Id])
)
