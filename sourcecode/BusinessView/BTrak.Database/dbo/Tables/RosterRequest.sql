CREATE TABLE [dbo].[RosterRequest]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[RosterName] NVARCHAR(250) NULL,
	[RequiredFromDate] DATETIME,
	[RequiredToDate] DATETIME,
	[RequiredEmployee] INT,
	[RequiredBudget] MONEY,
	[RequiredBreakMins] DECIMAL,
	[BranchId] UNIQUEIDENTIFIER,
	[IncludeHolidays] BIT,
	[IncludeWeekends] BIT,
	[TotalWorkingDays] INT,
	[TotalWorkingHours] INT,
	[RosterShiftDetails] VARCHAR(MAX),
	[RosterDepartmentDetails] VARCHAR(MAX),
	[RosterAdhocRequirement] VARCHAR(MAX),
	[StatusId] UNIQUEIDENTIFIER NULL,
	[IsTemplate] BIT NULL,
	[IsTimesheetApproved] BIT NULL,
	[CompanyId] UNIQUEIDENTIFIER NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[InActiveDateTime] DATETIME NULL,
	[UpdatedDateTime] DATETIME NULL,
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[TimeStamp] TimeStamp NOT NULL
	CONSTRAINT [PK_RosterRequest] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO

CREATE NONCLUSTERED INDEX IX_RosterRequest_CompanyId 
ON [dbo].[RosterRequest] (  CompanyId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY]