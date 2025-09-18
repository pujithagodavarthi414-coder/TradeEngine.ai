CREATE TABLE [dbo].[EstimateItem](
	[Id] [uniqueidentifier] NOT NULL,
	[EstimateId] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[ItemName] [nvarchar](150) NULL,
	[ItemDescription] [nvarchar](800) NULL,
	[Price] float NULL,
	[Quantity] float NULL,
	[Order] int NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] [timestamp] NOT NULL,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_EstimateItem] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[EstimateItem] WITH CHECK ADD CONSTRAINT [FK_Estimate_EstimateItem_EstimateId] FOREIGN KEY([EstimateId])
REFERENCES [dbo].[Estimate] ([Id])
GO
​
ALTER TABLE [dbo].[EstimateItem] CHECK CONSTRAINT [FK_Estimate_EstimateItem_EstimateId]
GO