CREATE PROCEDURE [dbo].[Marker230]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DELETE FROM [WorkflowTrigger] WHERE [WorkflowId] = '667ADD06-189B-4022-9264-4294706E335B'

        MERGE INTO [dbo].[WorkflowTrigger] AS Target 
        USING (VALUES
          (NEWID(),(SELECT Id FROM [Trigger] WHERE TriggerName = 'DocumentsUploadTrigger'),(SELECT Id FROM [AutomatedWorkFlow] WHERE [WorkflowName] = 'Upload evidence' AND CompanyId = @CompanyId),'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
         )
        AS Source ([Id],[TriggerId],[WorkflowId],[RefereceTypeId],[CreatedDateTime],[CreatedByUserId])
        ON Target.TriggerId = Source.TriggerId AND Target.[WorkflowId] = Source.[WorkflowId] AND Target.[RefereceTypeId] = Source.[RefereceTypeId]
        WHEN MATCHED THEN 
        UPDATE SET [Id] = Source.[Id],
                   [TriggerId] = Source.[TriggerId],
                   [WorkflowId] = Source.[WorkflowId],
                   [RefereceTypeId] = Source.[RefereceTypeId],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT([Id],[TriggerId],[WorkflowId],[RefereceTypeId],[CreatedByUserId],[CreatedDateTime]) VALUES ([Id],[TriggerId],[WorkflowId],[RefereceTypeId],[CreatedByUserId],[CreatedDateTime]);
END    
GO