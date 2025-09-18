
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryLinkService
    {
        List<UserStoryLinkTypeOutputModel> GetUserStoryLinkTypes(UserStoryLinkTypesSearchCriteriaInputModel userStoryLinkTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryLinksOutputModel> SearchUserStoriesLinks(UserStoryLinksSearchCriteriaModel userStoryLinkSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertUserStoryLink(UserStoryLinkUpsertModel userStoryLinkUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ArchiveUserStoryLink(ArchivedUserStoryLinkInputModel archivedUserStoryLinkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int? GetLinksCountForUserStory(Guid? userStoryId, bool? isSprintUserStories, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
