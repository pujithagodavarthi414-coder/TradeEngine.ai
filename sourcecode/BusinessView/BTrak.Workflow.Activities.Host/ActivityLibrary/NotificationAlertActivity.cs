using BTrak.Common;
using Btrak.Models.File;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Btrak.Models;
using Btrak.Services.DocumentStorageServices;
using Btrak.Services.FormDataServices;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Unity;
using Btrak.Models.Notification;
using System.ComponentModel.Design;
using System.Net;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("notificationalert_activity")]
    public class NotificationAlertActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                LoggingManager.Info("Entering into notification alert activity : " + DateTime.Now.ToString());
                var dataSetService = Unity.UnityContainer.Resolve<DataSetService>();
                string notificationType = (string)externalTask.Variables["notificationType"].Value;
                string notificationText = (string)externalTask.Variables["notificationText"].Value;
                string notificationMessage = (string)externalTask.Variables["notificationMessage"].Value;
                string notifyToUsersJson = (string)externalTask.Variables["notifyToUsersJson"].Value;
                string usersJson = (string)externalTask.Variables["usersJson"].Value;
                string navigationUrl = (string)externalTask.Variables["navigationUrl"].Value;
                var authorization = (string)externalTask.Variables["authorization"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var mongoBaseURL = (string)externalTask.Variables["mongoBaseURL"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;

                var loggedInUser = new LoggedInContext
                {
                    authorization = authorization,
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };
                NotificationAlertModel alertModel = new NotificationAlertModel
                {
                    NotificationText = string.IsNullOrEmpty(notificationMessage) ? notificationText : notificationMessage,
                    NotificationType = notificationType,
                    NotifyToUsersJson = usersJson, //TODO : Need to check json
                    NavigationUrl = navigationUrl
                };

                dataSetService.NotificationAlertWorkFlow(alertModel, mongoBaseURL, loggedInUser);
                LoggingManager.Info("Exit from notification alert activity : " + DateTime.Now.ToString());
            }
            catch (Exception ex)
            {
                LoggingManager.Debug("Notification alert activity Exception" + ex);
                LoggingManager.Error("Notification alert activity Exception" + ex);
                Console.WriteLine(ex.Message);
            }
        }
    }
}
