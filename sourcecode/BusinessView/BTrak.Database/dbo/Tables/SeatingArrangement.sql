CREATE TABLE [dbo].[SeatingArrangement](
	[Id] [uniqueidentifier] NOT NULL,
    [BranchId] UNIQUEIDENTIFIER NOT NULL, 
	[EmployeeId] [uniqueidentifier] NULL,
	[SeatCode] [nvarchar](50) NULL,
	[Description] [varchar](800) NULL,
	[Comment] [varchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] DATETIME NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_SeatingArrangement] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [FK_SeatingArrangement_Branch] FOREIGN KEY (BranchId) REFERENCES [Branch]([Id]), 
)
GO
