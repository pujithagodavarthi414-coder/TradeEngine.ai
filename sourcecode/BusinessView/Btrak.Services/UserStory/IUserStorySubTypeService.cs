using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public interface IUserStorySubTypeService
    {
        Guid? UpsertUserStorySubType(UserStorySubTypeUpsertInputModel userStorySubTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStorySubTypeApiReturnModel> SearchUserStorySubTypes(UserStorySubTypeSearchCriteriaInputModel userStorySubTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStorySubTypeApiReturnModel GetUserStorySubTypeById(Guid? userStorySubTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
