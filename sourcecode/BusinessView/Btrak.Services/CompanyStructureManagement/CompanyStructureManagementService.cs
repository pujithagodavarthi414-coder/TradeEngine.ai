using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructureManagement;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.CompanyStructureManagement;
using BTrak.Common;
using Omu.ValueInjecter;

namespace Btrak.Services.CompanyStructureManagement
{
    public class CompanyStructureManagementService: ICompanyStructureManagementService
    {
        private readonly CountryRepository _countryRepository;
        private readonly RegionRepository _regionRepository;
        private readonly IAuditService _auditService;

        public CompanyStructureManagementService(CountryRepository countryRepository, RegionRepository regionRepository, IAuditService auditService)
        {
            _countryRepository = countryRepository;
            _regionRepository = regionRepository;
            _auditService = auditService;
        }

        public Guid? UpsertCountry(CountryUpsertInputModel countryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertCountry", "CompanyStructureManagement Service"));

            countryUpsertInputModel.CountryName = countryUpsertInputModel.CountryName?.Trim();

            LoggingManager.Debug(countryUpsertInputModel.ToString());

            if (!CompanyStructureManagementValidations.ValidateUpsertCountry(countryUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            countryUpsertInputModel.CountryId = _countryRepository.UpsertCountry(countryUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertCountryCommandId, countryUpsertInputModel, loggedInContext);

            LoggingManager.Debug(countryUpsertInputModel.CountryId?.ToString());

            return countryUpsertInputModel.CountryId;
        }

        public List<CountryApiReturnModel> GetCountries(CountrySearchInputModel countrySearchInputModel, List<ValidationMessage> validationMessages,LoggedInContext loggedInContext)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCountries", "CompanyStructureManagement Service"));

            LoggingManager.Debug(countrySearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCountriesCommandId, countrySearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CountryApiReturnModel> countryReturnModels = _countryRepository.GetCountries(countrySearchInputModel, validationMessages,loggedInContext).ToList();

            return countryReturnModels;
        }

        public Guid? UpsertRegion(RegionUpsertInputModel regionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertRegion", "CompanyStructureManagement Service"));

            regionUpsertInputModel.RegionName = regionUpsertInputModel.RegionName?.Trim();

            LoggingManager.Debug(regionUpsertInputModel.ToString());

            if (!CompanyStructureManagementValidations.ValidateUpsertRegion(regionUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            regionUpsertInputModel.RegionId = _regionRepository.UpsertRegion(regionUpsertInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertRegionCommandId, regionUpsertInputModel, loggedInContext);

            LoggingManager.Debug(regionUpsertInputModel.RegionId?.ToString());

            return regionUpsertInputModel.RegionId;
        }

        public List<RegionApiReturnModel> GetRegions(RegionSearchInputModel regionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCountries", "CompanyStructureManagement Service"));

            LoggingManager.Debug(regionSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetRegionsCommandId, regionSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<RegionApiReturnModel> regionReturnModels = _regionRepository.GetRegions(regionSearchInputModel, loggedInContext, validationMessages).ToList();
            
            return regionReturnModels;
        }

        public List<CompanyStructureApiReturnModel> GetCompanyStructure(CompanyStructureSearchInputModel companyStructureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCompanyStructure", "CompanyStructureManagement Service"));

            LoggingManager.Debug(companyStructureSearchInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetCompanyStructureCommandId, companyStructureSearchInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<CompanyStructureSpReturnModel> companyStructureSpReturnModels = _countryRepository.GetCompanyStructure(companyStructureSearchInputModel, loggedInContext, validationMessages).ToList();

            List<CompanyStructureApiReturnModel> companyStructureApiReturnModel = new List<CompanyStructureApiReturnModel>();

            if (companyStructureSpReturnModels.Count > 0)
            {
                companyStructureApiReturnModel = companyStructureSpReturnModels.Select(ConvertToCompanyStructureApiReturnModel).ToList();
            }

            return companyStructureApiReturnModel;
        }
        
        private CompanyStructureApiReturnModel ConvertToCompanyStructureApiReturnModel(CompanyStructureSpReturnModel companyStructureSpReturnModel)
        {
            CompanyStructureApiReturnModel companyStructureApiReturnModel = new CompanyStructureApiReturnModel();

            companyStructureApiReturnModel.InjectFrom<NullableInjection>(companyStructureSpReturnModel);

            var regionsXml = companyStructureSpReturnModel.RegionsXml;
            if (regionsXml != null)
            {
                var regionsList = Utilities.GetObjectFromXml<RegionApiReturnModel>(regionsXml, "RegionApiReturnModel");
                companyStructureApiReturnModel.Regions = regionsList;
            }
            
            return companyStructureApiReturnModel;
        }
    }
}
