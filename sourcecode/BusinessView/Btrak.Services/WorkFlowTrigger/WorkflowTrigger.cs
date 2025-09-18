using System;
using System.Collections.Generic;
using System.Web.Configuration;
using System.Xml;
using BTrak.Common;
using Btrak.Services.WorkflowManagemet;
using CamundaClient;
using RestSharp;

namespace Btrak.Services.WorkFlowTrigger
{
    public class WorkflowTrigger : IWorkFlowTrigger
    {
        private IWorkflowManagementService _workflowManagementService;

        public WorkflowTrigger(IWorkflowManagementService workflowManagementService)
        {
            _workflowManagementService = workflowManagementService;
        }

        public void InvokeTrigger(Guid referenceId, string triggerName, Guid referenceTypeId, LoggedInContext loggedInContext,
            Dictionary<string, object> resultVariables)
        {
            var workflowTriggers =
                _workflowManagementService.GetWorkFlowByTriggerNameAndReferenceId(triggerName, referenceId, referenceTypeId,loggedInContext);

            if (workflowTriggers != null && workflowTriggers.Count > 0)
            {
                foreach (var workflowTriggerDetails in workflowTriggers)
                {
                    if (workflowTriggerDetails != null && !string.IsNullOrWhiteSpace(workflowTriggerDetails.WorkflowXml))
                    {
                        XmlDocument document = new XmlDocument();

                        document.LoadXml(workflowTriggerDetails.WorkflowXml);

                        var workflowName = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes["id"]?.InnerText.Trim();
                        var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                        CamundaEngineClient camunda = new CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);

                        var processInstanceId = camunda.BpmnWorkflowService.StartProcessInstance(workflowName, resultVariables);

                    }
                }
            }
        }
    }
}