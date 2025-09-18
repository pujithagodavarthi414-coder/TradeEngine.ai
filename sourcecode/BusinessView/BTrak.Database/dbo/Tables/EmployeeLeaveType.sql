CREATE TABLE [dbo].[EmployeeLeaveType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [EmployeeId] UNIQUEIDENTIFIER NOT NULL, 
    [LeaveTypeId] UNIQUEIDENTIFIER NOT NULL, 
	[NoOfLeaves] FLOAT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL, 
    [CreatedDateTime] DATETIMEOFFSET NULL, 
    [InactiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
    CONSTRAINT [PK_EmployeeStatusLeaveType] PRIMARY KEY ([Id]) 
)