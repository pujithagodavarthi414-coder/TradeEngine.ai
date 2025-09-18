CREATE TABLE [dbo].[TaskStatus](
    [Id] [uniqueidentifier] NOT NULL,
    [TaskStatusName] [nvarchar](250) NOT NULL,
    [CreatedDateTime] DATETIMEOFFSET NOT NULL,
    [CreatedByUserId] [uniqueidentifier] NOT NULL,    
    [Order] INT NULL, 
    CONSTRAINT [PK_TaskStatus] PRIMARY KEY CLUSTERED 
(
    [Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),   
)
GO