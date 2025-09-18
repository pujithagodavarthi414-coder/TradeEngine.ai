using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Work;
using BTrak.Common;

namespace Btrak.Services.Work
{
    public interface IWorkService
    {
        Guid? UpsertWork(WorkUpsertInputModel workUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        WorkApiReturnModel GetWorkById(Guid? workId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
