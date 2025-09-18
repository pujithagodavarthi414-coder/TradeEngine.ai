using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.CompanyLocation;
using BTrak.Common;

namespace Btrak.Services.CompanyLocation
{
    public interface ICompanyLocationService
    {
        Guid? UpsertCompanyLocation(CompanyLocationInputModel companyLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyLocationOutputModel> SearchCompanyLocation(CompanyLocationInputSearchCriteriaModel companyLocationInputSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyLocationOutputModel GetCompanyLocationById(Guid? locationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
