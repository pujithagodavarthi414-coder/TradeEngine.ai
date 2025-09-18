CREATE TABLE [dbo].[RoleLeaveType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [RoleId] UNIQUEIDENTIFIER NULL, 
    [LeaveTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL, 
    [CreatedDateTime] DATETIMEOFFSET NULL, 
    [InactiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
	[IsAccessAll] BIT NULL
    CONSTRAINT [PK_RoleLeaveFrequency] PRIMARY KEY ([Id]) 
)
