CREATE  TABLE [dbo].[RoomAmenity](
    [Id] [uniqueidentifier] NOT NULL,
    [RoomId] [uniqueidentifier] NOT NULL,
    [AmenityId] [uniqueidentifier] NOT NULL,
    [Price] [decimal](15,3) NULL,
    [Description] [nvarchar](max) NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL, 
    [TimeStamp] [timestamp] NULL, 
    CONSTRAINT [PK_RoomAmenity] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

 ALTER TABLE [dbo].[RoomAmenity] WITH CHECK ADD CONSTRAINT [FK_Room_RoomAmenity_RoomId] FOREIGN KEY([RoomId])
REFERENCES [dbo].[Room] ([Id])
GO

 ALTER TABLE [dbo].[RoomAmenity] WITH CHECK ADD CONSTRAINT [FK_Amenity_RoomAmenity_AmenityId] FOREIGN KEY([AmenityId])
REFERENCES [dbo].[Amenity] ([Id])
GO