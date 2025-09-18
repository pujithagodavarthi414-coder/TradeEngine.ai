using Btrak.Models;
using Btrak.Models.CustomApplication;
using Btrak.Models.FormDataServices;
using Btrak.Models.GenericForm;
using Btrak.Models.Notification;
using Btrak.Models.PositionTable;
using Btrak.Models.TradeManagement;
using Btrak.Models.Widgets;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Services.FormDataServices
{
    public interface IDataSetService
    {
        Task<Guid> CreateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> CreateDataSetGeneriForm(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> CreateDataSetGeneriFormUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationmessages);
        Task<Guid> UpdateDataSetJson(UpdateDataSetJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<string> CreateMultipleDataSet(List<DataSetUpsertInputModel> dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> CreatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationmessages);
        Task<object> GetDataSetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<DataSetOutputModel>> SearchDataSets(Guid? id, Guid? dataSourceId, string searchText,string jsonModel, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages,bool? isInnerQuery, bool? forFormFieldValue, string keyName, string keyValue, bool? forRecordValue, string paths = null, string companyIds = null, string mongoUrl = null);
        Task<List<DataSetOutputModelForForms>> SearchDataSetsForForms(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, bool advancedFilter, string fieldsJson, string KeyFilterJson,bool isRecordLevelPermissionEnabled,int ConditionalEnum,string RoleIds, string recordFilterJson, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<DataSetOutputModelForForms>> SearchDataSetsForFormsUnAuth(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, bool advancedFilter, string fieldsJson, string KeyFilterJson, List<ValidationMessage> validationmessages);
        Task<Guid> CreateDataSetHistory(DataSetHistoryInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<int?> GetDataSetsCountBasedOnTodaysCount(LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<int?> GetPublicDataSetsCountBasedOnTodaysCount(List<ValidationMessage> validationmessages);
        Task<Guid> CreateExecutionDataSet(DataSetUpsertInputModel purchaseExecutionModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<ExecutionStepsDataSetOutputModel>> SearchExecutionStepsDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<string> CreateMultipleDataSetSteps(List<DataSetUpsertInputModel> dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<Guid> CreateUserDataSetRelation<T>(T inputModel, string referenceText, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<DataSetLivesOutputModel>> SearchLivesDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        dynamic SearchDynamicDataSets(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        dynamic SearchDynamicDataSetsWithReference(Guid? id, Guid? dataSourceId, string searchText, string dataJsonValues, bool? isArchived, bool? isPagingRequired, int? pageNumber, int? pageSize, string referenceText, Guid? referenceId, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        dynamic DeleteDynamicDataSets(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        object DeleteDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<FormFieldValuesOuputModel> GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<dynamic> GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<PositionDashboardOutputModel> GetPositionTable(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<FinalReliasedOutputModel> GetRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<Guid?> UpdateUserContractQuantity(QuantityInputModel quantityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<FinalUnReliasedOutputModel> GetUnRealisedProfitAndLoss(string productType, DateTime? fromDate, DateTime? ToDate, string ContractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<InstanceLevelPositionDashboardOutputModel> GetInstanceLevelDashboardPositionTable(string productType, string companyName, DateTime? fromDate, DateTime? ToDate,bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<FinalInstanceLevelProfitLossModel>> GetInstanceLevelProfitAndLossDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate,bool? isConsolidated, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<DataServiceOutputModel> GetMongoQueryDetails(string mongoQuery, bool? isHeaderDetails, string collectionName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<string>> GetMongoCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<VesselDashboardModel> GetVesselDashboard(string productType, string companyName, DateTime? fromDate, DateTime? ToDate, bool? isConsolidated, string contractUniqueId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<PositionData>> GetPositionsDashboard(DateTime? fromDate, DateTime? ToDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<List<WebPageViewerModel>> GetWebPageView(string path, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<WebPageViewerModel> SaveWebPageView(WebPageViewerModel webPageViewerModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateYTDPandLHistory();
        Task<List<GetCO2EmmisionReportOutputModel>> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel dataModel, LoggedInContext loggedInContext);
        Task<Guid?> UpdateDataSetWorkflow(UpdateDataSetWorkflowModel updateDataSetWorkflowModel, LoggedInContext loggedInContext);
        Task<bool?> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<bool?> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void NotificationAlertWorkFlow(NotificationAlertModel dataModel, string mongoBaseURL, LoggedInContext loggedInContext);
        List<GenericFormHistoryOutputModel> SearchGenericFormHistory(Guid? referenceId, int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
