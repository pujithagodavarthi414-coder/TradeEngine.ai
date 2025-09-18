using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Common;

namespace Btrak.Services.Status
{
    public interface IBugPriorityService
    {
        List<BugPriorityApiReturnModel> GetAllBugPriorities(BugPriorityInputModel bugPriorityModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBugPriority(UpsertBugPriorityInputModel upsertBugPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
