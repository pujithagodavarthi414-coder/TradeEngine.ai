CREATE TABLE [dbo].[AutomatedWorkFlow]
(
	[Id] UNIQUEIDENTIFIER NOT NULL, 
    [WorkflowName] NVARCHAR(50) NOT NULL, 
    [WorkflowXml] NVARCHAR(MAX) NOT NULL, 
	[WorkFlowTypeId] UNIQUEIDENTIFIER  NULL, 
	[CompanyId] UNIQUEIDENTIFIER  NULL, 
    [CreatedByUserId] UNIQUEIDENTIFIER NOT NULL, 
    [CreatedDateTime] DATETIME NOT NULL, 
    [UpdatedByUserId] UNIQUEIDENTIFIER NULL, 
    [UpdatedDateTime] DATETIME NULL, 
    [InactiveDateTime] DATETIME NULL,
 CONSTRAINT [PK_AutomatedWorkFlow] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[AutomatedWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_AutomatedWorkFlow_User] FOREIGN KEY([CreatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[AutomatedWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_AutomatedWorkFlow_WorkFlowType] FOREIGN KEY([WorkFlowTypeId])
REFERENCES [dbo].[WorkFlowType] ([Id])
GO

ALTER TABLE [dbo].[AutomatedWorkFlow] CHECK CONSTRAINT [FK_AutomatedWorkFlow_User]
GO

ALTER TABLE [dbo].[AutomatedWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_AutomatedWorkFlow_User1] FOREIGN KEY([UpdatedByUserId])
REFERENCES [dbo].[User] ([Id])
GO

ALTER TABLE [dbo].[AutomatedWorkFlow] CHECK CONSTRAINT [FK_AutomatedWorkFlow_User1]
GO

ALTER TABLE [dbo].[AutomatedWorkFlow]  WITH CHECK ADD  CONSTRAINT [FK_AutomatedWorkFlow_Company] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[Company] ([Id])
GO

ALTER TABLE [dbo].[AutomatedWorkFlow] CHECK CONSTRAINT [FK_AutomatedWorkFlow_Company]
GO