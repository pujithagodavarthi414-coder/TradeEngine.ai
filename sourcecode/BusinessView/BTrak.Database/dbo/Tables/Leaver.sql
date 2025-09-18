CREATE TABLE [dbo].[Leaver]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [EmployeeId] [uniqueidentifier] NOT NULL,
    [Reason] [nvarchar](1200) NOT NULL,
    [LeavingDate] [datetime] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
    [TimeStamp] TIMESTAMP,
)
GO

ALTER TABLE [dbo].[Leaver]  WITH CHECK ADD  CONSTRAINT [FK_Employee_Leaver] FOREIGN KEY([EmployeeId])
REFERENCES [dbo].[Employee] ([Id])
GO

ALTER TABLE [dbo].[Leaver] CHECK CONSTRAINT [FK_Employee_Leaver]
GO
