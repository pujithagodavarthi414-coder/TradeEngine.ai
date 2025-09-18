CREATE TABLE [dbo].[PolicyReviewUser] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [PolicyId]        UNIQUEIDENTIFIER NOT NULL,
    [HasRead]         BIT              NULL DEFAULT 0,
    [StartTime]       DATETIME         NULL,
    [EndTime]         DATETIME         NULL,
    [UserId]          UNIQUEIDENTIFIER NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME         NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_dbo.PolicyReviewUser] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PolicyReviewUser_Policy] FOREIGN KEY ([PolicyId]) REFERENCES [dbo].[Policy] ([Id]),
    CONSTRAINT [FK_PolicyReviewUser_User] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
);

