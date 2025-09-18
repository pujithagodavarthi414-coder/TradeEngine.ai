CREATE TABLE [dbo].[PayrollTemplate](
	[Id] [uniqueidentifier] NOT NULL,
	[PayrollName] [nvarchar](250) NOT NULL,
	[PayrollShortName] [nvarchar](250) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[IsRepeatInfinitly] [bit] NULL DEFAULT 0,
	[IslastWorkingDay] [bit] NULL DEFAULT 0,
	[FrequencyId] [uniqueidentifier] NULL,	
    [CurrencyId] [uniqueidentifier] NULL,
	[InfinitlyRunDate] [datetime] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[JobId] BIGINT, 
    CONSTRAINT [PK_PayrollTemplate] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollTemplate]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplate_PayFrequency_FrequencyId] FOREIGN KEY([FrequencyId])
REFERENCES [dbo].[PayFrequency] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplate] CHECK CONSTRAINT [FK_PayrollTemplate_PayFrequency_FrequencyId]
GO

ALTER TABLE [dbo].[PayrollTemplate]  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplate_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplate] CHECK CONSTRAINT [FK_PayrollTemplate_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollTemplate]  WITH CHECK ADD  CONSTRAINT [FK_PayrollTemplate_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplate] CHECK CONSTRAINT [FK_PayrollTemplate_User_UpdatedByUserId]
GO
ALTER TABLE [dbo].[PayrollTemplate]  WITH NOCHECK ADD CONSTRAINT [FK_PayrollTemplate_SYS_Currency_CurrencyId] FOREIGN KEY([CurrencyId])
REFERENCES [dbo].[SYS_Currency] ([Id])
GO

ALTER TABLE [dbo].[PayrollTemplate] CHECK CONSTRAINT [FK_PayrollTemplate_SYS_Currency_CurrencyId]
GO