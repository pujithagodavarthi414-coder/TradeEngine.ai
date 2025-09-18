using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData
{
    public interface ILeaveStatusService
    {
         Guid? UpsertLeaveStatus(LeaveStatusUpsertModel leaveStatusUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
         List<GetLeaveStatusOutputModel> GetLeaveStatus(GetLeavestatusSearchCriteriaInputModel getLeavestatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}