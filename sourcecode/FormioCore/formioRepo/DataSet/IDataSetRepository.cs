using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using formioModels;
using formioModels.Dashboard;
using formioModels.Data;
using formioModels.ProfitAndLoss;

namespace formioRepo.DataSet
{
    public interface IDataSetRepository
    {
        Guid? CreateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> CreateMultipleDataSetSteps(List<DataSetUpsertInputModel> dataSetUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        Guid? UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserDatasetRelationOutputModel GetUserDataSetRelation(Guid? userId, Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages);
        Guid? UpdatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSetJob(DataSetUpsertInputModel dataSetUpsertInputModel,
             List<ValidationMessage> validationMessages);
        List<DataSetOutputModel> SearchDataSets(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSetOutputModelForForms> SearchDataSetsForForms(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<DataSetOutputModelForForms> SearchDataSetsForFormsUnAuth(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
            List<ValidationMessage> validationMessages);


        List<DataSetOutputModel> SearchDataSetsForJob(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
             List<ValidationMessage> validationMessages);
        List<DataSetOutputModel> GetDataSetsById(Guid? id, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        List<DataSetKeyOutputModel> GetDataSetByDataSourceId(Guid? id, Guid? keyId, LoggedInContext loggedInContext,
          List<ValidationMessage> validationMessages);
        int? GetDataSetCountBasedOnTodaysCount(List<ValidationMessage> validationMessages);
        int? GetDataSetLatestRFQId(Guid tempalteTypeId, List<ValidationMessage> validationMessages);
        List<DataSetOutputModel> GetLatestSwitchBlDataSets(bool isSwitchBl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetDataSetLatestProgramId(Guid? tempalteTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteDatasetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PositionDashboardOutputModel GetDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalReliasedOutputModel GetRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalUnReliasedOutputModel GetUnRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<DataSetOutputModel> UpdateDataSetByJob(Guid id, string fieldName, List<FormsMiniModelForUpdate> model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateDataSetByKey(Guid id, string key, object value, LoggedInContext loggedInContext);
        List<string> GetUniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetQueryData(GetQueryDataInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName,
            List<ValidationMessage> validationMessages);
        Guid? UpdateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel,
             List<ValidationMessage> validationMessages);
    }
}
