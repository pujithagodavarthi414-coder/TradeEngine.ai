using System;
using System.Collections.Generic;
using System.Configuration;
using BTrak.Common;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.PayRoll;
using Btrak.Services.Email;
using Btrak.Services.PayRoll;
using CamundaClient.Dto;
using CamundaClient.Worker;
using Unity;

namespace BTrak.Workflow.Activities.Host.ActivityLibrary
{
    [ExternalTaskTopic("PayrollStatus")]
    [ExternalTaskVariableRequirements("StatusName", "companyId", "loggedUserId", "payrollRunId")]
   public class PayrollStatusActivity : IExternalTaskAdapter
    {
        public void Execute(ExternalTask externalTask, ref Dictionary<string, object> resultVariables)
        {
            try
            {
                var payRollService = Unity.UnityContainer.Resolve<PayRollService>();
                var statusName = (string)externalTask.Variables["StatusName"].Value;
                var payrollRunId = (string)externalTask.Variables["payrollRunId"].Value;
                var companyId = (string)externalTask.Variables["companyId"].Value;
                var loggedUserId = (string)externalTask.Variables["loggedUserId"].Value;
                var loggedInUser = new LoggedInContext
                {
                    LoggedInUserId = new Guid(loggedUserId),
                    CompanyGuid = new Guid(companyId)
                };

                var statusid = payRollService.GetStatusIdByName(statusName, loggedInUser, new List<ValidationMessage>());
                var payRollStatus = new PayRollStatus
                {
                    //PayRollStatusName = statusName,
                    PayrollRunId = new Guid(payrollRunId),
                    WorkflowProcessInstanceId = new Guid(externalTask.ProcessInstanceId),
                    Id = statusid ?? Guid.NewGuid(),
                    IsPayslipReleased = true
                };
                
                payRollService.UpdatePayrollRunStatus(payRollStatus, loggedInUser, new List<ValidationMessage>());
            }
            catch (Exception ex)
            {
         Console.WriteLine(ex.Message);
            }
        }
    }
}
