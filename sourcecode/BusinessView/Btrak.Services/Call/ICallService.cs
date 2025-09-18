using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Comments;
using Btrak.Models.Crm.Call;
using BTrak.Common;

namespace Btrak.Services.Comments
{
    public interface ICallService
    {
        Guid? UpsertCallFeedback(CallFeedbackUserInputModel callFeedbackModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CallFeedbackApiReturnModel> SearchCallFeedback(CallFeedbackSearchCriteriaInputModel callFeedbackSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CallFeedbackApiReturnModel GetCallFeedbackById(Guid? commentId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CallFeedbackApiReturnModel> GetCallFeedbacksByReceiverId (Guid? receiverId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CallOutcomeModel> GetCallOutcome(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<VideoCallLogOutputModel> SearchVideoCallLog(RoomDetailsModel roomDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}