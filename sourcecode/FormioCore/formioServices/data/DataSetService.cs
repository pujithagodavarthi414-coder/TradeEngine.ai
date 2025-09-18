using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web.Http;
using formioCommon.Constants;
using formioHelpers;
using formioHelpers.Data;
using formioModels;
using formioModels.Dashboard;
using formioModels.Data;
using formioModels.ProfitAndLoss;
using formioRepo.Dashboard;
using formioRepo.DataSet;
using MongoDB.Bson;

namespace formioServices.Data
{
    public class DataSetService : IDataSetService
    {
        private readonly IDataSetRepository _dataSetRepository;

        public DataSetService(IDataSetRepository iDataSetRepository)
        {
            _dataSetRepository = iDataSetRepository;

        }
        public Guid? CreateDataSet(DataSetInputModel dataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            dataSetUpsertInputModel.SubmittedByFormDrill = dataSetInputModel.SubmittedByFormDrill;
            dataSetUpsertInputModel.SubmittedCompanyId = dataSetInputModel.SubmittedCompanyId;
            dataSetUpsertInputModel.SubmittedUserId = dataSetInputModel.SubmittedUserId;
            dataSetUpsertInputModel.IsNewRecord = dataSetInputModel.IsNewRecord;
            dataSetUpsertInputModel.RecordAccessibleUsers = dataSetInputModel.RecordAccessibleUsers;
            dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());

            if (!DataSourceValidations.ValidateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (dataSetUpsertInputModel.Id == null || dataSetInputModel.IsNewRecord == true)
            {
                int? dataSetCount = GetDataSetCountBasedOnTodaysCount(new List<ValidationMessage>());
                string todayDate = DateTime.Now.ToString("ddMyyyy");
                string uniqueNumber = todayDate + (dataSetCount + 1);
                dataSetUpsertInputModel.DataJson["UniqueNumber"] = uniqueNumber;
                dataSetUpsertInputModel.Id = _dataSetRepository.CreateDataSet(dataSetUpsertInputModel, dataSetInputModel.CommodityName, loggedInContext, validationMessages);
            }
            else if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
            {
                dataSetUpsertInputModel.Id = _dataSetRepository.UpdateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages);
            }

            return dataSetUpsertInputModel.Id;
        }
        public Guid? CreateDataSetUnAuth(DataSetInputModel dataSetInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetService"));

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            dataSetUpsertInputModel.SubmittedByFormDrill = dataSetInputModel.SubmittedByFormDrill;
            dataSetUpsertInputModel.SubmittedCompanyId = dataSetInputModel.SubmittedCompanyId;
            dataSetUpsertInputModel.SubmittedUserId = dataSetInputModel.SubmittedUserId;
            dataSetUpsertInputModel.IsNewRecord = dataSetInputModel.IsNewRecord;
            dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());


            if (dataSetUpsertInputModel.Id == null || dataSetInputModel.IsNewRecord == true)
            {
                int? dataSetCount = GetDataSetCountBasedOnTodaysCount(new List<ValidationMessage>());
                string todayDate = DateTime.Now.ToString("ddMyyyy");
                string uniqueNumber = todayDate + (dataSetCount + 1);
                dataSetUpsertInputModel.DataJson["UniqueNumber"] = uniqueNumber;
                dataSetUpsertInputModel.Id = _dataSetRepository.CreateDataSetUnAuth(dataSetUpsertInputModel, dataSetInputModel.CommodityName,  validationMessages);
            }
            else if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
            {
                dataSetUpsertInputModel.Id = _dataSetRepository.UpdateDataSetUnAuth(dataSetUpsertInputModel, validationMessages);
            }

            return dataSetUpsertInputModel.Id;
        }

        public List<Guid?> CreateMultipleDataSetSteps(List<DataSetInputModel> dataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateMultipleDataSetSteps", "DataSetService"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<DataSetUpsertInputModel> dataSetUpserts = new List<DataSetUpsertInputModel>();

            foreach (var dataSet in dataSetInputModel)
            {
                DataSetUpsertInputModel dataSetUpsert = (new DataSetUpsertInputModel
                {
                    Id = Guid.NewGuid(),
                    CompanyId = loggedInContext.CompanyGuid,
                    CreatedByUserId = loggedInContext.LoggedInUserId,
                    CreatedDateTime = DateTime.UtcNow,
                    IsArchived = false,
                    DataJson = BsonDocument.Parse(dataSet.DataJson.ToString()),
                    DataSourceId = dataSet.DataSourceId
                });

                if (!DataSourceValidations.ValidateDataSet(dataSetUpsert, loggedInContext, validationMessages))
                {
                    return null;
                }

                dataSetUpserts.Add(dataSetUpsert);
            };

            var data = _dataSetRepository.CreateMultipleDataSetSteps(dataSetUpserts, loggedInContext, validationMessages);

            return data;
        }
        public Guid? UpdateDataSet(DataSetInputModel dataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetService"));

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            dataSetUpsertInputModel.RecordAccessibleUsers = dataSetInputModel.RecordAccessibleUsers;
            if (!string.IsNullOrEmpty(dataSetInputModel.DataJson))
            {
                dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());
            }

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }
            if (dataSetUpsertInputModel.IsArchived == false || dataSetUpsertInputModel.IsArchived == null)
            {
                if (!DataSourceValidations.ValidateUpdateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages))
                {
                    return null;
                }
            }


            dataSetUpsertInputModel.Id = _dataSetRepository.UpdateDataSet(dataSetUpsertInputModel, loggedInContext, validationMessages);
            return dataSetUpsertInputModel.Id;
        }

        public Guid? UpdateDataSetUnAuth(DataSetInputModel dataSetInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetService"));

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            if (!string.IsNullOrEmpty(dataSetInputModel.DataJson))
            {
                dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());
            }
            if (dataSetUpsertInputModel.IsArchived == false || dataSetUpsertInputModel.IsArchived == null)
            {
                if (!DataSourceValidations.ValidateUpdateDataSetUnAuth(dataSetUpsertInputModel,  validationMessages))
                {
                    return null;
                }
            }


            dataSetUpsertInputModel.Id = _dataSetRepository.UpdateDataSetUnAuth(dataSetUpsertInputModel, validationMessages);
            return dataSetUpsertInputModel.Id;
        }

        public Guid? CreateUserDataSetRelation(UserDataSetInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateUserDataSetRelation", "DataSetService"));

            foreach (var user in userDataSetInputModel.UserId)
            {
                var userDatasetRelationOutput = _dataSetRepository.GetUserDataSetRelation(user, userDataSetInputModel.CompanyId, loggedInContext, validationMessages);

                UserDataSetUpsertInputModel dataSetUpsertInputModel = new UserDataSetUpsertInputModel();
                dataSetUpsertInputModel.UserId = user;
                dataSetUpsertInputModel.CompanyId = userDataSetInputModel.CompanyId;
                dataSetUpsertInputModel.DataSetIds = userDataSetInputModel.DataSetIds;

                if (dataSetUpsertInputModel.DataSetIds == null)
                {
                    dataSetUpsertInputModel.DataSetIds = new List<Guid>();
                }

                if (userDatasetRelationOutput?.Id != null)
                {
                    dataSetUpsertInputModel.Id = userDatasetRelationOutput.Id;
                    dataSetUpsertInputModel.CreatedByUserId = userDatasetRelationOutput.CreatedByUserId;
                    dataSetUpsertInputModel.CreatedDateTime = userDatasetRelationOutput.CreatedDateTime;
                    if (userDatasetRelationOutput.DataSetIds != null)
                    {
                        var dataSetIds = dataSetUpsertInputModel.DataSetIds;
                        dataSetIds.AddRange(userDatasetRelationOutput.DataSetIds);
                        dataSetUpsertInputModel.DataSetIds = dataSetIds.Distinct().ToList();
                    }
                }


                if (dataSetUpsertInputModel.Id == null)
                {
                    dataSetUpsertInputModel.Id = _dataSetRepository.CreateUserDataSetRelation(dataSetUpsertInputModel, loggedInContext, validationMessages);
                }
                else
                {
                    _dataSetRepository.UpdateUserDataSetRelation(dataSetUpsertInputModel, loggedInContext, validationMessages);
                }
            }

            return userDataSetInputModel.UserId[0];
        }

        public Guid? CreatePublicDataSet(DataSetInputModel dataSetInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetService"));


            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());

            if (dataSetUpsertInputModel.Id == null)
            {
                dataSetUpsertInputModel.Id = _dataSetRepository.CreatePublicDataSet(dataSetUpsertInputModel, validationMessages);
            }
            else if (dataSetUpsertInputModel.Id != null && dataSetUpsertInputModel.Id != Guid.Empty)
            {
                dataSetUpsertInputModel.Id = _dataSetRepository.UpdatePublicDataSet(dataSetUpsertInputModel, validationMessages);
            }

            return dataSetUpsertInputModel.Id;
        }
        public Guid? UpdatePublicDataSet(DataSetInputModel dataSetInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetService"));

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            if (!string.IsNullOrEmpty(dataSetInputModel.DataJson))
            {
                dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());
            }

            dataSetUpsertInputModel.Id = _dataSetRepository.UpdatePublicDataSet(dataSetUpsertInputModel, validationMessages);
            return dataSetUpsertInputModel.Id;
        }

        public Guid? UpdateDataSetJob(DataSetInputModel dataSetInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetJob", "DataSetService"));

            DataSetUpsertInputModel dataSetUpsertInputModel = new DataSetUpsertInputModel();

            dataSetUpsertInputModel.Id = dataSetInputModel.Id;
            dataSetUpsertInputModel.CompanyId = dataSetInputModel.CompanyId;
            dataSetUpsertInputModel.DataSourceId = dataSetInputModel.DataSourceId;
            dataSetUpsertInputModel.CreatedByUserId = dataSetInputModel.CreatedByUserId;
            dataSetUpsertInputModel.UpdatedByUserId = dataSetInputModel.UpdatedByUserId;
            dataSetUpsertInputModel.ArchivedByUserId = dataSetInputModel.ArchivedByUserId;
            dataSetUpsertInputModel.CreatedDateTime = dataSetInputModel.CreatedDateTime;
            dataSetUpsertInputModel.UpdatedDateTime = dataSetInputModel.UpdatedDateTime;
            dataSetUpsertInputModel.ArchivedDateTime = dataSetInputModel.ArchivedDateTime;
            dataSetUpsertInputModel.IsArchived = dataSetInputModel.IsArchived;
            if (!string.IsNullOrEmpty(dataSetInputModel.DataJson))
            {
                dataSetUpsertInputModel.DataJson = BsonDocument.Parse(dataSetInputModel.DataJson.ToString());
            }
            dataSetUpsertInputModel.Id = _dataSetRepository.UpdateDataSetJob(dataSetUpsertInputModel, validationMessages);
            return dataSetUpsertInputModel.Id;
        }
        public List<DataSetOutputModel> SearchDataSets(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSetService"));
            LoggingManager.Debug(dataSetSearchCriteriaInputModel.ToString());
            if (!DataSourceValidations.ValidateSearchDataSets(dataSetSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            return _dataSetRepository.SearchDataSets(dataSetSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public string GetDataSetLatestProgramId(Guid? countryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestProgramId", "DataSetService"));
            LoggingManager.Debug(countryId.ToString());

            return _dataSetRepository.GetDataSetLatestProgramId(countryId, loggedInContext, validationMessages);
        }

        public List<DataSetOutputModelForForms> SearchDataSetsForForms(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSetService"));
            LoggingManager.Debug(dataSetSearchCriteriaInputModel.ToString());
            if (!DataSourceValidations.ValidateSearchDataSets(dataSetSearchCriteriaInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            var data = _dataSetRepository.SearchDataSetsForForms(dataSetSearchCriteriaInputModel, loggedInContext, validationMessages);
            return data ?? new List<DataSetOutputModelForForms>();
        }
         public List<DataSetOutputModelForForms> SearchDataSetsForFormsUnAuth(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetsUnAuth", "DataSetService"));
            LoggingManager.Debug(dataSetSearchCriteriaInputModel.ToString());
            if (!DataSourceValidations.ValidateSearchDataSetsUnAuth(dataSetSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            return _dataSetRepository.SearchDataSetsForFormsUnAuth(dataSetSearchCriteriaInputModel, validationMessages);
        }

        public List<DataSetOutputModel> SearchDataSetsForJob(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSetService"));
            LoggingManager.Debug(dataSetSearchCriteriaInputModel.ToString());

            return _dataSetRepository.SearchDataSetsForJob(dataSetSearchCriteriaInputModel, validationMessages);
        }
        public List<DataSetOutputModel> GetDataSetsById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSetService"));
            LoggingManager.Debug(id.ToString());
            if (!DataSourceValidations.ValidateSearchDataSet(id, loggedInContext, validationMessages))
            {
                return null;
            }
            return _dataSetRepository.GetDataSetsById(id, loggedInContext, validationMessages);

        }

        public int? GetDataSetCountBasedOnTodaysCount(List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetCountBasedOnTodaysCount", "DataSetService"));

            return _dataSetRepository.GetDataSetCountBasedOnTodaysCount(validationMessages);
        }
        public int? GetDataSetLatestRFQId(Guid tempalteTypeId, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestRFQId", "DataSetService"));

            return _dataSetRepository.GetDataSetLatestRFQId(tempalteTypeId, validationMessages);
        }
        public List<DataSetOutputModel> GetLatestSwitchBlDataSets(bool isSwitchBl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestRFQId", "DataSetService"));

            return _dataSetRepository.GetLatestSwitchBlDataSets(isSwitchBl, loggedInContext, validationMessages);
        }

        public DataSetKeyOutputModel GetDataSetByKeyId(Guid? id, Guid? keyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetCountBasedOnTodaysCount", "DataSetService"));

            List<DataSetKeyOutputModel> dataSetKeyOutputModel = _dataSetRepository.GetDataSetByDataSourceId(id, keyId, loggedInContext, validationMessages);
            if (dataSetKeyOutputModel.Count > 0)
            {
                var outputModel = dataSetKeyOutputModel[0];
                return outputModel;
            }
            else
            {
                return new DataSetKeyOutputModel();
            }
        }

        public Guid? UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetJson", "DataSetService"));

            Guid? id = _dataSetRepository.UpdateDataSetJson(dataSetUpsertInputModel, loggedInContext, validationMessages);
            return id;
        }

        public Task<object> DeleteDatasetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSetService"));
            LoggingManager.Debug(id.ToString());
            if (!DataSourceValidations.ValidateSearchDataSet(id, loggedInContext, validationMessages))
            {
                return null;
            }
            return _dataSetRepository.DeleteDatasetById(id, loggedInContext, validationMessages);
        }
        public Task<object> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteMultipleDataSets", "DataSetService"));
            
            return _dataSetRepository.DeleteMultipleDataSets(inputModel, loggedInContext, validationMessages);
        }
         public Task<object> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UnArchiveMultipleDataSets", "DataSetService"));
            
            return _dataSetRepository.UnArchiveMultipleDataSets(inputModel, loggedInContext, validationMessages);
        }

        public PositionDashboardOutputModel GetDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboard", "DataSetService"));

            PositionDashboardOutputModel result = _dataSetRepository.GetDashboard(salesDashboardInput, loggedInContext, validationMessages);
            return result;
        }

        public FinalReliasedOutputModel GetRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRealisedPandLDashboard", "DataSetService"));

            FinalReliasedOutputModel result = _dataSetRepository.GetRealisedPandLDashboard(inputModel, loggedInContext, validationMessages);
            return result;
        }

        public FinalUnReliasedOutputModel GetUnRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnRealisedPandLDashboard", "DataSetService"));

            FinalUnReliasedOutputModel result = _dataSetRepository.GetUnRealisedPandLDashboard(inputModel, loggedInContext, validationMessages);
            return result;
        }

        public InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelDashboard", "DataSetService"));
            InstanceLevelPositionDashboardOutputModel result = new InstanceLevelPositionDashboardOutputModel();

            result = _dataSetRepository.GetInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);

            return result;
        }

        public List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelProfitLossDashboard", "DataSetService"));

            List<InstanceLevelPofitLossOutputModel> result = _dataSetRepository.GetInstanceLevelProfitLossDashboard(dashboardInputModel, loggedInContext, validationMessages);
            return result;
        }

        public void RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RefreshVesselSummary", "DataSetService"));

            _dataSetRepository.RefreshVesselSummary(inputModel, loggedInContext, validationMessages);
        }

        public List<string> GetUniqueValidation(UniqueValidateModel uvModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return _dataSetRepository.GetUniqueValidation(uvModel, loggedInContext, validationMessages);
        }

        public string GetQueryData(GetQueryDataInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQueryData", "DataSetService"));

            var result = _dataSetRepository.GetQueryData(inputModel, loggedInContext, validationMessages);

            return result;
        }

        public List<string> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCollections", "DataSetService"));

            var result = _dataSetRepository.GetCollections(loggedInContext, validationMessages);

            return result;
        }

        public VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVesselDashboard", "DataSetService"));

            VesselDashboardOutputModel result = _dataSetRepository.GetVesselDashboard(inputModel, loggedInContext, validationMessages);

            return result;
        }
        public List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "DataSetService"));

            List<PositionData> result = _dataSetRepository.GetPositionsDashboard(inputModel, loggedInContext, validationMessages);
            //result.ForEach(item => item.MTDPAndL = 0);
            foreach (var item in result.Where(x => x.Commodity.ToLower().Contains("total")).ToList())
            {
                decimal sum = 0;
                if (item.Commodity == "Sub Total" || item.Commodity.ToLower() == "sg ana-total" || item.Commodity.ToLower() == "orimu ana-total")
                {
                    item.OpeningBalance = item.Commodity != "Sub Total" ? 0 : result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.OpeningBalance);
                    item.YTDgross = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross);
                    item.YTDgross1 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross1);
                    item.YTDgross2 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross2);
                    item.YTDgross3 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross3);
                    item.YTDgross4 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross4);
                    item.YTDgross5 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross5);
                    item.YTDgross6 = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross6);
                    item.YTDgross7 = item.Commodity != "Sub Total" ? 0 : result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross7);
                    item.TotalGross = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.TotalGross);
                    item.NetClosing = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.NetClosing);
                    item.NetOpening = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.NetOpening);
                    item.DayChange = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.DayChange);
                    item.DayPAndL = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.DayPAndL);
                    item.MTDPAndL = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.MTDPAndL);
                    item.YTDRealisedPAndL = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDRealisedPAndL);
                    item.YTDUnRealisedPAndL = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDUnRealisedPAndL);
                    item.YTDTotalPAndL = result.Where(x => x.PositionName == item.PositionName && !x.Commodity.Contains("Total") && x.CompanyName == item.CompanyName).Sum(x => x.YTDTotalPAndL);
                }
                else if (item.Commodity.ToLower() == (item.PositionName + "-" + "Total").ToLower())
                {
                    item.OpeningBalance = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.OpeningBalance);
                    item.YTDgross = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross);
                    item.YTDgross1 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross1);
                    item.YTDgross2 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross2);
                    item.YTDgross3 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross3);
                    item.YTDgross4 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross4);
                    item.YTDgross5 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross5);
                    item.YTDgross6 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross6);
                    item.YTDgross7 = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDgross7);
                    item.TotalGross = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.TotalGross);
                    item.NetClosing = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.NetClosing);
                    item.NetOpening = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.NetOpening);
                    item.DayChange = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.DayChange);
                    item.DayPAndL = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.DayPAndL);
                    item.MTDPAndL = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.MTDPAndL);
                    item.YTDRealisedPAndL = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDRealisedPAndL);
                    item.YTDUnRealisedPAndL = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDUnRealisedPAndL);
                    item.YTDTotalPAndL = result.Where(x => x.Commodity == "Sub Total" && x.CompanyName == item.CompanyName).Sum(x => x.YTDTotalPAndL);
                }
                else if (item.PositionName.ToLower() == "grand total")
                {
                    item.YTDgross1 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross1);
                    item.YTDgross2 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross2);
                    item.YTDgross3 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross3);
                    item.YTDgross4 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross4);
                    item.YTDgross5 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross5);
                    item.YTDgross6 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross6);
                    item.YTDgross7 = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDgross7);
                    item.NetClosing = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.NetClosing);
                    item.NetOpening = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.NetOpening);
                    item.DayChange = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.DayChange);
                    item.DayPAndL = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.DayPAndL);
                    item.MTDPAndL = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.MTDPAndL);
                    item.YTDRealisedPAndL = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDRealisedPAndL);
                    item.YTDUnRealisedPAndL = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDUnRealisedPAndL);
                    item.YTDTotalPAndL = result.Where(x => x.Commodity?.ToLower().Contains("-total") == true).Sum(x => x.YTDTotalPAndL);
                }
            }
            return result;
        }

        public void UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateYTDPandLHistory", "DataSetService"));
            _dataSetRepository.UpdateYTDPandLHistory(inputModel, loggedInContext, validationMessages);
        }
        public List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCO2EmmisionReport", "DataSetService"));
            List<GetCO2EmmisionReportOutputModel>  result = _dataSetRepository.GetCO2EmmisionReport(inputModel, loggedInContext, validationMessages);
            return result;
        }
        public void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FieldUpdateWorkFlow", "DataSetService"));
             _dataSetRepository.FieldUpdateWorkFlow(inputModel,loggedInContext,validationMessages);
        }
        public Guid? UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetWorkFlow", "DataSetService"));
            Guid? dataSetId = CreateDataSet(inputModel.DataSetUpsertInputModel,loggedInContext,validationMessages);
            if(dataSetId != null && dataSetId != Guid.Empty)
            {
                inputModel.NewRecordDataSetId = dataSetId;
                _dataSetRepository.UpdateDataSetWorkFlow(inputModel, loggedInContext, validationMessages);
                return dataSetId;
            } else
            {
                return null;
            }
        }
    }
}
