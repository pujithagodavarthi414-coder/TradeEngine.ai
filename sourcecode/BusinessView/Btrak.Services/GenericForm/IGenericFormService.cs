using Btrak.Models;
using Btrak.Models.Employee;
using Btrak.Models.FormDataServices;
using Btrak.Models.FormTypes;
using Btrak.Models.GenericForm;
using Btrak.Models.Role;
using Btrak.Models.Widgets;
using Btrak.Models.WorkFlow;
using Btrak.Models.WorkflowManagement;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.GenericForm
{
    public interface IGenericFormService
    {
        void UpdateProcessInstanceStatus();
        Task<Guid?> UpsertGenricFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpsertGenricFormSubmittedUnAuth(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages);
        Task<GenericFormApiReturnModel> UpsertGenericForms(GenericFormUpsertInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormApiReturnModel> GetGenericForms(GenericFormSearchCriteriaInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormApiReturnModel> GetGenericFormsUnAuth(GenericFormSearchCriteriaInputModel genericFormModel, List<ValidationMessage> validationMessages);
        List<DataSourceKeysOutputModel> GetFormsFieldsByDataSource(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertWorkflow(WorkflowModel workflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateWorkflow(WorkflowModel workflowModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages); 
        List<GenericFormApiReturnModel> GetForms(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormApiReturnModel> GetGenericFormsByTypeId(Guid formTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FormTypeApiReturnModel> GetFormTypes(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string UpsertPublicGenericFormSubmitted(GenericFormSubmittedUpsertInputModel genericformSubmittedUpsertInputModel, List<ValidationMessage> validationMessages);
        Guid? UpsertGenericFormKey(GenericFormKeyUpsertInputModel genericFormKeyUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertFormWorkflow(FormWorkflowInputModel formWorkflowInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormKeySearchOutputModel> GetGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmitted(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<GetCustomeApplicationTagOutputModel> GetCustomApplicationTag(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FilterKeyValuePair> GetCustomApplicationTagKeys(GetCustomApplicationTagInpuModel getCustomApplicationTagInpuModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetTrendsOutputModel> GetTrends(GetTrendsInputModel getTrendsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmittedDataByKeyName(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, List<ValidationMessage> validationMessages);
        string ProcessCustomApplicationWorkflow(Dictionary<string, object> inputProperties, string customApplicationName,string customApplicationWorkflowName, string customApplicationWorkflowTrigger, LoggedInContext loggedInContext);
        List<GenericFormKeySearchOutputModel> GetEmployeeGenericFormKey(GenericFormKeySearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FormFieldValuesOuputModel GetFormFieldValues(GenericFormSubmittedSearchInputModel searchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormApiReturnModel> GetFormsWithField(GetFormsWithFieldInputModel getFormRecord, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserListApiOutputModel> GetUsersBasedonRole(string roleIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<FormFieldModel> GetFormsFields(FormfieldWorkFlowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
     
        List<RolesOutputModel> GetRoles(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ShareGenericFormSubmitted(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        //TODO
        FormFieldValuesOuputModel GetFormFieldValuesDummy(GenericFormSubmittedSearchInputModel searchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string BackgroundLookupLink(Guid customApplicationId, Guid formId, string companyIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
         Task<List<string>> UniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        object GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateLookupChildDataWithNewVar();

        Guid? UpsertActivity(ActivityModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivityOutputModel> GetActivity(ActivityModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertError(ErrorModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ErrorOutputModel> GetError(ErrorModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkflowOutputModel> GetWorkflows(WorkflowModel workflowModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<WorkflowOutputModel> GetWorkflowById(Guid? id,Guid? dataSourceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetProcessInstanceByFormSubmittedId(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);       
        dynamic Check(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormApiReturnModel> GetDataServiceGenericForms(GenericFormSearchCriteriaInputModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSourceKeysOutputModel> GetDataServiceFormsFields(FormWorkflowModel genericFormModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        dynamic GetFormRecordValues(GetFormRecordValuesInputModel getFormRecordValues, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<WorkflowDataSourceModel>> SearchDataSourceForWorkflows(Guid? id, Guid? companyModuleId, string searchText, bool? isArchived, string dataSourceType, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid?> CreateDataSource(WorkflowDataSourceModel workflowDataSourceModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> CreateDataSet(WorkflowDataSetModel workflowDataSetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void StartWorkflowProcessInstance(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void StartWorkflowProcessInstanceXml(GenericFormSubmittedUpsertInputModel genericFormSubmittedUpsertInputModel, Guid? dataSourceId, WorkFlowTriggerModel workFlowTriggerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string addonToMails = null);
        void MailWorkFlowTrigger(MailWorkFlowTriggerInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormSubmittedSearchOutputModel> GetGenericFormSubmittedUnAuth(GenericFormSubmittedSearchInputModel genericFormKeySearchInputModel, List<ValidationMessage> validationMessages);
        void SendGeneratedReporttoMail(SendGeneratedReporttoMailInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void RunWorkFlows(RunWorkFlowsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task UpsertGenericFormSubmittedFromExcel(GenericFormSubmittedFromExcelInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetAllFilesOfFormSubmittedOutputModel> GetAllFilesOfFormSubmitted(GetAllFilesOfFormSubmittedInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ShareDashBoardAsPDF(ShareDashBoardAsPDFInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ExcelSheetDetailsOutputModel> GetExcelSheetDetailsForProcessing(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GenericFormHistoryOutputModel> SearchGenericFormHistory(Guid? referenceId, int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}

