using AuthenticationServices.Models;
using AuthenticationServices.Models.TimeZone;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Repositories.Repositories.TimeZone
{
    public interface ITimeZoneRepository
    {
        List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages);
    }
}
