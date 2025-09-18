using Btrak.Models;
using Btrak.Models.TransitionDeadline;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.TransitionDeadline
{
    public interface ITransitionDeadlineService
    {
        Guid? UpsertTransitionDeadline(TransitionDeadlineUpsertInputModel transitionDeadlineUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TransitionDeadlineApiReturnModel> GetAllTransitionDeadlines(TransitionDeadlineInputModel transitionDeadlineInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TransitionDeadlineApiReturnModel GetTransitionDeadlineById(Guid? transitionDeadlineId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
