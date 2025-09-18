CREATE TABLE [dbo].[LoginAudit](
	[Id] [uniqueidentifier] NOT NULL,
	[LoggedinUserId] [uniqueidentifier] NOT NULL,
	[IpAddress] [nvarchar](250) NOT NULL,
	[Browser] [nvarchar](250) NOT NULL,
	[LoggedinDateTime] [datetime] NOT NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_LoginAudit] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[LoginAudit]  WITH CHECK ADD  CONSTRAINT [FK_User_LoginAudit_LoggedinUserId] FOREIGN KEY([LoggedinUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[LoginAudit] CHECK CONSTRAINT [FK_User_LoginAudit_LoggedinUserId]