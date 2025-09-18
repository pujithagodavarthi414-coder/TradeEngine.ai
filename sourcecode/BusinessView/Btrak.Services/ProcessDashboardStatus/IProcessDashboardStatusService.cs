using Btrak.Models;
using System;
using System.Collections.Generic;
using Btrak.Models.Dashboard;
using BTrak.Common;

namespace Btrak.Services.ProcessDashboardStatus
{
    public interface IProcessDashboardStatusService
    {
        Guid? UpsertProcessDashboardStatus(ProcessDashboardStatusUpsertInputModel processDashboardStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProcessDashboardStatusApiReturnModel> GetAllProcessDashboardStatuses(ProcessDashboardStatusInputModel processDashboardStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ProcessDashboardStatusApiReturnModel GetProcessDashboardStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
