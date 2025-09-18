CREATE  TABLE [dbo].[VenueAmenity](
    [Id] [uniqueidentifier] NOT NULL,
    [VenueId] [uniqueidentifier] NOT NULL,
    [AmenityId] [uniqueidentifier] NOT NULL,
    [Price] [decimal](15,3) NULL,
    [Description] [nvarchar](max) NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL, 
    [TimeStamp] [timestamp] NULL, 
    CONSTRAINT [PK_VenueAmenity] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
 ALTER TABLE [dbo].[VenueAmenity] WITH CHECK ADD CONSTRAINT [FK_Venue_VenueAmenity_VenueId] FOREIGN KEY([VenueId])
REFERENCES [dbo].[Venue] ([Id])
GO

ALTER TABLE [dbo].[VenueAmenity] WITH CHECK ADD CONSTRAINT [FK_Amenity_VenueAmenity_AmenityId] FOREIGN KEY([AmenityId])
REFERENCES [dbo].[Amenity] ([Id])
GO