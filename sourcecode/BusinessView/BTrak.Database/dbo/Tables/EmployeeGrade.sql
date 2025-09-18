CREATE TABLE [dbo].[EmployeeGrade](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[GradeId] [uniqueidentifier] NOT NULL,
	[ActiveFrom] [datetime] NOT NULL,
	[ActiveTo] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_EmployeeGrade] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

ALTER TABLE [dbo].[EmployeeGrade] WITH CHECK ADD CONSTRAINT [FK_Employee_EmployeeGrade_EmployeeId] FOREIGN KEY ([EmployeeId])
REFERENCES [dbo].[Employee]([Id])
GO

ALTER TABLE [dbo].[EmployeeGrade] WITH CHECK ADD CONSTRAINT [FK_Grade_EmployeeGrade_GradeId] FOREIGN KEY ([GradeId])
REFERENCES [dbo].[Grade]([Id])
GO