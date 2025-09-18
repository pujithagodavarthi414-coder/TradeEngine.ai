CREATE TABLE [dbo].[Vessel]
(
	[Id] [uniqueidentifier] NOT NULL,
	[VesselName] [nvarchar](250)  NOT NULL,
	[CreatedDateTime] [datetime] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NOT NULL,
    [CompanyId] UNIQUEIDENTIFIER NULL, 
	[InActiveDateTime] [datetime] NULL,
	[UpdatedDateTime] [datetime] NULL,
    [UpdatedByUserId] [uniqueidentifier] NULL,
	[TimeStamp] TIMESTAMP
)
