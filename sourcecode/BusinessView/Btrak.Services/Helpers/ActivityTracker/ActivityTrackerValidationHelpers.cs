using Btrak.Models;
using Btrak.Models.ActivityTracker;
using BTrak.Common;
using System.Collections.Generic;


namespace Btrak.Services.Helpers.ActivityTracker
{
    public class ActivityTrackerValidationHelpers
    {
        public List<ValidationMessage> InsertUserActivityTimeValidation(InsertUserActivityInputModel insertUserActivityTimeInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Insert User Activity Time Validation", "ActivityTrackerValidationHelpers"));
            if (insertUserActivityTimeInputModel.UserActivityTime ==  null || (insertUserActivityTimeInputModel.UserActivityTime.Count == 0 && insertUserActivityTimeInputModel.UserIdleActivityTime == null))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Insert User Activity Time Validation", "ActivityTrackerValidationHelpers"));
                LoggingManager.Debug("Checking List<InsertUserActivityTimeInputModel> in InsertUserActivityTimeValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyUserActivityTime
                });
            }
            return validationMessages;
        }

        public List<ValidationMessage> InsertUserActivityScreenShotValidation(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                "Insert User Activity Time Validation", "ActivityTrackerValidationHelpers"));
            if (insertUserActivityScreenShotInputModel.ScreenShotDate == null)
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertUserActivityScreenShotValidation", "ActivityTrackerValidationHelpers"));
                LoggingManager.Debug("Checking ScreenShotDate in InsertUserActivityScreenShotValidation");
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyScreenShotDate
                });
            }
            return validationMessages;
        }
    }
}
