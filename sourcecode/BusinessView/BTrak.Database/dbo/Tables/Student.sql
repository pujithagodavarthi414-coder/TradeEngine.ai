CREATE TABLE [dbo].[Student](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](250) NOT NULL,
	[RollNo] [nvarchar](250) NOT NULL,
	[EmailId] [nvarchar](250) NOT NULL,
	[Password] [nvarchar](250) NOT NULL,
	[MobileNo] [nvarchar](250) NOT NULL,
	[City] [nvarchar](250) NOT NULL,
	[CoutryId] [uniqueidentifier] NOT NULL,
	[StateId] [uniqueidentifier] NOT NULL,
	[DateOfBirth] [date] NOT NULL,
	[GenderId] [uniqueidentifier] NOT NULL,
	[Address] [nvarchar](800) NOT NULL,
	[CollegeId] [uniqueidentifier] NOT NULL,
	[StreamId] [uniqueidentifier] NOT NULL,
	[BtechPercentage] [float] NOT NULL,
	[InterPercentage] [float] NOT NULL,
	[TenthPercentage] [float] NOT NULL,
	[YearOfCompletion] [date] NOT NULL,
	[ProfileImage] [nvarchar](250) NULL,
	[ResumePath] [nvarchar](250) NOT NULL,
	[CreatedDateTime] [datetime] NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[UpadatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[FinalMarks] [float] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Student] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)
GO
ALTER TABLE [dbo].[Student]  WITH NOCHECK ADD  CONSTRAINT [FK_Student_State_StateId] FOREIGN KEY([StateId])
REFERENCES [dbo].[Country] ([Id])
GO

ALTER TABLE [dbo].[Student] CHECK CONSTRAINT [FK_Student_State_StateId]
GO