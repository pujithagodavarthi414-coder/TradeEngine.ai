using System;
using Btrak.Models.Goals;
using System.Collections.Generic;
using Btrak.Models;
using BTrak.Common;

namespace Btrak.Services.Goals
{
    public interface IGoalReplanTypeService
    {
        Guid? UpsertGoalReplanType(GoalReplanTypeUpsertInputModel goalReplanTypeUpsertInputModel, LoggedInContext loggedInContext,  List<ValidationMessage> validationMessages);
        List<GoalReplanTypeApiReturnModel> GetAllGoalReplanTypes(GoalReplanTypeInputModel goalReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        GoalReplanTypeApiReturnModel GetGoalReplanTypeById(Guid? goalReplanTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
