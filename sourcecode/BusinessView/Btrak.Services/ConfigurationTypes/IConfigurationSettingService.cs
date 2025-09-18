using Btrak.Models;
using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models.ConfigurationType;

namespace Btrak.Services.ConfigurationTypes
{
    public interface IConfigurationSettingService
    {
        Guid? UpsertConfigurationSettings(Guid? configurationId, ConfigurationSettingUpsertInputModel configurationSettingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ConfigurationSettingApiReturnModel> GetAllConfigurationSettings(ConfigurationSettingInputModel configurationSettingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ConfigurationTypeApiReturnModel> GetMandatoryFieldsBasedOnConfiguration(Guid? configurationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
