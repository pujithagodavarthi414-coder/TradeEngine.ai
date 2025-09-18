CREATE TABLE [dbo].[LeaveFrequency]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [LeaveTypeId] UNIQUEIDENTIFIER NOT NULL, 
    [EncashmentTypeId] UNIQUEIDENTIFIER NULL, 
    [LeaveFormulaId] UNIQUEIDENTIFIER NULL, 
	[NumberOfDaysToBeIntimated] FLOAT NULL, 
    [CarryForwardLeavesCount] FLOAT NULL, 
    [PayableLeavesCount] FLOAT NULL, 
    [DateFrom] DATETIME, 
    [DateTo] DATETIME, 
    [NoOfLeaves] FLOAT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] DATETIME NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
    [InActiveDateTime] DATETIME NULL, 
    [TimeStamp] TIMESTAMP,			 
    [CompanyId] UNIQUEIDENTIFIER NULL, 
    [IsToRepeatTheInterval] BIT NULL DEFAULT 0, 
    [PaymentTypeId] UNIQUEIDENTIFIER NULL, 
    [IsToCarryForward] BIT NULL DEFAULT 0, 
    [IsEncashable] BIT NULL, 
    [RestrictionTypeId] UNIQUEIDENTIFIER NULL, 
	[IsPaid] BIT NULL,
    [EmploymentTypeId] UNIQUEIDENTIFIER NULL, 
	[EncashedLeavesCount] FLOAT NULL
    CONSTRAINT [PK_LeaveFrequency] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_LeaveFrequency_LeaveType] FOREIGN KEY ([LeaveTypeId]) REFERENCES [LeaveType]([Id]), 
    CONSTRAINT [FK_LeaveFrequency_Encashment] FOREIGN KEY ([EncashmentTypeId]) REFERENCES [EncashmentType]([Id]), 
)
GO