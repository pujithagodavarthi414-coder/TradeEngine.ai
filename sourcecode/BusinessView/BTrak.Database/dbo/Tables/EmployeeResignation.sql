CREATE   TABLE [dbo].[EmployeeResignation](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[ResignationDate] [datetime] NOT NULL,
	[LastDate] [datetime]  NULL,
	[ResginationApprovedByEmployeeId] [uniqueidentifier]  NULL,
	[FinalAMountSettledPayrollRunId] [uniqueidentifier]  NULL,
    [AppiledDate] [datetime] NULL,
	[ApprovedDate] [datetime]  NULL,
	[ResignationStastusId] [uniqueidentifier]  NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[CommentByEmployee] VARCHAR(800) NULL,
	[CommentByEmployer] VARCHAR(800) NULL,
	[ResginationRejectedByEmployeeId] [uniqueidentifier]  NULL,
	[RejectedDate] [datetime]  NULL
    CONSTRAINT [PK_EmployeeResignation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[EmployeeResignation]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeResignation_Employee_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeResignation] CHECK CONSTRAINT [FK_EmployeeResignation_Employee_EmployeeId]
GO
ALTER TABLE [dbo].[EmployeeResignation]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeResignation_Employee_ResginationApprovedByEmployeeId] FOREIGN KEY([ResginationApprovedByEmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeResignation] CHECK CONSTRAINT [FK_EmployeeResignation_Employee_ResginationApprovedByEmployeeId]
GO

ALTER TABLE [dbo].[EmployeeResignation]  WITH NOCHECK ADD CONSTRAINT [FK_EmployeeResignation_ResignationStastus_ResignationStastusId] FOREIGN KEY([ResignationStastusId])
REFERENCES [dbo].[ResignationStatus] ([Id])
GO

ALTER TABLE [dbo].[EmployeeResignation] CHECK CONSTRAINT [FK_EmployeeResignation_ResignationStastus_ResignationStastusId]
GO

ALTER TABLE [dbo].[EmployeeResignation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeResignation_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeResignation] CHECK CONSTRAINT [FK_EmployeeResignation_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[EmployeeResignation]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeResignation_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EmployeeResignation] CHECK CONSTRAINT [FK_EmployeeResignation_User_UpdatedByUserId]
GO