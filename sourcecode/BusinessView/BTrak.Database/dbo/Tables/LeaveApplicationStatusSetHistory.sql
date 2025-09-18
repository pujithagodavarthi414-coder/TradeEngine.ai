CREATE TABLE [dbo].[LeaveApplicationStatusSetHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[LeaveApplicationId] [uniqueidentifier] NOT NULL,
	[LeaveStatusId] [uniqueidentifier] NOT NULL,
	[LeaveStuatusSetByUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] DATETIME NULL,
	[Reason] NVARCHAR(MAX) NULL,
	[Description] NVARCHAR(250) NULL,
	[TimeStamp] TIMESTAMP,
    [OldValue] NVARCHAR(MAX) NULL, 
    [NewValue] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_LeaveApplicationStatusSetHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[LeaveApplicationStatusSetHistory]  WITH CHECK ADD  CONSTRAINT [FK_LeaveApplication_LeaveApplicationStatus_LeaveApplicationId] FOREIGN KEY([LeaveApplicationId])
REFERENCES [dbo].[LeaveApplication] ([Id])
GO

ALTER TABLE [dbo].[LeaveApplicationStatus] CHECK CONSTRAINT [FK_LeaveApplication_LeaveApplicationStatus_LeaveApplicationId]
GO

CREATE NONCLUSTERED INDEX IX_LeaveApplicationStatus_LeaveApplicationId 
ON [dbo].[LeaveApplicationStatusSetHistory] (  LeaveApplicationId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO