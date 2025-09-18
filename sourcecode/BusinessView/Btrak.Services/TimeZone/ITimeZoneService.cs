
using Btrak.Models;
using Btrak.Models.TimeZone;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.TimeZone
{
    public interface ITimeZoneService
    {
        Guid? UpsertTimeZone(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages,LoggedInContext loggedInContext);
        List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages);
        List<TimeZoneOutputModel> GetAllTimeZoneLists(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        TimeZoneOutputModel GetTimeZoneById(Guid? timeZoneId, List<ValidationMessage> validationMessages);
    }
}
