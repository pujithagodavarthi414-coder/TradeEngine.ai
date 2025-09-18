CREATE TABLE [dbo].[MessageReadReceipt]
(
    [Id] UNIQUEIDENTIFIER NOT NULL,
    MessageId UNIQUEIDENTIFIER NOT NULL,
    ReceiverUserId UNIQUEIDENTIFIER NOT NULL,
    SenderUserId UNIQUEIDENTIFIER NOT NULL,
	ReadDateTime DATETIME NULL,
    DeliveredDateTime DATETIME NULL,
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] DATETIMEOFFSET NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    [IsChannel] BIT NOT NULL, 
    CONSTRAINT [PK_MessageReadReceipt] PRIMARY KEY ([Id]),
)
GO