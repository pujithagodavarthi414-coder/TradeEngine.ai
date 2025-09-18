CREATE TABLE [dbo].[GenericForms]
(
	[Id] [uniqueidentifier] NULL,
	[FormTypeId] [uniqueidentifier] NULL,
	[FormType] [nvarchar](100) NULL,
	[FormName] [nvarchar](max) NULL,
	[FormJson] [nvarchar](max) NULL,
	[CreatedOn] [datetime] NULL,
	[UpdatedOn] [datetime] NULL,
	[IsArchived] [BIT] NULL,
	[TimeStamp] TIMESTAMP,
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
