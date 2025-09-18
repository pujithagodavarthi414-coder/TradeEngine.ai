CREATE TABLE [dbo].[Permission] (
    [Id]                 UNIQUEIDENTIFIER NOT NULL,
    [UserId]             UNIQUEIDENTIFIER NOT NULL,
    [Date]               DATE             NOT NULL,
    [CreatedDateTime]    DATETIME         NOT NULL,
    [CreatedByUserId]    UNIQUEIDENTIFIER NOT NULL,
    [UpdatedDateTime]    DATETIME         NULL,
    [UpdatedByUserId]    UNIQUEIDENTIFIER NULL,
    [IsMorning]          BIT              NULL,
    [IsDeleted]          BIT              NULL,
    [Reason]             VARCHAR (1000)   NULL,
    [PermissionReasonId] UNIQUEIDENTIFIER NOT NULL,
    [Duration]           TIME (7)         NULL,
    [DurationInMinutes]  FLOAT (53)       NULL,
    [Hours]              DECIMAL (8, 2)   NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Permission] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_PermissionReason_Permission_PermissionReasonId] FOREIGN KEY ([PermissionReasonId]) REFERENCES [dbo].[PermissionReason] ([Id]),
    CONSTRAINT [FK_User_Permission_CreatedByUserId] FOREIGN KEY ([CreatedByUserId]) REFERENCES [dbo].[User] ([Id]),
    CONSTRAINT [FK_User_Permission_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[User] ([Id])
)
GO