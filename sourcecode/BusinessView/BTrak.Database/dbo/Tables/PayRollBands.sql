CREATE TABLE [dbo].[PayRollBands]
( 
 [Id] [uniqueidentifier] NOT NULL PRIMARY KEY,
 [Name] [nvarchar](250) NULL,
 [FromRange] [decimal](18, 4) NULL,
 [ToRange] [decimal](18, 4) NULL,
 [Percentage] [decimal](10, 4) NULL,
 [ActiveFrom] [datetime] NULL,
 [ActiveTo] [datetime] NULL,
 [ParentId] [uniqueidentifier] NULL,
 [CountryId] [uniqueidentifier] NULL,
 [PayRollComponentId] [uniqueidentifier] NULL,
 [MinAge] [int] NULL,
 [MaxAge] [int] NULL,
 [ForMale] [bit] NULL,
 [ForFemale] [bit] NULL,
 [Handicapped] [bit] NULL,
 [Order] [int] NULL,
 IsMarried [bit] NULL,
 [CreatedDateTime] [datetime] NOT NULL,
 [CreatedByUserId] [uniqueidentifier] NOT NULL,
 [UpdatedDateTime] [datetime] NULL,
 [UpdatedByUserId] [uniqueidentifier] NULL,
 [InactiveDateTime] [datetime] NULL,
 [TimeStamp] TIMESTAMP,
)
GO
ALTER TABLE [dbo].[PayRollBands]  WITH CHECK ADD  CONSTRAINT [FK_PayRollBands_PayRollBands_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[PayRollBands] ([Id])
GO

ALTER TABLE [dbo].[PayRollBands] CHECK CONSTRAINT [FK_PayRollBands_PayRollBands_ParentId]
GO
ALTER TABLE [dbo].[PayRollBands]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollBands_Country_CountryId] FOREIGN KEY([CountryId])
REFERENCES [dbo].[Country] ([Id])
GO
ALTER TABLE [dbo].[PayRollBands] CHECK CONSTRAINT [FK_PayRollBands_Country_CountryId]
GO
ALTER TABLE [dbo].[PayRollBands]  WITH NOCHECK ADD CONSTRAINT [FK_PayRollBands_PayRollComponent_PayRollComponentId] FOREIGN KEY([PayRollComponentId])
REFERENCES [dbo].[PayRollComponent] ([Id])
GO
ALTER TABLE [dbo].[PayRollBands] CHECK CONSTRAINT [FK_PayRollBands_PayRollComponent_PayRollComponentId]
GO