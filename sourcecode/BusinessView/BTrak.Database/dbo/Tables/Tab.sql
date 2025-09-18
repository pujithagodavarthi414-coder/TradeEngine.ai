CREATE TABLE [dbo].[Tab](
	[Id] [uniqueidentifier] NULL,
	[Name] [nvarchar](MAX) NULL,
	[ModuleId] [uniqueidentifier] NOT NULL FOREIGN KEY REFERENCES Module(Id),
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[InActiveDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP NULL
)
GO