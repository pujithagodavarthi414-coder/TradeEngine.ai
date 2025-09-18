CREATE TABLE [dbo].[SoftLabel]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [SoftLabelName] [nvarchar](800) NOT NULL,
	[SoftLabelKeyType] [nvarchar](500) NULL,
	[SoftLabelValue] [nvarchar](500) NULL,
    [IsActive] [bit] NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP
)
GO

ALTER TABLE [dbo].[SoftLabel]  WITH CHECK ADD  CONSTRAINT [FK_Branch_SoftLabel_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[SoftLabel] CHECK CONSTRAINT [FK_Branch_SoftLabel_BranchId]
GO
