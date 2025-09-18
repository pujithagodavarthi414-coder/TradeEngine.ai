CREATE TABLE [dbo].[ClientHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[ClientId] [uniqueidentifier] NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[OldValue] [nvarchar](500) NULL,
	[NewValue] [nvarchar](500) NULL,
	[FieldName] [nvarchar](150) NULL,
	[Description] [nvarchar](800) NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[TimeStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_ClientHistory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ClientHistory] WITH CHECK ADD CONSTRAINT [FK_Client_ClientHistory_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Client] ([Id])
GO

ALTER TABLE [dbo].[ClientHistory] CHECK CONSTRAINT [FK_Client_ClientHistory_ClientId]
GO
