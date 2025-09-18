CREATE TABLE [dbo].[ProjectType](
	[Id] [UNIQUEIDENTIFIER] NOT NULL,
	[ProjectTypeName] [NVARCHAR](250) NOT NULL,
	[ArchivedDateTime] DATETIMEOFFSET NULL,
	CompanyId [uniqueidentifier]  NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [UNIQUEIDENTIFIER] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [UNIQUEIDENTIFIER] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[InActiveDateTimeZoneId]  [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_ProjectType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO