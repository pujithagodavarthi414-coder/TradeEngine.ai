CREATE TABLE [dbo].[LeaveStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[LeaveStatusName] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] DATETIME NULL,
    [IsApproved] BIT NULL, 
    [IsRejected] BIT NULL, 
    [IsWaitingForApproval] BIT NULL, 
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    [LeaveStatusColour] NVARCHAR(50) NULL, 
    CONSTRAINT [PK_LeaveStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO