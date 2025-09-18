using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.LeaveType;
using Btrak.Models.LeaveManagement;
using Btrak.Models.MasterData;

namespace Btrak.Services.LeaveType
{
    public interface ILeaveTypeService
    {
        Guid? UpsertLeaveType(LeaveTypeInputModel leaveTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveFrequencySearchOutputModel> GetAllLeaveTypes(LeaveTypeSearchCriteriaInputModel leaveTypeSearchCriteriaInputModelLoggedInContext, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        LeaveFrequencySearchOutputModel GetLeaveTypeById(Guid? leaveTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MasterLeaveTypeSearchOutputModel> GetMasterLeaveTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
