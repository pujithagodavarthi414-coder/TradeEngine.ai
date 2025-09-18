using Btrak.Models.FieldPermissions;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.PermissionConfigurations
{
    public interface IConfigurationService
    {
        List<ConfigurationViewModel> GetConfigurations();
        void AddOrUpdateConfiguration(ConfigurationViewModel configurationViewModel, LoggedInContext loggedInContext);
        ConfigurationViewModel GetConfiguration(Guid configurationId);
        bool CheckConfigurationExists(ConfigurationViewModel configurationViewModel);
    }
}
