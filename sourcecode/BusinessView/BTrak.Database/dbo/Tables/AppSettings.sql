CREATE TABLE [dbo].[AppSettings](
	[Id] [uniqueidentifier] NOT NULL,
	[AppSettingsName] [nvarchar](250)  NOT NULL,
	[AppSettingsValue] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP, 
	[IsSystemLevel] [BIT] NULL
    CONSTRAINT [PK_[AppSettings] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [AppSettings] ADD CONSTRAINT [UK_AppSettings_AppSettingsName] UNIQUE ([AppSettingsName])
GO