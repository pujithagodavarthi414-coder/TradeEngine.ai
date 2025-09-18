CREATE TABLE [dbo].[MasterAccounts]
(
	[Id] [uniqueidentifier] NOT NULL,
	[Account] [nvarchar](250) NOT  NULL,
	[ClassNo] Int NULL,
	[ClassNoF] Int NULL,
	[Class]  [nvarchar](250) NULL,
	[ClassF]  [nvarchar](250) NULL,
	[Group]  [nvarchar](250) NULL,
	[GroupF]  [nvarchar](250) NULL,
	[SubGroup]  [nvarchar](250) NULL,
	[SubGroupF]  [nvarchar](250) NULL,
	[AccountNo] Int NULL,
	[AccountNoF] Int NULL,
	[Compte]  [nvarchar](250) NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NOT NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_MasterAccount] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
)
GO