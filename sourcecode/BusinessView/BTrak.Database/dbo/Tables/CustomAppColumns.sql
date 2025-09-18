CREATE TABLE [dbo].[CustomAppColumns](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomWidgetId] [uniqueidentifier] NOT NULL,
	[ColumnName] [nvarchar](50) NOT NULL,
	[ColumnAltName] [nvarchar](50) NULL,
	[ColumnType] [nvarchar](50) NOT NULL,
	[SubQuery] [nvarchar](max) NULL,
	[SubQueryTypeId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[InActiveDateTime] [datetimeoffset](7) NULL,
	[TimeStamp] [timestamp] NULL,
	[Precision] [varchar](250) NULL,
	[IsNullable] [bit] NULL,
	[MaxLength] [varchar](250) NULL,
	[Hidden] [bit] NULL,
	[Width] [nvarchar](250) NULL,
	[Order] [int] NULL,
	[ColumnFormatTypeId] [uniqueidentifier] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomAppColumns]  WITH CHECK ADD FOREIGN KEY([CustomWidgetId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomAppColumns]  WITH CHECK ADD FOREIGN KEY([SubQueryTypeId])
REFERENCES [dbo].[CustomAppSubQueryType] ([Id])
GO
