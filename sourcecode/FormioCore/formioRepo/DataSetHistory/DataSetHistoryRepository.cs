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

namespace formioRepo.DataSetHistory
{
    public class DataSetHistoryRepository : IDataSetHistoryRepository
    {
        private IConfiguration _iconfiguration;
        public DataSetHistoryRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }
        public Guid? CreateDataSetHistory(DataSetHistoryInputModel dataSetHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                dataSetHistoryInputModel.Id = Guid.NewGuid();
                dataSetHistoryInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                dataSetHistoryInputModel.CreatedDateTime = DateTime.UtcNow;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetHistory", "DataSetHistoryRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSetHistory);
                datasetCollection.InsertOne(dataSetHistoryInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetHistory", "DataSetHistoryRepository"));
                return dataSetHistoryInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSetHistory", "DataSetHistoryRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }
        public List<DataSetHistoryInputModel> SearchDataSetHistory(Guid? dataSetId,Guid? referenceId, int? pageNo, int? pageSize, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var dataSetHistoryRecords = new List<DataSetHistoryInputModel>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetHistory", "DataSetHistoryRepository"));
                IMongoCollection<DataSetHistoryInputModel> datasetCollection = GetMongoCollectionObject<DataSetHistoryInputModel>(MongoDBCollectionConstants.DataSetHistory);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSetHistory", "DataSetHistoryRepository"));
                var filter = new BsonArray
                {
                    
                };
                if (dataSetId != null)
                {
                   filter.Add(new BsonDocument("DataSetId", dataSetId.ToString()));
                }

                var lookUp = new BsonDocument("$lookup",
                              new BsonDocument {
                               { "from", "DataSet" },
                               { "localField", "DataSetId" },
                               { "foreignField", "_id" },
                               { "as", "datasets" }
                 });
               
                
                var dataSourcelookUp = new BsonDocument("$lookup",
                              new BsonDocument {
                               { "from", "DataSource" },
                               { "localField", "DataSourceId" },
                               { "foreignField", "_id" },
                               { "as", "dataSource" }
                 });
                
                var dataSourceKeylookUp = new BsonDocument("$lookup",
                              new BsonDocument {
            { "from", "DataSourceKeys" },
            { "let",
    new BsonDocument
            {
                { "dsId", "$DataSourceId" },
                { "field", "$Field" }
            } },
            { "pipeline",
    new BsonArray
            {
                new BsonDocument("$match",
                new BsonDocument("$expr",
                new BsonDocument("$and",
                new BsonArray
                            {
                                new BsonDocument("$eq",
                                new BsonArray
                                    {
                                        "$DataSourceId",
                                        "$$dsId"
                                    }),
                                new BsonDocument("$eq",
                                new BsonArray
                                    {
                                        "$Key",
                                        "$$field"
                                    })
                            })))
            } },
            { "as", "DataSourceKeys" }
        });

                var dataSourceKeysSet = new BsonDocument("$set",
                          new BsonDocument{
                                { "Label", new BsonDocument("$arrayElemAt", new BsonArray{ "$DataSourceKeys.Label", 0}) },
                                { "Type", new BsonDocument("$arrayElemAt", new BsonArray{ "$DataSourceKeys.Type", 0}) },
                                { "Format", new BsonDocument("$arrayElemAt", new BsonArray{ "$DataSourceKeys.Format", 0}) },
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{ "$dataSource.Name", 0}) }
               });
                var skip = ((pageNo - 1) * pageSize);
                var facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                             new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)),
                                 new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", pageSize)}},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });
                var unwind = new BsonDocument("$unwind", new BsonDocument("path", "$Data"));
                var dataSetStage = new BsonDocument("$set",
                                   new BsonDocument("TotalCount", new BsonDocument("$arrayElemAt", new BsonArray
                                   {
                                       "$TotalCount.TotalCount",
                                        0
                                })));
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(filter)));
               
                var stages = new List<BsonDocument>();
                stages.Add(lookUp);
                stages.Add(matchStage);
                stages.Add(dataSourcelookUp);
                stages.Add(dataSourceKeylookUp);
                stages.Add(dataSourceKeysSet);
                stages.Add(facet);
                stages.Add(unwind);
                stages.Add(dataSetStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var history = BsonHelper.ConvertBsonDocumentListToModel<DataSetHistoryConversionModel>(aggregateDataList);
                if(history.Count == 0)
                {
                    return dataSetHistoryRecords;
                } 
                else
                {
                    dataSetHistoryRecords = history.Select(e => new DataSetHistoryInputModel
                    {
                        Id = e.Data.Id,
                        DataSetId = e.Data.DataSetId,
                        Field = e.Data.Field,
                        OldValue = e.Data.OldValue,
                        NewValue = e.Data.NewValue,
                        CreatedByUserId = e.Data.CreatedByUserId,
                        CreatedDateTime = e.Data.CreatedDateTime,
                        Description = e.Data.Description,
                        DataSetFormData = e.Data.DataSetFormData,
                        DataSourceFormJson = e.Data.DataSourceFormJson,
                        DataSourceName = e.Data.DataSourceName,
                        DataSourceId = e.Data.DataSourceId,
                        datasets = e.Data.datasets,
                        dataSource = e.Data.dataSource,
                        TotalCount = e.TotalCount,
                        Label = e.Data.Label,
                        Type = e.Data.Type,
                        Format = e.Data.Format
                       
                    }).ToList();

                    return dataSetHistoryRecords;
                }
               
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSetRepository", exception));
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
    }
}
