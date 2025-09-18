CREATE TABLE [dbo].[StatusReportingConfigurations]
(
	[Id] [uniqueidentifier] NULL,
	[ConfigurationName] [nvarchar](500) NULL,
	[FormTypeId] [uniqueidentifier] NULL,
	[FormType] [nvarchar](100) NULL,
	[FormId] [uniqueidentifier] NULL,
	[EmployeeIds] [nvarchar](max) NULL,
	[StatusConfigurationOptions] [nvarchar](500) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[UpdatedOn] [datetime] NULL,
	[UpdatedBy] [uniqueidentifier] NULL,
	[IsArchived] [bit] NULL,
	[ArchivedBy] [uniqueidentifier] NULL,
	[ArchivedOn] [datetime] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
)
