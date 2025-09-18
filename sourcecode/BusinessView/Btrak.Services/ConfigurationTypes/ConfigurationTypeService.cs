using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Models.ConfigurationType;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.ConfigurationType;
using System.Diagnostics;

namespace Btrak.Services.ConfigurationTypes
{
    public class ConfigurationTypeService : IConfigurationTypeService
    {
        private readonly ConfigurationTypeRepository _configurationTypeRepository;
        private readonly IAuditService _auditService;

        public ConfigurationTypeService(ConfigurationTypeRepository configurationTypeRepository, IAuditService auditService)
        {
            _configurationTypeRepository = configurationTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertConfigurationType(ConfigurationTypeUpsertInputModel configurationTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertConfigurationType", "ConfigurationType Service"));

            configurationTypeUpsertInputModel.ConfigurationTypeName = configurationTypeUpsertInputModel.ConfigurationTypeName?.Trim();

            LoggingManager.Debug(configurationTypeUpsertInputModel.ToString());

            if (!ConfigurationTypeValidations.ValidateUpsertConfigurationType(configurationTypeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            configurationTypeUpsertInputModel.ConfigurationTypeId = _configurationTypeRepository.UpsertConfigurationType(configurationTypeUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertConfigurationTypeCommandId, configurationTypeUpsertInputModel, loggedInContext);

            LoggingManager.Debug(configurationTypeUpsertInputModel.ConfigurationTypeId.ToString());

            return configurationTypeUpsertInputModel.ConfigurationTypeId;
        }

        public List<ConfigurationTypeApiReturnModel> GetAllConfigurationTypes(ConfigurationTypeInputModel configurationTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConfigurationTypes", "ConfigurationType Service"));

            LoggingManager.Debug(configurationTypeInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetAllConfigurationTypesCommandId, configurationTypeInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<ConfigurationTypeApiReturnModel> configurationTypeReturnModels = _configurationTypeRepository.GetAllConfigurationTypes(configurationTypeInputModel, loggedInContext, validationMessages).ToList();

            return configurationTypeReturnModels;
        }

        public ConfigurationTypeApiReturnModel GetConfigurationTypeById(Guid? configurationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetConfigurationTypeById", "ConfigurationType Service"));

            LoggingManager.Debug(configurationTypeId?.ToString());

            if (!ConfigurationTypeValidations.ValidateConfigurationTypeById(configurationTypeId, loggedInContext, validationMessages))
            {
                return null;
            }

            var configurationTypeInputModel = new ConfigurationTypeInputModel
            {
                ConfigurationTypeId = configurationTypeId
            };

            ConfigurationTypeApiReturnModel configurationTypeReturnModel = _configurationTypeRepository.GetAllConfigurationTypes(configurationTypeInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!ConfigurationTypeValidations.ValidateConfigurationTypeFoundWithId(configurationTypeId, validationMessages, configurationTypeReturnModel))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetConfigurationTypeByIdCommandId, configurationTypeInputModel, loggedInContext);

            return configurationTypeReturnModel;
        }
    }
}
