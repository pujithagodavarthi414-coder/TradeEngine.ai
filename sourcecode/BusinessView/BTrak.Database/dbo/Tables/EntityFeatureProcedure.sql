CREATE TABLE [dbo].[EntityFeatureProcedure]
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
 CONSTRAINT [PK_EntityFeatureProcedure] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON))
GO
ALTER TABLE [dbo].[EntityFeatureProcedure]  WITH CHECK ADD  CONSTRAINT [FK_User_EntityFeatureProcedure_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[EntityFeatureProcedure] CHECK CONSTRAINT [FK_User_EntityFeatureProcedure_CreatedByUserId]