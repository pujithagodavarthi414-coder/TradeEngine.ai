CREATE TABLE [dbo].[UserCanteenBalanceCredit](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NOT NULL,
	[BalanceCredit] [money] NOT NULL,
	[CreditedDateTime] [datetime] NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserCanteenBalanceCredit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO
ALTER TABLE [dbo].[UserCanteenBalanceCredit]  WITH CHECK ADD  CONSTRAINT [FK_UserCanteenBalanceCredit_User] FOREIGN KEY([UserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserCanteenBalanceCredit] CHECK CONSTRAINT [FK_UserCanteenBalanceCredit_User]
GO

CREATE NONCLUSTERED INDEX IX_UserCanteenBalanceCredit_UserId ON [dbo].[UserCanteenBalanceCredit] (  UserId ASC  )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO