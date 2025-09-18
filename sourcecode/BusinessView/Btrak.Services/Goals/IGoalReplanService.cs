using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Goals;
using BTrak.Common;

namespace Btrak.Services.Goals
{
    public interface IGoalReplanService
    {
        Guid? InsertGoalReplan(GoalReplanUpsertInputModel goalReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}