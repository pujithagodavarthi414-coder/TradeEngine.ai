CREATE TABLE [dbo].[DynamicTab](
	[Id] [uniqueidentifier] NOT NULL,
	[DynamicTabName] [nvarchar](250) NULL,
	[Description] [nvarchar](500) NULL,
	 ViewRole [varchar](max) NULL,
	 EditRole [varchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[DynamicModuleId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp],
 CONSTRAINT [PK_DynamicTab] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
