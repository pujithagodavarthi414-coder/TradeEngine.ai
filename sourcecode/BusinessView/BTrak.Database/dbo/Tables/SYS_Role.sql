CREATE TABLE [dbo].[SYS_Role](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](800) NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
    [IsDeveloper] BIT NULL, 
    [IsAdministrator] BIT NULL, 
	[TimeStamp] TIMESTAMP,
    [InactiveDateTime] DATETIME NULL
    CONSTRAINT [PK_SYS_Role] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
   
)