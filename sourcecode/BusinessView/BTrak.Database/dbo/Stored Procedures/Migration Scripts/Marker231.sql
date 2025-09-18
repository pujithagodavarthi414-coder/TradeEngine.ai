CREATE PROCEDURE [dbo].[Marker231]
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

MERGE INTO [dbo].[AutomatedWorkFlow] AS Target 
	USING (VALUES
	(NEWID(),'Generic mail',N'<?xml version="1.0" encoding="UTF-8"?>
<bpmn:definitions xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:bpmn="http://www.omg.org/spec/BPMN/20100524/MODEL" xmlns:bpmndi="http://www.omg.org/spec/BPMN/20100524/DI" xmlns:dc="http://www.omg.org/spec/DD/20100524/DC" xmlns:camunda="http://camunda.org/schema/1.0/bpmn" xmlns:di="http://www.omg.org/spec/DD/20100524/DI" id="Definitions_1" targetNamespace="http://bpmn.io/schema/bpmn"><bpmn:process id="genmail" name="gen mail" isExecutable="true"><bpmn:startEvent id="StartEvent_1"><bpmn:outgoing>Flow_11b98fm</bpmn:outgoing></bpmn:startEvent><bpmn:sequenceFlow id="Flow_11b98fm" sourceRef="StartEvent_1" targetRef="Activity_1swcocc" /><bpmn:serviceTask id="Activity_1swcocc" name="mail" camunda:type="external" camunda:topic="notification-activity"><bpmn:extensionElements><camunda:inputOutput><camunda:inputParameter name="message">Created ${name}</camunda:inputParameter><camunda:inputParameter name="responsibleUser">srihari@kothapalli.co.uk</camunda:inputParameter></camunda:inputOutput></bpmn:extensionElements><bpmn:incoming>Flow_11b98fm</bpmn:incoming><bpmn:outgoing>Flow_17ias8z</bpmn:outgoing></bpmn:serviceTask><bpmn:endEvent id="Event_0hyqz6x"><bpmn:incoming>Flow_17ias8z</bpmn:incoming></bpmn:endEvent><bpmn:sequenceFlow id="Flow_17ias8z" sourceRef="Activity_1swcocc" targetRef="Event_0hyqz6x" /></bpmn:process><bpmndi:BPMNDiagram id="BPMNDiagram_1"><bpmndi:BPMNPlane id="BPMNPlane_1" bpmnElement="genmail"><bpmndi:BPMNEdge id="Flow_17ias8z_di" bpmnElement="Flow_17ias8z"><di:waypoint x="360" y="120" /><di:waypoint x="412" y="120" /></bpmndi:BPMNEdge><bpmndi:BPMNEdge id="Flow_11b98fm_di" bpmnElement="Flow_11b98fm"><di:waypoint x="209" y="120" /><di:waypoint x="260" y="120" /></bpmndi:BPMNEdge><bpmndi:BPMNShape id="_BPMNShape_StartEvent_2" bpmnElement="StartEvent_1"><dc:Bounds x="173" y="102" width="36" height="36" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Activity_1b1lnic_di" bpmnElement="Activity_1swcocc"><dc:Bounds x="260" y="80" width="100" height="80" /></bpmndi:BPMNShape><bpmndi:BPMNShape id="Event_0hyqz6x_di" bpmnElement="Event_0hyqz6x"><dc:Bounds x="412" y="102" width="36" height="36" /></bpmndi:BPMNShape></bpmndi:BPMNPlane></bpmndi:BPMNDiagram></bpmn:definitions>
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
          (NEWID(),'2FF09EB8-DB74-4719-BDB6-D7A42426F53F',(SELECT Id FROM [AutomatedWorkFlow] WHERE [WorkflowName] = 'Generic mail' AND CompanyId = @CompanyId),'733C033C-F047-4907-A741-88E9F3090F85',CAST(N'2018-03-01T00:00:00.000' AS DateTime), @DefaultUserId)
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



