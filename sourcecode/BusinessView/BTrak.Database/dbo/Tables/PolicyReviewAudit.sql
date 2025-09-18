CREATE TABLE [dbo].[PolicyReviewAudit] (
    [Id]              UNIQUEIDENTIFIER NOT NULL,
    [PolicyId]        UNIQUEIDENTIFIER NOT NULL,
    [OpenedDate]      DATETIME         NULL,
    [ReadDate]        DATETIME         NULL,
    [InsertedDate]    DATETIME         NULL,
    [DeletedDate]     DATETIME         NULL,
    [UpdatedDate]     DATETIME         NULL,
    [PrintedDate]     DATETIME         NULL,
    [DownloadedDate]  DATETIME         NULL,
    [ImportedDate]    DATETIME         NULL,
    [ExportedDate]    DATETIME         NULL,
    [UserId]          UNIQUEIDENTIFIER NULL,
    [CreatedDateTime] DATETIME         NOT NULL,
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime] DATETIME         NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TIMESTAMP,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_User_PolicyReviewAudit_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
)

