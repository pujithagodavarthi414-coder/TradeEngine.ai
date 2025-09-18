CREATE TABLE [dbo].[Room](
    [Id] [uniqueidentifier] NOT NULL,
    [VenueId] [uniqueidentifier] NOT NULL,
    [Name] [nvarchar](255) NOT NULL,
    [ImageJson] [nvarchar](800) NULL,
    [Description] [nvarchar](max) NULL,
	[Town][nvarchar](255) NULL,
	[Locality][nvarchar](255) NULL,
    [AddressJson] [nvarchar](max) NULL,
    [Video][nvarchar](800) NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL, 
    [TimeStamp] [timestamp] NULL,
    CONSTRAINT [PK_Room] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
 ALTER TABLE [dbo].[Room] WITH CHECK ADD CONSTRAINT [FK_Venue_Room_VenueId] FOREIGN KEY([VenueId])
REFERENCES [dbo].[Venue] ([Id])
GO