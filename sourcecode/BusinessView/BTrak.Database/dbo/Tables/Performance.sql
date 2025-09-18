CREATE TABLE [dbo].[Performance]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [ConfigurationId] UNIQUEIDENTIFIER NOT NULL, 
    [FormData] NVARCHAR(MAX) NOT NULL, 
    [IsDraft] BIT NOT NULL, 
    [IsSubmitted] BIT NOT NULL, 
    [IsApproved] BIT NULL, 
    [ApprovedBy] UNIQUEIDENTIFIER NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDatetime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDatetime] DATETIME NULL,
    [SubmitedDatetime] DATETIME NULL,
    [ApprovedDatetime] DATETIME NULL
 CONSTRAINT [PK_Performance] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Performance]  WITH CHECK ADD  CONSTRAINT [FK_Performance_User1] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Performance] CHECK CONSTRAINT [FK_Performance_User1]
GO

ALTER TABLE [dbo].[Performance]  WITH CHECK ADD  CONSTRAINT [FK_Performance_User2] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[Performance] CHECK CONSTRAINT [FK_Performance_User2]
GO
