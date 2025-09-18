CREATE TABLE [dbo].[LeaveApplication](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[LeaveAppliedDate] [datetime] NOT NULL,
	[LeaveReason] [nvarchar](800) NULL,
	[LeaveTypeId] [uniqueidentifier] NOT NULL,
	[LeaveDateFrom] [datetime] NOT NULL,
	[LeaveDateTo] [datetime] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[OverallLeaveStatusId] [uniqueidentifier] NULL,
	[FromLeaveSessionId] [uniqueidentifier] NULL,
	[ToLeaveSessionId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[IsDeleted] BIT NULL,
	[TimeStamp] TIMESTAMP,
    [BackUpUserId] UNIQUEIDENTIFIER NULL
CONSTRAINT [PK_LeaveApplication] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_LeaveApplication_LeaveType] FOREIGN KEY ([LeaveTypeId]) REFERENCES [LeaveType]([Id]), 
    CONSTRAINT [FK_LeaveApplication_FromLeaveSession] FOREIGN KEY ([FromLeaveSessionId]) REFERENCES [LeaveSession]([Id]),
    CONSTRAINT [FK_LeaveApplication_ToLeaveSession] FOREIGN KEY ([ToLeaveSessionId]) REFERENCES [LeaveSession]([Id])
)
GO

CREATE NONCLUSTERED INDEX IX_LeaveApplication_UserId_LeaveDateFrom_LeaveDateTo 
ON [dbo].[LeaveApplication] (  UserId ASC  , LeaveDateFrom ASC  , LeaveDateTo ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_LeaveApplication_UserId 
ON [dbo].[LeaveApplication] (  UserId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO

CREATE NONCLUSTERED INDEX IX_LeaveApplication_OverallLeaveStatusId
ON [dbo].[LeaveApplication] ([OverallLeaveStatusId])
INCLUDE ([UserId],[LeaveTypeId],[LeaveDateFrom],[LeaveDateTo],[FromLeaveSessionId],[ToLeaveSessionId])
GO