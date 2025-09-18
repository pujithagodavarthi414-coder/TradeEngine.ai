using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public interface IUserStoryReviewCommentService
    {
        Guid? UpsertUserStoryReviewComment(UserStoryReviewCommentUpsertInputModel userStoryReviewCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
