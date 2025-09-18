using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioRepo.Helpers;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace formioRepo.DataSourceKeysConfiguration
{
    public class DataSourceKeysConfigurationRepository : IDataSourceKeysConfigurationRepository
    {
        IConfiguration _iconfiguration;
        public DataSourceKeysConfigurationRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                dataSetUpsertInputModel.Id = Guid.NewGuid();
                dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                dataSetUpsertInputModel.IsArchived = false;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceKeys", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceKeys);
                return null;
            }
        }

        public Guid? UpdateDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeys", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("IsArchived", false),
                    Builders<BsonDocument>.Update.Set("IsDefault", dataSetUpsertInputModel.IsDefault),
                    Builders<BsonDocument>.Update.Set("IsPrivate", dataSetUpsertInputModel.IsPrivate),
                    Builders<BsonDocument>.Update.Set("IsTag", dataSetUpsertInputModel.IsTag),
                    Builders<BsonDocument>.Update.Set("IsTrendsEnable", dataSetUpsertInputModel.IsTrendsEnable),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceKeys(dataSetUpsertInputModel, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeys", "DataSetRepository"));
                return dataSetUpsertInputModel.CustomApplicationId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeys", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSourceKeys);
                return null;
            }
        }

        public Guid? ArchiveDataSourceKeysConfiguration(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeys", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("ArchivedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetArchiveDataSourceKeys(dataSetUpsertInputModel, loggedInContext);
                datasetCollection.UpdateMany(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeys", "DataSetRepository"));
                return dataSetUpsertInputModel.CustomApplicationId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeys", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSourceKeys);
                return null;
            }
        }

        public DataSourceKeysConfigurationModel SearchDataSourceKeysConfiguration(DataSourceKeysConfigurationSearchInputModel dataSourceKeysSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysConfiguration", "DataSourceRepository"));
                 IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false)
                };
               
                if (dataSourceKeysSearchInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceKeysSearchInputModel.Id.ToString()));
                }
                if (dataSourceKeysSearchInputModel.DataSourceKeyId != null)
                {
                    filter.Add(new BsonDocument("DataSourceKeyId", dataSourceKeysSearchInputModel.DataSourceKeyId.ToString()));
                }
                if (dataSourceKeysSearchInputModel.CustomApplicationId != null)
                {
                    filter.Add(new BsonDocument("CustomApplicationId", dataSourceKeysSearchInputModel.CustomApplicationId.ToString()));
                }

                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSourceKeys", "DataSourceKeyId", "_id", "datasourcekeys");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "Key", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.Key", 0}) },
                                { "Label", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.Label", 0}) },
                                { "DataSourceId", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.DataSourceId", 0}) }

                });
                
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookup);
                stages.Add(set);

                if (!dataSourceKeysSearchInputModel.IsOnlyForKeys)
                {
                    var dataSourceLookup = new BsonDocument("$lookup", new BsonDocument {
                                    { "from", "DataSource" },
                                    { "localField", "datasourcekeys.DataSourceId" },
                                    { "foreignField", "_id" },
                                    { "as", "dataSource" }
                    });
                    var dataSourceSet = new BsonDocument("$set",
                              new BsonDocument{
                                { "FormName", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSource.Name", 0}) },
                                { "Fields", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSource.Fields", 0}) }

                      });
                    stages.Add(dataSourceLookup);
                    stages.Add(dataSourceSet);
                }
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysConfigurationOutputModel>(aggregateDataList);
                DataSourceKeysConfigurationModel dataSourceKeysConfiguration = new DataSourceKeysConfigurationModel();
                dataSourceKeysConfiguration.dataSourceKeys = dataSources;
                var selectedKeyIds = dataSources.Where(x => x.IsDefault == true).Select(x => x.DataSourceKeyId).ToList();
                if (selectedKeyIds.Count > 0)
                {
                    dataSourceKeysConfiguration.SelectedKeyIds = string.Join(",", selectedKeyIds);
                }
                var selectedPrivateKeyIds = dataSources.Where(x => x.IsPrivate == true).Select(x => x.DataSourceKeyId).ToList();
                if (selectedPrivateKeyIds.Count > 0)
                {
                    dataSourceKeysConfiguration.SelectedPrivateKeyIds = string.Join(",", selectedPrivateKeyIds);
                }
                var selectedTagKeyIds = dataSources.Where(x => x.IsTag == true).Select(x => x.DataSourceKeyId).ToList();
                if (selectedTagKeyIds.Count > 0)
                {
                    dataSourceKeysConfiguration.SelectedTagKeyIds = string.Join(",", selectedTagKeyIds);
                }
                var selectedTrendEnableKeyIds = dataSources.Where(x => x.IsTrendsEnable == true).Select(x => x.DataSourceKeyId).ToList();
                if (selectedTrendEnableKeyIds.Count > 0)
                {
                    dataSourceKeysConfiguration.SelectedEnableTrendsKeys = string.Join(",", selectedTrendEnableKeyIds);
                }
                return dataSourceKeysConfiguration;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeysConfiguration", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public List<DataSourceKeysConfigurationOutputModel> SearchDataSourceKeysConfigurationAnonymous(DataSourceKeysConfigurationSearchInputModel dataSourceKeysSearchInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeysConfiguration", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false)
                };

                if (dataSourceKeysSearchInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceKeysSearchInputModel.Id.ToString()));
                }
                if (dataSourceKeysSearchInputModel.DataSourceKeyId != null)
                {
                    filter.Add(new BsonDocument("DataSourceKeyId", dataSourceKeysSearchInputModel.DataSourceKeyId.ToString()));
                }
                if (dataSourceKeysSearchInputModel.CustomApplicationId != null)
                {
                    filter.Add(new BsonDocument("CustomApplicationId", dataSourceKeysSearchInputModel.CustomApplicationId.ToString()));
                }

                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSourceKeys", "DataSourceKeyId", "_id", "datasourcekeys");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "Key", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.Key", 0}) },
                                { "Label", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.Label", 0}) },
                                { "DataSourceId", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.DataSourceId", 0}) }

                });
                var dataSourceLookup = new BsonDocument("$lookup", new BsonDocument {
                                    { "from", "DataSource" },
                                    { "localField", "datasourcekeys.DataSourceId" },
                                    { "foreignField", "_id" },
                                    { "as", "dataSource" }
                 });
                var dataSourceSet = new BsonDocument("$set",
                          new BsonDocument{
                                { "FormName", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSource.Name", 0}) },
                                { "Fields", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSource.Fields", 0}) }

                  });
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookup);
                stages.Add(set);
                stages.Add(dataSourceLookup);
                stages.Add(dataSourceSet);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysConfigurationOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeysConfiguration", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        protected IMongoDatabase GetMongoDbConnection()
        {
            MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
            return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        }
        protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        {
            IMongoDatabase imongoDb = GetMongoDbConnection();
            return imongoDb.GetCollection<T>(collectionName);
        }

        public FilterDefinition<BsonDocument> GetUpdateDataSourceKeys(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()),
                fBuilder.Eq("DataSourceKeyId", dataSetUpsertInputModel.DataSourceKeyId.ToString()),
                 fBuilder.Eq("IsArchived", false));

        }

        public FilterDefinition<BsonDocument> GetArchiveDataSourceKeys(DataSourceKeysConfigurationInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("CustomApplicationId", dataSetUpsertInputModel.CustomApplicationId.ToString()),
                   fBuilder.Eq("IsArchived", false));

        }
    }
}
