CREATE TABLE [dbo].[EmployeeReportTo](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[ReportingMethodId] [uniqueidentifier] NULL,
	[ReportToEmployeeId] [uniqueidentifier] NOT NULL,
	[OtherText] [nvarchar](500) NULL,
	[ActiveFrom] [datetime] NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeReport] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[EmployeeReportTo]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeReportTo_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeReportTo] CHECK CONSTRAINT [FK_Employee_EmployeeReportTo_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeReportTo]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeReportTo_ReportToEmployeeId] FOREIGN KEY([ReportToEmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeReportTo] CHECK CONSTRAINT [FK_Employee_EmployeeReportTo_ReportToEmployeeId]
GO

ALTER TABLE [dbo].[EmployeeReportTo]  WITH NOCHECK ADD  CONSTRAINT [FK_ReportingMethod_EmployeeReportTo_ReportingMethodId] FOREIGN KEY([ReportingMethodId])
REFERENCES [dbo].[ReportingMethod] ([Id])
GO

ALTER TABLE [dbo].[EmployeeReportTo] CHECK CONSTRAINT [FK_ReportingMethod_EmployeeReportTo_ReportingMethodId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeReportTo_EmployeeId 
ON [dbo].[EmployeeReportTo] (  EmployeeId ASC  )
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO