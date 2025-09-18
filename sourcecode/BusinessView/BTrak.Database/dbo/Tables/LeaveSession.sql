CREATE TABLE [dbo].[LeaveSession](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier]  NULL,
	[LeaveSessionName] [nvarchar](800) NULL,
	[IsFullDay] [BIT] NULL,
	[IsSecondHalf] [BIT] NULL,
	[IsFirstHalf] [BIT] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedByUserId] UNIQUEIDENTIFIER NULL,
	[UpdatedDateTime] DATETIME NULL,
    [InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_LeaveSession] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO