CREATE TABLE [dbo].[CrmMasterTableType](
	[Id] [uniqueidentifier] NOT NULL,
	[MasterTableName] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_CRM_MasterTableType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_CrmMasterTableType_MasterTableName] UNIQUE ([MasterTableName])
)