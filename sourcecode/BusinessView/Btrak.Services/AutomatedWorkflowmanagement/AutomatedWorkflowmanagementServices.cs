using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.WorkflowManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web.Configuration;
using System.Xml;
//using CamundaClient.Requests;
//using CamundaClient;
using RestSharp;
using Camunda.Api.Client.Message;
using cam = Camunda.Api.Client;
using Camunda.Api.Client;
using Newtonsoft.Json;
using System.Reflection;
using Newtonsoft.Json.Linq;
using System.Linq;

namespace Btrak.Services.AutomatedWorkflowmanagement
{
    public class AutomatedWorkflowmanagementServices : IAutomatedWorkflowmanagementServices
    {
        private  AutomatedWorkflowmanagementRepository _automatedWorkflowmanagementRepository = new AutomatedWorkflowmanagementRepository();

        private  AuditService _auditService = new AuditService();

        public List<WorkFlowTriggerModel> GetTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetPersistance", "workFlowTriggerModel", workFlowTriggerModel, "Persistance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _automatedWorkflowmanagementRepository.GetTriggers(workFlowTriggerModel, loggedInContext, validationMessages);
        }

        public List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkFlowTriggers", "workFlowTriggerModel", workFlowTriggerModel, "Persistance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _automatedWorkflowmanagementRepository.GetWorkFlowTriggers(workFlowTriggerModel, loggedInContext, validationMessages);
        }

        public List<WorkFlowTriggerModel> GetWorkFlowTriggers(WorkFlowTriggerModel workFlowTriggerModel, Guid? CompanyId, Guid UserId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkFlowTriggers", "workFlowTriggerModel", workFlowTriggerModel, "Persistance Service"));

            return _automatedWorkflowmanagementRepository.GetWorkFlowTriggers(workFlowTriggerModel, CompanyId, UserId, validationMessages);
        }

        public IList<WorkFlowTriggerModel> GetWorkflowsForTriggers(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetWorkFlows", "workFlowTriggerModel", workFlowTriggerModel, "Persistance Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            return _automatedWorkflowmanagementRepository.GetWorkflowsForTriggers(workFlowTriggerModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertWorkflowTrigger(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWorkflowTrigger", "workFlowTriggerModel", workFlowTriggerModel, "Automatedworkflowmanagement Service"));


            Guid? upsertWorkflowTriggerId = _automatedWorkflowmanagementRepository.UpsertWorkflowTrigger(workFlowTriggerModel, loggedInContext, validationMessages);

            if (workFlowTriggerModel.ReferenceId != null && workFlowTriggerModel.ReferenceTypeId != null)
            {
                _automatedWorkflowmanagementRepository.UpsertGenericStatus(new GenericStatusModel()
                {
                    ReferenceId = workFlowTriggerModel.ReferenceId,
                    ReferenceTypeId = workFlowTriggerModel.ReferenceTypeId,
                    Status = AppConstants.DraftStatus,
                    WorkFlowId = workFlowTriggerModel.WorkflowId
                }, loggedInContext, validationMessages);
            }

            if(workFlowTriggerModel.ToSetDefaultWorkflows == true)
            {
                var model = new DefaultWorkflowModel();
                model.AuditDefaultWorkflowId = workFlowTriggerModel.AuditDefaultWorkflowId;
                model.ConductDefaultWorkflowId = workFlowTriggerModel.ConductDefaultWorkflowId;
                model.QuestionDefaultWorkflowId = workFlowTriggerModel.QuestionDefaultWorkflowId;
                UpsertDefaultWorkFlow(model, loggedInContext, validationMessages);
            }

            if (upsertWorkflowTriggerId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "Automatedworkflowmanagement Service"));

                _auditService.SaveAudit(AppConstants.Widgets, workFlowTriggerModel, loggedInContext);

                DeployWorkFlowDetails(workFlowTriggerModel);

                return upsertWorkflowTriggerId;
            }           

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "Automatedworkflowmanagement Service"));
            return null;
        }

        public Guid? UpsertGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWorkflowStatus", "workFlowStatusModel", workFlowStatusModel, "Automatedworkflowmanagement Service"));


            Guid? upsertGenericStatusId = _automatedWorkflowmanagementRepository.UpsertGenericStatus(workFlowStatusModel, loggedInContext, validationMessages);

            if (upsertGenericStatusId != Guid.Empty)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "Automatedworkflowmanagement Service"));

                _auditService.SaveAudit(AppConstants.Widgets, workFlowStatusModel, loggedInContext);

                return upsertGenericStatusId;
            }

            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWorkflowTrigger", "Automatedworkflowmanagement Service"));
            return null;
        }

        public List<GenericStatusModel> GetGenericStatus(GenericStatusModel workFlowStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertWorkflowStatus", "workFlowStatusModel", workFlowStatusModel, "Automatedworkflowmanagement Service"));

            return _automatedWorkflowmanagementRepository.GetGenericStatus(workFlowStatusModel, loggedInContext, validationMessages);
        }

        public Guid? UpsertDefaultWorkFlow(DefaultWorkflowModel workFlowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertDefaultWorkFlow", "WorkFlowTriggerModel", workFlowModel, "Automatedworkflowmanagement Service"));

            return _automatedWorkflowmanagementRepository.UpsertDefaultWorkFlow(workFlowModel, loggedInContext, validationMessages);
        }

        public List<DefaultWorkflowModel> GetDefaultWorkFlows(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _automatedWorkflowmanagementRepository.GetDefaultWorkFlows(loggedInContext, validationMessages);
        }

        private void DeployWorkFlowDetails(WorkFlowTriggerModel workFlowTriggerModel)
        {
            try
            {
                XmlDocument document = new XmlDocument();

                if (workFlowTriggerModel.WorkflowXml != null)
                {
                    document.LoadXml(workFlowTriggerModel.WorkflowXml);

                    var workflowName = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]
                        ?.Attributes["id"]?.InnerText.Trim();

                    List<object> files = new List<object>();

                    byte[] array = Encoding.ASCII.GetBytes(workFlowTriggerModel.WorkflowXml);

                    CamundaClient.Dto.FileParameter filePraParameter =
                        new CamundaClient.Dto.FileParameter(array, workflowName + ".bpmn");

                    files.Add((object)filePraParameter);

                    var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];

                    using (StreamReader streamReader = new StreamReader(CamundaClient.Requests.FormUpload.MultipartFormDataPost(camundaApiBaseUrl + "/engine-rest/engine/default/deployment/create", null, null, new Dictionary<string, object>()
                    {
                        {
                            "deployment-name",
                            (object) workflowName
                        },
                        {
                            "deployment-source",
                            (object) "C# Process Application"
                        },
                        {
                            "enable-duplicate-filtering",
                            (object) "true"
                        },

                        {
                            "data",
                            (object) files
                        }
                    }).GetResponseStream() ?? throw new InvalidOperationException(), Encoding.UTF8))
                    {
                        //List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                        //LoggedInContext loggedInContext = new LoggedInContext();
                        //StartWorkflowProcessInstance(workFlowTriggerModel, loggedInContext, validationMessages);
                    }
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeployWorkFlowDetails", "AutomatedWorkflowmanagementServices ", exception.Message), exception);

            }
        }

        public WorkFlowTriggerModel GetWorkflowBasedOnWorkflowId(Guid? workFlowId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<WorkFlowTriggerModel> workFlows = _automatedWorkflowmanagementRepository.GetWorkflowsForTriggers(new WorkFlowTriggerModel() { WorkflowId = workFlowId }, loggedInContext, validationMessages);

            if (workFlows != null && workFlows.Count > 0)
            {
                return workFlows.Find(x => x.WorkflowId != null);
            }
            return null;
        }


        public void StartWorkflowProcessInstance(WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            XmlDocument document = new XmlDocument();

            document.LoadXml(workFlowTriggerModel.WorkflowXml);

            XmlAttributeCollection xmlAttributeCollection = document.GetElementsByTagName("bpmn:definitions")[0]?.ChildNodes[0]?.Attributes;

            if (xmlAttributeCollection != null)
            {
                var workflowName = xmlAttributeCollection["id"]?.InnerText.Trim();
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];


                CamundaClient.CamundaEngineClient camundaEngineClient = new CamundaClient.CamundaEngineClient(new Uri(camundaApiBaseUrl + "/engine-rest/engine/default/"), null, null);
                var parametersNeedToSendToAWorkflow = new Dictionary<string, object>
                {
                    {"referenceId", workFlowTriggerModel.ReferenceId},
                    {"referenceTypeId", workFlowTriggerModel.ReferenceTypeId},
                    {"loggedUserId", loggedInContext.LoggedInUserId},
                    {"companyId", loggedInContext.CompanyGuid},
                    {"answer",  workFlowTriggerModel.Answer},
                    {"name",  workFlowTriggerModel.Name},
                    {"fileIds",  workFlowTriggerModel.FileIds},
                    {"isForAuditRecurringMail",  workFlowTriggerModel.IsForAuditRecurringMail == true ? "true" : null}
                };

                var processInstanceId = camundaEngineClient.BpmnWorkflowService.StartProcessInstance(workflowName, parametersNeedToSendToAWorkflow);

                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/engine/default/process-instance/" + processInstanceId + "/activity-instances";
                RestClient client = new RestClient(corpSiteApi);
                RestRequest request = new RestRequest();

                // Use the Method property to set the HTTP method
                request.Method = Method.GET;

                client.Execute(request);
            }
        }

        public void TriggerReceiveTask(string messageName, dynamic processVariables, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string instanceId = null)
        {
            try
            {
                var camundaApiBaseUrl = WebConfigurationManager.AppSettings["CamundaApiBaseUrl"];
                var corpSiteApi = camundaApiBaseUrl + "/engine-rest/message";
                RestClient client = new RestClient(corpSiteApi);
                RestRequest request = new RestRequest();
                request.Method = Method.POST;
                Dictionary<string, object> pv =  new Dictionary<string, object>();
                foreach (var kv in processVariables)
                {
                    JObject obj = (JObject)JToken.FromObject(kv);
                    var o = obj.Properties().Select(x => x.Name).ToList();
                    var key = o[0];
                    var a = new { value = kv[o[0]] };
                    pv.Add(key, a);
                }
                dynamic reqData;
                if (instanceId != null)
                {
                    reqData = new { processInstanceId = instanceId, messageName = messageName, processVariables = new { pv },  };
                } else
                {
                    reqData = new { messageName = messageName, processVariables = new { pv } };
                }
                string requestJson = JsonConvert.SerializeObject(reqData);
                string datareq = requestJson;
                client.Execute(request.AddJsonBody(datareq));
            }
            catch(Exception e)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "TriggerReceiveTask", "AutomatedWorkflowmanagementServices ", e.Message), e);
            }
        }
    }
}