CREATE TABLE [dbo].[FormAccessibility]
(
	Id UNIQUEIDENTIFIER NOT NULL,
	[FormId] [uniqueidentifier] NOT NULL,
	[IsAbleToLogin] BIT NULL,
	[IsAbleToPay] BIT NULL,
	[IsAbleToCall] BIT NULL,
	[IsAbleToComment] BIT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] DATETIME NULL,
	[TimeStamp] TimeStamp NOT NULL
CONSTRAINT [PK_FormAccessibility] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80) ON [PRIMARY]
) ON [PRIMARY]
GO


ALTER TABLE [dbo].[FormAccessibility]  WITH NOCHECK ADD  CONSTRAINT [FK_GenericForm_FormAccessibility_FormId] FOREIGN KEY([FormId])
REFERENCES [dbo].[GenericForm] ([Id])
GO

ALTER TABLE [dbo].[FormAccessibility] CHECK CONSTRAINT [FK_GenericForm_FormAccessibility_FormId]
GO

