using Btrak.Models;
using Btrak.Models.Lives;
using BTrak.Common;
using DocumentFormat.OpenXml.Packaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.Lives
{
    public interface ILivesService
    {
        List<BasicProgramOutputModel> GetProgramBasicDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLivesProgram(ProgramUpsertModel programUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertESGIndicators(ESGIndicatorsInputModel eSGIndicatorsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ESGIndicatorOutputModel> GetESGIndicatorsDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertValidatorDetails(ValidatorInputModel validatorInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ValidatorOutputModel> GetValidatorDetails(ValidatorSearchInputModel validatorSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertBudgetAndInvestments(BudgetAndInvestmentsInputModel budgetAndInvestmentsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<BudgetAndInvestmentsOutputModel> GetBudgetAndInvestments(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserLevelAccessOutputModel> GetUserLevelAccess(UserLevelAccessModel userLevelAccessModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertUserLevelAccess(UserLevelAccessModel userLevelAccessModel,string referenceText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateShowInerestOnProgram(ProgramUpsertModel programUpsert, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic ImportProgramProgress(Guid applicationId, SpreadsheetDocument spreadSheetDocument, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertProgramProgress(ProgramProgressInputModel programProgressInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        BasicProgramOutputModel GetProgramOverviewDetails(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ProgramProgressOutputModel> GetProgramProgress(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetIndependentSmallholderCertification(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetKPI1CertifiedSHFsLocation(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetKPI2FFBProductivityPhase01Location(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetKPI3LogisticalProblemLocation(ProgramSearchInputModel programSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object DeleteformIOdynamic(string Id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object DeleteDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
