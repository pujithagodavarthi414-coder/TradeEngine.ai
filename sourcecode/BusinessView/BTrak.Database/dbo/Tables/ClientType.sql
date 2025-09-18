CREATE TABLE [dbo].[ClientType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ClientTypeName] [nvarchar](250) NULL,
	[Order] INT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
	CONSTRAINT [PK_ClientType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

