CREATE TABLE [dbo].[Employee](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [uniqueidentifier] NULL,
	[EmployeeNumber] [nvarchar](250) NULL,
	FormJson NVARCHAR(MAX) NULL,
	[GenderId] [uniqueidentifier] NULL,
	[BranchId] UNIQUEIDENTIFIER NULL,
	[MaritalStatusId] [uniqueidentifier] NULL,
	[MarriageDate] [datetime] NULL,
	[NationalityId] [uniqueidentifier] NULL,
	[BusinessUnitId] [uniqueidentifier] NULL,
	[DateofBirth] [datetime] NULL,
	[Smoker] [bit] NULL,
	[MilitaryService] [bit] NULL,
	[NickName] [nvarchar](50) NULL,
	[TaxCode] [nvarchar](100) NULL,
	[MACAddress][NVARCHAR](50) NULL,
	[TrackEmployee] [bit] NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[IPNumber] [NVARCHAR](50) NULL,
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_Employee] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO

CREATE NONCLUSTERED INDEX IX_Employee_UserId 
ON [dbo].[Employee] (  UserId ASC  )   
WITH (  PAD_INDEX = OFF ,FILLFACTOR = 80   ,SORT_IN_TEMPDB = OFF , IGNORE_DUP_KEY = OFF , STATISTICS_NORECOMPUTE = OFF , DROP_EXISTING = ON , ONLINE = OFF , ALLOW_ROW_LOCKS = ON , ALLOW_PAGE_LOCKS = ON  ) 
ON [PRIMARY] 
GO