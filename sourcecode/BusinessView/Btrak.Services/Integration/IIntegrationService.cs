using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Btrak.Models.Integration;
using Btrak.Models;

namespace Btrak.Services.Integration
{
    public interface IIntegrationService
    {
        bool ValidateIntegrationDetails(IntegrationDetailsModel  integrationDetailsModel, LoggedInContext loggedInContext);
        List<MyWorkDetailsModel> GetUserWorkItems(Guid? integrationTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool AddWorkLogTime(WorkLogTimeInputModel addWorkLogInputModel,LoggedInContext loggedInContext);
        List<IntegrationTypesDetailsModel> GetIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IntegrationTypesDetailsModel> GetUserIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<IntegrationTypesDetailsModel> GetCompanyIntegrationTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CompanyOrUserLevelIntegrationDetailsModel> GetCompanyLevelIntrgrations(CompanyLevelIntegrationsInputModel companylevelintegrationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? AddOrUpdateCompanyLevelIntegration(CompanyOrUserLevelIntegrationDetailsModel companylevelintegrationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
