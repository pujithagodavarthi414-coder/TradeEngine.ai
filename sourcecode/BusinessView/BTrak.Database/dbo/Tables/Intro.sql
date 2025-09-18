CREATE TABLE [dbo].[Intro](
	[Id] [uniqueidentifier] NOT NULL,
	[ModuleId] [uniqueidentifier] NOT NULL,
	[EnableIntro] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[UserId] [uniqueidentifier] NOT NULl
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

CREATE NONCLUSTERED INDEX [IX_Intro_EnableIntro_InActiveDateTime_UserId]
ON [dbo].[Intro] ([EnableIntro],[InActiveDateTime],[UserId])
INCLUDE ([ModuleId])
GO