CREATE TABLE [dbo].[ButtonType](
	[Id] [uniqueidentifier] NOT NULL,
	[ButtonTypeName] [nvarchar](250) NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[IsStart] BIT NULL, 
    [IsBreakIn] BIT NULL, 
    [IsFinish] BIT NULL, 
    [IsLunchStart] BIT NULL, 
    [IsLunchEnd] BIT NULL, 
    [BreakOut] BIT NULL, 
    [ButtonCode] NVARCHAR(50) NULL, 
    [ShortName] NVARCHAR(250) NULL, 
    CONSTRAINT [PK_ButtonType] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY], 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ButtonType]  WITH CHECK ADD  CONSTRAINT [FK_Company_ButtonType_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[ButtonType] CHECK CONSTRAINT [FK_Company_ButtonType_CompanyId]
GO

ALTER TABLE [dbo].[ButtonType]  WITH CHECK ADD  CONSTRAINT [FK_User_ButtonType_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ButtonType] CHECK CONSTRAINT [FK_User_ButtonType_CreatedByUserId]
GO

CREATE NONCLUSTERED INDEX [IX_ButtonType_CompanyId]
ON [dbo].[ButtonType] ([CompanyId])
GO