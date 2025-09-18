CREATE TABLE [dbo].[ProcedureName]
(
	[Id] [uniqueidentifier] NOT NULL,
	[ActionPath] [nvarchar](800) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LookupKey] [int] NULL,
	[AccessAll] [bit] NOT NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Procedure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON))
GO
ALTER TABLE [dbo].[ProcedureName]  WITH CHECK ADD  CONSTRAINT [FK_User_Procedure_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Procedure] CHECK CONSTRAINT [FK_User_Procedure_CreatedByUserId]