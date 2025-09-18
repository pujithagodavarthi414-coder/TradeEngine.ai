CREATE TABLE [dbo].[CRMVideoLog]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ReceiverId] [uniqueidentifier] NOT NULL,
	[RoomSid] NVARCHAR(200),
	[CompositionSid] NVARCHAR(200),
	[RoomName] NVARCHAR(200),
	[VideoCallDateTime] datetime,
	[VideoRecordingLink] nvarchar(max),
	[FileName] NVARCHAR(1000),
	[Extension] nvarchar(100),
	[Type] nvarchar(100),
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL, 
    CONSTRAINT [PK_CRMVideoLog] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
