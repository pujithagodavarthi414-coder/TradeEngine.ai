using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using formioCommon.Constants;
using formioModels;
using formioModels.Dashboard;
using formioModels.Data;
using formioModels.ProfitAndLoss;
using MongoDB.Bson;
using MongoDB.Driver;

namespace formioRepo.DataSet
{
    public class DataSetFakeRepository : IDataSetRepository
    {
        public Guid? CreateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            dataSetUpsertInputModel.Id = Guid.NewGuid();
            dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
            dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
            return new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
        } 
        public Guid? CreateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName,
             List<ValidationMessage> validationMessages)
        {
            dataSetUpsertInputModel.Id = Guid.NewGuid();
            dataSetUpsertInputModel.CompanyId = Guid.NewGuid();
            dataSetUpsertInputModel.CreatedByUserId = Guid.NewGuid();
            dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
            return new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
        }

        public Guid? UpdateDataSetJob(DataSetUpsertInputModel dataSetUpsertInputModel,
             List<ValidationMessage> validationMessages)
        {
            string filter = "{ '_id' : '" + dataSetUpsertInputModel.Id.ToString() + "'}";
            string update = "{$set: { 'DataJson':'" + dataSetUpsertInputModel.DataJson
                                                    + "','DataSourceId':'" + dataSetUpsertInputModel.DataSourceId.ToString()
                                                    + "','UpdatedDateTime':'" + DateTime.UtcNow
                                                    + "' } }";
            return dataSetUpsertInputModel.Id;
        }
        public Guid? UpdateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel,
             LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            string filter = "{ '_id' : '" + dataSetUpsertInputModel.Id.ToString() + "','CompanyId':'" + loggedInContext.CompanyGuid.ToString() + "'}";
            string update = "{$set: { 'DataJson':'" + dataSetUpsertInputModel.DataJson
                                                    + "','DataSourceId':'" + dataSetUpsertInputModel.DataSourceId.ToString()
                                                    + "','UpdatedDateTime':'" + DateTime.UtcNow
                                                    + "','UpdatedByUserId':'" + loggedInContext.LoggedInUserId.ToString()
                                                    + "' } }";
            return dataSetUpsertInputModel.Id;
        }
        public Guid? UpdateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel,
             List<ValidationMessage> validationMessages)
        {
            string filter = "{ '_id' : '" + dataSetUpsertInputModel.Id.ToString() + "','CompanyId':'" + Guid.NewGuid().ToString() + "'}";
            string update = "{$set: { 'DataJson':'" + dataSetUpsertInputModel.DataJson
                                                    + "','DataSourceId':'" + dataSetUpsertInputModel.DataSourceId.ToString()
                                                    + "','UpdatedDateTime':'" + DateTime.UtcNow
                                                    + "','UpdatedByUserId':'" + Guid.NewGuid().ToString()
                                                    + "' } }";
            return dataSetUpsertInputModel.Id;
        }

        public Guid? CreateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return userDataSetInputModel.UserId;
        }

        public Guid? UpdateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return userDataSetInputModel.UserId;
        }

        public UserDatasetRelationOutputModel GetUserDataSetRelation(Guid? userId, Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new UserDatasetRelationOutputModel();
        }

        public List<DataSetOutputModel> SearchDataSets(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived)
            };
            if (dataSetSearchCriteriaInputModel.SearchText != null)
            {
                filter.Add(new BsonDocument("Name",
                    new BsonDocument("$regex",
                        new Regex($"(?i){dataSetSearchCriteriaInputModel.SearchText.Trim()}"))));
            }
            if (dataSetSearchCriteriaInputModel.DataSourceId != null)
            {
                filter.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
            }
            if (dataSetSearchCriteriaInputModel.Id != null)
            {
                filter.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
            }
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            List<DataSetOutputModel> returnResult = new List<DataSetOutputModel>();
            DataSetOutputModel result = new DataSetOutputModel();
            result.DataSourceId = new Guid("88199da5-1f54-45f2-8990-657b4337a715");
            result.Id = new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
            result.DataJson = "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}";
            returnResult.Add(result);
            return returnResult;
        }

        public List<DataSetOutputModel> SearchDataSetsForJob(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel,
            List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {

                new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived)
            };
            if (dataSetSearchCriteriaInputModel.SearchText != null)
            {
                filter.Add(new BsonDocument("Name",
                    new BsonDocument("$regex",
                        new Regex($"(?i){dataSetSearchCriteriaInputModel.SearchText.Trim()}"))));
            }
            if (dataSetSearchCriteriaInputModel.DataSourceId != null)
            {
                filter.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
            }
            if (dataSetSearchCriteriaInputModel.Id != null)
            {
                filter.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
            }
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            List<DataSetOutputModel> returnResult = new List<DataSetOutputModel>();
            DataSetOutputModel result = new DataSetOutputModel();
            result.DataSourceId = new Guid("88199da5-1f54-45f2-8990-657b4337a715");
            result.Id = new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
            result.DataJson = "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}";
            returnResult.Add(result);
            return returnResult;
        }
        public List<DataSetOutputModel> GetDataSetsById(Guid? id, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("_id", id.ToString())
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            List<DataSetOutputModel> returnResult = new List<DataSetOutputModel>();
            DataSetOutputModel result = new DataSetOutputModel();
            result.DataSourceId = new Guid("88199da5-1f54-45f2-8990-657b4337a715");
            result.Id = new Guid("89eba5de-dcdf-4243-a2a4-81d3ab39a834");
            result.DataJson = "{\"textField2\":\"asd\",\"textArea2\":\"asd\",\"radio3\":\"\",\"textArea3\":\"asd\",\"radio2\":\"\",\"submit\":true}";
            returnResult.Add(result);
            return returnResult;
        }

        public int? GetDataSetCountBasedOnTodaysCount(List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? CreatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Guid? UpdatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<DataSetKeyOutputModel> GetDataSetByDataSourceId(Guid? id, Guid? keyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public int? GetDataSetLatestRFQId(Guid tempalteTypeId, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public Guid? UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<DataSetOutputModel> GetLatestSwitchBlDataSets(bool isSwitchBl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public List<DataSetOutputModelForForms> SearchDataSetsForForms(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public List<DataSetOutputModelForForms> SearchDataSetsForFormsUnAuth(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<Guid?> CreateMultipleDataSetSteps(List<DataSetUpsertInputModel> dataSetUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public string GetDataSetLatestProgramId(Guid? tempalteTypeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Task<object> DeleteDatasetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public Task<object> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public Task<object> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public PositionDashboardOutputModel GetDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public FinalReliasedOutputModel GetRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        FinalUnReliasedOutputModel IDataSetRepository.GetUnRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public void RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<DataSetOutputModel> UpdateDataSetByJob(Guid id, string fieldName, List<FormsMiniModelForUpdate> model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public void UpdateDataSetByKey(Guid id, string key, object value, LoggedInContext loggedInContext)
        {
            throw new NotImplementedException();
        }
        public List<string> GetUniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public string GetQueryData(GetQueryDataInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public List<string> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public void UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
        public void UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
    }
}
