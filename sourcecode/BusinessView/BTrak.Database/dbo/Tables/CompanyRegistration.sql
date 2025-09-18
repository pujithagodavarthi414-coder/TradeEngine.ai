CREATE TABLE [dbo].[CompanyRegistration]
(
    [Id] [uniqueidentifier] NOT NULL,	
	[Name] [nvarchar](250) NULL,
	[Email] [nvarchar](250) NULL,
	[VerificationCode] [int] NULL,
	[SiteAddress] [nvarchar](500) NULL,
	[IsVerified] BIT NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_CompanyRegistration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)
GO
