CREATE TABLE [dbo].[BoardTypeWorkFlow](
	[Id] [uniqueidentifier] NOT NULL,
	[BoardTypeId] [uniqueidentifier] NULL,
	[WorkFlowId] [uniqueidentifier] NULL,
	[CreatedDateTime] DATETIMEOFFSET NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIMEOFFSET NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_BoardTypeWorkFlow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO
ALTER TABLE [dbo].[BoardTypeWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_BoardTypeWorkFlow_BoardType_BoardTypeId] FOREIGN KEY([BoardTypeId])
REFERENCES [dbo].[BoardType] ([Id])
GO
ALTER TABLE [dbo].[BoardTypeWorkFlow] CHECK CONSTRAINT [FK_BoardTypeWorkFlow_BoardType_BoardTypeId]
GO
ALTER TABLE [dbo].[BoardTypeWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_BoardTypeWorkFlow_WorkFlow_WorkFlowId] FOREIGN KEY([WorkFlowId])
REFERENCES [dbo].[WorkFlow] ([Id])
GO
ALTER TABLE [dbo].[BoardTypeWorkFlow] CHECK CONSTRAINT [FK_BoardTypeWorkFlow_WorkFlow_WorkFlowId]
GO

CREATE NONCLUSTERED INDEX IX_BoardTypeWorkFlow_BoardTypeId
ON [dbo].[BoardTypeWorkFlow] ([BoardTypeId])
INCLUDE ([WorkFlowId])
GO