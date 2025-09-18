using Btrak.Models;
using Btrak.Models.ConsiderHour;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.ConsideredHours
{
    public interface IConsideredHourService
    {
        Guid? UpsertConsideredHours(ConsiderHourUpsertInputModel considerHourUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ConsiderHourApiReturnModel> GetAllConsideredHours(ConsiderHourInputModel considerHourInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ConsiderHourApiReturnModel GetConsideredHoursById(Guid? statusId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
