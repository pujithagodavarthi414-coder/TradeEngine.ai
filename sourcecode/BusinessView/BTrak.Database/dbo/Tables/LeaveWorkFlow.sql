CREATE TABLE [dbo].[LeaveWorkFlow](
	[Id] [uniqueidentifier] NOT NULL,
	[AppliedDesignationId] [uniqueidentifier] NOT NULL,
	[ApprovedDesignationId] [uniqueidentifier] NOT NULL,
	[OrderNumber] [int] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    [MinApprovedOrdernuber] INT NULL, 
    CONSTRAINT [PK_LeaveWorkFlow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_LeaveWorkFlow_AppliedDesignationId_ApprovedDesignationId] UNIQUE ([AppliedDesignationId],[ApprovedDesignationId])
)
GO