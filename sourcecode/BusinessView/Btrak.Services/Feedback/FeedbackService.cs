using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.Partial;
using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Models.UserStory;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.Feedback;
using BTrak.Common;

namespace Btrak.Services.Feedback
{
    public class FeedbackService : IFeedbackService
    {
        private readonly FeedbackRepository _feedbackRepository;
        private readonly IAuditService _auditService;

        public FeedbackService(IAuditService auditService,
             FeedbackRepository feedbackRepository)
        {
            _auditService = auditService;
            _feedbackRepository = feedbackRepository;
        }

        public List<FeedbackApiReturnModel> SearchFeedbacks(FeedbackSearchCriteriaInputModel feedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFeedbacks", "Feedback Service"));

            _auditService.SaveAudit(AppCommandConstants.GetNotificationsCommandId, feedbackSearchCriteriaInputModel, loggedInContext);

            List<FeedbackApiReturnModel> feedbackApiReturnModels = _feedbackRepository.SearchFeedbacks(feedbackSearchCriteriaInputModel, loggedInContext, validationMessages);

            return feedbackApiReturnModels;
        }

        public Guid? SubmitFeedBackForm(FeedbackSubmitModel feedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Feebdback form", "upsertFeedbacModel", feedbackModel, "UpsertFeedbackForm Api"));

            if (!FeedbackValidationHelper.UpsertFeedbackValidation(feedbackModel, loggedInContext, validationMessages))
            {
                return null;
            }

            feedbackModel.FeedbackId = _feedbackRepository.SubmitFeedBackForm(feedbackModel, loggedInContext, validationMessages);

            LoggingManager.Debug("feedback with the id " + feedbackModel.FeedbackId);

            _auditService.SaveAudit(AppCommandConstants.UpsertFeedbackTypeCommandId, feedbackModel, loggedInContext);

            return feedbackModel.FeedbackId;
        }

        public FeedbackApiReturnModel GetFeedbackById(Guid? feedbackId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFeedbackById", "Feedback Service" + "and feedbackIdd=" + feedbackId));

            LoggingManager.Debug(feedbackId?.ToString());

            if (!FeedbackValidationHelper.GetFeedbackByIdValidations(feedbackId, loggedInContext, validationMessages))
                return null;

            var feedbackSearchCriteriaInputModel = new FeedbackSearchCriteriaInputModel
            {
                FeedbackId = feedbackId
            };

            FeedbackApiReturnModel feedbackApiReturnModel = _feedbackRepository.SearchFeedbacks(feedbackSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (feedbackApiReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundfeedbackWithTheId, feedbackId)
                });

                return null;
            }

            _auditService.SaveAudit(AppConstants.Feedback, feedbackSearchCriteriaInputModel, loggedInContext);

            LoggingManager.Debug(feedbackApiReturnModel.ToString());

            return feedbackApiReturnModel;
        }

        public Guid? UpsertBugFeedback(UserStoryUpsertInputModel bugInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert BugFeedback", "bugInsertModel", bugInsertModel, "UpsertBugFeedback Api"));

            if (!FeedbackValidationHelper.UpsertBugFeedbackValidation(bugInsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            bugInsertModel.UserStoryId = _feedbackRepository.SubmitBugFeedback(bugInsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("UserStory with the id " + bugInsertModel.UserStoryId);

            _auditService.SaveAudit(AppCommandConstants.UpsertFeedbackTypeCommandId, bugInsertModel, loggedInContext);

            return bugInsertModel.UserStoryId;
        }

        public Guid? UpsertMissingFeature(UserStoryUpsertInputModel featureInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert BugFeedback", "featureInsertModel", featureInsertModel, "UpsertBugFeedback Api"));

            if (!FeedbackValidationHelper.UpsertBugFeedbackValidation(featureInsertModel, loggedInContext, validationMessages))
            {
                return null;
            }

            featureInsertModel.UserStoryId = _feedbackRepository.UpsertMissingFeature(featureInsertModel, loggedInContext, validationMessages);

            LoggingManager.Debug("UserStory with the id " + featureInsertModel.UserStoryId);

            _auditService.SaveAudit(AppCommandConstants.UpsertFeedbackTypeCommandId, featureInsertModel, loggedInContext);

            return featureInsertModel.UserStoryId;
        }
    }
}
