CREATE TABLE [dbo].[RoomTemperature](
	[Id] [uniqueidentifier] NOT NULL,
	[Date] [datetime] NOT NULL,
	[Temperature] [int] NOT NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_RoomTemperature] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)