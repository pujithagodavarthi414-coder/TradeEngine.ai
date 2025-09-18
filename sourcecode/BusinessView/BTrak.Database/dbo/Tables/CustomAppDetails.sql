CREATE TABLE [dbo].[CustomAppDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[CustomApplicationId] [uniqueidentifier] NOT NULL,
	[IsDefault] [bit] NOT NULL,
	[VisualizationName] [nvarchar](max) NULL,
	[VisualizationType] [nvarchar](100) NOT NULL,
	[FilterQuery] [nvarchar](max) NULL,
	[DefaultColumns] [nvarchar](max) NULL,
	[PivotMeasurersToDisplay] [nvarchar](max) NULL,
	[XCoOrdinate] [nvarchar](max) NULL,
	[YCoOrdinate] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[HeatMapMeasure] [nvarchar](max) NULL,
	[ColumnFormatQuery] [nvarchar](max) NULL,
	[ColumnAltName] [nvarchar](max) NULL,
	[ChartColorJson] [nvarchar](MAX) NULL,
 CONSTRAINT [PK_CustomAppDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CustomAppDetails] ADD  DEFAULT ((0)) FOR [IsDefault]
GO

ALTER TABLE [dbo].[CustomAppDetails]  WITH CHECK ADD  CONSTRAINT [FK_CustomWidgets_CustomAppDetails_CustomApplicationId] FOREIGN KEY([CustomApplicationId])
REFERENCES [dbo].[CustomWidgets] ([Id])
GO

ALTER TABLE [dbo].[CustomAppDetails] CHECK CONSTRAINT [FK_CustomWidgets_CustomAppDetails_CustomApplicationId]
GO
