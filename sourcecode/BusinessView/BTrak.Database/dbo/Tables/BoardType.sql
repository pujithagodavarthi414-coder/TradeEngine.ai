CREATE TABLE [dbo].[BoardType](
	[Id] [uniqueidentifier] NOT NULL,
	[BoardTypeName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
    [UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[BoardTypeUIId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
    [IsBugBoard] BIT NULL DEFAULT 0, 
    [IsSuperAgileBoard] BIT NULL DEFAULT 0, 
    [IsDefault] BIT NULL DEFAULT 0, 
    CONSTRAINT [PK_BoardType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO