using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.TimeZone;
using AuthenticationServices.Repositories.Repositories.TimeZone;
using System;
using System.Collections.Generic;
using System.Text;

namespace AuthenticationServices.Services.TimeZone
{
    public class TimeZoneService : ITimeZoneService
    {
        private readonly ITimeZoneRepository _timeZoneRepository;

        public TimeZoneService(ITimeZoneRepository timeZoneRepository)
        {
            _timeZoneRepository = timeZoneRepository;
        }

        public List<TimeZoneOutputModel> GetAllTimeZones(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllTimeZones", "timeZoneInputModel", timeZoneInputModel, "TimeZone Service"));

            if (validationMessages.Count > 0)
            {
                return null;
            }

            List<TimeZoneOutputModel> timeZoneModels = _timeZoneRepository.GetAllTimeZones(timeZoneInputModel, validationMessages);
            return timeZoneModels;
        }
    }
}
