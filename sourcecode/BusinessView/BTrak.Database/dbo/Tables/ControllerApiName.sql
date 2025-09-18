CREATE TABLE [dbo].[ControllerApiName](
	[Id] [uniqueidentifier] NOT NULL,
	[ActionPath] [nvarchar](800) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[AccessAll] [bit] NOT NULL DEFAULT 0,
	[LookUpKey] [INT] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
	[InactiveDateTime] [datetime] NULL,
 CONSTRAINT [PK_ControllerApiName] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON))
GO
ALTER TABLE [dbo].[ControllerApiName]  WITH CHECK ADD  CONSTRAINT [FK_User_ControllerApiName_CreatedByUserId] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiName] CHECK CONSTRAINT [FK_User_ControllerApiName_CreatedByUserId]
GO
ALTER TABLE [dbo].[ControllerApiName]  WITH CHECK ADD  CONSTRAINT [FK_User_ControllerApiName_UpdatedByUserId] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[ControllerApiName] CHECK CONSTRAINT [FK_User_ControllerApiName_UpdatedByUserId]
GO

CREATE NONCLUSTERED INDEX IX_ControllerApiName_ActionPath 
ON [dbo].[ControllerApiName] (  ActionPath ASC  )   
INCLUDE ( AccessAll )  
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO