CREATE TABLE [dbo].[ReferenceType]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ReferenceTypeName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[CompanyId] [uniqueidentifier] NULL
 CONSTRAINT [PK_ReferenceType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

ALTER TABLE [dbo].[ReferenceType]  WITH NOCHECK ADD CONSTRAINT [FK_ReferenceType_ReferenceType_Id] FOREIGN KEY ([Id])
REFERENCES [dbo].[ReferenceType] ([Id])
GO

ALTER TABLE [dbo].[ReferenceType] CHECK CONSTRAINT [FK_ReferenceType_ReferenceType_Id]
GO