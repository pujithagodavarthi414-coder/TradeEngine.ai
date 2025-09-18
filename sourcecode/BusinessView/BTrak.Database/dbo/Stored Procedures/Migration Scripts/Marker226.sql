CREATE PROCEDURE [dbo].[Marker226]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
DECLARE @DefaultUserId UNIQUEIDENTIFIER = NULL
        
        SET @DefaultUserId = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')

		IF(@DefaultUserId IS NOT NULL)
		BEGIN

   MERGE INTO [dbo].[ReferenceType] AS Target 
        USING (VALUES 
        		(N'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6','Evidence upload',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId,NULL,NULL,NULL),
        		(N'6A752767-347B-4E6C-8F73-4E3FA9BF0ACC','Conducts evidence upload',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId,NULL,NULL,NULL),
        		(N'D8C4322A-7041-473A-A4B1-3608B260A5B7','Audit questions evidence upload',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId,NULL,NULL,NULL),
				(N'98A3A24D-BE04-4A12-8E48-73648A0507FB','Audits evidence upload',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId,NULL,NULL,NULL),
        		(N'C6BA92FE-B4A5-4082-B513-9FDCA29610B8','Conducts questions evidence upload',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId,NULL,NULL,NULL)
        ) 
        AS Source ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
        ON Target.[ReferenceTypeName] = Source.[ReferenceTypeName]
        WHEN MATCHED THEN 
        UPDATE SET [Id] = Source.[Id],
                   [ReferenceTypeName] = Source.[ReferenceTypeName],
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CreatedByUserId] = Source.[CreatedByUserId],
                   [UpdatedDateTime] = Source.[UpdatedDateTime],
                   [UpdatedByUserId] = Source.[UpdatedByUserId],
                   [InActiveDateTime] = Source.[InActiveDateTime]
        WHEN NOT MATCHED BY TARGET THEN 
        INSERT ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) VALUES ([Id],[ReferenceTypeName],[CreatedDateTime],[CreatedByUserId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

MERGE INTO [dbo].[AutomatedWorkFlow] AS Target 
	USING (VALUES
	(NEWID(),'Upload evidence',N'<?xml version="1.0" encoding="UTF-8"?> <bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1" targetNamespace="http://bpmn.io/schema/bpmn"><bpmn:process id="Upload_evidence" name="Upload evidence" isExecutable="true"><bpmn:startEvent id="StartEvent_1"><bpmn:outgoing>Flow_1yptj9k</bpmn:outgoing></bpmn:startEvent><bpmn:sequenceFlow id="Flow_1yptj9k" sourceRef="StartEvent_1" targetRef="Activity_16sylk6" /><bpmn:endEvent id="Event_0bw34e3"><bpmn:incoming>Flow_10si3w3</bpmn:incoming></bpmn:endEvent><bpmn:sequenceFlow id="Flow_10si3w3" sourceRef="Activity_16sylk6" targetRef="Event_0bw34e3" /><bpmn:serviceTask id="Activity_16sylk6" name="adhoc-update" camunda:type="external" camunda:topic="adhoc-userstory"><bpmn:extensionElements><camunda:inputOutput><camunda:inputParameter name="responsibleUser">sreevathsav.gorantla@kothapalli.co.uk</camunda:inputParameter><camunda:inputParameter name="spanInDays">2</camunda:inputParameter></camunda:inputOutput></bpmn:extensionElements><bpmn:incoming>Flow_1yptj9k</bpmn:incoming><bpmn:outgoing>Flow_10si3w3</bpmn:outgoing></bpmn:serviceTask></bpmn:process><bpmndi:BPMNDiagram id="BPMNDiagram_1"><bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="Upload_evidence"><bpmndi:BPMNEdge id="Flow_10si3w3_di" bpmnElement="Flow_10si3w3"><di:waypoint x="360" y="120" /><di:waypoint x="412" y="120" /></bpmndi:BPMNEdge><bpmndi:BPMNEdge id="Flow_1yptj9k_di" bpmnElement="Flow_1yptj9k"><di:waypoint x="209" y="120" /><di:waypoint x="260" y="120" /></bpmndi:BPMNEdge><bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1"><dc:Bounds x="173" y="102" width="36" height="36" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Event_0bw34e3_di" bpmnElement="Event_0bw34e3"><dc:Bounds x="412" y="102" width="36" height="36" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Activity_1wap7lo_di" bpmnElement="Activity_16sylk6"><dc:Bounds x="260" y="80" width="100" height="80" /></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></bpmn:definitions>
	',@CompanyId,CAST(N'2018-03-01T00:00:00.000' AS DateTime), @UserId)
	)
	AS Source ([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId])
	ON Target.[WorkflowName] = Source.[WorkflowName] AND Target.CompanyId = SOURCE.CompanyId  
	WHEN MATCHED THEN 
	UPDATE SET [Id] = Source.[Id],
	           [WorkflowName] = Source.[WorkflowName],
	           [WorkflowXml] = Source.[WorkflowXml],
	           [CompanyId] = Source.[CompanyId],
	           [CreatedDateTime] = Source.[CreatedDateTime],
	           [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId]) VALUES ([Id],[WorkflowName],[WorkflowXml],[CompanyId],[CreatedDateTime],[CreatedByUserId]);
	
	MERGE INTO [dbo].[WorkflowTrigger] AS Target 
        USING (VALUES
          (NEWID(),(SELECT Id FROM [Trigger] WHERE TriggerName = 'DocumentsUploadTrigger'),(SELECT Id FROM [AutomatedWorkFlow] WHERE [WorkflowName] = 'Upload evidence' AND CompanyId = @CompanyId),'BFB5614F-34DE-45C2-AEDA-A2B387FA35C6',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId)
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
END
GO
