using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.SoftLabels;
using BTrak.Common;

namespace Btrak.Services.SoftLabels
{
    public interface ISoftLabelsService
    {
        Guid? UpsertSoftLabels(SoftLabelsInputMethod softLabelsInputMethod, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<SoftLabelsOutputMethod> GetSoftLabels(SoftLabelsSearchCriteriaInputModel softLabelsSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
