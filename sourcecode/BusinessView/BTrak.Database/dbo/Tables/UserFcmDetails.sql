CREATE TABLE [dbo].[UserFcmDetails](
	[Id] [uniqueidentifier] NOT NULL,
	[UserId] [nvarchar](max) NOT NULL,
	[FcmToken] [nvarchar](max) NOT NULL,
	[DeviceUniqueId] [nvarchar](max) NULL,
	[IsDelete] [bit] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [IsFromBTrakMobile] BIT NULL, 
    [TimeStamp] TIMESTAMP,
    CONSTRAINT [PK_UserFcmDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
