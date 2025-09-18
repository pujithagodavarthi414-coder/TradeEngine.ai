using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.TimeZone;
using BTrak.Common;

namespace Btrak.Services.Helpers.TimeZoneValidationHelpers
{
    public class TimeZoneValidationsHelper
    {
        public static bool UpsertTimeZoneValidation(TimeZoneInputModel timeZoneInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertTimeZoneValidation", "timeZoneInputModel", timeZoneInputModel, "TimeZoneValidationsHelper"));
            
            if (string.IsNullOrEmpty(timeZoneInputModel.TimeZoneName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTimeZoneName
                });
            }
             
            if (timeZoneInputModel.TimeZoneOffset == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyTimeZoneOffset
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetTimeZoneByIdValidation(Guid? timeZoneId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetTimeZoneByIdValidation", "timeZoneId", timeZoneId, "TimeZoneValidationsHelper"));
           
            if (timeZoneId == Guid.Empty || timeZoneId == null)
            {
                validationMessages.Add(new ValidationMessage()
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyTimeZoneId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
