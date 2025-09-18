using Btrak.Models;
using Btrak.Models.MasterData;
using Btrak.Models.Performance;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.MasterData
{
    public interface IGenericFormMasterDataService
    {
        Guid? UpsertGenericFormType(GenericFormTypeUpsertModel genericFormTypeUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetGenericFormTypesOutputModel> GetGenericFormTypes(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetGenericFormTypesOutputModel> GetGenericFormTypesAnonymous(GetGenericFormTypesSearchCriteriaInputModel getFormTypesSearchCriteriaInputModel, List<ValidationMessage> validationMessages);
        Guid? UpsertCustomFormSubmission(CustomFormSubmissionUpsertModel customFormType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetCustomFormSubmissionOutputModel> GetCustomFormSubmissions(CustomFormSubmissionSearchCriteriaInputModel customFormTypeSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertInductionConfiguration(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InductionModel> GetInductionConfigurations(InductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeInductionModel> GetEmployeeInductions(EmployeeInductionModel inductionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertExitConfiguration(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExitModel> GetExitConfigurations(ExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeExitModel> GetEmployeeExits(EmployeeExitModel exitModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}