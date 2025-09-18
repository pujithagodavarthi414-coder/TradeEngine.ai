CREATE TABLE [dbo].[PayrollInputConfiguration]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[EmployeeId] UNIQUEIDENTIFIER NOT NULL,
	[ReferenceId] UNIQUEIDENTIFIER NOT NULL,
	[CreatedDateTime] DATETIME NOT NULL,
	[CreatedByUserId] UNIQUEIDENTIFIER NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[InactiveDateTime] [datetime] NULL,
	[PayrollInput] DECIMAL(20,2) NULL,
	[RunMonth] DATETIME NOT NULL
CONSTRAINT [PK_PayrollInputConfiguration] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)
GO
