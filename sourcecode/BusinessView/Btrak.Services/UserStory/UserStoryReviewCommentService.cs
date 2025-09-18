using System;
using System.Collections.Generic;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.UserStory;
using BTrak.Common;

namespace Btrak.Services.UserStory
{
    public class UserStoryReviewCommentService : IUserStoryReviewCommentService
    {
        private readonly UserStoryReviewCommentRepository _userStoryReviewCommentRepository;
        private readonly IAuditService _auditService;

        public UserStoryReviewCommentService(UserStoryReviewCommentRepository userStoryReviewCommentRepository, IAuditService auditService)
        {
            _userStoryReviewCommentRepository = userStoryReviewCommentRepository;
            _auditService = auditService;
        }

        public Guid? UpsertUserStoryReviewComment(UserStoryReviewCommentUpsertInputModel userStoryReviewCommentUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertUserStoryReviewComment", "UserStoryReviewComment Service and logged details=" + loggedInContext));

            LoggingManager.Debug(userStoryReviewCommentUpsertInputModel.ToString());

            userStoryReviewCommentUpsertInputModel.Comment = userStoryReviewCommentUpsertInputModel.Comment?.Trim();

            if (!UserStoryReviewCommentValidations.ValidateUpsertUserStoryReviewComment(userStoryReviewCommentUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            userStoryReviewCommentUpsertInputModel.UserStoryReviewCommentId = _userStoryReviewCommentRepository.UpsertUserStoryReviewComment(userStoryReviewCommentUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertUserStoryReviewCommentCommandId, userStoryReviewCommentUpsertInputModel, loggedInContext);

            LoggingManager.Debug(userStoryReviewCommentUpsertInputModel.UserStoryReviewCommentId?.ToString());

            return userStoryReviewCommentUpsertInputModel.UserStoryReviewCommentId;
        }
    }
}
