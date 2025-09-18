CREATE TABLE [dbo].[Project](
	[Id] [uniqueidentifier] NOT NULL,
	CompanyId [uniqueidentifier]  NULL,
	[ProjectName] [nvarchar](250) NOT NULL,
	[ProjectUniqueName] [nvarchar](250) NULL,
	ProjectResponsiblePersonId [uniqueidentifier] NULL,
	CreatedDateTimeZone [uniqueidentifier] NULL,
	[CreatedDateTime] [datetimeoffset] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetimeoffset] NULL,
    [UpdatedDateTimeZone] [uniqueidentifier] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[ProjectStatusColor] [varchar](250) NULL,
	[ProjectTypeId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetimeoffset] NULL,
	[InActiveDateTimeZoneId] [uniqueidentifier] NULL,
	[IsDateTimeConfiguration] [BIT] DEFAULT 0 NOT NULL,
	[TimeStamp] TIMESTAMP,
    [Tag] NVARCHAR(250) NULL, 
    [IsSprintsConfiguration] BIT NULL, 
    [ProjectStartDate] DATETIMEOFFSET NULL, 
    [ProjectEndDate] DATETIMEOFFSET NULL, 
    [ProjectEndDateTimeZoneId] [uniqueidentifier] NULL,
	ProjectStartDateTimeZoneId [uniqueidentifier] NULL,
    CONSTRAINT [PK_Project] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[Project]  WITH CHECK ADD  CONSTRAINT [FK_ProjectType_Project_ProjectTypeId] FOREIGN KEY([ProjectTypeId])
REFERENCES [dbo].[ProjectType] ([Id])
GO

ALTER TABLE [dbo].[Project] CHECK CONSTRAINT [FK_ProjectType_Project_ProjectTypeId]
GO

CREATE NONCLUSTERED INDEX [IX_Project_CompanyId_ProjectName]
ON [dbo].[Project] ([CompanyId],[ProjectName])
GO