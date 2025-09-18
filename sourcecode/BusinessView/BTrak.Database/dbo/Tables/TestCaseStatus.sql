CREATE TABLE [dbo].[TestCaseStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](250) NULL,
	[StatusShortName] [nvarchar](250) NULL,
	[CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedDateTimeZoneId] [uniqueidentifier]  NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
	[UpdatedDateTimeZoneId] [uniqueidentifier] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[StatusHexValue] [nvarchar](50) NULL,
	CompanyId [uniqueidentifier]  NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsFailed] BIT NULL, 
    [IsPassed] BIT NULL, 
    [IsReTest] BIT NULL, 
    [IsBlocked] BIT NULL, 
    [IsUntested] BIT NULL, 
    CONSTRAINT [PK_TestCaseStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TestCaseStatus]  WITH CHECK ADD  CONSTRAINT [FK_TestCaseStatus_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[TestCaseStatus] CHECK CONSTRAINT [FK_TestCaseStatus_CompanyId]
GO