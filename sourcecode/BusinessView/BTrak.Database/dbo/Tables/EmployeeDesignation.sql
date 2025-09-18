CREATE TABLE [dbo].[EmployeeDesignation](
	[Id] [uniqueidentifier] NOT NULL,
	[DesignationId] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[EmploymentStatusId] [uniqueidentifier] NOT NULL,
	[JobCategoryId] [uniqueidentifier] NOT NULL,
	[DepartmentId] [uniqueidentifier] NULL,
	[ContrcatStartDate] [datetime] NULL,
	[ContrcatEndDate] [datetime] NULL,
	[ContractDetails] [nvarchar](800) NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP NULL,
 CONSTRAINT [PK_EmployeeDesignation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[EmployeeDesignation]  WITH NOCHECK ADD  CONSTRAINT [FK_Designation_EmployeeDesignation_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[Designation] ([Id])
GO

ALTER TABLE [dbo].[EmployeeDesignation] CHECK CONSTRAINT [FK_Designation_EmployeeDesignation_DesignationId]
GO
ALTER TABLE [dbo].[EmployeeDesignation]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_EmployeeDesignation_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeDesignation] CHECK CONSTRAINT [FK_Employee_EmployeeDesignation_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeDesignation]  WITH NOCHECK ADD  CONSTRAINT [FK_Department_EmployeeDesignation_DepartmentId] FOREIGN KEY([DepartmentId])
REFERENCES [dbo].[Department] ([Id])
GO

ALTER TABLE [dbo].[EmployeeDesignation] CHECK CONSTRAINT [FK_Department_EmployeeDesignation_DepartmentId]
GO
ALTER TABLE [dbo].[EmployeeDesignation]  WITH NOCHECK ADD  CONSTRAINT [FK_EmploymentStatus_EmployeeDesignation_EmploymentStatusId] FOREIGN KEY([EmploymentStatusId])
REFERENCES [dbo].[EmploymentStatus] ([Id])
GO

ALTER TABLE [dbo].[EmployeeDesignation] CHECK CONSTRAINT [FK_EmploymentStatus_EmployeeDesignation_EmploymentStatusId]
GO

ALTER TABLE [dbo].[EmployeeDesignation]  WITH NOCHECK ADD  CONSTRAINT [FK_JobCategory_EmployeeDesignation_JobCategoryId] FOREIGN KEY([JobCategoryId])
REFERENCES [dbo].[JobCategory] ([Id])
GO

ALTER TABLE [dbo].[EmployeeDesignation] CHECK CONSTRAINT [FK_JobCategory_EmployeeDesignation_JobCategoryId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeDesignation_EmployeeId
ON [dbo].[EmployeeDesignation] (  EmployeeId ASC  )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO