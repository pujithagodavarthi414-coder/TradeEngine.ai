CREATE TABLE [dbo].[HRMS_MasterTable](
	[Id] [uniqueidentifier] NOT NULL,
	[HRMS_MasterTableTypeId] [uniqueidentifier] NOT NULL,
	[MasterValue] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_HRMS_MasterTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_HRMS_MasterTable_MasterValue_HRMSMasterTableTypeId] UNIQUE ([HRMS_MasterTableTypeId], [MasterValue])
)