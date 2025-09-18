using System;
using System.Collections.Generic;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;
using Btrak.Models;
using Btrak.Services.AutomatedWorkflowmanagement;
using System.Data.SqlClient;
using System.Configuration;
using Dapper;
using System.Data;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("status-update")]
    public class GenericStatusChangeActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                string loggedUserId = externalTask.Variables.ContainsKey("loggedUserId") && externalTask.Variables["loggedUserId"]?.Value != null ? Convert.ToString(externalTask.Variables["loggedUserId"].Value) : string.Empty;
                string companyId = externalTask.Variables.ContainsKey("companyId") && externalTask.Variables["companyId"]?.Value != null ? (string)externalTask.Variables["companyId"].Value : string.Empty;
                string referenceId = externalTask.Variables.ContainsKey("referenceId") && externalTask.Variables["referenceId"]?.Value != null ? Convert.ToString(externalTask.Variables["referenceId"].Value) : string.Empty;
                string referenceTypeId = externalTask.Variables.ContainsKey("referenceTypeId") && externalTask.Variables["referenceTypeId"]?.Value != null ? (string)externalTask.Variables["referenceTypeId"].Value : string.Empty;
                string statusChangedTobe = externalTask.Variables.ContainsKey("statusChangedTobe") && externalTask.Variables["statusChangedTobe"]?.Value != null ? Convert.ToString(externalTask.Variables["statusChangedTobe"].Value) : string.Empty;
                string responsibleUser = externalTask.Variables.ContainsKey("responsibleUser") && externalTask.Variables["responsibleUser"]?.Value != null ? Convert.ToString(externalTask.Variables["responsibleUser"].Value) : string.Empty;
                string statusColor = externalTask.Variables.ContainsKey("statusColor") && externalTask.Variables["statusColor"]?.Value != null ? Convert.ToString(externalTask.Variables["statusColor"].Value) : string.Empty;
                string userStoryId = externalTask.Variables.ContainsKey("userStoryId") && externalTask.Variables["userStoryId"]?.Value != null ? Convert.ToString(externalTask.Variables["userStoryId"].Value) : string.Empty;
                foreach (var parameter in externalTask.Variables)
                {
                    resultVariables.Add(parameter.Key, externalTask.Variables[parameter.Key].Value);
                }

                var automatedWorkflowService = Unity.UnityContainer.Resolve<AutomatedWorkflowmanagementServices>();
              

                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                var validationMessages = new List<ValidationMessage>();
                if(!string.IsNullOrEmpty(referenceId) && !string.IsNullOrEmpty(referenceTypeId) && !string.IsNullOrEmpty(statusChangedTobe))
                {
                    automatedWorkflowService.UpsertGenericStatus(new Btrak.Models.WorkflowManagement.GenericStatusModel()
                    {
                        ReferenceId = Guid.Parse(referenceId),
                        ReferenceTypeId = Guid.Parse(referenceTypeId),
                        Status = statusChangedTobe,
                        StatusColor = statusColor
                    }, loggedInContext, validationMessages);
                    //if(userStoryId != null && userStoryId != "")
                    //{
                    //    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString))
                    //    {

                    //        DynamicParameters parameters = new DynamicParameters();
                    //        parameters.Add("@TaskId", new Guid(externalTask.ProcessInstanceId));
                    //        parameters.Add("@UserStoryId", userStoryId);
                    //        parameters.Add("@ReferenceId", referenceId);
                    //        parameters.Add("@ReferenceTypeId", Guid.Parse(referenceTypeId));

                    //        conn.Query<UserstoryReferences>("USP_UpdateWorkflowTask", parameters, commandType: CommandType.StoredProcedure);
                    //    }
                    //}
                }

            }
            catch (Exception ex)
            {
                LoggingManager.Error(ex);
                throw ex;
            }

        }

    }
}