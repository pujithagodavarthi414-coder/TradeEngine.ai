﻿CREATE TABLE [dbo].[ApiResourceProperties]
(
	[Id] UNIQUEIDENTIFIER NOT NULL,
	[Key] NVARCHAR(250) NOT NULL,
	[Value] NVARCHAR(250) NOT NULL,
	ApiResourceId INT,
	CONSTRAINT [PK_ApiResourceProperties] PRIMARY KEY CLUSTERED 
	(
		[Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
)
GO

ALTER TABLE [dbo].[ApiResourceProperties]  WITH NOCHECK ADD  CONSTRAINT [FK_ApiResourceProperties_ApiResources_ApiResourceId] FOREIGN KEY([ApiResourceId])
REFERENCES [dbo].[ApiResources] ([Id])
GO