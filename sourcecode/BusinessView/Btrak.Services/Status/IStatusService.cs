using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.Status;

namespace Btrak.Services.Status
{
    public interface IStatusService
    {
        Guid? UpsertStatus(UserStoryStatusUpsertInputModel userStoryStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserStoryStatusApiReturnModel> GetAllStatuses(UserStoryStatusInputModel userStoryStatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserstoryStatusApiTaskStatusReturnModel> GetAllTaskStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserStoryStatusApiReturnModel GetStatusById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
