CREATE TABLE [dbo].[Job](
	[Id] [uniqueidentifier] NOT NULL,
	[DesignationId] [uniqueidentifier] NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[EmploymentStatusId] [uniqueidentifier] NULL,
	[JobCategoryId] [uniqueidentifier] NULL,
	[JoinedDate] [datetime] NULL,
	[DepartmentId] [uniqueidentifier] NULL,
	[BranchId] [uniqueidentifier] NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    [InActiveDateTime] [datetime] NULL,
	[NoticePeriodInMonths] INT NULL,
 CONSTRAINT [PK_Job] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Designation_Job_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[Designation] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Designation_Job_DesignationId]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Job_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Employee_Job_EmployeeId]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Department_Job_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Department_Job_DepartmentId]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_EmploymentStatus_Job_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_EmploymentStatus_Job_EmploymentStatusId]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_JobCategory_Job_JobCategoryId] FOREIGN KEY([JobCategoryId])
REFERENCES [dbo].[JobCategory] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_JobCategory_Job_JobCategoryId]
GO
ALTER TABLE [dbo].[Job]  WITH CHECK ADD  CONSTRAINT [FK_Branch_Job_BranchId] FOREIGN KEY([BranchId])
REFERENCES [dbo].[Branch] ([Id])
GO

ALTER TABLE [dbo].[Job] CHECK CONSTRAINT [FK_Branch_Job_BranchId]
GO

CREATE NONCLUSTERED INDEX IX_Job_EmployeeId ON [dbo].[Job] (  EmployeeId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_Job_JoinedDate
ON [dbo].[Job] ([JoinedDate])
INCLUDE ([EmployeeId])
GO