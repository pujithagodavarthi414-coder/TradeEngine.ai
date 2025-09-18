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

namespace formioRepo.DataSourceHistory
{
    public class DataSourceHistoryRepository : IDataSourceHistoryRepository
    {
        private readonly IConfiguration _iconfiguration;
        public DataSourceHistoryRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }
        public Guid? CreateDataSourceHistory(DataSourceHistoryInputModel dataSourceHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var id = Guid.NewGuid();
                dataSourceHistoryInputModel.Id = Guid.NewGuid();
                dataSourceHistoryInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                dataSourceHistoryInputModel.CreatedDateTime = DateTime.UtcNow;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceHistory", "DataSourceHistoryRepository"));
                IMongoCollection<BsonDocument> dataSourceCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceHistory);
                dataSourceCollection.InsertOne(dataSourceHistoryInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceHistory", "DataSourceHistoryRepository"));
                return id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSourceHistory", "DataSourceHistoryRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceHistory);
                return null;
            }
        }

        public List<DataSourceHistoryOutputModel> SearchDataSourceHistory(DataSourceHistorySearchInputModel dataSourceHistorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceHistory", "DataSourceHistoryRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceHistory);
                var filter = new List<BsonDocument>
                {

                    new BsonDocument("IsArchived", false)
                };
                
                if (dataSourceHistorySearchInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceHistorySearchInputModel.Id.ToString()));
                }
                if (dataSourceHistorySearchInputModel.DataSourceId != null)
                {
                    filter.Add(new BsonDocument("DataSourceId", dataSourceHistorySearchInputModel.DataSourceId.ToString()));
                }
                var lookUp = new BsonDocument("$lookup",
                           new BsonDocument {
                               { "from", "DataSource" },
                               { "localField", "DataSourceId" },
                               { "foreignField", "_id" },
                               { "as", "dataSources" }
              });
              var set = new BsonDocument("$set",
                           new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSources.Name", 0}) }

                });
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookUp);
                stages.Add(set);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceHistoryOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceHistory", "DataSourceHistoryRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSourceHistory);
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

        
    }
}
