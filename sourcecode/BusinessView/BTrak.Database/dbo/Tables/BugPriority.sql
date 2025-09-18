CREATE TABLE BugPriority (
[Id] UNIQUEIDENTIFIER NOT NULL,
[PriorityName] NVARCHAR(200) NOT NULL,
[Color] NVARCHAR(100) NOT NULL,
[Icon] NVARCHAR(100) NULL,
[CompanyId] [uniqueidentifier] NULL,
[Order] [int] NULL,
[CreatedDateTime] DATETIMEOFFSET NOT NULL,
[CreatedDateTimeZoneId] [uniqueidentifier] NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[UpdatedDateTime] DATETIMEOFFSET NULL,
[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
[UpdatedByUserId] [uniqueidentifier] NULL,
[Description] [varchar](250) NULL,
[IsCritical] BIT NULL, 
[IsHigh] BIT NULL, 
[IsMedium] BIT NULL, 
[IsLow] BIT NULL, 
[TimeStamp] TIMESTAMP,
[InActiveDateTime] DATETIMEOFFSET NULL,

    CONSTRAINT [PK_BugPriority] PRIMARY KEY ([Id]) 
)