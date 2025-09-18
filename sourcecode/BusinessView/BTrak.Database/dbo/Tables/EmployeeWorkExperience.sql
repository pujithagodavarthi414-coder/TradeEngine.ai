CREATE TABLE [dbo].[EmployeeWorkExperience](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[Company] [nvarchar](500) NOT NULL,
	[DesignationId] [uniqueidentifier] NOT NULL,
	[FromDate] [datetime] NOT NULL,
	[ToDate] [datetime] NULL,
	[Comments] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeWorkExperience] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[EmployeeWorkExperience]  WITH NOCHECK ADD  CONSTRAINT [FK_Employee_EmployeeWorkExperience_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeWorkExperience] CHECK CONSTRAINT [FK_Employee_EmployeeWorkExperience_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeWorkExperience]  WITH NOCHECK ADD  CONSTRAINT [FK_Designation_EmployeeWorkExperience_DesignationId] FOREIGN KEY([DesignationId])
REFERENCES [dbo].[Designation] ([Id])
GO

ALTER TABLE [dbo].[EmployeeWorkExperience] CHECK CONSTRAINT [FK_Designation_EmployeeWorkExperience_DesignationId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeWorkExperience_EmployeeId 
ON [dbo].[EmployeeWorkExperience] (  EmployeeId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO