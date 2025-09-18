CREATE  TABLE [dbo].[PayPolicy](
	[Id] [uniqueidentifier] NOT NULL,
	[PolicyName] [nvarchar](250) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[IsEnabled] [bit] NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayPolicy] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO
ALTER TABLE [dbo].[PayPolicy]  WITH CHECK ADD  CONSTRAINT [FK_PayPolicy_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayPolicy] CHECK CONSTRAINT [FK_PayPolicy_User_CreatedByUserId]
GO

ALTER TABLE [dbo].[PayPolicy]  WITH CHECK ADD  CONSTRAINT [FK_PayPolicy_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayPolicy] CHECK CONSTRAINT [FK_PayPolicy_User_UpdatedByUserId]
GO