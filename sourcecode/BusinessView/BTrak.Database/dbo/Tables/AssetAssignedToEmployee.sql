CREATE TABLE [dbo].[AssetAssignedToEmployee](
	[Id] [uniqueidentifier] NOT NULL,
	[AssetId] [uniqueidentifier] NOT NULL,
	[AssignedToEmployeeId] [uniqueidentifier] NOT NULL,
	[AssignedDateFrom] [datetime] NULL,
	[AssignedDateTo] [datetime] NULL,
	[ApprovedByUserId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_AssetAssignedToEmployee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[AssetAssignedToEmployee]  WITH CHECK ADD  CONSTRAINT [FK_Asset_AssetAssignedToEmployee_AssetId] FOREIGN KEY([AssetId])
REFERENCES [dbo].[Asset] ([Id])
GO

ALTER TABLE [dbo].[AssetAssignedToEmployee] CHECK CONSTRAINT [FK_Asset_AssetAssignedToEmployee_AssetId]
GO

CREATE NONCLUSTERED INDEX IX_AssetAssignedToEmployee_AssetId
ON [dbo].[AssetAssignedToEmployee] ([AssetId])
INCLUDE ([AssignedToEmployeeId],[AssignedDateFrom],[AssignedDateTo],[ApprovedByUserId])
GO