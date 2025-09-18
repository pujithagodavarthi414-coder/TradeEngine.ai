CREATE TABLE [dbo].[File](
	[Id] [uniqueidentifier] NOT NULL,
	[UserStoryId] [uniqueidentifier] NULL,
	[FileName] [nvarchar](800) NULL,
	[FilePath] [nvarchar](1000) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[LeadId] [uniqueidentifier] NULL,
	[FoodOrderId] [uniqueidentifier] NULL,
	[EmployeeId] [uniqueidentifier] NULL,
	[ExpenseId] [uniqueidentifier] NULL,
	[ExpenseReportId] [uniqueidentifier] NULL,
	[StatusReportingId] [uniqueidentifier] NULL,
	[IsTimeSheetUpload] [bit] NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_File] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_Expense] FOREIGN KEY([ExpenseId])
REFERENCES [dbo].[Expense] ([Id])
GO

ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_Expense]
GO
ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_ExpenseReport] FOREIGN KEY([ExpenseReportId])
REFERENCES [dbo].[ExpenseReport] ([Id])
GO

ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_ExpenseReport]
GO


ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_Employee] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_Employee]
GO

ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_FoodOrder] FOREIGN KEY([FoodOrderId])
REFERENCES [dbo].[FoodOrder] ([Id])
GO

ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_FoodOrder]
GO

ALTER TABLE [dbo].[File]  WITH CHECK ADD  CONSTRAINT [FK_File_StatusReporting] FOREIGN KEY([StatusReportingId])
REFERENCES [dbo].[StatusReporting] ([Id])
GO

ALTER TABLE [dbo].[File] CHECK CONSTRAINT [FK_File_StatusReporting]
GO
