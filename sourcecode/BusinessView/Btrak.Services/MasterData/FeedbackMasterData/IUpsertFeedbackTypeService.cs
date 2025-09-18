using Btrak.Models;
using Btrak.Models.MasterData.FeedbackTypeModel;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData.FeedbackMasterData
{
    public interface IUpsertFeedbackTypeService
    {
        Guid? UpsertFeedbackType(UpsertFeedbackTypeModel upsertFeedbackTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetFeedbackTypeSearchCriteriaInputModel> GetFeedbackTypes(GetFeedbackTypeSearchCriteriaInputModel getFeedbackTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
