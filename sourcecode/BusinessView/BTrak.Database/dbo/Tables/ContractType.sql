CREATE TABLE [dbo].[ContractType]
(
	[Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [ContractTypeName] [nvarchar](500) NOT NULL,
    [IsActive] [bit] NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [TimeStamp] TIMESTAMP,
	[TerminationDate] [datetime] NULL,
	[TerminationReason] [nvarchar](800) NULL
)
GO