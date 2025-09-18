CREATE TABLE [dbo].[LeaveType](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[LeaveTypeName] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[MasterLeaveTypeId] UNIQUEIDENTIFIER,
	[LeaveShortName] NVARCHAR(250),
	[TimeStamp] TIMESTAMP,
	[LeaveTypeColor] NVARCHAR(250),
    CONSTRAINT [PK_LeaveType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    [IsIncludeHolidays] BIT NULL, 
)
GO