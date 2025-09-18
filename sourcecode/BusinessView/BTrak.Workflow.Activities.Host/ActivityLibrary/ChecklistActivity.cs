using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Btrak.Models.GenericForm;
using Btrak.Services.Email;
using Btrak.Services.AdhocWork;
using Unity;
using Btrak.Models.AdhocWork;
using System.Data.SqlClient;
using Dapper;
using System.Data;
using Btrak.Services.UserStory;
using System.Linq;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("checklist_activity")]
    public class ChecklistActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            
            try
            {
                var _adhocWorkService = Unity.UnityContainer.Resolve<AdhocWorkService>();
                var userStoryReplanService = Unity.UnityContainer.Resolve<UserStoryReplanTypeService>();
                var checklistName = (string)externalTask.Variables["name"].Value;
                var displayName = (string)externalTask.Variables["displayName"].Value;
                var taskName = (string)externalTask.Variables["taskName"].Value;
                var priority = (string)externalTask.Variables["priority"].Value;
                var description = (string)externalTask.Variables["description"].Value;
                var taskOwner = (string)externalTask.Variables["taskOwner"].Value;
                var dueDate = (string)externalTask.Variables["dueDate"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                //foreach (var parameter in externalTask.Variables)
                //{
                //    resultVariables.Add(parameter.Key, externalTask.Variables[parameter.Key].Value);
                //}
                var loggedInUser = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };
                var validationMessages = new List<ValidationMessage>();
                var userStoryTypeModel = new Btrak.Models.MasterData.UserStoryTypeSearchInputModel();
                userStoryTypeModel.GenericStatusType = true;
                var userStoryTypeId = userStoryReplanService.GetUserStoryTypes(userStoryTypeModel, loggedInUser, validationMessages).Where(x => x.IsApproveOrDecline != null && x.IsApproveOrDecline.Value).Select(x => x.UserStoryTypeId).FirstOrDefault();
                LoggingManager.Debug("userStoryTypeId:" + userStoryTypeId?.ToString());
                var checkList = new AdhocWorkInputModel
                {
                    //ChecklistName = checklistName,
                    //DisplayName = displayName,
                   Description = description,
                   DeadLineDate = string.IsNullOrEmpty(dueDate) ? (DateTime?)null : Convert.ToDateTime(dueDate),
                   UserStoryName = taskName,
                   OwnerUserId = new Guid(taskOwner),
                    //UserStoryPriorityId = priority != null ? new Guid(priority) : (Guid?)null,
                    UserStoryTypeId = userStoryTypeId,
                };
                Guid? adhocWorkId = _adhocWorkService.UpsertAdhocWork(checkList, loggedInUser, new List<ValidationMessage>());
                using (var conn = new SqlConnection(ConfigurationManager.ConnectionStrings["BTrakConnectionString"].ConnectionString))
                {

                    DynamicParameters parameters = new DynamicParameters();
                    parameters.Add("@TaskId", new Guid(externalTask.ProcessInstanceId));
                    parameters.Add("@UserStoryId", adhocWorkId);

                    conn.Query<UserstoryReferences>("USP_UpdateWorkflowTask", parameters, commandType: CommandType.StoredProcedure);
                }
                //resultVariables.Add("userStoryId", adhocWorkId);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
