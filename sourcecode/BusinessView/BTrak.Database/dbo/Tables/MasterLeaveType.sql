CREATE TABLE [dbo].[MasterLeaveType](
	[Id] [uniqueidentifier] NOT NULL,
	[MasterLeaveTypeName] [nvarchar](800) NULL,
	[IsCasualLeave] BIT NULL,
	[IsWorkFromHome] BIT NULL,
	[IsSickLeave] BIT NULL,
	[IsOnSite] BIT NULL,
	[IsWithoutIntimation] BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[OriginalCreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[OriginalCreatedDateTime] DATETIME NOT NULL,
    CONSTRAINT [PK_MasterLeaveType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO