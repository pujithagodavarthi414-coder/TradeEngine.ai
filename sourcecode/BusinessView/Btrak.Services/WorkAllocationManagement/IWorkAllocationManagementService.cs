using Btrak.Models;
using Btrak.Models.MyWork;
using Btrak.Models.Work;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.WorkAllocationManagement
{
    public interface IWorkAllocationManagementService
    {
        List<WorkAllocationApiReturnModel> GetEmployeeWorkAllocation(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkAllocationApiReturnModel> GetWorkAllocationByProjectId(Guid? projectId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserHistoricalWorkReportSearchSpOutputModel> GetWorkAllocationDrillDownDetailsbyUserId(WorkAllocationSearchCriteriaInputModel workAllocationSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
