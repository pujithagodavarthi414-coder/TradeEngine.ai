CREATE TABLE [dbo].[MariatalStatusLeaveType]
(
	[Id] UNIQUEIDENTIFIER NOT NULL , 
    [MariatalStatusId] UNIQUEIDENTIFIER NULL, 
    [LeaveTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIMEOFFSET NULL, 
    [CreatedDateTime] DATETIMEOFFSET NULL, 
    [InactiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP, 
	[IsAccessAll] BIT NULL
    CONSTRAINT [PK_MariatalStatusLeaveType] PRIMARY KEY ([Id]) 
)