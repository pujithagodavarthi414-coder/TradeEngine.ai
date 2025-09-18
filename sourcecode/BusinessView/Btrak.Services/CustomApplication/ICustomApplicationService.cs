using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.GenericForm;
using System.Web;
using DocumentFormat.OpenXml.Packaging;
using CamundaClient.Dto;
using Btrak.Models.CustomFields;

namespace Btrak.Services.CustomApplication
{
    public interface ICustomApplicationService
    {
        Guid? UpsertCustomApplication(CustomApplicationUpsertInputModel customApplicationUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<CustomApplicationSearchOutputModel> GetCustomApplication(CustomApplicationSearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        CustomApplicationSearchOutputModel GetCustomApplicationKeysSelected(CustomApplicationSearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        CustomApplicationSearchOutputModel GetPublicCustomApplicationById(CustomApplicationSearchInputModel customApplication, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpsertCustomApplicationKeys(CustomApplicationKeyUpsertInputModel customApplicationUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<CustomApplicationKeySearchOutputModel> GetCustomApplicationKeys(CustomApplicationKeySearchInputModel customApplicationSearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);

        Guid? UpsertCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<CustomApplicationWorkflowSearchOutputModel> GetCustomApplicationWorkflow(CustomApplicationWorkflowUpsertInputModel customApplicationWorkflowSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<CustomApplicationWorkflowTypeReturnModel> GetCustomApplicationWorkflowTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<string> GetCustomApplicationValuesByKeys(Guid customApplicationId,string key, List<ValidationMessage> validationMessages);

        bool ImportVerifiedApplication(ValidatedSheetsImportModel validatedSheets, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        FormImportsRawModel ImportCustomApplicationFromExcel(Guid applicationId, string formName, SpreadsheetDocument spreadSheetDocument, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<UserTasksModel> GetHumanTaskList(string processDefinitionKey, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        void CompleteUserTask(string taskId, bool isApproved);

        Guid? UpsertObservationType(ObservationTypeModel observationType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ObservationTypeModel> GetObservationType(ObservationTypeModel observationTypeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<FormHistoryModel> GetFormHistory(FormHistoryModel formHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<ResidentObservationApiReturnModel> GetResidentObservations(CustomFieldSearchCriteriaInputModel customFieldSearchCriteriaModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UpsertDataLevelKeyConfigurationModel> GetLevels(GetLevelsKeyConfigurationModel upsertDataLevelKeyConfiguration, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertLevel(UpsertLevelModel observationType, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CustomApplicationSearchOutputModel> GetCustomApplicationUnAuth(CustomApplicationSearchInputModel customApplicationSearchInputModel, List<ValidationMessage> validationMessages);

    }
}
