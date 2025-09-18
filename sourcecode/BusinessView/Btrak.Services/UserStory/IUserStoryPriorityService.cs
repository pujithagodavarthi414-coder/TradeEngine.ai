using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryPriorityService
    {
        List<UserStoryPriorityApiReturnModel> SearchUserStoryPriorities(UserStoryPriorityInputModel userStoryPriorityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
