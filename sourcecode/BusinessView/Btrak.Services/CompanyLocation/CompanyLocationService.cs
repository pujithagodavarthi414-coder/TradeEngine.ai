using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyLocation;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.CompanyLocationValidationHelpers;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.CompanyLocation
{
    public class CompanyLocationService : ICompanyLocationService
    {
        private readonly CompanyLocationRepository _companyLocationRepository;
        private readonly IAuditService _auditService;

        public CompanyLocationService(CompanyLocationRepository companyLocationRepository, IAuditService auditService)
        {
            _companyLocationRepository = companyLocationRepository;
            _auditService = auditService;
        }

        public Guid? UpsertCompanyLocation(CompanyLocationInputModel companyLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertCompanyLocation", "companyLocationInputModel", companyLocationInputModel, "Company Location Service"));

            if (!CompanyLocationValidationHelper.UpsertCompanyLocationValidation(companyLocationInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            companyLocationInputModel.CompanyLocationId = _companyLocationRepository.UpsertCompanyLocation(companyLocationInputModel, loggedInContext, validationMessages);

            LoggingManager.Debug("Company location with the id " + companyLocationInputModel.CompanyLocationId);
            _auditService.SaveAudit(AppCommandConstants.UpsertCompanyLocationCommandId, companyLocationInputModel, loggedInContext);
            return companyLocationInputModel.CompanyLocationId;
        }

        public List<CompanyLocationOutputModel> SearchCompanyLocation(CompanyLocationInputSearchCriteriaModel companyLocationInputSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "SearchCompanyLocation", "companyLocationInputSearchCriteriaModel", companyLocationInputSearchCriteriaModel, "Company Location Service"));
            _auditService.SaveAudit(AppCommandConstants.SearchCompanyLocationCommandId, companyLocationInputSearchCriteriaModel, loggedInContext);
            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            LoggingManager.Info("Getting CompanyLocation search list ");
            List<CompanyLocationOutputModel> companyLocationReturnList = _companyLocationRepository.SearchCompanyLocation(companyLocationInputSearchCriteriaModel, loggedInContext, validationMessages).ToList();
            return companyLocationReturnList;
        }

        public CompanyLocationOutputModel GetCompanyLocationById(Guid? locationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetCompanyLocationById", "locationId", locationId, "CompanyLocation Service"));
           
            if (!CompanyLocationValidationHelper.GetCompanyLocationByIdValidation(locationId, loggedInContext, validationMessages))
            {
                return null;
            }

            CompanyLocationInputSearchCriteriaModel searchCriteriaModel = new CompanyLocationInputSearchCriteriaModel { CompanyLocationId = locationId };
            LoggingManager.Info("Getting Company Location by Id ");
            _auditService.SaveAudit(AppCommandConstants.GetCompanyLocationByIdCommandId, searchCriteriaModel, loggedInContext);
            CompanyLocationOutputModel companyLocationList = _companyLocationRepository.SearchCompanyLocation(searchCriteriaModel, loggedInContext, validationMessages).FirstOrDefault();
            if (companyLocationList != null) return companyLocationList;
            validationMessages.Add(new ValidationMessage
            {
                ValidationMessageType = MessageTypeEnum.Error,
                ValidationMessaage = string.Format(ValidationMessages.NotFoundCompanyLocationWithTheId, locationId)
            });
            return null;
        }
    }
}
