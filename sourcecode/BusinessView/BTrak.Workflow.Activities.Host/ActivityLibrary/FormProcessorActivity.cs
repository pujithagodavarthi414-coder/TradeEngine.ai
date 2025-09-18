using System;
using System.Collections.Generic;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Btrak.Models.AdhocWork;
using Btrak.Services.Account;
using Btrak.Services.AdhocWork;
using Btrak.Services.GenericForm;
using Btrak.Services.UserStory;
using Dapper;
using Unity;
using Btrak.Models;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using Btrak.Models.GenericForm;
using System.Linq;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("form-processer")]
    public class FormProcessorActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {

                string customApplicationId = externalTask.Variables.ContainsKey("customApplicationId") && externalTask.Variables["customApplicationId"]?.Value != null ? Convert.ToString(externalTask.Variables["customApplicationId"].Value) : string.Empty;
                string submittedFormId = externalTask.Variables.ContainsKey("submittedFormId") && externalTask.Variables["submittedFormId"]?.Value != null ? Convert.ToString(externalTask.Variables["submittedFormId"].Value) : string.Empty;
                string loggedUserId = externalTask.Variables.ContainsKey("loggedUserId") && externalTask.Variables["loggedUserId"]?.Value != null ? Convert.ToString(externalTask.Variables["loggedUserId"].Value) : string.Empty;
                string companyId = externalTask.Variables.ContainsKey("companyId") && externalTask.Variables["companyId"]?.Value != null ? (string)externalTask.Variables["companyId"].Value : string.Empty;
                string appUrl = externalTask.Variables.ContainsKey("appUrl") && externalTask.Variables["appUrl"]?.Value != null ? Convert.ToString(externalTask.Variables["appUrl"].Value) : string.Empty;
                string formJson = externalTask.Variables.ContainsKey("formJson") && externalTask.Variables["formJson"]?.Value != null ? Convert.ToString(externalTask.Variables["formJson"].Value) : string.Empty;

                foreach (var parameter in externalTask.Variables)
                {
                    resultVariables.Add(parameter.Key, externalTask.Variables[parameter.Key].Value);
                }

                var userStoryService = Unity.UnityContainer.Resolve<UserStoryService>();
                var userStoryReplanService = Unity.UnityContainer.Resolve<UserStoryReplanTypeService>();
                var userService = Unity.UnityContainer.Resolve<UserService>();
                var genericFormService = Unity.UnityContainer.Resolve<GenericFormService>();
                var adhocWorkService = Unity.UnityContainer.Resolve<AdhocWorkService>();

                var loggedInContext = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                var validationMessages = new List<ValidationMessage>();
                var userStoryTypeModel = new Btrak.Models.MasterData.UserStoryTypeSearchInputModel();
                var userStoryTypeId = userStoryReplanService.GetUserStoryTypes(userStoryTypeModel, loggedInContext, validationMessages).Where(x => x.IsFillForm != null &&  x.IsFillForm.Value).Select(x => x.UserStoryTypeId).FirstOrDefault();
                string formName = (string)externalTask.Variables["formName"].Value;
                string userName = externalTask.Variables.ContainsKey("userNameNeedToBeAssigned") && externalTask.Variables["userNameNeedToBeAssigned"].Value != null ? Convert.ToString(externalTask.Variables["userNameNeedToBeAssigned"].Value) : string.Empty ;
                var result = genericFormService.GetGenericForms(new GenericFormSearchCriteriaInputModel { FormName = formName }, loggedInContext, validationMessages).FirstOrDefault();
                Guid? userId = null;
                if (!string.IsNullOrEmpty(userName))
                    userId = userService.GetUserId(userName);
                else if (loggedUserId != null)
                {
                    Guid outGuidVariable;
                    Guid.TryParse(loggedUserId, out outGuidVariable);
                    userId = outGuidVariable;
                }

                if (result != null && userId != null)
                {
                    if (resultVariables.ContainsKey("formIdNeedToBeFilledByUser"))
                        resultVariables["formIdNeedToBeFilledByUser"] = result.Id;
                    else
                        resultVariables.Add("formIdNeedToBeFilledByUser", result.Id);


                    var genericformSubmittedId = genericFormService.UpsertGenricFormSubmitted(new GenericFormSubmittedUpsertInputModel()
                    {
                        FormId = result.Id,
                        FormJson = formJson,
                    },loggedInContext,validationMessages).Result;

                    var userStory = new AdhocWorkInputModel()
                    {
                        UserStoryName = formName + " is assigned to you, please update and submit it.",
                        UserStoryTypeId = userStoryTypeId,
                        OwnerUserId = userId,
                        FormId = result.Id,
                        GenericFormSubmittedId = genericformSubmittedId
                    };


                    var userStoryId = adhocWorkService.UpsertAdhocWork(userStory, loggedInContext, validationMessages);
                    using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString))
                    {

                        DynamicParameters parameters = new DynamicParameters();
                        parameters.Add("@TaskId", new Guid(externalTask.ProcessInstanceId));
                        parameters.Add("@UserStoryId", userStoryId);
                        parameters.Add("@CustomAppId", customApplicationId);
                        parameters.Add("@FormId", result.Id);

                        conn.Query<UserstoryReferences>("USP_UpdateWorkflowTask", parameters, commandType: CommandType.StoredProcedure);
                    }
                }



            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Execute", "FormProcessorActivity", ex.Message), ex);

                throw ex;
            }

        }

    }
}