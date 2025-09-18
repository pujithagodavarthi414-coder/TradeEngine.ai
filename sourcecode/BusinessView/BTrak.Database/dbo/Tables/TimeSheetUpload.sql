CREATE TABLE [dbo].[TimeSheetUpload](
	[Id] [uniqueidentifier] NOT NULL,
	[Date] [date] NOT NULL,
	[BranchId] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](900) NULL,
	[FilePath] [nvarchar](max) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_TimeSheetUpload] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
GO
ALTER TABLE [dbo].[TimeSheetUpload]  WITH CHECK ADD  CONSTRAINT [FK_Branch_TimeSheetUpload_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[TimeSheetUpload] CHECK CONSTRAINT [FK_Branch_TimeSheetUpload_BranchId]
GO
ALTER TABLE [dbo].[TimeSheetUpload]  WITH CHECK ADD  CONSTRAINT [FK_User_TimeSheetUpload_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[TimeSheetUpload] CHECK CONSTRAINT [FK_User_TimeSheetUpload_CreatedByUserId]
GO