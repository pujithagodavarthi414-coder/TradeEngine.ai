CREATE TABLE [dbo].[ResignationStatus](
	[Id] [uniqueidentifier] NOT NULL,
	[StatusName]  [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsApproved] BIT NULL, 
    [IsRejected] BIT NULL, 
    [IsWaitingForApproval] BIT NULL, 
    [ResignationStatusColour] NVARCHAR(50) NULL,
    CONSTRAINT [PK_ResignationStatus] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO