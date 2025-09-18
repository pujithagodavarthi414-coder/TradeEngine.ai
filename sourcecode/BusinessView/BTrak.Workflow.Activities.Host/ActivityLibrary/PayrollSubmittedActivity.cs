
using System.Collections.Generic;
using CamundaClient.Dto;
using CamundaClient.Worker;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("PayrollSubmitted")]
    public class PayrollSubmittedActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
        }
    }
}
