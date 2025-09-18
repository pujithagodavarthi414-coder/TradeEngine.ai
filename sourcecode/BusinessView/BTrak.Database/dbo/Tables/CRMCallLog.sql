CREATE TABLE [dbo].[CRMCallLog]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ReceiverId] [uniqueidentifier] NOT NULL,
	[CallConnectedTo] NVARCHAR(150) NOT NULL,
	[CallOutcomeCode]  NVARCHAR(50) NOT NULL,
	[CallDescription] nvarchar(1000),
	[CallStartedOn] datetime,
	[CallEndedOn] datetime,
	[CallRecordingLink] nvarchar(max),
	[CallLoggedDate] datetime,
	[CallLoggedTime] datetime,
	[ActivityTypeId] UNIQUEIDENTIFIER NULL,
	[CallResource] nvarchar(max),
	[CompanyId]  [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL, 
    CONSTRAINT [PK_CRMCallLog] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO