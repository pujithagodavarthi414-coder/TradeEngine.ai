using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ConfigurationType;
using BTrak.Common;

namespace Btrak.Services.Helpers.ConfigurationType
{
    public static class ConfigurationTypeValidations
    {
        public static bool ValidateUpsertConfigurationType(ConfigurationTypeUpsertInputModel configurationTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (string.IsNullOrEmpty(configurationTypeUpsertInputModel.ConfigurationTypeName))
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfigurationTypeName
                });
            }

            if (configurationTypeUpsertInputModel.ConfigurationTypeName?.Length > AppConstants.InputWithMaxSize250)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthForConfigurationTypeName
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateConfigurationTypeById(Guid? configurationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (configurationTypeId == Guid.Empty || configurationTypeId == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfigurationTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool ValidateConfigurationTypeFoundWithId(Guid? configurationTypeId, List<ValidationMessage> validationMessages, ConfigurationTypeApiReturnModel configurationTypeSpReturnModel)
        {
            if (configurationTypeSpReturnModel == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage =  string.Format(ValidationMessages.NotFoundConfigurationTypeWithTheId, configurationTypeId)
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}
