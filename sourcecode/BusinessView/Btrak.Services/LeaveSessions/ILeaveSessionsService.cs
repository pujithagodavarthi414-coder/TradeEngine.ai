using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.LeaveSessions;
using BTrak.Common;

namespace Btrak.Services.LeaveSessions
{
    public interface ILeaveSessionsService
    {
        Guid? UpsertLeaveSession(LeaveSessionsInputModel leaveSessionInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<LeaveSessionsOutputModel> GetAllLeaveSessions(LeaveSessionsInputModel leaveSessionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        LeaveSessionsOutputModel GetLeaveSessionsById(Guid? leaveSessionId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
