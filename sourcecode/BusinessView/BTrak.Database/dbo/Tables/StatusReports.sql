CREATE TABLE [dbo].[StatusReports](
	[Id] [uniqueidentifier] NULL,
	[StatusConfigurationId] [uniqueidentifier] NULL,
	[FormId] [uniqueidentifier] NULL,
	[FormName] [nvarchar](100) NULL,
	[Description] [nvarchar](300) NULL,
	[FormData] [nvarchar](max) NULL,
	[UploadedFileName] [nvarchar](max) NULL,
	[UploadedFileUrl] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[CreatedBy] [uniqueidentifier] NULL,
	[ReportAssignedBy] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP
)
GO
