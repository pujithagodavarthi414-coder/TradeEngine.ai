CREATE TABLE [dbo].[UserBreak](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
	[IsOfficeBreak] [bit] NOT NULL,
	[BreakIn] DATETIMEOFFSET NULL,
	[BreakInTimeZone] UNIQUEIDENTIFIER NULL,
	[BreakOut] DATETIMEOFFSET NULL,
	[BreakOutTimeZone] UNIQUEIDENTIFIER NULL,
	[InActiveDateTime] [datetime] NULL,
	[BreakTypeId] [uniqueidentifier] NULL,
    [CreatedDateTime] DATETIME NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    CONSTRAINT [PK_UserBreak] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[UserBreak]  WITH NOCHECK ADD CONSTRAINT [FK_BreakType_UserBreak_BreakTypeId] FOREIGN KEY ([BreakTypeId])
REFERENCES [dbo].[BreakType] ([Id])
GO

ALTER TABLE [dbo].[UserBreak] CHECK CONSTRAINT [FK_BreakType_UserBreak_BreakTypeId]
GO

CREATE NONCLUSTERED INDEX IX_UserBreak_UserId_Date_BreakOut
ON [dbo].[UserBreak] ([UserId],[Date],[BreakOut])
GO