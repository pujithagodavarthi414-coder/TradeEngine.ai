CREATE TABLE [dbo].[EmployeeEducation](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[EducationLevelId] [uniqueidentifier] NOT NULL,
	[Institute] [nvarchar](800) NOT NULL,
	[MajorSpecialization] [nvarchar](800) NULL,
	[GPA_Score] [decimal](18, 2) NOT NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeEducation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[EmployeeEducation]  WITH CHECK ADD  CONSTRAINT [FK_Employee_EmployeeEducation_EmployeeId] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEducation] CHECK CONSTRAINT [FK_Employee_EmployeeEducation_EmployeeId]
GO

ALTER TABLE [dbo].[EmployeeEducation]  WITH NOCHECK ADD  CONSTRAINT [FK_EducationLevel_EmployeeEducation_EducationLevelId] FOREIGN KEY([EducationLevelId])
REFERENCES [dbo].[EducationLevel] ([Id])
GO

ALTER TABLE [dbo].[EmployeeEducation] CHECK CONSTRAINT [FK_EducationLevel_EmployeeEducation_EducationLevelId]
GO

CREATE NONCLUSTERED INDEX IX_EmployeeEducation_EmployeeId 
ON [dbo].[EmployeeEducation] (  EmployeeId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO