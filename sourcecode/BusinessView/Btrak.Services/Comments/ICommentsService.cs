using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Comments;
using BTrak.Common;

namespace Btrak.Services.Comments
{
    public interface ICommentsService
    {
        Guid? UpsertComment(CommentUserInputModel commentModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CommentApiReturnModel> SearchComments(CommentsSearchCriteriaInputModel commentsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CommentApiReturnModel GetCommentById(Guid? commentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CommentApiReturnModel> GetCommentsByReceiverId(Guid? receiverId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}