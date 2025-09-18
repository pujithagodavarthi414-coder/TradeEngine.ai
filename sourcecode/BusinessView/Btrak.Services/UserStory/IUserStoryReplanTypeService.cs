using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Status;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryReplanTypeService
    {
        Guid? UpsertUserStoryReplanType(UpsertUserStoryReplanTypeInputModel upsertUserStoryReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryReplanTypeOutputModel> GetUserStoryReplanTypes(UserStoryReplanTypeSearchCriteriaInputModel userStoryReplanTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryTypeSearchInputModel> GetUserStoryTypes(UserStoryTypeSearchInputModel userStoryTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteUserStoryType(UpsertUserStoryTypeInputModel upsertUserStoryTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
