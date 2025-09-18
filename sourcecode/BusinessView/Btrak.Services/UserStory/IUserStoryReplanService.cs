using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryReplanService
    {
        Guid? InsertUserStoryReplan(UserStoryReplanUpsertInputModel userStoryReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalReplanHistoryApiReturnModel> GoalReplanHistory(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> UpsertUserStoryReplan(UserStoryReplanInputModel userStoryReplanInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalReplanHistoryOutputModel> GetGoalReplanHistory(Guid? goalId,int? goalReplanValue, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<GoalReplanHistoryOutputModel> GetSprintReplanHistory(Guid? sprintId, int? goalReplanValue, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}