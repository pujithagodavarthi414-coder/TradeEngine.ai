using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.ConfigurationType;
using Btrak.Services.Audit;
using Btrak.Services.Helpers.ConfigurationType;
using BTrak.Common;

namespace Btrak.Services.ConfigurationTypes
{
    public class ConfigurationSettingService : IConfigurationSettingService
    {
        private readonly ConfigurationTypeRepository _configurationTypeRepository;
        private readonly IAuditService _auditService;

        public ConfigurationSettingService(ConfigurationTypeRepository configurationTypeRepository, IAuditService auditService)
        {
            _configurationTypeRepository = configurationTypeRepository;
            _auditService = auditService;
        }

        public Guid? UpsertConfigurationSettings(Guid? configurationId, ConfigurationSettingUpsertInputModel configurationSettingUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered Upsert Configuration Settings for configurationId " + configurationId + ", configurationSettingUpsertInputModel=" + configurationSettingUpsertInputModel + ", Logged in User Id=" + loggedInContext.LoggedInUserId);

            Guid? fieldPermissionId = configurationSettingUpsertInputModel?.FieldPermissionId;

            if (!ConfigurationSettingServiceValidation.UpsertConfigurationSettingsValidation(configurationId, configurationSettingUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (configurationSettingUpsertInputModel != null)
            {
                if (configurationSettingUpsertInputModel.FieldPermissionId == null || configurationSettingUpsertInputModel.FieldPermissionId == Guid.Empty)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotEmptyFieldPermissionId
                    });

                    return null;
                }
            }

            string configurationSettingXml = null;

            if (configurationSettingUpsertInputModel != null)
            {
                configurationSettingXml = Utilities.GetXmlFromObject(configurationSettingUpsertInputModel);
            }

            if (configurationSettingUpsertInputModel == null)
            {
                configurationId = _configurationTypeRepository.UpsertConfigurationSettings(configurationId, null, loggedInContext, validationMessages);

                if (configurationId != Guid.Empty)
                {
                    LoggingManager.Debug("New configuration settings for the configuration id " + configurationId + " has been created.");

                    _auditService.SaveAudit(AppCommandConstants.UpsertConfigurationSettingsCommandId, (ConfigurationSettingUpsertInputModel)null, loggedInContext);

                    return configurationId;
                }

                throw new Exception(ValidationMessages.ExceptionConfigurationSettingsCouldNotBeCreated);
            }

            _configurationTypeRepository.UpsertConfigurationSettings(configurationId, configurationSettingXml, loggedInContext, validationMessages);

            LoggingManager.Debug("Field permissions for the fieldPermissionId" + fieldPermissionId + " has been updated.");

            _auditService.SaveAudit(AppCommandConstants.UpsertConfigurationSettingsCommandId, configurationSettingXml, loggedInContext);

            return fieldPermissionId;
        }

        public List<ConfigurationSettingApiReturnModel> GetAllConfigurationSettings(ConfigurationSettingInputModel configurationSettingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllConfigurationSettings", "Configuration Setting Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllConfigurationSettingsCommandId, configurationSettingInputModel, loggedInContext);

            if (!ConfigurationSettingServiceValidation.GetAllConfigurationSettingsValidations(configurationSettingInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (configurationSettingInputModel.ProjectId != null)
            {
                configurationSettingInputModel.UserId = loggedInContext.LoggedInUserId;
            }

            List<ConfigurationSettingApiReturnModel> configurationSettingsList = _configurationTypeRepository.GetAllConfigurationSettings(configurationSettingInputModel, loggedInContext, validationMessages).ToList();
            return configurationSettingsList;
        }

        public List<ConfigurationTypeApiReturnModel> GetMandatoryFieldsBasedOnConfiguration(Guid? configurationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetMandatoryFieldsBasedOnConfiguration", "Configuration Setting Service"));


            if (!ConfigurationSettingServiceValidation.GetMandatoryFieldsBasedOnConfiguration(configurationId,
                loggedInContext, validationMessages))
            {
                return null;
            }

            List<ConfigurationTypeApiReturnModel> configurationTypeReturnModels = _configurationTypeRepository.GetMandatoryFieldsBasedOnConfiguration(configurationId, loggedInContext, validationMessages).ToList();
            
            return configurationTypeReturnModels;
        }
    }
}
