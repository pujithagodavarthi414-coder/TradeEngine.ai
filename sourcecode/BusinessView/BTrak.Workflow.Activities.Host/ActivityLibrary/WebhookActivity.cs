using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models.SystemManagement;
using Btrak.Services.Email;
using BTrak.Common;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Btrak.Services.WorkFlow;
using Unity;


namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("webhook_activity")]
    public class WebhookActivity: IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                var workFlowService = Unity.UnityContainer.Resolve<WorkFlowService>();
                

            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }
    }
}
