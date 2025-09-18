using formioCommon.Constants;
using formioModels.Data;
using formioModels;
using formioRepo.DataSet;
using formioRepo.Helpers;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Text.RegularExpressions;

namespace formioRepo.DataLevelKeyConfiguration
{
    public class DataLevelKeyConfigurationRepository : IDataLevelKeyConfigurationRepository
    {
        IConfiguration _iconfiguration;

        public DataLevelKeyConfigurationRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationRepository"));
                dataLevelKeyConfigurationModel.Id = (dataLevelKeyConfigurationModel.Id == null || dataLevelKeyConfigurationModel.Id == Guid.Empty) ? Guid.NewGuid() : dataLevelKeyConfigurationModel.Id;
                UpsertDataLevelKeyConfigurationModel upsertDataLevelKeyConfigurationModel = new UpsertDataLevelKeyConfigurationModel();
                upsertDataLevelKeyConfigurationModel.Id=dataLevelKeyConfigurationModel.Id;
                upsertDataLevelKeyConfigurationModel.CustomApplicationId = dataLevelKeyConfigurationModel.CustomApplicationId;
                upsertDataLevelKeyConfigurationModel.CompanyId = loggedInContext.CompanyGuid;
                upsertDataLevelKeyConfigurationModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                upsertDataLevelKeyConfigurationModel.CreatedDateTime = DateTime.UtcNow;
                upsertDataLevelKeyConfigurationModel.IsArchived = false;
                upsertDataLevelKeyConfigurationModel.DataJson = dataLevelKeyConfigurationModel.ToBsonDocument();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataLevelKeyConfiguration);
                datasetCollection.InsertOne(upsertDataLevelKeyConfigurationModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationRepository"));
                return upsertDataLevelKeyConfigurationModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateLevelKeyConfiguration", "DataLevelKeyConfigurationRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }
        public Guid? UpdateLevelKeyConfiguration(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataLevelKeyConfigurationRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataLevelKeyConfiguration);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("IsArchived", dataLevelKeyConfigurationModel.IsArchived==null?false:dataLevelKeyConfigurationModel.IsArchived),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                if (dataLevelKeyConfigurationModel.IsArchived == true)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));
                    update.Add(Builders<BsonDocument>.Update.Set("IsArchived", true));
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                }
                update.Add(Builders<BsonDocument>.Update.Set("DataJson", dataLevelKeyConfigurationModel.ToBsonDocument()));
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSource(dataLevelKeyConfigurationModel, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSet", "DataLevelKeyConfigurationRepository"));
                return dataLevelKeyConfigurationModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSet", "DataLevelKeyConfigurationRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }
        public List<GetDataLevelKeyConfigurationModel> SearchLevelKeyConfiguration(Guid? customApplicationId, Guid? id,bool? isArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchLevelKeyConfiguration", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataLevelKeyConfiguration);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString())
                };
                if (id != null)
                {
                    filter.Add(new BsonDocument("_id", id.ToString()));
                }
                if (customApplicationId != null)
                {
                    filter.Add(new BsonDocument("CustomApplicationId", customApplicationId.ToString()));
                }
                if (isArchived == null)
                {
                    filter.Add(new BsonDocument("IsArchived", false));

                }
                if (isArchived != null)
                {
                    filter.Add(new BsonDocument("IsArchived", isArchived));

                }
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var upsertDataLevelKeyConfigurations = BsonHelper.ConvertBsonDocumentListToModel<GetDataLevelKeyConfigurationModel>(aggregateDataList);
                return upsertDataLevelKeyConfigurations;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchLevelKeyConfiguration", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSets);
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
        public FilterDefinition<BsonDocument> GetUpdateDataSource(DataLevelKeyConfigurationModel dataLevelKeyConfigurationModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", dataLevelKeyConfigurationModel.Id.ToString()),
                fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()));

        }
    }
}