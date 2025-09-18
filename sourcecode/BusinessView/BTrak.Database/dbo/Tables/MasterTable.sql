CREATE TABLE [dbo].[MasterTable](
	[Id] [uniqueidentifier] NOT NULL,
	[MasterTableTypeId] [uniqueidentifier] NOT NULL,
	[MasterValue] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](50) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_MasterTable] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_MasterTable_MasterValue_MasterTableTypeId] UNIQUE ([MasterValue], [MasterTableTypeId])
)