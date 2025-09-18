CREATE TABLE [dbo].[EmployeeLeaveAllowance](
	[Id] [uniqueidentifier] NOT NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[LeaveAllowanceId] [uniqueidentifier] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] DATETIME NULL, 
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_EmployeeLeaveAllowance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_EmployeeLeaveAllowance_EmployeeId_LeaveAllowanceId] UNIQUE ([EmployeeId],[LeaveAllowanceId])
)
GO