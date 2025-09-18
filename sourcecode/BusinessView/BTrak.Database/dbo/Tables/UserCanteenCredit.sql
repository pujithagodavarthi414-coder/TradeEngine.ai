CREATE TABLE [dbo].[UserCanteenCredit](
	[Id] [uniqueidentifier] NOT NULL,
	[CreditedToUserId] [uniqueidentifier] NOT NULL,
	[CreditedByUserId] [uniqueidentifier] NOT NULL,
	[Amount] [money] NOT NULL,
	[IsOffered] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[InActiveDateTime] [datetime] NULL,
	[CurrencyId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_UserCanteenCredit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[UserCanteenCredit]  WITH CHECK ADD  CONSTRAINT [FK_User_UserCanteenCredit_CreditedToUserId] FOREIGN KEY([CreditedToUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserCanteenCredit] CHECK CONSTRAINT [FK_User_UserCanteenCredit_CreditedToUserId]
GO

ALTER TABLE [dbo].[UserCanteenCredit]  WITH CHECK ADD  CONSTRAINT [FK_User_UserCanteenCredit_CreditedByUserId] FOREIGN KEY([CreditedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[UserCanteenCredit] CHECK CONSTRAINT [FK_User_UserCanteenCredit_CreditedByUserId]
GO

CREATE NONCLUSTERED INDEX IX_UserCanteenCredit_CreaditedToUser 
ON [dbo].[UserCanteenCredit] (  CreditedToUserId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO