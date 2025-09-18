CREATE TABLE [dbo].[LogTimeOption]
(
	[Id] [uniqueidentifier] NOT NULL,
	[LogTimeOption] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [IsSetTo] BIT NULL, 
    [IsUseExistingEstimateHours] BIT NULL, 
    [IsAdjustAutomatically] BIT NULL, 
    [IsReduceBy] BIT NULL, 
    [InactiveDateTime] DATETIME NULL, 
	[TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_LogTimeOption] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) 
)
GO