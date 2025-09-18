CREATE TABLE [dbo].[Channel](
	[Id] [uniqueidentifier] NOT NULL,
	[CompanyId] [uniqueidentifier] NULL,
	[ChannelName] [nvarchar](100) NOT NULL,
	[IsDeleted] [bit] NULL,
	[ChannelImage] [nvarchar](800) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
	[ProjectId] [uniqueidentifier] NULL,
	[LastMessageDateTime] [datetime] NULL,
	[CurrentOwnerShipId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO


