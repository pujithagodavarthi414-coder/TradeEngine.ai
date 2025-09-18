using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyStructureManagement;
using BTrak.Common;

namespace Btrak.Services.CompanyStructureManagement
{
    public interface ICompanyStructureManagementService
    {
        Guid? UpsertCountry(CountryUpsertInputModel countryUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CountryApiReturnModel> GetCountries(CountrySearchInputModel countrySearchInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        Guid? UpsertRegion(RegionUpsertInputModel regionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RegionApiReturnModel> GetRegions(RegionSearchInputModel regionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyStructureApiReturnModel> GetCompanyStructure(CompanyStructureSearchInputModel companyStructureSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
