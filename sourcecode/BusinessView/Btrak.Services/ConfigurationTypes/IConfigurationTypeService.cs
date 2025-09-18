using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.ConfigurationType;

namespace Btrak.Services.ConfigurationTypes
{
    public interface IConfigurationTypeService
    {
        Guid? UpsertConfigurationType(ConfigurationTypeUpsertInputModel configurationTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ConfigurationTypeApiReturnModel> GetAllConfigurationTypes(ConfigurationTypeInputModel configurationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ConfigurationTypeApiReturnModel GetConfigurationTypeById(Guid? configurationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
