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
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace formioRepo.DataSourceKeys
{
    public class DataSourceKeysRepository : IDataSourceKeysRepository
    {
        IConfiguration _iconfiguration;
        public DataSourceKeysRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", true),
                    new BsonDocument("DataSourceId", dataSetUpsertInputModel.DataSourceId.ToString()),
                    new BsonDocument("Key", dataSetUpsertInputModel.Key)
                };
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(stages, aggregateOptions).ToList();
                var dataSourceKey = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(aggregateDataList)?.FirstOrDefault();
                if (dataSourceKey != null)
                {
                    //code
                    IMongoCollection<BsonDocument> datasetkcCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeysConfiguration);
                    var filter1 = new List<BsonDocument>
                    {
                    new BsonDocument("IsArchived", false),
                    new BsonDocument("DataSourceKeyId", dataSourceKey.Id.ToString())
                    };
                    var matchStage1 = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter1));
                    var stages1 = new List<BsonDocument>();
                    stages1.Add(matchStage1);
                    //var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSourceKeysConfiguration", "_id", "DataSourceKeyId", "DataSourceKeysConfig");
                    //stages.Add(lookup);
                    //stages.Add(new BsonDocument("$project", new BsonDocument { { "DataSourceKeysConfig", 1 }, { "_id", 0 } }));
                    var aggregateDataList1 = datasetkcCollection.Aggregate<BsonDocument>(stages1, aggregateOptions)?.ToList();
                    var dataSourceKey1 = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysConfigurationOutputModel>(aggregateDataList1).ToList();
                    if (dataSourceKey1 != null && dataSourceKey1.Count > 0)
                    {
                        dataSetUpsertInputModel.Id = Guid.NewGuid();
                        dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                        dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                        dataSetUpsertInputModel.IsArchived = false;
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetRepository"));
                        IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                        datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSetRepository"));
                        foreach (var dsk in dataSourceKey1)
                        {
                            var currentUtcTime = DateTime.UtcNow;
                            var update = new List<UpdateDefinition<BsonDocument>>
                            {
                                Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                                Builders<BsonDocument>.Update.Set("DataSourceKeyId", dataSetUpsertInputModel.Id),
                                Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                            };
                            var updateFields = Builders<BsonDocument>.Update.Combine(update);
                            datasetkcCollection.UpdateOne(filter: Builders<BsonDocument>.Filter.Eq("_id", dsk.Id.ToString()), update: updateFields);
                        }
                    }
                    else
                    {
                        dataSetUpsertInputModel.Id = Guid.NewGuid();
                        dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                        dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                        dataSetUpsertInputModel.IsArchived = false;
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetRepository"));
                        IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                        datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSetRepository"));
                    }
                    var deleteFilter = Builders<BsonDocument>.Filter.Eq("_id", dataSourceKey.Id.ToString());
                    dataCollection.DeleteOne(deleteFilter);
                    return dataSetUpsertInputModel.Id;
                }
                else 
                {
                    dataSetUpsertInputModel.Id = Guid.NewGuid();
                    dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                    dataSetUpsertInputModel.IsArchived = false;
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceKeys", "DataSetRepository"));
                    IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                    datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceKeys", "DataSetRepository"));
                    return dataSetUpsertInputModel.Id;
                }
                
                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceKeys", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceKeys);
                return null;
            }
        }

        public Guid? UpdateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSourceKeys", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("ArchivedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceKeys(dataSetUpsertInputModel, loggedInContext);
                datasetCollection.UpdateMany(filter: filterObject, update: updateFields);
                //var filter = Builders<BsonDocument>.Filter.Eq("DataSourceId", dataSetUpsertInputModel.DataSourceId.ToString());
                //datasetCollection.DeleteMany(filter);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSourceKeys", "DataSetRepository"));
                return dataSetUpsertInputModel.DataSourceId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSourceKeys", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSourceKeys);
                return null;
            }
        }

        public FilterDefinition<BsonDocument> GetUpdateDataSourceKeys(DataSourceKeysInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("DataSourceId", dataSetUpsertInputModel.DataSourceId.ToString()));

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

        public List<DataSourceKeysOutputModel> SearchDataSourceKeys(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeys", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false)
                };
                if (dataSourceKeysSearchInputModel.SearchText != null)
                {
                    filter.Add(new BsonDocument("$or",
                new BsonArray
                    {
                        new BsonDocument("Label",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceKeysSearchInputModel.SearchText.Trim()}")))

                    }));
                }
                if (dataSourceKeysSearchInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceKeysSearchInputModel.Id.ToString()));
                }
                if (dataSourceKeysSearchInputModel.Type != null)
                {
                    filter.Add(new BsonDocument("Type", dataSourceKeysSearchInputModel.Type.ToString()));
                }

                List<string> dataSourceIds = dataSourceKeysSearchInputModel.FormIdsString != null 
                                             ? dataSourceKeysSearchInputModel.FormIdsString.Split(',').Select(s => s.Trim()).ToList() 
                                             :new List<string>();
                if (dataSourceKeysSearchInputModel.DataSourceId != null)
                {
                    dataSourceIds.Add(dataSourceKeysSearchInputModel.DataSourceId.ToString());
                }
                if (dataSourceIds != null && dataSourceIds.Count > 0)
                {
                   filter.Add(new BsonDocument("DataSourceId", new BsonDocument("$in", new BsonArray(dataSourceIds))));
                }

                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);

                if (!dataSourceKeysSearchInputModel.IsOnlyForKeys)
                {
                    var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasources");
                    var dataSourceSet = new BsonDocument("$set",
                              new BsonDocument{
                                { "FormName", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasources.Name", 0}) },
                                { "Fields", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasources.Fields", 0}) }

                      });

                    stages.Add(lookup);
                    stages.Add(dataSourceSet);
                }
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeys", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public List<DataSourceKeysOutputModel> SearchDataSourceKeysAnonymous(DataSourceKeysSearchInputModel dataSourceKeysSearchInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceKeys", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false)
                };
                if (dataSourceKeysSearchInputModel.SearchText != null)
                {
                    filter.Add(new BsonDocument("$or",
                new BsonArray
                    {
                        new BsonDocument("Label",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceKeysSearchInputModel.SearchText.Trim()}")))

                    }));
                }
                if (dataSourceKeysSearchInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceKeysSearchInputModel.Id.ToString()));
                }
                if (dataSourceKeysSearchInputModel.DataSourceId != null)
                {
                    filter.Add(new BsonDocument("DataSourceId", dataSourceKeysSearchInputModel.DataSourceId.ToString()));
                }
                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasources");
                var dataSourceSet = new BsonDocument("$set",
                          new BsonDocument{
                                { "FormName", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasources.Name", 0}) },
                                { "Fields", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasources.Fields", 0}) }

                  });
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookup);
                stages.Add(dataSourceSet);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceKeys", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }
        public Guid? CreateOrUpdateQunatityDetails(CreateOrUpdateQunatityInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> mongoCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.ContractQuantity);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                inputModel.CompanyId = loggedInContext.CompanyGuid;
                
                var pipeline = new List<BsonDocument>
                {new BsonDocument("$match",new BsonDocument
                    {
                    {"CompanyId", loggedInContext.CompanyGuid.ToString() },
                    {"UniqueId", inputModel.UniqueId },
                    {"IsArchived", false} }),
                   new BsonDocument ( "$project", new BsonDocument { { "_id" , 1} })
                };

                var resultSet = mongoCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).FirstOrDefault();
                
                var quantityId = resultSet == null ? null : resultSet.TryGetValue("_id", out BsonValue Id) ? Id.ToString() : null;

                if (!string.IsNullOrWhiteSpace(quantityId))
                {
                    inputModel.Id = Guid.Parse(quantityId);
                    LoggingManager.Info("Updating record with Id - " + inputModel.Id.ToString() + " from " + MongoDBCollectionConstants.ContractQuantity + " Collection");

                    var update = new List<UpdateDefinition<BsonDocument>>
                    {
                        Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                        Builders<BsonDocument>.Update.Set("ContractQuantity", inputModel.ContractQuantity)
                    };

                    var fBuilder = GetUpdateFilter(inputModel,loggedInContext);
                    FilterDefinition<BsonDocument> filter = fBuilder;
                    var updateFields = Builders<BsonDocument>.Update.Combine(update);
                    mongoCollection.UpdateOne(filter: fBuilder, update: updateFields);
                }
                else
                {
                    inputModel.Id = Guid.NewGuid();
                    LoggingManager.Info("Inserting new record with Id - " + inputModel.Id.ToString() + " into " + MongoDBCollectionConstants.ContractQuantity + " Collection");
                    inputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    inputModel.CreatedDateTime = DateTime.UtcNow;
                    inputModel.IsArchived = false;
                    mongoCollection.InsertOne(inputModel.ToBsonDocument());
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateOrUpdateQunatityDetails", "DataSetRepository"));
                return inputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateOrUpdateQunatityDetails", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceKeys);
                return null;
            }
        }
        public FilterDefinition<BsonDocument> GetUpdateFilter(CreateOrUpdateQunatityInputModel inputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", inputModel.Id.ToString()),
                         fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()),
                         fBuilder.Eq("UniqueId", inputModel.UniqueId)
                         );
        }
    }
}
