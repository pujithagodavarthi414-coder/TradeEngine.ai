using CamundaClient.Worker;
using CamundaClient.Dto;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BTrak.Common;
using Btrak.Models.GenericForm;
using Btrak.Models;
using Btrak.Services.WorkFlow;
using Unity;
using Btrak.Services.FormDataServices;
using Btrak.Models.FormDataServices;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("syncform_activity")]
    public class SyncFormActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            //try
            //{
            //    LoggingManager.Info("Entering into Sync form : " + DateTime.Now.ToString());
            //    var dataSourceService = Unity.UnityContainer.Resolve<DataSourceService>();
            //    var authorization = (string)externalTask.Variables["authorization"].Value;
            //    var mongoBaseURL = (string)externalTask.Variables["mongoBaseURL"].Value;
            //    var companyId = (string)externalTask.Variables["companyId"].Value;
            //    var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
            //    var fieldUniqueId = (string)externalTask.Variables["fieldUniqueId"].Value;
            //    var dataSetId = (string)externalTask.Variables["dataSetId"].Value;
            //    var fieldUpdateModelJson = (string)externalTask.Variables["fieldUpdateModelJson"].Value;

            //    Console.WriteLine("mongoBaseURL" + mongoBaseURL);
            //    Console.WriteLine("loggedUserId" + loggedUserId);

            //    LoggingManager.Debug("authorization" + authorization);
            //    LoggingManager.Debug("companyId" + companyId);
            //    LoggingManager.Debug("loggedUserId" + loggedUserId);
            //    var loggedInUser = new LoggedInContext
            //    {
            //        authorization = authorization,
            //        LoggedInUserId = new Guid(loggedUserId),
            //        CompanyGuid = new Guid(companyId)
            //    };
            //    SyncSubmittedDataModel dataModel = new SyncSubmittedDataModel
            //    {
            //        FieldUniqueId = fieldUniqueId,
            //        FieldUpdateModelJson = fieldUpdateModelJson,
            //        MongoBaseURL = mongoBaseURL,
            //        DataSetId = new Guid(dataSetId)
            //    };

            //    dataSourceService.SyncSubmittedData(dataModel, loggedInUser);
            //    LoggingManager.Info("Exit from Sync form : " + DateTime.Now.ToString());
            //}
            //catch (Exception ex)
            //{
            //    LoggingManager.Debug("Sync form Exception" + ex);
            //    LoggingManager.Error("Sync form Exception" + ex);
            //    Console.WriteLine(ex.Message);
            //}
        }
    }
}
