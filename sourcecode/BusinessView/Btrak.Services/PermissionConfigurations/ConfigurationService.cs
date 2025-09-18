using Btrak.Models.FieldPermissions;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;

namespace Btrak.Services.PermissionConfigurations
{
    public class ConfigurationService : IConfigurationService
    {
        private readonly ConfigurationRepository _configurationRepository = new ConfigurationRepository();

        public List<ConfigurationViewModel> GetConfigurations()
        {
            return _configurationRepository.SelectAll().Select(x => new ConfigurationViewModel
            {
                ConfigurationId = x.Id,
                ConfigurationName = x.ConfigurationName,
                CreatedDateTime = x.CreatedDateTime,
                CreatedByUserId = x.CreatedByUserId
            }).ToList();
        }

        public void AddOrUpdateConfiguration(ConfigurationViewModel configurationViewModel, LoggedInContext loggedInContext)
        {
            ConfigurationDbEntity configurationDbEntity;

            if (configurationViewModel.ConfigurationId == Guid.Empty)
            {
                configurationDbEntity = new ConfigurationDbEntity
                {
                    Id = Guid.NewGuid(),
                    ConfigurationName = configurationViewModel.ConfigurationName,
                    CreatedByUserId = loggedInContext.LoggedInUserId,
                    CreatedDateTime = DateTime.Now
                };

                _configurationRepository.Insert(configurationDbEntity);

                var configurationId = configurationDbEntity.Id;
                if (configurationId != Guid.Empty)
                {
                    _configurationRepository.AddFieldPermissionsBasedOnConfigurationId(configurationId, loggedInContext);
                }
            }
        }

        public ConfigurationViewModel GetConfiguration(Guid configurationId)
        {
            var configuration = _configurationRepository.GetConfiguration(configurationId);

            ConfigurationViewModel configurationViewModel = new ConfigurationViewModel()
            {
                ConfigurationId = configuration.Id,
                ConfigurationName = configuration.ConfigurationName
            };
            return configurationViewModel;
        }

        public bool CheckConfigurationExists(ConfigurationViewModel configurationViewModel)
        {
            var configuration = _configurationRepository.GetConfigurationBasedOnConfigurationName(configurationViewModel.ConfigurationName);
            var isConfigurationExists = configuration != null && (configurationViewModel.ConfigurationId == Guid.Empty || configurationViewModel.ConfigurationId != configuration.ConfigurationId);
            return isConfigurationExists;
        }
    }
}
