CREATE  TABLE [dbo].[PayrollRun](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[BranchId] [uniqueidentifier] NULL,
	PayrollTemplateId [uniqueidentifier] NULL,
	[RunDate] [datetime]  NULL,
	[BankSubmittedFilePointer] [nvarchar](max)  NULL,
	[PayrollStartDate] [datetime]  NULL,
	[PayrollEndDate] [datetime]  NULL,
	TotalEmployees INT,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
    [ChequeDate] DATETIME NULL, 
    [AlphaCode] NVARCHAR(MAX) NULL, 
    [Cheque] NVARCHAR(MAX) NULL, 
    [ChequeNo] NVARCHAR(MAX) NULL, 
    CONSTRAINT [PK_PayrollRun] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO

ALTER TABLE [dbo].[PayrollRun]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRun_User_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRun] CHECK CONSTRAINT [FK_PayrollRun_User_CreatedByUserId]
GO
ALTER TABLE [dbo].[PayrollRun]  WITH CHECK ADD  CONSTRAINT [FK_PayrollRun_User_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[PayrollRun] CHECK CONSTRAINT [FK_PayrollRun_User_UpdatedByUserId]
GO