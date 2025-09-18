using formioCommon.Constants;
using formioModels;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using formioModels.Data;
using formioRepo.Helpers;
using System.Linq;
using MongoDB.Bson.Serialization;
using Newtonsoft.Json;
using System.Threading.Tasks;
using Newtonsoft.Json.Linq;
using System.IO;
using Jint.Parser;

namespace formioRepo.DataSource
{
    public class DataSourceRepository : IDataSourceRepository
    {
        IConfiguration _iconfiguration;
        public DataSourceRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                var id = Guid.NewGuid();
                dataSourceInputModel.Id = id;
                if (dataSourceInputModel.SubmittedByFormDrill)
                {
                    dataSourceInputModel.CompanyId = dataSourceInputModel.SubmittedCompanyId;
                    dataSourceInputModel.CreatedByUserId = dataSourceInputModel.SubmittedUserId;
                }
                else
                {
                    dataSourceInputModel.CompanyId = loggedInContext.CompanyGuid;
                    dataSourceInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                }
                dataSourceInputModel.CreatedDateTime = DateTime.UtcNow;
                dataSourceInputModel.IsArchived = false;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSourceStart", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataSourceCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);
                var fBuilder = Builders<BsonDocument>.Filter;
                var dataSourcesCount = dataSourceCollection
                    .Find(fBuilder.And(fBuilder.Eq("Name", dataSourceInputModel.Name.Trim()),
                    fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString())))
                    .CountDocuments();
                if (dataSourcesCount > 0)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.DataSourceExist, dataSourceInputModel.Name.Trim())
                    });

                    return null;
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceBeforeExec", "DataSourceRepository"));
                dataSourceCollection.InsertOne(dataSourceInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSourceAfterExe", "DataSourceRepository"));
                return id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSource", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSource);
                return null;
            }
        }
        public FilterDefinition<BsonDocument> GetUpdateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
                return fBuilder.And(fBuilder.Eq("_id", dataSourceInputModel.Id.ToString()),
                    fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()));
        }
        public Guid? UpdateDataSource(DataSourceInputModel dataSourceInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSource", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);
                if (!string.IsNullOrEmpty(dataSourceInputModel.Name))
                {
                    var CompanyId = loggedInContext.CompanyGuid;
                    if (dataSourceInputModel.SubmittedByFormDrill)
                    {
                        CompanyId = (Guid)dataSourceInputModel.SubmittedCompanyId;
                    }
                    else
                    {
                        CompanyId = loggedInContext.CompanyGuid;
                    }
                    var fBuilder = Builders<BsonDocument>.Filter;
                    var channelsCount = dataCollection
                        .Find(fBuilder.And(fBuilder.Eq("Name", dataSourceInputModel.Name.Trim()),
                    fBuilder.Eq("CompanyId", CompanyId.ToString())))
                        .CountDocuments();
//                    new BsonArray
//{
//    new BsonDocument("$match",
//    new BsonDocument("Name", dataSourceInputModel.Name)),
//    new BsonDocument("$match",
//    new BsonDocument("_id",
//    new BsonDocument("$ne", dataSourceInputModel.Id.ToString())))
//};
                    if (channelsCount > 1)
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.DataSourceExist, dataSourceInputModel.Name.Trim())
                        });

                        return null;
                    }
                    var currentUtcTime = DateTime.UtcNow;
                    var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("Name", dataSourceInputModel.Name),
                    Builders<BsonDocument>.Update.Set("Description", dataSourceInputModel.Description),
                    Builders<BsonDocument>.Update.Set("Tags", dataSourceInputModel.Tags),
                    Builders<BsonDocument>.Update.Set("DataSourceType", dataSourceInputModel.DataSourceType),
                    Builders<BsonDocument>.Update.Set("IsArchived", dataSourceInputModel.IsArchived),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", (dataSourceInputModel.SubmittedByFormDrill==true?dataSourceInputModel.SubmittedUserId.ToString():loggedInContext.LoggedInUserId.ToString())),
                    Builders<BsonDocument>.Update.Set("Fields", dataSourceInputModel.Fields),
                    Builders<BsonDocument>.Update.Set("FormBgColor", dataSourceInputModel.FormBgColor),
                    Builders<BsonDocument>.Update.Set("ViewFormRoleIds", dataSourceInputModel.ViewFormRoleIds),
                    Builders<BsonDocument>.Update.Set("EditFormRoleIds", dataSourceInputModel.EditFormRoleIds)
                };
                    if (dataSourceInputModel.IsArchived)
                    {
                        update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));
                        update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                    }
                    var updateFields = Builders<BsonDocument>.Update.Combine(update);
                    var filterObject = GetUpdateDataSource(dataSourceInputModel, loggedInContext);
                    dataCollection.UpdateOne(filter: filterObject, update: updateFields);

                }
                
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSource", "DataSourceRepository"));
                return dataSourceInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSource", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSource);
                return null;
            }
        }
        public List<DataSourceOutputModel> SearchDataSource(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);
                var moduleTypeNumber = 0;
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived)
                };
                if(dataSourceSearchCriteriaInputModel.IsIncludedAllForms == false)
                {
                    if (dataSourceSearchCriteriaInputModel.UserCompanyIds != null && dataSourceSearchCriteriaInputModel.UserCompanyIds.Count > 0)
                    {
                        var companyIds = dataSourceSearchCriteriaInputModel.UserCompanyIds.Select(g => g.ToString()).ToList();
                        if (!dataSourceSearchCriteriaInputModel.IsCompanyBased)
                        {
                            companyIds.Add(loggedInContext.CompanyGuid.ToString());
                        }

                        filter.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                                            BsonHelper.ConvertGenericListToBsonArray(companyIds))));
                    }
                    else
                    {
                        filter.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                    }
                }
                if (dataSourceSearchCriteriaInputModel.SearchText != null)
                {
                    filter.Add(new BsonDocument("$or",
                new BsonArray
                    {
                        new BsonDocument("Name",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("DataSourceType",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("Description",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}")))
                    }));
                }
                if (dataSourceSearchCriteriaInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
                }
                if (dataSourceSearchCriteriaInputModel.CompanyModuleId != null)
                {
                    filter.Add(new BsonDocument("CompanyModuleId", dataSourceSearchCriteriaInputModel.CompanyModuleId.ToString()));
                }
                if(dataSourceSearchCriteriaInputModel.FormIds != null && dataSourceSearchCriteriaInputModel.FormIds.Count > 0)
                {
                    var dataSourceIdValues = dataSourceSearchCriteriaInputModel.FormIds.Select(g => g.ToString()).ToList(); 

                    filter.Add(new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSourceIdValues))));
                }
                if(dataSourceSearchCriteriaInputModel.DataSourceType != null)
                {
                    var dataSourceType = dataSourceSearchCriteriaInputModel.DataSourceType;

                    filter.Add(new BsonDocument("DataSourceType", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSourceType))));
                }
               
                if(dataSourceSearchCriteriaInputModel.ParamsJson != null)
                {
                    foreach (var jsonModel in dataSourceSearchCriteriaInputModel.ParamsJson)
                    {
                        if (jsonModel.KeyName != "ReferenceId")
                        {
                            var searchName = "Fields." + jsonModel.KeyName;
                            filter.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                            if (jsonModel.KeyValue != null)
                            {
                                if (jsonModel.Type == "number")
                                {
                                    if (jsonModel.KeyName == "ModuleTypeId")
                                    {
                                        moduleTypeNumber = Convert.ToInt32(jsonModel.KeyValue);
                                    }
                                    filter.Add(new BsonDocument(searchName, Convert.ToInt32(jsonModel.KeyValue)));
                                }
                                else
                                {
                                    filter.Add(new BsonDocument(searchName, jsonModel.KeyValue.ToString()));
                                }
                            }
                        }
                        else
                        {
                            filter.Add(new BsonDocument("Fields.ReferenceId", new BsonDocument("$exists", true)));
                            if (moduleTypeNumber != 4 && moduleTypeNumber != 6 && moduleTypeNumber != 7 && moduleTypeNumber != 2 && moduleTypeNumber != 78)
                            {
                                filter.Add(new BsonDocument("Fields.ReferenceId", jsonModel.KeyValue.ToString()));
                            }
                        }
                    }
                }
                
                var lookUp = new BsonDocument("$lookup",
                             new BsonDocument {
                               { "from", "DataSet" },
                               { "localField", "_id" },
                               { "foreignField", "DataSourceId" },
                               { "as", "datasets" }
                });
                var set = new BsonDocument("$set",
                           new BsonDocument{
                                { "DataSetId", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets._id",0}) },
                                { "DataSetFormJson", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataJson",0}) }
                              
                });
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
               var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSource", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }
         public List<DataSourceOutputModel> SearchDataSourceUnAuth(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSource", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);
                var moduleTypeNumber = 0;
                var filter = new List<BsonDocument>
                {
                    //new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                    new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived),
                    new BsonDocument("Fields.AllowAnnonymous", true)
                };
                //if(dataSourceSearchCriteriaInputModel.UserCompanyIds != null && dataSourceSearchCriteriaInputModel.UserCompanyIds.Count > 0)
                //{
                //    var companyIds = dataSourceSearchCriteriaInputModel.UserCompanyIds.Select(g => g.ToString()).ToList();
                //    if (!dataSourceSearchCriteriaInputModel.IsCompanyBased)
                //    {
                //        companyIds.Add(loggedInContext.CompanyGuid.ToString());
                //    }

                //    filter.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                //                        BsonHelper.ConvertGenericListToBsonArray(companyIds))));
                //} else
                //{
                //    filter.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                //}
                if (dataSourceSearchCriteriaInputModel.SearchText != null)
                {
                    filter.Add(new BsonDocument("$or",
                new BsonArray
                    {
                        new BsonDocument("Name",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("DataSourceType",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("Description",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}")))
                    }));
                }
                if (dataSourceSearchCriteriaInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
                }
                if (dataSourceSearchCriteriaInputModel.CompanyModuleId != null)
                {
                    filter.Add(new BsonDocument("CompanyModuleId", dataSourceSearchCriteriaInputModel.CompanyModuleId.ToString()));
                }
                if(dataSourceSearchCriteriaInputModel.FormIds != null && dataSourceSearchCriteriaInputModel.FormIds.Count > 0)
                {
                    var dataSourceIdValues = dataSourceSearchCriteriaInputModel.FormIds.Select(g => g.ToString()).ToList(); 

                    filter.Add(new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSourceIdValues))));
                }
                if(dataSourceSearchCriteriaInputModel.DataSourceType != null)
                {
                    var dataSourceType = dataSourceSearchCriteriaInputModel.DataSourceType;

                    filter.Add(new BsonDocument("DataSourceType", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSourceType))));
                }
               
                if(dataSourceSearchCriteriaInputModel.ParamsJson != null)
                {
                    foreach (var jsonModel in dataSourceSearchCriteriaInputModel.ParamsJson)
                    {
                        if (jsonModel.KeyName != "ReferenceId")
                        {
                            var searchName = "Fields." + jsonModel.KeyName;
                            filter.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                            if (jsonModel.KeyValue != null)
                            {
                                if (jsonModel.Type == "number")
                                {
                                    if (jsonModel.KeyName == "ModuleTypeId")
                                    {
                                        moduleTypeNumber = Convert.ToInt32(jsonModel.KeyValue);
                                    }
                                    filter.Add(new BsonDocument(searchName, Convert.ToInt32(jsonModel.KeyValue)));
                                }
                                else
                                {
                                    filter.Add(new BsonDocument(searchName, jsonModel.KeyValue.ToString()));
                                }
                            }
                        }
                        else
                        {
                            filter.Add(new BsonDocument("Fields.ReferenceId", new BsonDocument("$exists", true)));
                            if (moduleTypeNumber != 4 && moduleTypeNumber != 6 && moduleTypeNumber != 7 && moduleTypeNumber != 2 && moduleTypeNumber != 78)
                            {
                                filter.Add(new BsonDocument("Fields.ReferenceId", jsonModel.KeyValue.ToString()));
                            }
                        }
                    }
                }
                
                var lookUp = new BsonDocument("$lookup",
                             new BsonDocument {
                               { "from", "DataSet" },
                               { "localField", "_id" },
                               { "foreignField", "DataSourceId" },
                               { "as", "datasets" }
                });
                var set = new BsonDocument("$set",
                           new BsonDocument{
                                { "DataSetId", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets._id",0}) },
                                { "DataSetFormJson", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataJson",0}) }
                              
                });
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                //stages.Add(lookUp);
                //stages.Add(set);
                var pipeline = stages;
               var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSource", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public List<DataSourceOutputModel> SearchDataSourceForJob(DataSourceSearchCriteriaInputModel dataSourceSearchCriteriaInputModel,List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSourceForJob", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);
                var filter = new List<BsonDocument>
                {
                   
                    new BsonDocument("IsArchived", dataSourceSearchCriteriaInputModel.IsArchived)
                };
                if (dataSourceSearchCriteriaInputModel.SearchText != null)
                {
                    filter.Add(new BsonDocument("$or",
                new BsonArray
                    {
                        new BsonDocument("Name",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("DataSourceType",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}"))),
                        new BsonDocument("Description",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSourceSearchCriteriaInputModel.SearchText.Trim()}")))
                    }));
                }
                if (dataSourceSearchCriteriaInputModel.Id != null)
                {
                    filter.Add(new BsonDocument("_id", dataSourceSearchCriteriaInputModel.Id.ToString()));
                }
              
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSourceForJob", "DataSourceRepository", exception));
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

        public List<SearchDataSourceOutputModel> SearchAllDataSources(SearchDataSourceInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchAllDataSources", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);

                var stages = new List<BsonDocument>();

                stages = new List<BsonDocument> {
                            new BsonDocument("$lookup",
                            new BsonDocument
                                {
                                    { "from", "DataSourceKeys" },
                                    { "localField", "_id" },
                                    { "foreignField", "DataSourceId" },
                                    { "pipeline",
                            new BsonArray
                                    {
                                        new BsonDocument("$match",
                                        new BsonDocument("IsArchived", false))
                                    } },
                                    { "as", "KeySet" }
                                }),
                            //new BsonDocument("$match",
                            //new BsonDocument
                            //    {
                            //        { "IsArchived", false },
                            //        { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                            //    }),
                            //new BsonDocument("$match",
                            //new BsonDocument("KeySet",
                            //new BsonDocument("$not",
                            //new BsonDocument("$size", 0)))),
                            //new BsonDocument("$project",
                            //new BsonDocument
                            //    {
                            //        { "_id", 1 },
                            //        { "Name", 1 }
                            //    }
                            //)
                };

                var stage1 = new BsonDocument();
                if(loggedInContext != null)
                {
                    stage1 = new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { "IsArchived", false },
                                    { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                                });
                } 
                else
                {
                    stage1 = new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { "IsArchived", false },
                                    //{ "CompanyId", loggedInContext.CompanyGuid.ToString() },
                                });
                }
                stages.Add(stage1);

                var stage2 = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                            new BsonDocument("KeySet",
                            new BsonDocument("$not",
                            new BsonDocument("$size", 0)))),
                            new BsonDocument("$project",
                            new BsonDocument
                                {
                                    { "_id", 1 },
                                    { "Name", 1 }
                                }
                            )
                };
                stages.AddRange(stage2);
                if (inputModel.FormId != null)
                {
                    stages.Add(new BsonDocument("_id", inputModel.FormId.ToString()));
                }

                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<SearchDataSourceOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchAllDataSources", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public List<GetDataSourcesByIdOutputModel> GetDataSourcesById(GetDataSourcesByIdInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSourcesById", "DataSourceRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSource);

                var stages = new List<BsonDocument>();
                var filter = new List<BsonDocument>();

                List<string> companyIds = new List<string>();

                companyIds.Add(loggedInContext.CompanyGuid.ToString());

                if (!string.IsNullOrEmpty(inputModel.CompanyIds))
                {
                    companyIds.AddRange(inputModel.CompanyIds.Split(",").Select(g => g.ToString()).ToList());
                }

                filter.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(companyIds))));

                if (!string.IsNullOrEmpty(inputModel.FormIds))
                {
                    var formIds = inputModel.FormIds.Split(",").Select(g => g.ToString()).ToList();

                    filter.Add(new BsonDocument("_id", new BsonDocument("$in",
                                            BsonHelper.ConvertGenericListToBsonArray(formIds))));
                }

                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));

                var finalStages = new List<BsonDocument> {
                            new BsonDocument("$lookup",
                            new BsonDocument
                                {
                                    { "from", "DataSourceKeys" },
                                    { "localField", "_id" },
                                    { "foreignField", "DataSourceId" },
                                    { "pipeline", new BsonArray
                                                         {
                                                             new BsonDocument("$match",
                                                             new BsonDocument("$and",
                                                             new BsonArray
                                                                     {
                                                                         new BsonDocument("IsArchived", false)
                                                                     })),
                                                             new BsonDocument("$project",
                                                             new BsonDocument
                                                                 {
                                                                     { "_id", 1 },
                                                                     { "Key", 1 },
                                                                     { "Label", 1 },
                                                                     { "Type", 1 },
                                                                     { "Path", 1 }
                                                                 })
                                                         } },
                                    { "as", "KeySet" }
                                }),
                            new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { "IsArchived", false },
                                }),
                            new BsonDocument("$match",
                            new BsonDocument("KeySet",
                            new BsonDocument("$not",
                            new BsonDocument("$size", 0)))),
                            new BsonDocument("$project",
                            new BsonDocument
                                {
                                    { "_id", 1 },
                                    { "Name", 1 },
                                    { "KeySet", 1 }
                                }
                            )
                };

                stages.Add(matchStage);
                stages.AddRange(finalStages);

                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<GetDataSourcesByIdOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSourcesById", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public string GenericQueryApi(string inputQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GenericQueryApi", "DataSourceRepository"));

                var db = GetMongoDbConnection();

                var cmd = new JsonCommand<BsonDocument>(inputQuery);
                var result = db.RunCommand(cmd);
                
                return result.ToJson();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GenericQueryApi", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public GetFormFieldValuesOutputModel GetFormFieldValues(GetFormFieldValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "DataSourceRepository"));

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                GetFormFieldValuesOutputModel formFieldValuesOuputModel = new GetFormFieldValuesOutputModel();
                SampleOutputModel keysData = new SampleOutputModel();
                var matchStage = new List<BsonDocument>();

                if (inputModel.FormId != null && inputModel.Key != null)
                {
                    IMongoCollection<BsonDocument> keysDataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                    var keyStages = new List<BsonDocument>();

                    var matchStage1 = new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", new List<BsonDocument>() {
                            //new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()) ,
                            new BsonDocument("IsArchived", false),
                            new BsonDocument("Path", inputModel.Key),
                            new BsonDocument("DataSourceId", inputModel.FormId.ToString()),
                        }));

                    keyStages.Add(matchStage1);

                    keyStages.Add(new BsonDocument("$project", new BsonDocument
                                                          {
                                                              { "Key", 1 },
                                                              { "Type", 1 },
                                                              { "DecimalLimit", 1 },
                                                              { "RequireDecimal", 1 },
                                                              { "Format", 1 },
                                                              { "Delimiter", 1 }
                                                          }));
                    var aggregateDataList = keysDataCollection.Aggregate<BsonDocument>(keyStages, aggregateOptions).ToList();
                    keysData = BsonHelper.ConvertBsonDocumentListToModel<SampleOutputModel>(aggregateDataList).FirstOrDefault();
                }

                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                var datasetMatch = new List<BsonDocument>();

                List<string> ids = new List<string>();

                if (!string.IsNullOrEmpty(inputModel.CompanyIds))
                {
                    ids = inputModel.CompanyIds.Split(',').ToList();
                }

                if (inputModel.CompanyIds != null && ids.Count > 0)
                {
                    ids.Add(loggedInContext.CompanyGuid.ToString());
                    datasetMatch.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(ids))));
                }
                else
                {
                    datasetMatch.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                }
                if (inputModel.FormId != null)
                {
                        datasetMatch.Add(new BsonDocument("DataSourceId", inputModel.FormId.ToString()));
                }
                if (inputModel.FilterValue != null && !string.IsNullOrEmpty(inputModel.FilterValue))
                {
                    datasetMatch.Add(
                        new BsonDocument("DataJson.FormData." + inputModel.Key,
                        new BsonDocument("$regex",
                            new Regex($"{inputModel.FilterValue.Trim()}", RegexOptions.IgnoreCase)))
                    );
                }

                var FormDataLookUpFilter = new BsonDocument("DataJson.FormData",
                                 new BsonDocument
                                         {
                                                     { "$exists", true },
                                                     { "$ne", BsonNull.Value }
                                         });

                datasetMatch.Add(FormDataLookUpFilter);
                datasetMatch.Add(new BsonDocument("IsArchived", false));
                if (inputModel.FilterFieldsBasedOnForm == true && !string.IsNullOrEmpty(inputModel.FilterFormName))
                {
                    datasetMatch.Add(new BsonDocument("$or",
                    new BsonArray
                    {
                        new BsonDocument("DataJson.FormData." + inputModel.Key,
                        new BsonDocument("$regex",
                            new Regex($"(?i){inputModel.FilterFormName.Trim()}")))
                    }));
                    //new BsonDocument
                    //                    {
                    //                        { "$regex",
                    //            new Regex(fieldData.Value.ToString().Trim()) },
                    //                        { "$options", "i" }
                    //                    }))
                }

                matchStage.Add(new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", datasetMatch)));
                var unwinddirec = new List<BsonDocument>();
                if(inputModel != null && !string.IsNullOrWhiteSpace(inputModel.Key))
                {
                    var splitLoop = inputModel.Key.Split(".").ToArray();
                    var s1 = string.Empty;
                    var index = 0;
                    foreach (var s in splitLoop)
                    {
                        if (index == 0)
                        {
                            s1 = s1 + s;
                        }
                        else
                        {
                            s1 = s1 + "." + s;
                        }
                        var unwindrec = new BsonDocument("$unwind", "$DataJson.FormData." + s1);
                        unwinddirec.Add(unwindrec);
                        matchStage.Add(unwindrec);
                        index++;
                    }

                    var doc = new BsonDocument("$addFields", new BsonDocument("Data", "$DataJson.FormData." + inputModel.Key));
                    if (inputModel.FilterValue != null && !string.IsNullOrEmpty(inputModel.FilterValue))
                    {
                        var proj1 = new BsonDocument("$project", new BsonDocument { { "Data", 1 }, { "_id", 0 }, { "DataLength", new BsonDocument { { "$strLenCP", "$Data" } } } });
                        var facet = new List<BsonDocument> {
                                            new BsonDocument("$sort",
                                                new BsonDocument("DataLength", 1)),
                                            };
                        matchStage.Add(doc);
                        matchStage.Add(proj1);
                        matchStage.AddRange(facet);
                        if (inputModel.PageNumber != null && inputModel.PageSize != null)
                        {
                            var skip = ((inputModel.PageNumber - 1) * inputModel.PageSize);
                            var facet1 = new List<BsonDocument> { new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", inputModel.PageSize)
                                            };
                            matchStage.AddRange(facet1);
                        }
                        var proj2 = new BsonDocument("$project", new BsonDocument { { "Data", 1 }});
                        matchStage.Add(proj2);
                    }
                    else 
                    {
                        //inputModel.PageNumber = inputModel.PageNumber ?? 1;
                        //inputModel.PageSize = inputModel.PageSize ?? 500;
                        var proj = new BsonDocument("$project", new BsonDocument { { "Data", 1 }, { "_id", 0 } });
                        var facet = new List<BsonDocument> {
                                            new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)),
                                            };
                        matchStage.Add(doc);
                        matchStage.Add(proj);
                        matchStage.AddRange(facet);
                        if (inputModel.PageNumber != null && inputModel.PageSize != null) 
                        {
                            var skip = ((inputModel.PageNumber - 1) * inputModel.PageSize);
                            var facet1 = new List<BsonDocument> { new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", inputModel.PageSize)
                                            };
                            matchStage.AddRange(facet1);
                        }
                    }
                }
                List<DataSetOutputModelForFormFields> dataSetList = new List<DataSetOutputModelForFormFields>();
                var dataSets = datasetCollection.Aggregate<BsonDocument>(matchStage, aggregateOptions).ToList();

                List<dynamic> keyValues = new List<dynamic>();

                keyValues = BsonHelper.ConvertBsonDocumentListToModel<InnerOutputModel>(dataSets).Select(x => x.Data).ToList();

                if (inputModel.FilterValue != null && !string.IsNullOrEmpty(inputModel.FilterValue))
                {
                    keyValues = keyValues.Where(x => x.GetType() == typeof(string) ? x.ToLower().Contains(inputModel.FilterValue.ToLower()) : x.toString().ToLower().Contains(inputModel.FilterValue.ToLower())).ToList();
                }

                if (inputModel.FormId != null && inputModel.Value != null && !string.IsNullOrEmpty(inputModel.Value))
                {
                    var ds = new List<BsonDocument> {
                        new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", new List<BsonDocument>() {
                                new BsonDocument("DataSourceId", inputModel.FormId.ToString()),
                                new BsonDocument("DataJson.FormData." + inputModel.Key,inputModel.Value)
                                }))
                            };
                    ds.AddRange(unwinddirec);
                    ds.Add(new BsonDocument("$addFields", new BsonDocument("Data", "$DataJson.FormData." + inputModel.Key)));
                    ds.Add(new BsonDocument("$project", new BsonDocument { { "Data", 1 }, { "_id", 0 } }));
                    //matchStage.Insert(0,ds);
                    var dataSetsFilter = datasetCollection.Aggregate<BsonDocument>(ds, aggregateOptions).ToList();
                    var kv = BsonHelper.ConvertBsonDocumentListToModel<InnerOutputModel>(dataSetsFilter).Select(x => x.Data).ToList();
                    var data = kv?.FirstOrDefault(x => x == inputModel.Value);
                    keyValues.Add(data);
                }

                

                if (inputModel.FilterFieldsBasedOnForm == true && !string.IsNullOrEmpty(inputModel.FilterFormName))
                {
                    formFieldValuesOuputModel.FieldValues = keyValues.Distinct().Where(x => x.GetType() == typeof(string) ? x.ToLower().Contains(inputModel.FilterFormName.ToLower())  : x.toString().ToLower().Contains(inputModel.FilterFormName.ToLower())).ToList();
                }
                else
                {
                    formFieldValuesOuputModel.FieldValues = keyValues.Distinct().ToList();
                }

                if (keysData != null)
                {
                    formFieldValuesOuputModel.Key = keysData.Key;
                    formFieldValuesOuputModel.Type = keysData.Type;
                    formFieldValuesOuputModel.DecimalLimit = keysData.DecimalLimit;
                    formFieldValuesOuputModel.Format = keysData.Format;
                    formFieldValuesOuputModel.Delimiter = keysData.Delimiter;
                    formFieldValuesOuputModel.RequireDecimal = keysData.RequireDecimal;
                }

                return formFieldValuesOuputModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public string GetFormRecordValues(GetFormRecordValuesInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFormFieldValues", "DataSourceRepository"));

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                IMongoCollection<DataSourceOutputModel> dataSourceCollection = GetMongoCollectionObject<DataSourceOutputModel>(MongoDBCollectionConstants.DataSource);
                IMongoCollection<DataSourceKeysOutputModel> dataSourceKeysCollection = GetMongoCollectionObject<DataSourceKeysOutputModel>(MongoDBCollectionConstants.DataSourceKeys);
                
                var companyIdsMatch = new List<BsonDocument>();
                var datasetMatch = new List<BsonDocument>();
                var matchStage = new List<BsonDocument>();
                var datasetPipeline = new List<BsonDocument>();

                List<string> ids = new List<string>();

                if (!string.IsNullOrEmpty(inputModel.CompanyIds))
                {
                    ids = inputModel.CompanyIds.Split(',').ToList();
                }

                if (inputModel.CompanyIds != null && ids.Count > 0)
                {
                    ids.Add(loggedInContext.CompanyGuid.ToString());
                    companyIdsMatch.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(ids))));
                }
                else
                {
                    companyIdsMatch.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                }

                if (inputModel.FormsModel != null && inputModel.FormsModel.Count > 0)
                {
                    List<string> formIds = new List<string>();
                    formIds = inputModel.FormsModel.Select(x => x.FormId.ToString()).ToList();
                    datasetMatch.Add(new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(formIds))));
                }

                datasetMatch.Add(new BsonDocument("IsArchived", false));

                matchStage.Add(new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", datasetMatch)));

                matchStage.Add(new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", companyIdsMatch)));

                matchStage.Add(new BsonDocument("$project", new BsonDocument { { "CreatedDateTime", 1 }, { "Name", 1 }, { "_id", 1 } }));
                
                var dataSourceList = dataSourceCollection.Aggregate<BsonDocument>(matchStage, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSourceOutputModel>(dataSourceList);

                Guid? formId = dataSources.Select(x => x.Id).FirstOrDefault();
                if (formId != null)
                {
                    datasetPipeline.Add(new BsonDocument("$match", new BsonDocument("DataSourceId", formId.ToString())));
                }

                var FormDataLookUpFilter = new BsonDocument("DataJson.FormData",
                                 new BsonDocument
                                         {
                                                     { "$exists", true },
                                                     { "$ne", BsonNull.Value }
                                         });

                datasetPipeline.Add(new BsonDocument("$match", new BsonDocument("IsArchived", false)));
                datasetPipeline.Add(new BsonDocument("$match", FormDataLookUpFilter));

                datasetPipeline.Add(new BsonDocument("$match", new BsonDocument("DataJson.FormData." + inputModel.KeyName, inputModel.KeyValue)));
                datasetPipeline.Add(new BsonDocument("$match",
                        BsonHelper.GetBsonDocumentWithConditionalObject("$and", companyIdsMatch)));

                var splits = inputModel.KeyName?.Split('.');
                var splitLoop = splits.SkipLast(1).ToArray();
                var s1 = string.Empty;
                var index = 0;
                foreach (var s in splitLoop)
                {
                    if (index == 0)
                    {
                        s1 = s1 + s;
                    }
                    else
                    {
                        s1 = s1 + "." + s;
                    }
                    var unwindrec = new BsonDocument("$unwind", "$DataJson.FormData." + s1);
                    datasetPipeline.Add(unwindrec);
                    datasetPipeline.Add(new BsonDocument("$match", new BsonDocument("DataJson.FormData." + inputModel.KeyName, inputModel.KeyValue)));
                    index++;
                }

                var dict = new Dictionary<string, object>();
                foreach (var formModel in inputModel.FormsModel)
                {
                    var path = formModel.Path;
                    var af = new BsonDocument("$addFields", new BsonDocument(formModel.KeyName + "-Value", "$DataJson.FormData." + path));
                    datasetPipeline.Add(af);
                    dict.Add(formModel.KeyName + "-Value", 1);
                }
                dict.Add("_id", 0);
                dict.Add("CreatedDateTime", 1);
                var proj = new BsonDocument("$project", new BsonDocument(dict));
                datasetPipeline.Add(proj);

                if(inputModel.IsForRq != true)
                {
                    int pageSize = 100;
                    int pageNumber = 1;
                    var skip = ((pageNumber - 1) * pageSize);

                    var facet = new List<BsonDocument> {
                                            new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)),
                                             new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", pageSize),
                                                new BsonDocument("$project", new BsonDocument("CreatedDateTime", 0)),
                    };

                    datasetPipeline.AddRange(facet);
                }
                List<DataSetOutputModelForFormFields> dataSetList = new List<DataSetOutputModelForFormFields>();
                var dataSets = datasetCollection.Aggregate<BsonDocument>(datasetPipeline, aggregateOptions).ToList();

                var dataSourceKeysPipeline = new List<BsonDocument> {
                                             new BsonDocument("$match", new BsonDocument("DataSourceId", formId.ToString())),
                                             new BsonDocument("$match", new BsonDocument("IsArchived", false)),
                };
                var formDict = new Dictionary<object, Array>();
                if (inputModel.IsForRq == true && dataSets != null && dataSets.Count > 0)
                {

                    var ls = new List<object>();
                    foreach (var d in dataSets)
                    {
                        var ar = new Dictionary<string, object>();
                        foreach (var form in inputModel.FormsModel)
                        {
                            var keyFilter = new List<BsonDocument>();
                            string keyName = form.KeyName + "-Value";
                            keyFilter.AddRange(dataSourceKeysPipeline);
                            keyFilter.Add(new BsonDocument("$match", new BsonDocument("Key", form.KeyName)));
                            var keys = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(dataSourceKeysCollection.Aggregate<BsonDocument>
                                                                                          (keyFilter, aggregateOptions).ToList()).OrderByDescending(x => x.Key).FirstOrDefault();
                            BsonValue value1;
                            string value = d.TryGetValue(keyName, out value1) ? value1.ToString() : null;
                            ar.Add(form.KeyName, value == "BsonNull" ? null : value);
                            ar.Add(form.KeyName + "-Type", keys?.Type);
                            ar.Add(form.KeyName + "-Format", keys?.Format);
                            ar.Add(form.KeyName + "-DecimalLimit", keys?.DecimalLimit);
                            ar.Add(form.KeyName + "-RequireDecimal", keys?.RequireDecimal);
                            ar.Add(form.KeyName + "-Delimiter", keys?.Delimiter);
                        }
                        var a = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ar));
                        ls.Add(a);
                    }
                    formDict.Add(inputModel.FormsModel.Select(x => x.FormName).FirstOrDefault(), ls.ToArray());
                }
                else if (inputModel.IsForRq != true && dataSets != null && dataSets.Count > 0)
                {
                    var ar = new Dictionary<string, object>();
                    foreach (var form in inputModel.FormsModel)
                    {
                        var keyFilter = new List<BsonDocument>();
                        string keyName = form.KeyName + "-Value";
                        keyFilter.AddRange(dataSourceKeysPipeline);
                        keyFilter.Add(new BsonDocument("$match", new BsonDocument("Key", form.KeyName)));
                        var keys = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(dataSourceKeysCollection.Aggregate<BsonDocument>
                                                                                      (keyFilter, aggregateOptions).ToList()).OrderByDescending(x => x.Key).FirstOrDefault();
                        BsonValue value1;
                        string value = dataSets[0].TryGetValue(keyName, out value1) ? value1.ToString() : null;
                        ar.Add(form.KeyName, value == "BsonNull" ? null : value);
                        ar.Add(form.KeyName + "-Type", keys?.Type);
                        ar.Add(form.KeyName + "-Format", keys?.Format);
                        ar.Add(form.KeyName + "-DecimalLimit", keys?.DecimalLimit);
                        ar.Add(form.KeyName + "-RequireDecimal", keys?.RequireDecimal);
                        ar.Add(form.KeyName + "-Delimiter", keys?.Delimiter);
                    }
                    var a = JsonConvert.DeserializeObject(JsonConvert.SerializeObject(ar));
                    formDict.Add(inputModel.FormsModel.Select(x => x.FormName).FirstOrDefault(), new[] { a });

                }
                return JsonConvert.SerializeObject(formDict);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFormFieldValues", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSource);
                return null;
            }
        }

        public NotificationModel UpsertNotification(NotificationModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> notifyCol = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.Notifications);
                notifyCol.InsertOne(inputModel.ToBsonDocument());
                return inputModel;
            }
            catch(Exception e)
            {
                return null;
            }
        }

        public List<NotificationModel> GetNotifications(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> notifyCol = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.Notifications);
                var stages = new List<BsonDocument>();
                var filter = new List<BsonDocument>
                {
                    //new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                    new BsonDocument("CreatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                    new BsonDocument("IsArchived", false),
                    new BsonDocument("ReadTime", BsonNull.Value),
                };
                //var filter1 = new BsonDocument("ReadTime",
                //                 new BsonDocument
                //                         {
                //                                     { "$exists", true },
                //                                     { "$ne", BsonNull.Value }
                //                         });
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = notifyCol.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var nfs = BsonHelper.ConvertBsonDocumentListToModel<NotificationModel>(aggregateDataList);
                return nfs;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public List<Guid?> UpsertReadNewNotifications(NotificationReadModel model, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            IMongoCollection<BsonDocument> notifyCol = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.Notifications);
            var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", model.ReadTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                    Builders<BsonDocument>.Update.Set("ReadTime", model.ReadTime)
                };
            var updateFields = Builders<BsonDocument>.Update.Combine(update);
            var ids = model.NotificationIds.Select(m => m.ToString()).ToList();
            var filter = new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(ids)));
            notifyCol.UpdateMany(filter: filter, update: updateFields);
            return model.NotificationIds;
        }
    }
}
