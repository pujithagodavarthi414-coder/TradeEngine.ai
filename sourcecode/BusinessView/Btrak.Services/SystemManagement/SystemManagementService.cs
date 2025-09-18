using System.Collections.Generic;
using System.Linq;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.SystemManagement;
using Btrak.Dapper.Dal.Partial;

namespace Btrak.Services.SystemManagement
{
    public class SystemManagementService: ISystemManagementService
    {
        private readonly SystemCurrencyRepository _systemCurrencyRepository;
        private readonly SystemCountryRepository _systemCountryRepository;
        private readonly SystemRoleRepository _systemRoleRepository;

        public SystemManagementService(SystemCurrencyRepository systemCurrencyRepository, SystemCountryRepository systemCountryRepository, SystemRoleRepository systemRoleRepository)
        {
            _systemCurrencyRepository = systemCurrencyRepository;
            _systemCountryRepository = systemCountryRepository;
            _systemRoleRepository = systemRoleRepository;
        }

        public List<SystemCurrencyApiReturnModel> SearchSystemCurrencies(SystemCurrencySearchCriteriaInputModel systemCurrencySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemCurrencies", "systemCurrencySearchCriteriaInputModel", systemCurrencySearchCriteriaInputModel, "SystemManagementService"));

            List<SystemCurrencyApiReturnModel> systemCurrencies = _systemCurrencyRepository.SearchSystemCurrencies(systemCurrencySearchCriteriaInputModel, validationMessages).ToList();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCurrencies", "SystemManagementService"));

            return systemCurrencies;
        }

        public List<SystemCountryApiReturnModel> SearchSystemCountries(SystemCountrySearchCriteriaInputModel systemCountrySearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemCountries", "systemCountrySearchCriteriaInputModel", systemCountrySearchCriteriaInputModel, "SystemManagementService"));

            List<SystemCountryApiReturnModel> systemCountries = _systemCountryRepository.SearchSystemCountries(systemCountrySearchCriteriaInputModel, validationMessages).ToList();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemCountries", "SystemManagementService"));

            return systemCountries;
        }

        public List<SystemRoleApiReturnModel> SearchSystemRoles(SystemRoleSearchCriteriaInputModel systemRoleSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchSystemRoles", "systemRoleSearchCriteriaInputModel", systemRoleSearchCriteriaInputModel, "SystemManagementService"));

            List<SystemRoleApiReturnModel> systemRoles = _systemRoleRepository.SearchSystemRoles(systemRoleSearchCriteriaInputModel, validationMessages).ToList();

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchSystemRoles", "SystemManagementService"));

            return systemRoles;
        }
    }
}
