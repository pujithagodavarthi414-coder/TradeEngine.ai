using AuthenticationServices.Models;
using AuthenticationServices.Models.TimeZone;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.TimeZone
{
    public interface ITimeZoneService
    {
        List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages);
    }
}
