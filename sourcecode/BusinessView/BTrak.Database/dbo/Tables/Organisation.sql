CREATE TABLE [dbo].[Organisation](
    [Id] [uniqueidentifier] NOT NULL,
    [CompanyId] [uniqueidentifier] NOT NULL,
    [Name] [nvarchar](255) NOT NULL,
    [Description] [nvarchar](max) NULL,
	[Town][nvarchar](255) NULL,
	[Locality][nvarchar](255) NULL,
    [AddressJson] [nvarchar](max) NULL, 
    [Telephone] [nvarchar](50) NULL, 
    [ImageJson] [nvarchar](max) NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CreatedDateTime] [datetime] NOT NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
    [UpdatedDateTime] [datetime] NULL,
    [InActiveDateTime] [datetime] NULL, 
    [TimeStamp] [timestamp] NULL, 
    CONSTRAINT [PK_Organisation] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Organisation] WITH CHECK ADD CONSTRAINT [FK_Company_Organisation_VenueId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
Go