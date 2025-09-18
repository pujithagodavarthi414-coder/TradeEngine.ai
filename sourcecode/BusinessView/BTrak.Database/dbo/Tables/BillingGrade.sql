CREATE TABLE [dbo].[BillingGrade]
(
	[Id] [uniqueidentifier] NOT NULL,
	[GradeName] [nvarchar](250)  NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP, 
    [ProductId] UNIQUEIDENTIFIER NOT NULL, 
    [GstCode] NVARCHAR(50) NOT NULL,    
	CONSTRAINT [PK_BillingGrade] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)
)
GO
