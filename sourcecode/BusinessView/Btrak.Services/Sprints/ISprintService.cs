using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Sprints
{
    public interface ISprintService
    {
        Guid? UpsertSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SprintsApiReturnModel> SearchSprints(SprintSearchCriteriaInputModel sprintssSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        SprintsApiReturnModel GetSprintById(string SprintId, bool? IsBacklog, bool isUnique, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CompleteSprint(SprintUpsertModel sprintsUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GoalActivityWithUserStoriesOutputModel> GetSprintActivityWithUserStories(GoalActivityWithUserStoriesInputModel goalActivityWithUserStoriesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SprintsApiReturnModel> GetUserStoriesForAllSprints(UserStoriesForAllSprints userStoriesForAllSprints, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
