CREATE TABLE [dbo].[College](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[CoutryId] [uniqueidentifier] NOT NULL,
	[StateId] [uniqueidentifier] NOT NULL,
	[CollegeName] [nvarchar](250) NOT NULL,
	[City] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_College] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_College_CompanyId_CoutryId_StateId_CollegeName_City] UNIQUE ([CompanyId], [CoutryId], [StateId], [City], [CollegeName])
)
GO
ALTER TABLE [dbo].[College]  WITH CHECK ADD  CONSTRAINT [FK_College_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[College] CHECK CONSTRAINT [FK_College_State_StateId]
GO