using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.SystemManagement;

namespace Btrak.Services.SystemManagement
{
    public interface ISystemManagementService
    {
        List<SystemCurrencyApiReturnModel> SearchSystemCurrencies(SystemCurrencySearchCriteriaInputModel systemCurrencySearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        List<SystemCountryApiReturnModel> SearchSystemCountries(SystemCountrySearchCriteriaInputModel systemCountrySearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        List<SystemRoleApiReturnModel> SearchSystemRoles(SystemRoleSearchCriteriaInputModel systemRoleSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
    }
}
