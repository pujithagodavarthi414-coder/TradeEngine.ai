using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Status;
using BTrak.Common;

namespace Btrak.Services.Status
{
    public interface IGoalStatusService
    {
        List<GoalStatusApiReturnModel> GetAllGoalStatuses(GoalStatusInputModel goalStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
