CREATE TABLE [dbo].[Question](
	[Id] [uniqueidentifier] NOT NULL,
	[CategoryId] [uniqueidentifier] NOT NULL,
	[Question] [nvarchar](500) NOT NULL,
	[Option1] [nvarchar](250) NOT NULL,
	[Option2] [nvarchar](250) NOT NULL,
	[Option3] [nvarchar](250) NOT NULL,
	[Option4] [nvarchar](250) NOT NULL,
	[OptionNo] [int] NULL,
	[MarksAllocated] [float] NOT NULL,
	[CreatedByUserId] [uniqueidentifier] NULL,
	[CreatedDateTime] [datetime] NULL,
	[UpdatedByUserId] [uniqueidentifier] NULL,
	[UpdatedDateTime] [datetime] NULL,
	[TimeStamp] TIMESTAMP,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON), 
    CONSTRAINT [AK_Question_Question] UNIQUE ([Question])
)