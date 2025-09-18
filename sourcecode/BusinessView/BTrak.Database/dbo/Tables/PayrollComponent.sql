CREATE TABLE [dbo].[PayrollComponent](
	[Id] [uniqueidentifier] NOT NULL,
	[ComponentName] [nvarchar](250) NOT NULL,
	[CompanyId] [uniqueidentifier] NOT NULL,
	[IsDeduction] [bit] NOT NULL DEFAULT 0,
	[IsVariablePay] [bit] NOT NULL DEFAULT 0,
	[EmployeeContributionPercentage] DECIMAL(18,4) NULL,
    [EmployerContributionPercentage] DECIMAL(18,4) NULL,
	[IsVisible] [bit] NULL DEFAULT 1,
	[RelatedToContributionPercentage] [bit] NULL DEFAULT 0,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[IsBands] [bit] NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_PayrollComponent] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO