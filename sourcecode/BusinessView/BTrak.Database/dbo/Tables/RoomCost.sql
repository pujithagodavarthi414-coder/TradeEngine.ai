CREATE TABLE [dbo].[RoomCost]
(
[Id]  [uniqueidentifier] NOT NULL,
[RoomId]  [uniqueidentifier] NOT NULL,
[Cost] [decimal](10,3) NOT NULL,
[Tax]  [decimal](10,3) NOT NULL,
[DepositAmount] [decimal](10,3) NOT NULL,
[CreatedByUserId] [uniqueidentifier] NOT NULL,
[CreatedDateTime] [datetime] NOT NULL,
[UpdatedByUserId] [uniqueidentifier] NULL,
[UpdatedDateTime] [datetime] NULL,
[InActiveDateTime] [datetime] NULL,
[TimeStamp] [timestamp] NULL,
CONSTRAINT [PK_RoomCost] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] 
Go
ALTER TABLE [dbo].[RoomCost]  WITH CHECK ADD  CONSTRAINT [FK_Room_RoomCost_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO
ALTER TABLE [dbo].[RoomCost] CHECK CONSTRAINT [FK_Room_RoomCost_RoomId]
GO