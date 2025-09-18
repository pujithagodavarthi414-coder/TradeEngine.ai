CREATE TABLE [dbo].[SMSLog]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ReceiverId] [uniqueidentifier] NULL,
	[SentTo] nvarchar(50) NOT NULL,
	[TemplateId] [uniqueidentifier] NULL,
	[Message] nvarchar(250) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	CONSTRAINT [PK_SMSLog] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)
)
