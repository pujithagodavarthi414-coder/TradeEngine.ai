using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.ConfigurationType;
using BTrak.Common;

namespace Btrak.Services.Helpers.ConfigurationType
{
    public static class ConfigurationSettingServiceValidation
    {
        public static bool UpsertConfigurationSettingsValidation(Guid? configurationId, ConfigurationSettingUpsertInputModel configurationSettingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (configurationId == null || configurationId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfigurationTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetAllConfigurationSettingsValidations(ConfigurationSettingInputModel configurationSettingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (configurationSettingInputModel?.ConfigurationTypeId == null || configurationSettingInputModel.ConfigurationTypeId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfigurationTypeId
                });
            }

            return validationMessages.Count <= 0;
        }

        public static bool GetMandatoryFieldsBasedOnConfiguration(Guid? configurationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages);

            if (configurationId == null || configurationId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NotEmptyConfigurationTypeId
                });
            }

            return validationMessages.Count <= 0;
        }
    }
}