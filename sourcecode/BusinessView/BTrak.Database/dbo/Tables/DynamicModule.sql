CREATE TABLE [dbo].[DynamicModule](
	[Id] [uniqueidentifier] NOT NULL,
	DynamicModuleName [nvarchar](250) NULL,
	[Description] [nvarchar](500) NULL,
	ModuleIcon [nvarchar](max) NULL,
	ViewRole [nvarchar](max) NULL,
	EditRole [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] [timestamp],
 CONSTRAINT [PK_DynamicModule] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
