using formioModels;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using formioModels.Data;
using MongoDB.Bson;
using MongoDB.Driver;
using System.Threading.Tasks;
using formioCommon.Constants;

namespace formioRepo.DataSource
{
    public class DataSourceFakeRepository : IDataSourceRepository
    {
        public Guid? CreateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            dataSourceInputModel.Id = Guid.NewGuid();
            dataSourceInputModel.CompanyId = loggedInContext.CompanyGuid;
            dataSourceInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
            dataSourceInputModel.CreatedDateTime = DateTime.UtcNow;
            return new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
        }
        public Guid? UpdateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            string filter = "{ '_id' : '" + dataSourceInputModel.Id.ToString() + "','CompanyId':'" + loggedInContext.CompanyGuid.ToString() + "'}";
            string update = "{$set: { 'Name':'" + dataSourceInputModel.Name
                                                + "','Description':'" + dataSourceInputModel.Description
                                                + "','Tags':'" + dataSourceInputModel.Tags
                                                + "','DataSourceType':'" + dataSourceInputModel.DataSourceType
                                                + "','IsArchived':'" + dataSourceInputModel.IsArchived
                                                + "','UpdatedDateTime':'" + DateTime.UtcNow
                                                + "','UpdatedByUserId':'" + loggedInContext.LoggedInUserId.ToString()
                                                + "','FormJson':'" + dataSourceInputModel.Fields
                                                + "' } }";
            return new Guid("3B3DE008-7F82-4ADF-A867-8827A99CE596");
        }
        public List<DataSourceOutputModel> SearchDataSource(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
           var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived)
            };
            if (dataSourceSearchCriteriaInputModel.SearchText != null)
            {
                filter.Add(new BsonDocument("Name",
                    new BsonDocument("$regex",
                        new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))));
            }
            if (dataSourceSearchCriteriaInputModel.Id != null)
            {
                filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
            }
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new List<DataSourceOutputModel>
            {
                new DataSourceOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    FormTypeId = new Guid("06c5d24a-1b26-48c7-b8b5-4a2bade3539c"),
                    Name = "vv",
                    Fields = 
                        "{\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField2\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null},{\"label\":\"Columns\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"columns2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":[{\"components\":[{\"label\":\"\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"table2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":[[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tabs\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tabs\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tab 1\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab1\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField3\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]},{\"label\":\"tab2\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}]],\"components\":null}],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null},{\"components\":[],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null}],\"rows\":null,\"components\":null},{\"label\":\"Submit\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"submit\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}",
                    IsArchived = false
                }
            };
        }

        public List<DataSourceOutputModel> SearchDataSourceUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived)
            };
            if (dataSourceSearchCriteriaInputModel.SearchText != null)
            {
                filter.Add(new BsonDocument("Name",
                    new BsonDocument("$regex",
                        new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))));
            }
            if (dataSourceSearchCriteriaInputModel.Id != null)
            {
                filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
            }
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new List<DataSourceOutputModel>
            {
                new DataSourceOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    FormTypeId = new Guid("06c5d24a-1b26-48c7-b8b5-4a2bade3539c"),
                    Name = "vv",
                    Fields =
                        "{\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField2\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null},{\"label\":\"Columns\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"columns2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":[{\"components\":[{\"label\":\"\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"table2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":[[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tabs\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tabs\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tab 1\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab1\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField3\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]},{\"label\":\"tab2\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}]],\"components\":null}],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null},{\"components\":[],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null}],\"rows\":null,\"components\":null},{\"label\":\"Submit\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"submit\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}",
                    IsArchived = false
                }
            };
        }

        public List<DataSourceOutputModel> SearchDataSourceForJob(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel,  List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
               
                new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived)
            };
            if (dataSourceSearchCriteriaInputModel.SearchText != null)
            {
                filter.Add(new BsonDocument("Name",
                    new BsonDocument("$regex",
                        new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))));
            }
            if (dataSourceSearchCriteriaInputModel.Id != null)
            {
                filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
            }
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new List<DataSourceOutputModel>
            {
                new DataSourceOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    FormTypeId = new Guid("06c5d24a-1b26-48c7-b8b5-4a2bade3539c"),
                    Name = "vv",
                    Fields =
                        "{\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField2\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null},{\"label\":\"Columns\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"columns2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":[{\"components\":[{\"label\":\"\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"table2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":[[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tabs\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tabs\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Tab 1\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab1\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[{\"label\":\"Text Field\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"textField3\",\"placeholder\":null,\"defaultValue\":\"\",\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]},{\"label\":\"tab2\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"tab2\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}],[{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]},{\"label\":null,\"title\":null,\"type\":null,\"input\":false,\"key\":null,\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":[]}]],\"components\":null}],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null},{\"components\":[],\"type\":null,\"input\":false,\"key\":\"column\",\"label\":\"Column\",\"placeholder\":null,\"defaultValue\":null,\"customDefaultValue\":null,\"columns\":null,\"rows\":null}],\"rows\":null,\"components\":null},{\"label\":\"Submit\",\"title\":null,\"type\":null,\"input\":false,\"key\":\"submit\",\"placeholder\":null,\"defaultValue\":null,\"description\":null,\"tooltip\":null,\"columns\":null,\"rows\":null,\"components\":null}]}",
                    IsArchived = false
                }
            };
        }

        public List<SearchDataSourceOutputModel> SearchAllDataSources(SearchDataSourceInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", false)
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new List<SearchDataSourceOutputModel>
            {
                new SearchDataSourceOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    Name = "vv"
                }
            };
        }

        public List<GetDataSourcesByIdOutputModel> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", false)
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new List<GetDataSourcesByIdOutputModel>
            {
                new GetDataSourcesByIdOutputModel
                {
                    Id = new Guid("9d7db5b8-2eb0-41e8-ac40-fa91731be7d8"),
                    Name = "vv"
                }
            };
        }
        public string GenericQueryApi(string inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", false)
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return null;
        }

        public GetFormFieldValuesOutputModel GetFormFieldValues(GetFormFieldValuesInputModel inputQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", false)
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return new GetFormFieldValuesOutputModel();
        }

        public string GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var filter = new BsonArray
            {
                new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                new BsonDocument("IsArchived", false)
            };
            var matchStage = new BsonDocument("$match",
                new BsonDocument("$and", new BsonArray(filter)));
            var stages = new List<BsonDocument>();
            stages.Add(matchStage);
            var pipeline = stages;
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
            return null;
        }

        public NotificationModel UpsertNotification(NotificationModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<NotificationModel> GetNotifications(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }

        public List<Guid?> UpsertReadNewNotifications(NotificationReadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            throw new NotImplementedException();
        }
    }
}
