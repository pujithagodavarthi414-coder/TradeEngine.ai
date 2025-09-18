using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using formioModels;
using formioModels.Dashboard;
using formioModels.Data;
using formioModels.ProfitAndLoss;

namespace formioServices.Data
{
    public interface IDataSetService
    {
        Guid? CreateDataSet(DataSetInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreateUserDataSetRelation(UserDataSetInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreatePublicDataSet(DataSetInputModel dataSetUpsertInputModel,List<ValidationMessage> validationMessages);
        Guid? UpdatePublicDataSet(DataSetInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages);

        Guid? UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        Guid? UpdateDataSet(DataSetInputModel dataSetUpsertInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSetJob(DataSetInputModel dataSetUpsertInputModel,
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
        int? GetDataSetCountBasedOnTodaysCount(List<ValidationMessage> validationMessages);
        int? GetDataSetLatestRFQId(Guid tempalteTypeId, List<ValidationMessage> validationMessages);
        List<DataSetOutputModel> GetLatestSwitchBlDataSets(bool isSwitchBl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        DataSetKeyOutputModel GetDataSetByKeyId(Guid? id, Guid? keyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<Guid?> CreateMultipleDataSetSteps(List<DataSetInputModel> dataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetDataSetLatestProgramId(Guid? countryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteDatasetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task<object> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PositionDashboardOutputModel GetDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalReliasedOutputModel GetRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        FinalUnReliasedOutputModel GetUnRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetUniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetQueryData(GetQueryDataInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<string> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? CreateDataSetUnAuth(DataSetInputModel dataSetUpsertInputModel,List<ValidationMessage> validationMessages);
        Guid? UpdateDataSetUnAuth(DataSetInputModel dataSetUpsertInputModel,List<ValidationMessage> validationMessages);
    }
}
