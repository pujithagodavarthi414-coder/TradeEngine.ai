using Btrak.Models;
using Btrak.Models.Performance;
using BTrak.Common;
using System.Collections.Generic;

namespace Btrak.Services.Helpers
{
    public class PerformanceValidationHelpers
    {
        public static bool UpsertPerfomaceConfigurationValidations(PerformanceConfigurationModel performanceConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "Upsert Performance Validation", "performanceConfigurationModel", performanceConfigurationModel, "performance Validation Helper"));
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(performanceConfigurationModel.ConfigurationName))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "performance configuration name is required", "performance Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PerformanceNameIsRequired
                });
            }
            if (string.IsNullOrEmpty(performanceConfigurationModel.FormJson))
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "performance FormJson is required", "performance Validation Helper"));

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PerformanceFormIsRequired
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
