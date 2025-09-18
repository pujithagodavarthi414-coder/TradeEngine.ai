CREATE TABLE [dbo].[ProcessDashboardStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusName] [nvarchar](1000) NULL,
	[HexaValue] [nvarchar](100) NULL,
	[CreatedDateTime] [datetimeoffset] NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	CompanyId [uniqueidentifier]  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 [ShortName] NVARCHAR(250) NULL, 
    CONSTRAINT [PK_ProcessDashboardStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]

GO