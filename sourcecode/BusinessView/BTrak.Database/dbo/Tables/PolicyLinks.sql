CREATE TABLE [dbo].[PolicyLinks] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [PolicyId]        UNIQUEIDENTIFIER NOT NULL,
    [LinkedPolicyId]  UNIQUEIDENTIFIER NOT NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME         NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_dbo.PolicyLinks] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Policy_PolicyLinks_PolicyId] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([Id]),
    CONSTRAINT [FK_Policy_PolicyLinks_LinkedPolicyId] FOREIGN KEY ([LinkedPolicyId]) REFERENCES [dbo].[Policy] ([Id])
);

