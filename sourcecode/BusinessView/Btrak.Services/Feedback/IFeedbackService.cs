using Btrak.Models;
using Btrak.Models.Feedback;
using Btrak.Models.UserStory;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Feedback
{
   public interface IFeedbackService
    {
        Guid? SubmitFeedBackForm(FeedbackSubmitModel feedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FeedbackApiReturnModel> SearchFeedbacks(FeedbackSearchCriteriaInputModel feedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FeedbackApiReturnModel GetFeedbackById(Guid? feedbackId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBugFeedback(UserStoryUpsertInputModel bugInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertMissingFeature(UserStoryUpsertInputModel featureInsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
