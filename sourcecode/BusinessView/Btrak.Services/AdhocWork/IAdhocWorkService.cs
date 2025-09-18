using Btrak.Models;
using Btrak.Models.AdhocWork;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.AdhocWork
{
    public interface IAdhocWorkService
    {
         List<GetAdhocWorkOutputModel> SearchAdhocWork(AdhocWorkSearchInputModel payGradeRatesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
         Guid? UpsertAdhocWork(AdhocWorkInputModel adhocWorkInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
         GetAdhocWorkOutputModel GetAdhocWorkByUserStoryId(Guid? userStoryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
