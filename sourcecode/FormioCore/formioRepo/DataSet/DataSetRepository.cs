using System;
using System.Collections.Generic;
using System.Linq;
using formioCommon.Constants;
using formioModels;
using formioModels.Data;
using formioRepo.Helpers;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Text.RegularExpressions;
using MongoDB.Bson.Serialization;
using System.Threading.Tasks;
using Models.GenericSearch;
using formioRepo.Dashboard;
using formioModels.ProfitAndLoss;
using System.Collections;
using MongoDB.Driver.Linq;
using System.Configuration;
using System.Reflection;
using System.Dynamic;
using formioModels.Dashboard;
using static formioRepo.Dashboard.CommodityConstants;
using PDFHTMLDesignerModels.SFDTParameterModel;
using System.Data;
using Microsoft.SqlServer.Server;
using System.IO;
using Microsoft.AspNetCore.DataProtection.KeyManagement;
using Azure;

namespace formioRepo.DataSet
{
    public class DataSetRepository : IDataSetRepository
    {
        IConfiguration _iconfiguration;

        private readonly DashboardRepository _dashboardRepository;
        private readonly DashboardRepositoryNew _dashboardRepositoryNew;

        public DataSetRepository(IConfiguration iConfiguration, DashboardRepository dashboardRepository, DashboardRepositoryNew dashboardRepositoryNew)
        {
            _iconfiguration = iConfiguration;
            _dashboardRepository = dashboardRepository;
            _dashboardRepositoryNew = dashboardRepositoryNew;
        }
        public FilterDefinition<BsonDocument> GetUpdateDataSource(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            if (loggedInContext != null)
            {
                return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()),
                fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()));
            }
            else
            {
                return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()));
            }
        }
        public FilterDefinition<BsonDocument> GetUpdateDataSourceUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel)
        {
            var fBuilder = Builders<BsonDocument>.Filter;

            return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()));
        }

        public FilterDefinition<BsonDocument> GetUpdateDataSet(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()),
                fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()));

        }

        public FilterDefinition<BsonDocument> GetPublicUpdateDataSource(DataSetUpsertInputModel dataSetUpsertInputModel)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()));

        }

        public FilterDefinition<BsonDocument> GetPublicUpdateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetUpsertInputModel)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", userDataSetUpsertInputModel.Id.ToString()));

        }

        public FilterDefinition<BsonDocument> GetUpdateDataSourceForJob(DataSetUpsertInputModel dataSetUpsertInputModel)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", dataSetUpsertInputModel.Id.ToString()));

        }
        public Guid? CreateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try

            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetRepository"));
                dataSetUpsertInputModel.Id = (dataSetUpsertInputModel.Id == null || dataSetUpsertInputModel.Id == Guid.Empty) ? Guid.NewGuid() : dataSetUpsertInputModel.Id;
                if (dataSetUpsertInputModel.SubmittedByFormDrill)
                {
                    dataSetUpsertInputModel.CompanyId = dataSetUpsertInputModel.SubmittedCompanyId;
                    dataSetUpsertInputModel.CreatedByUserId = dataSetUpsertInputModel.SubmittedUserId;
                }
                else
                {
                    dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
                    dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                }
                dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                dataSetUpsertInputModel.IsArchived = false;
                string invoiceId = "";
                var contractType = dataSetUpsertInputModel.DataJson.GetValue("ContractType", new BsonString(string.Empty)).AsString;
                var invoiceType = dataSetUpsertInputModel.DataJson.GetValue("InvoiceType", new BsonString(string.Empty)).AsString;
                if (contractType == "Invoice Queue" && invoiceType == "Receivable")
                {
                    IMongoCollection<DataSetOutputModel> invoiceQueueCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                    var contractId = dataSetUpsertInputModel.DataJson.GetValue("ContractId", new BsonString(string.Empty)).AsString;
                    var invoiceMatchStage = new BsonDocument("$match",
                        new BsonDocument("_id", contractId));

                    var invoiceStages = new List<BsonDocument>();
                    invoiceStages.Add(invoiceMatchStage);
                    var invoicePipeline = invoiceStages;

                    var invoiceAggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                    var invoiceAggregateDataList = invoiceQueueCollection.Aggregate<BsonDocument>(invoicePipeline, invoiceAggregateOptions).ToList();

                    var invoiceQueue = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(invoiceAggregateDataList).ToList();

                    if (invoiceQueue != null && invoiceQueue.Count > 0)
                    {
                        //((BsonDocument)formData).GetValue("commodityName", new BsonString(string.Empty));
                        invoiceId = "/" + DateTime.Now.Month.ToString() + "/" + commodityName + DateTime.Now.Year.ToString();
                        BsonDocument data = (BsonDocument)dataSetUpsertInputModel.DataJson.GetValue("FormData", new BsonString(string.Empty));
                        data.Add("invoiceId", invoiceId);
                        dataSetUpsertInputModel.DataJson.Set("FormData", data);
                    }
                }
                if (contractType == "Invoice Queue" && invoiceType == "Payable")
                {
                    IMongoCollection<DataSetOutputModel> invoiceQueueCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                    var match = new BsonArray
                {
                    new BsonDocument("DataJson.ContractType", "Invoice Queue")
                };
                    match.Add(new BsonDocument("DataJson.InvoiceType", invoiceType));
                    var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                    var invoiceSortStage = new BsonDocument("$sort",
                        new BsonDocument("CreatedDateTime", -1));

                    var limitStage = new BsonDocument("$limit", 1);

                    var invoiceStages = new List<BsonDocument>();
                    invoiceStages.Add(matchStage);
                    invoiceStages.Add(invoiceSortStage);
                    invoiceStages.Add(limitStage);
                    var invoicePipeline = invoiceStages;

                    var invoiceAggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                    var invoiceAggregateDataList = invoiceQueueCollection.Aggregate<BsonDocument>(invoicePipeline, invoiceAggregateOptions).ToList();

                    var invoiceQueue = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(invoiceAggregateDataList).ToList();
                    if (invoiceQueue != null && invoiceQueue.Count > 0)
                    {
                        var jsonData = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(JsonConvert.SerializeObject(invoiceQueue[0].DataJson));
                        Dictionary<string, string> keyValueMap = new Dictionary<string, string>();
                        JObject formfield = (JObject)JsonConvert.DeserializeObject(jsonData.FormData.ToString());
                        foreach (KeyValuePair<string, JToken> keyValuePair in formfield)
                        {
                            keyValueMap.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                        }
                        string latestInvoiceId = string.Empty;
                        foreach (var keyValue in keyValueMap)
                        {
                            if (keyValue.Key == "invoiceId")
                            {
                                latestInvoiceId = keyValue.Value;
                            }
                        }
                        if (latestInvoiceId != null && latestInvoiceId != string.Empty)
                        {
                            invoiceId = "Inv" + DateTime.Now.Year.ToString() + (int.Parse(latestInvoiceId.ToString().Substring(7)) + 1);
                        }
                        else
                        {
                            invoiceId = "Inv" + DateTime.Now.Year.ToString() + "1";
                        }
                        BsonDocument data = (BsonDocument)dataSetUpsertInputModel.DataJson.GetValue("FormData", new BsonString(string.Empty));
                        data.Add("invoiceId", invoiceId);
                        dataSetUpsertInputModel.DataJson.Set("FormData", data);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }
        public Guid? CreateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, string commodityName, List<ValidationMessage> validationMessages)
        {
            try

            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetUnAuth", "DataSetRepository"));
                dataSetUpsertInputModel.Id = (dataSetUpsertInputModel.Id == null || dataSetUpsertInputModel.Id == Guid.Empty) ? Guid.NewGuid() : dataSetUpsertInputModel.Id;
                //if (dataSetUpsertInputModel.SubmittedByFormDrill)
                //{
                //    dataSetUpsertInputModel.CompanyId = dataSetUpsertInputModel.SubmittedCompanyId;
                //    dataSetUpsertInputModel.CreatedByUserId = dataSetUpsertInputModel.SubmittedUserId;
                //}
                //else
                //{
                //    dataSetUpsertInputModel.CompanyId = loggedInContext.CompanyGuid;
                //    dataSetUpsertInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                //}
                dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                dataSetUpsertInputModel.IsArchived = false;
                string invoiceId = "";
                var contractType = dataSetUpsertInputModel.DataJson.GetValue("ContractType", new BsonString(string.Empty)).AsString;
                var invoiceType = dataSetUpsertInputModel.DataJson.GetValue("InvoiceType", new BsonString(string.Empty)).AsString;
                if (contractType == "Invoice Queue" && invoiceType == "Receivable")
                {
                    IMongoCollection<DataSetOutputModel> invoiceQueueCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSetUnAuth);
                    var contractId = dataSetUpsertInputModel.DataJson.GetValue("ContractId", new BsonString(string.Empty)).AsString;
                    var invoiceMatchStage = new BsonDocument("$match",
                        new BsonDocument("_id", contractId));

                    var invoiceStages = new List<BsonDocument>();
                    invoiceStages.Add(invoiceMatchStage);
                    var invoicePipeline = invoiceStages;

                    var invoiceAggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                    var invoiceAggregateDataList = invoiceQueueCollection.Aggregate<BsonDocument>(invoicePipeline, invoiceAggregateOptions).ToList();

                    var invoiceQueue = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(invoiceAggregateDataList).ToList();

                    if (invoiceQueue != null && invoiceQueue.Count > 0)
                    {
                        //((BsonDocument)formData).GetValue("commodityName", new BsonString(string.Empty));
                        invoiceId = "/" + DateTime.Now.Month.ToString() + "/" + commodityName + DateTime.Now.Year.ToString();
                        BsonDocument data = (BsonDocument)dataSetUpsertInputModel.DataJson.GetValue("FormData", new BsonString(string.Empty));
                        data.Add("invoiceId", invoiceId);
                        dataSetUpsertInputModel.DataJson.Set("FormData", data);
                    }
                }
                if (contractType == "Invoice Queue" && invoiceType == "Payable")
                {
                    IMongoCollection<DataSetOutputModel> invoiceQueueCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSetUnAuth);
                    var match = new BsonArray
                {
                    new BsonDocument("DataJson.ContractType", "Invoice Queue")
                };
                    match.Add(new BsonDocument("DataJson.InvoiceType", invoiceType));
                    var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                    var invoiceSortStage = new BsonDocument("$sort",
                        new BsonDocument("CreatedDateTime", -1));

                    var limitStage = new BsonDocument("$limit", 1);

                    var invoiceStages = new List<BsonDocument>();
                    invoiceStages.Add(matchStage);
                    invoiceStages.Add(invoiceSortStage);
                    invoiceStages.Add(limitStage);
                    var invoicePipeline = invoiceStages;

                    var invoiceAggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                    var invoiceAggregateDataList = invoiceQueueCollection.Aggregate<BsonDocument>(invoicePipeline, invoiceAggregateOptions).ToList();

                    var invoiceQueue = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(invoiceAggregateDataList).ToList();
                    if (invoiceQueue != null && invoiceQueue.Count > 0)
                    {
                        var jsonData = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(JsonConvert.SerializeObject(invoiceQueue[0].DataJson));
                        Dictionary<string, string> keyValueMap = new Dictionary<string, string>();
                        JObject formfield = (JObject)JsonConvert.DeserializeObject(jsonData.FormData.ToString());
                        foreach (KeyValuePair<string, JToken> keyValuePair in formfield)
                        {
                            keyValueMap.Add(keyValuePair.Key, keyValuePair.Value.ToString());
                        }
                        string latestInvoiceId = string.Empty;
                        foreach (var keyValue in keyValueMap)
                        {
                            if (keyValue.Key == "invoiceId")
                            {
                                latestInvoiceId = keyValue.Value;
                            }
                        }
                        if (latestInvoiceId != null && latestInvoiceId != string.Empty)
                        {
                            invoiceId = "Inv" + DateTime.Now.Year.ToString() + (int.Parse(latestInvoiceId.ToString().Substring(7)) + 1);
                        }
                        else
                        {
                            invoiceId = "Inv" + DateTime.Now.Year.ToString() + "1";
                        }
                        BsonDocument data = (BsonDocument)dataSetUpsertInputModel.DataJson.GetValue("FormData", new BsonString(string.Empty));
                        data.Add("invoiceId", invoiceId);
                        dataSetUpsertInputModel.DataJson.Set("FormData", data);
                    }
                }
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSetUnAuth", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSetUnAuth);
                datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSetUnAuth", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSetUnAuth", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }

        public List<Guid?> CreateMultipleDataSetSteps(List<DataSetUpsertInputModel> dataSetUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateMultipleDataSetSteps", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                datasetCollection.InsertMany(dataSetUpsertInputModels.Select(t => t.ToBsonDocument()));
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateMultipleDataSetSteps", "DataSetRepository"));
                return dataSetUpsertInputModels?.Select(t => t?.Id)?.ToList();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateMultipleDataSetSteps", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }
        public Guid? UpdateDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("DataSourceId", dataSetUpsertInputModel.DataSourceId),
                    Builders<BsonDocument>.Update.Set("IsArchived", dataSetUpsertInputModel.IsArchived==null?false:dataSetUpsertInputModel.IsArchived),
                    Builders<BsonDocument>.Update.Set("RecordAccessibleUsers", dataSetUpsertInputModel.RecordAccessibleUsers),
                    //Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                if (dataSetUpsertInputModel.IsArchived == true)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));
                    //update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                }
                if (dataSetUpsertInputModel.DataJson != null)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("DataJson", dataSetUpsertInputModel.DataJson));
                }
                if (loggedInContext != null)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()));
                    if (dataSetUpsertInputModel.IsArchived == true)
                    {
                        update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                    }
                }
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSource(dataSetUpsertInputModel, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSet", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSet", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }
        public Guid? UpdateDataSetUnAuth(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetUnAuth", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSetUnAuth);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("DataSourceId", dataSetUpsertInputModel.DataSourceId),
                    Builders<BsonDocument>.Update.Set("IsArchived", dataSetUpsertInputModel.IsArchived==null?false:dataSetUpsertInputModel.IsArchived),
                    //Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                if (dataSetUpsertInputModel.IsArchived == true)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));
                    //update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                }
                if (dataSetUpsertInputModel.DataJson != null)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("DataJson", dataSetUpsertInputModel.DataJson));
                }
                //if (loggedInContext != null)
                //{
                //    update.Add(Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()));
                //    if (dataSetUpsertInputModel.IsArchived == true)
                //    {
                //        update.Add(Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId.ToString()));
                //    }
                //}
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceUnAuth(dataSetUpsertInputModel);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetUnAuth", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetUnAuth", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }

        public Guid? UpdateDataSetJson(UpdateDataSetDataJsonModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("IsArchived", false),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };

                foreach (var paramsModel in dataSetUpsertInputModel.ParamsJsonModel)
                {
                    var keyName = "DataJson." + paramsModel.KeyName;
                    if (paramsModel.Type == "List")
                    {
                        if (!string.IsNullOrEmpty(paramsModel.KeyValue))
                        {
                            var values = paramsModel.KeyValue.Split(",");
                            update.Add(Builders<BsonDocument>.Update.Set(keyName, values));
                        }
                        else
                        {
                            update.Add(Builders<BsonDocument>.Update.Set(keyName, paramsModel.KeyValue));
                        }

                    }
                    else if (paramsModel.Type == "object")
                    {
                        update.Add(Builders<BsonDocument>.Update.Set(keyName, MongoDB.Bson.Serialization.BsonSerializer.Deserialize<BsonDocument>(paramsModel.KeyValue)));
                    }
                    else if (paramsModel.Type == "boolean")
                    {
                        var result = Convert.ToBoolean(paramsModel.KeyValue);
                        update.Add(Builders<BsonDocument>.Update.Set(keyName, result));
                    }
                    else if (paramsModel.Type == "DateTime?")
                    {
                        var result = Convert.ToDateTime(paramsModel.KeyValue);
                        update.Add(Builders<BsonDocument>.Update.Set(keyName, result));
                    }
                    else if (paramsModel.Type == "decimal")
                    {
                        if (!string.IsNullOrEmpty(paramsModel.KeyValue))
                        {
                            var result = Convert.ToDecimal(paramsModel.KeyValue);
                            update.Add(Builders<BsonDocument>.Update.Set(keyName, result));
                        }
                        else
                        {
                            update.Add(Builders<BsonDocument>.Update.Set(keyName, paramsModel.KeyValue));
                        }
                    }
                    else
                    {
                        update.Add(Builders<BsonDocument>.Update.Set(keyName, paramsModel.KeyValue));
                    }
                }

                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSet(dataSetUpsertInputModel, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetJson", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSetJson", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }

        public Guid? CreateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateUserDataSetRelation", "DataSetRepository"));
                userDataSetInputModel.Id = Guid.NewGuid();
                userDataSetInputModel.CreatedDateTime = DateTime.UtcNow;
                userDataSetInputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.UserDataSet);
                datasetCollection.InsertOne(userDataSetInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateUserDataSetRelation", "DataSetRepository"));
                return userDataSetInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateUserDataSetRelation", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }

        public Guid? UpdateUserDataSetRelation(UserDataSetUpsertInputModel userDataSetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateUserDataSetRelation", "DataSetRepository"));

                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.UserDataSet);


                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", false)
                };

                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetPublicUpdateUserDataSetRelation(userDataSetInputModel);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateUserDataSetRelation", "DataSetRepository"));
                return userDataSetInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserDataSetRelation", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }

        public UserDatasetRelationOutputModel GetUserDataSetRelation(Guid? userId, Guid? companyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserDataSetRelation", "DataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.UserDataSet);
                var filter = new List<BsonDocument>();

                if (userId != null)
                {
                    filter.Add(new BsonDocument("UserId", userId.ToString()));
                }

                if (companyId != null)
                {
                    filter.Add(new BsonDocument("CompanyId", companyId.ToString()));
                }
                else
                {
                    filter.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                }

                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).FirstOrDefault();
                var userDataSet = BsonSerializer.Deserialize<UserDatasetRelationOutputModel>(aggregateDataList);
                //BsonHelper.ConvertBsonDocumentListToModel<UserDatasetRelationOutputModel>(aggregateDataList).ToList();
                return userDataSet;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserDataSetRelation", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }

        public Guid? CreatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                dataSetUpsertInputModel.Id = Guid.NewGuid();
                dataSetUpsertInputModel.CreatedDateTime = DateTime.UtcNow;
                dataSetUpsertInputModel.IsArchived = false;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                datasetCollection.InsertOne(dataSetUpsertInputModel.ToBsonDocument());
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateDataSet", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateDataSet", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSet);
                return null;
            }
        }
        public Guid? UpdatePublicDataSet(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("DataSourceId", dataSetUpsertInputModel.DataSourceId),
                    Builders<BsonDocument>.Update.Set("IsArchived", false)
                };
                if (dataSetUpsertInputModel.IsArchived == true)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));
                }
                if (dataSetUpsertInputModel.DataJson != null)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("DataJson", dataSetUpsertInputModel.DataJson));
                }
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetPublicUpdateDataSource(dataSetUpsertInputModel);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSet", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSet", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }
        public Guid? UpdateDataSetJob(DataSetUpsertInputModel dataSetUpsertInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("DataSourceId", dataSetUpsertInputModel.DataSourceId),
                    Builders<BsonDocument>.Update.Set("IsArchived", dataSetUpsertInputModel.IsArchived),

                };
                if (dataSetUpsertInputModel.IsArchived == true)
                {
                    update.Add(Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow));

                }

                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceForJob(dataSetUpsertInputModel);
                datasetCollection.UpdateOne
                    (filter: filterObject, update: updateFields);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSet", "DataSetRepository"));
                return dataSetUpsertInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateDataSet", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSet);
                return null;
            }
        }
        public List<DataSetOutputModel> SearchDataSets(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<DataSetOutputModel> dataSourcesList = new List<DataSetOutputModel>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSetRepository"));
                var match = new List<BsonDocument>
                {
                    //new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString())
                };
                if (loggedInContext != null)
                {
                    if (dataSetSearchCriteriaInputModel.CompanyIds != null && dataSetSearchCriteriaInputModel.CompanyIds.Count > 0)
                    {
                        var companyIds = dataSetSearchCriteriaInputModel.CompanyIds.Select(g => g.ToString()).ToList();
                        companyIds.Add(loggedInContext.CompanyGuid.ToString());

                        match.Add(new BsonDocument("CompanyId", new BsonDocument("$in",
                                            BsonHelper.ConvertGenericListToBsonArray(companyIds))));
                    }
                    else
                    {
                        match.Add(new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));
                    }
                }
                bool isInvoiceQueue = false;
                bool isContractLink = false;
                bool isForReport = false;
                bool isPurchase = false;
                bool isSales = false;
                bool isRFQ = false;
                bool isProgram = false;
                bool isFilterLinkContracts = false;
                bool isKPIsNeeded = false;
                if (dataSetSearchCriteriaInputModel.DataSourceId != null)
                {
                    match.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
                }
                if (dataSetSearchCriteriaInputModel.Id != null)
                {
                    match.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
                }

                else
                {
                    match.Add(new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived));
                }
                var stages = new List<BsonDocument>();
                //if (dataSetSearchCriteriaInputModel.IsInnerQuery != true && dataSetSearchCriteriaInputModel.ForFormFieldValue != true)
                //{ 
                foreach (var param in dataSetSearchCriteriaInputModel.DataJsonInputs)
                {
                    if (param.KeyName == "CreatedByUserId")
                    {
                        match.Add(new BsonDocument("CreatedByUserId", loggedInContext?.LoggedInUserId.ToString()));
                    }
                    //else if (dataSetSearchCriteriaInputModel.CreatedDateTime != null)
                    //{
                    //    match.Add(new BsonDocument("CreatedDateTime", dataSetSearchCriteriaInputModel.CreatedDateTime));
                    //}
                    else
                    {
                        var searchName = string.Empty;
                        if (param.IsFormData == true)
                        {
                            searchName = "DataJson.FormData." + param.KeyName;
                        }
                        else
                        {
                            searchName = "DataJson." + param.KeyName;
                        }

                        if (param.KeyName != "PurchaseStatusReport" && param.KeyName != "VesselConfirmationIdForRFQ" && param.KeyName != "FormDataLookUpFilter" && param.KeyValue != "VesselForLinking" && param.KeyName != "isFilterLinkContracts" && param.KeyName != "KPIsList")
                        {
                            match.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                        }

                        if (param.KeyName == "FormDataLookUpFilter")
                        {
                            match.Add(
                                             new BsonDocument("DataJson.FormData",
                                             new BsonDocument
                                                     {
                                                         { "$exists", true },
                                                         { "$ne", BsonNull.Value }
                                                     })
                                         );
                        }

                        if (param.KeyValue != null && param.KeyValue != "VesselConfirmationIdForRFQ" && param.KeyValue != "VesselForLinking")
                        {
                            if (param.Type == "number")
                            {
                                match.Add(new BsonDocument(searchName, Convert.ToInt32(param.KeyValue)));
                            }
                            else if (param.Type == "boolean")
                            {
                                if (Convert.ToBoolean(param.KeyValue))
                                {
                                    match.Add(new BsonDocument(searchName, Convert.ToBoolean(param.KeyValue)));
                                }
                                else
                                {
                                    match.Add(new BsonDocument(searchName, new BsonDocument("$ne", true)));
                                }
                            }
                            else if (param.Type == "ListFilter")
                            {
                                List<string> stringValues = param.KeyValue.Split(',').ToList();

                                match.Add(new BsonDocument(searchName, new BsonDocument("$in",
                                                    BsonHelper.ConvertGenericListToBsonArray(stringValues))));

                            }
                            else
                            {
                                match.Add(new BsonDocument(searchName, param.KeyValue.ToString()));
                            }
                        }
                        if (param.KeyValue != null && param.KeyValue == "VesselForLinking")
                        {
                            match.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                            match.Add(new BsonDocument(searchName, "Vessel"));
                            match.Add(new BsonDocument("DataJson.IsContractLink", new BsonDocument("$ne", true)));
                            match.Add(new BsonDocument("DataJson.IsCancelContract", new BsonDocument("$ne", true)));
                            //match.Add(new BsonDocument("DataJson.ContractPdf", new BsonDocument("$ne", null)));
                            match.Add(
                                new BsonDocument("DataJson.ContractPdf",
                                new BsonDocument
                                    {
                                        { "$ne", BsonNull.Value }
                                    })
                            );
                            match.Add(new BsonDocument("DataJson.ContractPdf", new BsonDocument("$ne", string.Empty)));
                        }
                    }
                    if (param.KeyValue == "Invoice Queue")
                    {
                        isInvoiceQueue = true;
                    }

                    if (param.KeyName == "KPIsList")
                    {
                        isKPIsNeeded = true;
                    }

                    if (param.KeyName == "IsContractLink")
                    {
                        isContractLink = true;
                    }
                    if (param.KeyName == "isFilterLinkContracts")
                    {
                        isFilterLinkContracts = true;
                    }
                    if (param.KeyValue == "Purchase")
                    {
                        isPurchase = true;
                    }
                    if (param.KeyValue == "Sale")
                    {
                        isSales = true;
                    }

                    if (param.KeyName == "PurchaseStatusReport")
                    {
                        isForReport = true;
                    }
                    if (param.KeyName == "VesselConfirmationIdForRFQ")
                    {
                        isRFQ = true;
                    }
                    if (param.KeyName == "ProgramId")
                    {
                        isProgram = true;
                    }
                }
                if (dataSetSearchCriteriaInputModel.SearchText != null)
                {
                    match.Add(new BsonDocument("$or",
                    new BsonArray
                    {
                        new BsonDocument("DataJson.FormData.contractNumber",
                        new BsonDocument("$regex",
                            new Regex($"(?i){dataSetSearchCriteriaInputModel.SearchText.Trim()}")))
                    }));
                }
                if (dataSetSearchCriteriaInputModel.DataSourceIds != null && dataSetSearchCriteriaInputModel.DataSourceIds.Count > 0)
                {
                    var dataSourceIds = dataSetSearchCriteriaInputModel.DataSourceIds.Select(g => g.ToString()).ToList();

                    match.Add(new BsonDocument("DataSourceId", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSourceIds))));
                }
                if (dataSetSearchCriteriaInputModel.DataSetIds != null && dataSetSearchCriteriaInputModel.DataSetIds.Count > 0)
                {
                    var dataSetIds = dataSetSearchCriteriaInputModel.DataSetIds.Select(g => g.ToString()).ToList();

                    match.Add(new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(dataSetIds))));
                }


                bool isTemplatesLookup = false;
                var templateLookup = new BsonDocument();
                var setTemplateJson = new BsonDocument();
                if (dataSetSearchCriteriaInputModel.DataJsonInputs != null)
                {
                    if (dataSetSearchCriteriaInputModel?.DataJsonInputs?.Where(t => (t.KeyName == "ContractType" && t.KeyValue == "ExecutionSteps"))?.FirstOrDefault()?.KeyValue != null)
                    {
                        isTemplatesLookup = true;

                        templateLookup = new BsonDocument("$lookup",
                                          new BsonDocument{
                                                  { "from", "DataSource" },
                                                  { "localField", "DataJson.TemplateId" },
                                                  { "foreignField", "_id" },
                                                  { "as", "templates" }
                                              });

                        setTemplateJson = new BsonDocument("$set",
                                          new BsonDocument("DataJson.DataSourceFormJson",
                                          new BsonDocument("$arrayElemAt",
                                          new BsonArray { "$templates.Fields", 0 })));
                    }
                }

                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasets");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Name",0}) },
                                { "DataSourceFormJson", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Fields",0}) },
                                { "DataSourceType", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataSourceType",0}) }
                    });
                var lookup1 = new BsonDocument();
                var set1 = new BsonDocument();
                var set2 = new BsonDocument();
                var purchaseLookUp = new BsonDocument();
                var programLookUp = new BsonDocument();
                var salesLookUp = new BsonDocument();
                var stepsLookup = new BsonDocument();
                var rfqLookup = new BsonDocument();
                var programSet = new BsonDocument();
                var kpisList = new BsonDocument();
                var kpiSet = new BsonDocument();

                if (isInvoiceQueue == true)
                {
                    lookup1 = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.ContractId", "_id", "contract");
                    set1 = new BsonDocument("$set",
                                new BsonDocument{
                                { "ContractData", new BsonDocument("$arrayElemAt", new BsonArray{ "$contract.DataJson", 0}) }
                        });
                }
                if (isContractLink == true)
                {
                    purchaseLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.PurchaseContractIds", "_id", "PurchaseContracts");
                    salesLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.SalesContractIds", "_id", "SalesContracts");
                }
                if (isProgram == true)
                {
                    programLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.ProgramId", "_id", "Programs");
                    programSet = new BsonDocument("$set",
                               new BsonDocument{
                                { "ProgramFormData", new BsonDocument("$arrayElemAt", new BsonArray{ "$Programs.DataJson", 0}) },
                                { "ProgramId", new BsonDocument("$arrayElemAt", new BsonArray{ "$Programs._id", 0}) }
                       });
                }

                if (isKPIsNeeded == true)
                {
                    kpisList = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "_id", "DataJson.ProgramId", "DataJson.KPIs");
                    //kpiSet = new BsonDocument("$set",
                    //           new BsonDocument{
                    //            { "DataJson.ProgramFormData", new BsonDocument("$arrayElemAt", new BsonArray{ "$KPIs.DataJson", 0}) },
                    //            { "DataJson.ProgramId", new BsonDocument("$arrayElemAt", new BsonArray{ "$KPIs._id", 0}) }
                    //   });
                }

                if (isFilterLinkContracts == true)
                {
                    var userContracts = GetUserDataSetRelation(loggedInContext.LoggedInUserId, loggedInContext.CompanyGuid, loggedInContext, validationMessages);

                    var values = userContracts.DataSetIds.ToString();
                    List<string> stringValues = userContracts.DataSetIds.Select(t => t.ToString()).ToList();

                    purchaseLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.PurchaseContractIds", "_id", "PurchaseContracts");
                    salesLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "DataJson.SalesContractIds", "_id", "SalesContracts");

                    match.Add(new BsonDocument("_id", new BsonDocument("$in",
                                        BsonHelper.ConvertGenericListToBsonArray(stringValues))));

                    matchStage = new BsonDocument("$match",
                        new BsonDocument("$and", new BsonArray(match)));

                }
                if (isForReport == true)
                {
                    stepsLookup = new BsonDocument("$lookup",
                       new BsonDocument
                           {
                               { "from", "DataSet" },
                               { "pipeline",
                       new BsonArray
                               {
                                   new BsonDocument("$match",
                                   new BsonDocument("$expr",
                                   new BsonDocument("$eq",
                                   new BsonArray
                                               {
                                                   "$DataJson.ContractType",
                                                   "ExecutionSteps"
                                               })))
                               } },
                               { "localField", "_id" },
                               { "foreignField", "DataJson.PurchaseId" },
                               { "as", "DataJson.ExecutionSteps" }
                           });
                    //stepsSet = new BsonDocument("$set",
                    //           new BsonDocument{
                    //            { "DataJson.ExecutionSteps", new BsonDocument("$arrayElemAt", new BsonArray{ "$Steps.DataJson", null}) }
                    //   });
                }
                if (isPurchase == true)
                {
                    match.Add(new BsonDocument("DataJson.ContractType", "Vessel"));
                    purchaseLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "_id", "DataJson.PurchaseContractIds", "VesselContracts");
                    set1 = new BsonDocument("$set",
                                new BsonDocument{
                                { "VesselContractId", new BsonDocument("$arrayElemAt", new BsonArray{ "$VesselContracts._id", 0}) }
                        });
                    set2 = new BsonDocument("$set",
                             new BsonDocument{
                                { "DataJson.VesselContractStatusId", new BsonDocument("$arrayElemAt", new BsonArray{ "$VesselContracts.DataJson.StatusId", 0}) }
                     });
                }
                if (isSales == true)
                {
                    match.Add(new BsonDocument("DataJson.ContractType", "Vessel"));
                    salesLookUp = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "_id", "DataJson.SalesContractIds", "VesselContracts");
                    set1 = new BsonDocument("$set",
                              new BsonDocument{
                                { "VesselContractId", new BsonDocument("$arrayElemAt", new BsonArray{ "$VesselContracts._id", 0}) }
                      });
                    set2 = new BsonDocument("$set",
                              new BsonDocument{
                                { "DataJson.VesselContractStatusId", new BsonDocument("$arrayElemAt", new BsonArray{ "$VesselContracts.DataJson.StatusId", 0}) }
                      });
                }
                if (isRFQ == true)
                {
                    rfqLookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSet", "_id", "DataJson.TemplateTypeId", "VesselConfirmation");
                    set1 = new BsonDocument("$set",
                              new BsonDocument{
                                { "DataJson.VesselConfirmationId", new BsonDocument("$arrayElemAt", new BsonArray{ "$VesselConfirmation._id", 0}) }
                      });
                }
                string sortName = null;
                if (isContractLink == true)
                {
                    sortName = "DataJson.LinkCreatedDateTime";
                }
                else
                {
                    sortName = "CreatedDateTime";
                }
                var facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                             new BsonDocument("$sort",
                                                new BsonDocument(sortName, -1)) }},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });
                if (dataSetSearchCriteriaInputModel.IsPagingRequired == true)
                {
                    var skip = ((dataSetSearchCriteriaInputModel.PageNumber - 1) * dataSetSearchCriteriaInputModel.PageSize);
                    facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                            new BsonDocument("$sort",
                                                new BsonDocument(sortName, -1)),
                                             new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", dataSetSearchCriteriaInputModel.PageSize)}},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });
                }

                var unwind = new BsonDocument("$unwind", new BsonDocument("path", "$Data"));
                var dataSetStage = new BsonDocument("$set",
                                   new BsonDocument("TotalCount", new BsonDocument("$arrayElemAt", new BsonArray
                                   {
                                       "$TotalCount.TotalCount",
                                        0
                                })));
                stages.Add(matchStage);

                stages.Add(lookup);
                stages.Add(set);

                if (isTemplatesLookup == true)
                {
                    stages.Add(templateLookup);
                    stages.Add(setTemplateJson);
                }

                if (isForReport == true)
                {
                    stages.Add(stepsLookup);

                }

                if (isInvoiceQueue)
                {
                    stages.Add(lookup1);
                    stages.Add(set1);
                }
                if (isContractLink)
                {
                    stages.Add(purchaseLookUp);
                    stages.Add(salesLookUp);
                }
                if (isPurchase == true)
                {
                    stages.Add(purchaseLookUp);
                    stages.Add(set1);
                    stages.Add(set2);
                }

                if (isKPIsNeeded == true)
                {
                    stages.Add(kpisList);
                    //stages.Add(kpiSet);
                }

                if (isSales == true)
                {
                    stages.Add(salesLookUp);
                    stages.Add(set1);
                    stages.Add(set2);
                }
                if (isRFQ == true)
                {
                    stages.Add(rfqLookup);
                    stages.Add(set1);
                }
                if (isProgram == true)
                {
                    stages.Add(programLookUp);
                    stages.Add(programSet);
                }

                stages.Add(facet);
                stages.Add(unwind);
                stages.Add(dataSetStage);
                //}
                //else
                //{
                if (dataSetSearchCriteriaInputModel.IsInnerQuery == true && dataSetSearchCriteriaInputModel.ForFormFieldValue == true)
                {
                    var doc = new BsonDocument("$addFields", new BsonDocument(dataSetSearchCriteriaInputModel.KeyName.Split('.').LastOrDefault(), "$DataJson.FormData." + dataSetSearchCriteriaInputModel.KeyName));
                    var proj = new BsonDocument("$project", new BsonDocument(dataSetSearchCriteriaInputModel.KeyName.Split('.').LastOrDefault(), 1));
                    stages.Add(doc);
                    stages.Add(proj);
                }
                if (dataSetSearchCriteriaInputModel.IsInnerQuery == true && dataSetSearchCriteriaInputModel.ForRecordValue == true)
                {
                    var splits = dataSetSearchCriteriaInputModel.KeyName?.Split('.');
                    var splitLoop = splits.SkipLast(1).ToArray();
                    var matchValue = new BsonDocument("$match", new BsonDocument("DataJson.FormData." + dataSetSearchCriteriaInputModel.KeyName, dataSetSearchCriteriaInputModel.KeyValue));
                    //var unwindrec = new BsonDocument("$unwind", "$DataJson.FormData." + dataSetSearchCriteriaInputModel.KeyName.Replace("."+splits.LastOrDefault(), ""));
                    ////var proj = new BsonDocument("$project", new BsonDocument("DataJson.FormData", 1));
                    stages.Add(matchValue);
                    //stages.Add(unwindrec);
                    //stages.Add(matchValue);
                    //stages.Add(proj);
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
                        stages.Add(unwindrec);
                        stages.Add(matchValue);
                        index++;
                    }
                    var paths = dataSetSearchCriteriaInputModel.Paths.Split(',');
                    var dict = new Dictionary<string, object>();
                    foreach (var path in paths)
                    {
                        var path1 = path.Split('.');
                        var innerKey = path1 != null && path1.Length > 1 ? true : false;
                        if (innerKey == true)
                        {
                            var af = new BsonDocument("$addFields", new BsonDocument(path.Split('.').LastOrDefault(), "$DataJson.FormData." + path));
                            stages.Add(af);
                            dict.Add(path.Split('.').LastOrDefault(), 1);
                        }
                        else
                        {
                            var af = new BsonDocument("$addFields", new BsonDocument(path, "$DataJson.FormData." + path));
                            stages.Add(af);
                            dict.Add(path, 1);
                        }
                    }
                    var proj = new BsonDocument("$project", new BsonDocument(dict));
                    stages.Add(proj);
                }

                //}
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };

                dynamic dataSources;
                if (dataSetSearchCriteriaInputModel.IsInnerQuery == true && (dataSetSearchCriteriaInputModel.ForFormFieldValue == true || dataSetSearchCriteriaInputModel.ForRecordValue == true))
                {
                    dataSources = new List<DataSetConversionModelForFormFields>();
                }
                else
                {
                    dataSources = new List<DataSetConversionModel>();
                }
                if (dataSetSearchCriteriaInputModel.IsPagingRequired != null && dataSetSearchCriteriaInputModel.IsPagingRequired == true)
                {
                    var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                    dataSources = new List<DataSetConversionModel>();
                    dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetConversionModel>(aggregateDataList);
                }
                else
                {
                    int pageSize = 10;
                    int pageNumber = 1;
                    int totalCount = 0;

                    do
                    {
                        stages.Remove(facet);
                        stages.Remove(unwind);

                        stages.Remove(dataSetStage);

                        var skip = ((pageNumber - 1) * pageSize);
                        facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                            new BsonDocument("$sort",
                                                new BsonDocument(sortName, -1)),
                                new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", pageSize)}},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }
                         });

                        stages.Add(facet);
                        stages.Add(unwind);
                        stages.Add(dataSetStage);
                        var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                        var c = aggregateDataList.Count();
                        if (dataSetSearchCriteriaInputModel.IsInnerQuery == true && (dataSetSearchCriteriaInputModel.ForFormFieldValue == true || dataSetSearchCriteriaInputModel.ForRecordValue == true))
                        {
                            //dataSources = new List<DataSetConversionModelForFormFields>();
                            var dataSourcesInner = BsonHelper.ConvertBsonDocumentListToModel<DataSetConversionModelForFormFields>(aggregateDataList);
                            if (dataSourcesInner.Count > 0)
                            {
                                dataSources.AddRange(dataSourcesInner);
                            }
                            if (dataSources.Count > 0 && totalCount == 0)
                            {
                                double count = (double)dataSourcesInner?.FirstOrDefault()?.TotalCount;
                                totalCount = (int)Math.Ceiling(count / (pageSize * 1.00));
                            }
                        }
                        else
                        {
                            //dataSources = new List<DataSetConversionModel>();
                            var dataSourcesInner = BsonHelper.ConvertBsonDocumentListToModel<DataSetConversionModel>(aggregateDataList);
                            if (dataSourcesInner.Count > 0)
                            {
                                dataSources.AddRange(dataSourcesInner);
                            }
                            if (dataSources.Count > 0 && totalCount == 0)
                            {
                                double count = (double)dataSourcesInner?.FirstOrDefault()?.TotalCount;
                                totalCount = (int)Math.Ceiling(count / (pageSize * 1.00));
                            }
                        }

                        pageNumber++;

                    } while (pageNumber <= totalCount);

                }
                if (dataSetSearchCriteriaInputModel.IsInnerQuery == true && (dataSetSearchCriteriaInputModel.ForFormFieldValue == true || dataSetSearchCriteriaInputModel.ForRecordValue == true))
                {
                    foreach (var data in dataSources)
                    {
                        var model = new DataSetOutputModel();
                        model.DataJsonForFields = data.Data;
                        model.TotalCount = data.TotalCount;
                        dataSourcesList.Add(model);
                    }
                }
                else
                {
                    foreach (var data in dataSources)
                    {
                        var model = new DataSetOutputModel();
                        model = data.Data;
                        model.TotalCount = data.TotalCount;
                        dataSourcesList.Add(model);
                    }
                }
                return dataSourcesList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSets);
                return null;
            }
        }

        public List<DataSetOutputModel> UpdateDataSetByJob(Guid id, string fieldName, List<FormsMiniModelForUpdate> dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetByJob", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                foreach (var m in dataSetUpsertInputModel)
                {
                    update.Add(Builders<BsonDocument>.Update.Set($"DataJson.FormData.{fieldName}.{m.KeyName}", m.keyValue));
                }
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceById(id, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false),
                    new BsonDocument("_id", id.ToString())
                };
                var matchStage = new BsonDocument("$match",
                    BsonHelper.GetBsonDocumentWithConditionalObject("$and", filter));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(stages, aggregateOptions).ToList();
                var dataModels = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateDataSetByJob", "DataSetRepository"));
                return dataModels;
            }
            catch (Exception e)
            {
                return null;
            }
        }

        public void UpdateDataSetByKey(Guid id, string key, object value, LoggedInContext loggedInContext)
        {
            try
            {
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var currentUtcTime = DateTime.UtcNow;
                var update = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                };
                update.Add(Builders<BsonDocument>.Update.Set($"DataJson.FormData.{key}", value));
                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                var filterObject = GetUpdateDataSourceById(id, loggedInContext);
                datasetCollection.UpdateOne(filter: filterObject, update: updateFields);
            }
            catch (Exception e)
            {

            }
        }

        public FilterDefinition<BsonDocument> GetUpdateDataSourceById(Guid id, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", id.ToString()));
        }

        public List<DataSetOutputModelForForms> SearchDataSetsForForms(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<DataSetOutputModelForForms> dataSourcesList = new List<DataSetOutputModelForForms>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSets", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSets", "DataSetRepository"));
                var match = new BsonArray
                {
                    new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                    new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived)
                };
                bool isInvoiceQueue = false;
                bool isContractLink = false;
                bool isPurchase = false;
                bool isSales = false;
                List<BsonDocument> recordLevelCheck = new List<BsonDocument>();
                if (dataSetSearchCriteriaInputModel.DataSourceId != null)
                {
                    match.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
                }
                if (dataSetSearchCriteriaInputModel.Id != null)
                {
                    match.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
                }
                if (dataSetSearchCriteriaInputModel.IsRecordLevelPermissionEnabled)
                {
                    if (dataSetSearchCriteriaInputModel.ConditionalEnum == 1)
                    {
                        recordLevelCheck = new List<BsonDocument>{
                            new BsonDocument("$match",
                            new BsonDocument("RecordAccessibleUsers",
                            new BsonDocument("$regex", loggedInContext.LoggedInUserId.ToString())))
                        };
                    }
                    else if (dataSetSearchCriteriaInputModel.ConditionalEnum == 2)
                    {
                        var roleIds = dataSetSearchCriteriaInputModel.RoleIds.Split(',');
                        var regexPattern = string.Join("|", roleIds.Select(id => $@"\b{id}\b"));

                        recordLevelCheck = new List<BsonDocument>{
                            new BsonDocument("$match",
                            new BsonDocument("RecordAccessibleUsers",
                            new BsonDocument("$regex", regexPattern)))
                        };
                    }
                }
                var stages = new List<BsonDocument>();
                foreach (var param in dataSetSearchCriteriaInputModel.DataJsonInputs)
                {
                    var searchName = "DataJson." + param.KeyName;
                    if (param.KeyName != "DateTo" && param.KeyName != "DateFrom")
                    {
                        match.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                    }
                    if (param.KeyValue != null)
                    {
                        if (param.Type == "number")
                        {
                            match.Add(new BsonDocument(searchName, Convert.ToInt32(param.KeyValue)));
                        }
                        else if (param.Type == "boolean")
                        {
                            if (Convert.ToBoolean(param.KeyValue))
                            {
                                match.Add(new BsonDocument(searchName, Convert.ToBoolean(param.KeyValue)));
                            }
                            else
                            {
                                match.Add(new BsonDocument(searchName, new BsonDocument("$ne", true)));
                            }
                        }
                        else if (param.KeyName == "DateFrom")
                        {
                            var test1 = DateTime.Parse(param.KeyValue).ToString("yyyy,MM,dd,0,0,0");
                            var test = DateTime.Parse(param.KeyValue);
                            var Date = test.Day;
                            var month = test.Month;
                            var year = test.Year;
                            //long date = long.Parse(test1);

                            match.Add(new BsonDocument("CreatedDateTime", new BsonDocument("$gte", new DateTime(year, month, Date, 0, 0, 0))));

                        }
                        else if (param.KeyName == "DateTo")
                        {
                            var test = DateTime.Parse(param.KeyValue);
                            var Date = test.Day;
                            var month = test.Month;
                            var year = test.Year;
                            match.Add(new BsonDocument("CreatedDateTime", new BsonDocument("$lte", new DateTime(year, month, Date, 0, 0, 0))));
                        }
                        else
                        {
                            match.Add(new BsonDocument(searchName, param.KeyValue.ToString()));
                        }
                    }

                }

                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));

                var fieldSearch = new List<BsonDocument>();
                if (dataSetSearchCriteriaInputModel.AdvancedFilter == true && dataSetSearchCriteriaInputModel.Fields != null)
                {
                    foreach (FieldSearchModel fieldData in dataSetSearchCriteriaInputModel.Fields)
                    {
                        if (fieldData.Value != null)
                        {
                            var fieldName = "DataJson.FormData." + fieldData.Field;
                            string unwindPath = string.Join(".", fieldName.Split(".").SkipLast(1));

                            var splitLoop = fieldData.Field.Split(".").ToArray();
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
                                fieldSearch.Add(unwindrec);
                                fieldSearch.Add(new BsonDocument("$match",
                                                    new BsonDocument("$and", new BsonArray{new BsonDocument("DataJson.FormData." + s1,
                                                                 new BsonDocument
                                                                         {
                                                                            { "$exists", true }
                                                                            ,{ "$ne", BsonNull.Value }
                                                    })})));
                                index++;
                            }

                            fieldSearch.AddRange(new List<BsonDocument>{
                                new BsonDocument("$addFields",
                                new BsonDocument(fieldName + "_Filter",
                                new BsonDocument("$toString", "$"+ fieldName))),
                                new BsonDocument("$match",
                                new BsonDocument(fieldName + "_Filter",
                                new BsonDocument
                                        {
                                            { "$regex",
                                new Regex(fieldData.Value.ToString().Trim()) },
                                            { "$options", "i" }
                                        }))
                            });
                        }
                    }
                }

                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasets");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Name",0}) },
                                //{ "DataSourceFormJson", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Fields",0}) },
                                { "DataSourceType", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataSourceType",0}) }
                    });

                var facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                             new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)) }},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });

                if (dataSetSearchCriteriaInputModel.IsPagingRequired == true)
                {
                    var skip = ((dataSetSearchCriteriaInputModel.PageNumber - 1) * dataSetSearchCriteriaInputModel.PageSize);
                    facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                            new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)),
                                             new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", dataSetSearchCriteriaInputModel.PageSize)}},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });
                }

                var unwind = new BsonDocument("$unwind", new BsonDocument("path", "$Data"));
                var dataSetStage = new BsonDocument("$set",
                                   new BsonDocument("TotalCount", new BsonDocument("$arrayElemAt", new BsonArray
                                   {
                                       "$TotalCount.TotalCount",
                                        0
                                })));
                stages.Add(matchStage);
                if (dataSetSearchCriteriaInputModel.IsRecordLevelPermissionEnabled)
                {
                    if (dataSetSearchCriteriaInputModel.ConditionalEnum == 3)
                    {
                        if (dataSetSearchCriteriaInputModel.RecordFilters == null)
                            return dataSourcesList;

                        // here taking direct form fields
                        var filterData = dataSetSearchCriteriaInputModel.RecordFilters
                                             .Where(form => form.UserIds.Split(',').Contains(loggedInContext.LoggedInUserId.ToString()))
                                             .SelectMany(x => x.Fields)
                                             .ToList();

                        if (filterData != null && filterData.Count > 0)
                        {
                            var filters = new List<BsonDocument>();
                            var andFilters = new List<BsonDocument>();
                            var orFilters = new List<BsonDocument>();

                            foreach (var field in filterData)
                            {
                                //here we need to implement unwind if fields are multiple level
                                var filter = new BsonDocument("DataJson.FormData." + field.FieldName, field.FieldValue);

                                if (field.Condition.ToLower() == "or")
                                {
                                    orFilters.Add(filter);
                                }
                                else
                                {
                                    andFilters.Add(filter);
                                }
                            }

                            // Combine AND and OR filters
                            BsonDocument combinedFilter;

                            if (andFilters.Count > 0)
                            {
                                if (andFilters.Count == 1)
                                {
                                    orFilters.Add(andFilters[0]);
                                }
                                else
                                {
                                    orFilters.Add(new BsonDocument("$and", new BsonArray(andFilters)));
                                }
                            }

                            BsonDocument finalFilter;
                            if (orFilters.Count > 0)
                            {
                                finalFilter = new BsonDocument("$or", new BsonArray(orFilters));
                            }
                            else
                            {
                                finalFilter = new BsonDocument("$and", new BsonArray(andFilters));
                            }

                            // Create the aggregation pipeline
                            stages.AddRange(new List<BsonDocument>
                            {
                                new BsonDocument("$match", finalFilter)
                            });
                        }
                        else
                            return dataSourcesList;
                    }
                    else
                        stages.AddRange(recordLevelCheck);

                }
                if (dataSetSearchCriteriaInputModel.AdvancedFilter == true)
                    stages.AddRange(fieldSearch);
                if (dataSetSearchCriteriaInputModel.KeyFilterJson?.Count > 0)
                {
                    var dict = new Dictionary<string, object>();
                    dict.Add("DataSourceId", 1);
                    dict.Add("CreatedDateTime", 1);
                    dict.Add("CreatedByUserId", 1);
                    dict.Add("UpdatedByUserId", 1);
                    dict.Add("UpdatedDateTime", 1);
                    dict.Add("DataSourceName", 1);
                    dict.Add("DataJson.UniqueNumber", 1);
                    dict.Add("DataJson.IsApproved", 1);
                    dict.Add("DataJson.CustomApplicationId", 1);
                    dict.Add("DataJson.Status", 1);
                    dict.Add("IsPdfGenerated", 1);
                    foreach (var key in dataSetSearchCriteriaInputModel.KeyFilterJson)
                    {
                        dict.Add("DataJson.FormData." + key, 1);
                    }
                    var proj = new BsonDocument("$project", new BsonDocument(dict));
                    stages.Add(proj);
                }
                stages.Add(lookup);
                stages.Add(set);
                stages.Add(facet);
                stages.Add(unwind);
                stages.Add(dataSetStage);

                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();

                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetConversionModelForForms>(aggregateDataList);
                foreach (var data in dataSources)
                {
                    var model = new DataSetOutputModelForForms();
                    model = data.Data;
                    model.TotalCount = data.TotalCount;
                    dataSourcesList.Add(model);
                }
                return dataSourcesList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSets);
                return null;
            }
        }
        public List<DataSetOutputModelForForms> SearchDataSetsForFormsUnAuth(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<DataSetOutputModelForForms> dataSourcesList = new List<DataSetOutputModelForForms>();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetsForFormsUnAuth", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSetUnAuth);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSetsForFormsUnAuth", "DataSetRepository"));
                var match = new BsonArray
                {
                    new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived)
                };
                bool isInvoiceQueue = false;
                bool isContractLink = false;
                bool isPurchase = false;
                bool isSales = false;
                if (dataSetSearchCriteriaInputModel.DataSourceId != null)
                {
                    match.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
                }
                if (dataSetSearchCriteriaInputModel.Id != null)
                {
                    match.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
                }
                var stages = new List<BsonDocument>();
                foreach (var param in dataSetSearchCriteriaInputModel.DataJsonInputs)
                {
                    var searchName = "DataJson." + param.KeyName;
                    if (param.KeyName != "DateTo" && param.KeyName != "DateFrom")
                    {
                        match.Add(new BsonDocument(searchName, new BsonDocument("$exists", true)));
                    }
                    if (param.KeyValue != null)
                    {
                        if (param.Type == "number")
                        {
                            match.Add(new BsonDocument(searchName, Convert.ToInt32(param.KeyValue)));
                        }
                        else if (param.Type == "boolean")
                        {
                            if (Convert.ToBoolean(param.KeyValue))
                            {
                                match.Add(new BsonDocument(searchName, Convert.ToBoolean(param.KeyValue)));
                            }
                            else
                            {
                                match.Add(new BsonDocument(searchName, new BsonDocument("$ne", true)));
                            }
                        }
                        else if (param.KeyName == "DateFrom")
                        {
                            var test1 = DateTime.Parse(param.KeyValue).ToString("yyyy,MM,dd,0,0,0");
                            var test = DateTime.Parse(param.KeyValue);
                            var Date = test.Day;
                            var month = test.Month;
                            var year = test.Year;
                            //long date = long.Parse(test1);

                            match.Add(new BsonDocument("CreatedDateTime", new BsonDocument("$gte", new DateTime(year, month, Date, 0, 0, 0))));

                        }
                        else if (param.KeyName == "DateTo")
                        {
                            var test = DateTime.Parse(param.KeyValue);
                            var Date = test.Day;
                            var month = test.Month;
                            var year = test.Year;
                            match.Add(new BsonDocument("CreatedDateTime", new BsonDocument("$lte", new DateTime(year, month, Date, 0, 0, 0))));
                        }
                        else
                        {
                            match.Add(new BsonDocument(searchName, param.KeyValue.ToString()));
                        }
                    }

                }

                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                var fieldSearch = new List<BsonDocument>();
                if (dataSetSearchCriteriaInputModel.AdvancedFilter == true)
                {
                    foreach (FieldSearchModel fieldData in dataSetSearchCriteriaInputModel.Fields)
                    {
                        if (fieldData.Value != null)
                        {
                            var fieldName = "DataJson.FormData." + fieldData.Field;
                            string unwindPath = string.Join(".", fieldName.Split(".").SkipLast(1));

                            var splitLoop = fieldData.Field.Split(".").ToArray();
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
                                fieldSearch.Add(unwindrec);
                                fieldSearch.Add(new BsonDocument("$match",
                                                    new BsonDocument("$and", new BsonArray{new BsonDocument("DataJson.FormData." + s1,
                                                                 new BsonDocument
                                                                         {
                                                                            { "$exists", true }
                                                                            ,{ "$ne", BsonNull.Value }
                                                    })})));
                                index++;
                            }

                            fieldSearch.AddRange(new List<BsonDocument>{
                                new BsonDocument("$addFields",
                                new BsonDocument(fieldName + "_Filter",
                                new BsonDocument("$toString", "$"+ fieldName))),
                                new BsonDocument("$match",
                                new BsonDocument(fieldName + "_Filter",
                                new BsonDocument
                                        {
                                            { "$regex",
                                new Regex(fieldData.Value.ToString().Trim()) },
                                            { "$options", "i" }
                                        }))
                            });
                        }
                    }
                }

                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasets");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Name",0}) },
                                //{ "DataSourceFormJson", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Fields",0}) },
                                { "DataSourceType", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataSourceType",0}) }
                    });

                var facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                             new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)) }},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });

                if (dataSetSearchCriteriaInputModel.IsPagingRequired == true)
                {
                    var skip = ((dataSetSearchCriteriaInputModel.PageNumber - 1) * dataSetSearchCriteriaInputModel.PageSize);
                    facet = new BsonDocument("$facet", new BsonDocument{
                                { "Data", new BsonArray {
                                            new BsonDocument("$sort",
                                                new BsonDocument("CreatedDateTime", -1)),
                                             new BsonDocument("$skip", skip),
                                                new BsonDocument("$limit", dataSetSearchCriteriaInputModel.PageSize)}},
                                { "TotalCount", new BsonArray{
                         new BsonDocument("$count", "TotalCount")} }

                 });
                }

                var unwind = new BsonDocument("$unwind", new BsonDocument("path", "$Data"));
                var dataSetStage = new BsonDocument("$set",
                                   new BsonDocument("TotalCount", new BsonDocument("$arrayElemAt", new BsonArray
                                   {
                                       "$TotalCount.TotalCount",
                                        0
                                })));
                stages.Add(matchStage);
                if (dataSetSearchCriteriaInputModel.AdvancedFilter == true)
                    stages.AddRange(fieldSearch);
                if (dataSetSearchCriteriaInputModel.KeyFilterJson?.Count > 0)
                {
                    var dict = new Dictionary<string, object>();
                    dict.Add("DataSourceId", 1);
                    dict.Add("CreatedDateTime", 1);
                    dict.Add("CreatedByUserId", 1);
                    dict.Add("UpdatedByUserId", 1);
                    dict.Add("UpdatedDateTime", 1);
                    dict.Add("DataSourceName", 1);
                    dict.Add("DataJson.UniqueNumber", 1);
                    dict.Add("DataJson.IsApproved", 1);
                    dict.Add("DataJson.CustomApplicationId", 1);
                    dict.Add("DataJson.Status", 1);
                    dict.Add("IsPdfGenerated", 1);
                    foreach (var key in dataSetSearchCriteriaInputModel.KeyFilterJson)
                    {
                        dict.Add("DataJson.FormData." + key, 1);
                    }
                    var proj = new BsonDocument("$project", new BsonDocument(dict));
                    stages.Add(proj);
                }
                stages.Add(lookup);
                stages.Add(set);
                stages.Add(facet);
                stages.Add(unwind);
                stages.Add(dataSetStage);

                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();

                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetConversionModelForForms>(aggregateDataList);
                foreach (var data in dataSources)
                {
                    var model = new DataSetOutputModelForForms();
                    model = data.Data;
                    model.TotalCount = data.TotalCount;
                    dataSourcesList.Add(model);
                }
                return dataSourcesList;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSets);
                return null;
            }
        }

        public List<DataSetOutputModel> SearchDataSetsForJob(DataSetSearchCriteriaInputModel dataSetSearchCriteriaInputModel, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchDataSetsForJob", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchDataSetsForJob", "DataSetRepository"));
                var match = new BsonArray
                {

                    new BsonDocument("IsArchived", dataSetSearchCriteriaInputModel.IsArchived)
                };
                if (dataSetSearchCriteriaInputModel.DataSourceId != null)
                {
                    match.Add(new BsonDocument("DataSourceId", dataSetSearchCriteriaInputModel.DataSourceId.ToString()));
                }
                if (dataSetSearchCriteriaInputModel.Id != null)
                {
                    match.Add(new BsonDocument("_id", dataSetSearchCriteriaInputModel.Id.ToString()));
                }
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasets");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Name",0}) },
                                { "DataSourceType", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.DataSourceType",0}) }
                    });
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookup);
                stages.Add(set);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchDataSets", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionSearchDataSets);
                return null;
            }
        }
        public List<DataSetOutputModel> GetDataSetsById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSetRepository"));
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
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }

        public List<DataSetKeyOutputModel> GetDataSetByDataSourceId(Guid? id, Guid? keyId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetDataSetsById", "DataSetRepository"));
                var filter = new BsonArray
                {
                    new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()),
                    new BsonDocument("_id", id.ToString())
                };
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(filter)));

                var lookup = BsonHelper.GetBsonDocumentWithJoin<BsonDocument>("DataSource", "DataSourceId", "_id", "datasets");
                var set = new BsonDocument("$set",
                            new BsonDocument{
                                { "DataSourceName", new BsonDocument("$arrayElemAt", new BsonArray{"$datasets.Name",0}) }

                    });
                var dataSourceKeyLookup = new BsonDocument("$lookup", new BsonDocument {
                                    { "from", "DataSourceKeys" },
                                    { "localField", "datasets.DataSourceId" },
                                    { "foreignField", "_id" },
                                    { "as", "datasourcekeys" }
                 });
                var dataSourceset = new BsonDocument("$set",
                           new BsonDocument{
                                { "Key", new BsonDocument("$arrayElemAt", new BsonArray{ "$datasourcekeys.Key", 0}) }

                   });
                var match = new BsonArray
                {
                    new BsonDocument("datasourcekeys._id", keyId.ToString()),

                };
                var filterStage = new BsonDocument("$match",
                 new BsonDocument("$and", new BsonArray(match)));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(lookup);
                stages.Add(set);
                stages.Add(dataSourceKeyLookup);
                stages.Add(dataSourceset);
                stages.Add(filterStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetKeyOutputModel>(aggregateDataList);
                return dataSources;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }
        public int? GetDataSetCountBasedOnTodaysCount(List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetsById", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> fileCollections = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                string todayDate = DateTime.Now.Date.ToString("yyyy-MM-dd");
                //var a = fileCollections.Find(new BsonDocument("$where", "this.IsArchived == false && this.CreatedDateTime.ToString(\"yyyy-MM-dd\") == todayDate")).ToList();
                var stg1 = new BsonDocument("$match",
                    new BsonDocument("IsArchived", false));
                var stg2 = new BsonDocument("$match", new BsonDocument("CreatedDateTime", new BsonDocument("$gte", DateTime.Today)));
                var stg3 = new BsonDocument("$count", "total");
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = fileCollections.Aggregate<BsonDocument>(new List<BsonDocument> { stg1, stg2, stg3 }, aggregateOptions).FirstOrDefault();
                return (aggregateDataList != null ? (aggregateDataList.TryGetValue("total", out BsonValue ct) ? ct?.AsInt32 : 0) : 0);

                //List<DataSetOutputModel> filteredResult = fileCollections.AsQueryable<DataSetOutputModel>().Where(p => p.IsArchived == false).ToList();
                //List<DataSetOutputReturnModel> result = filteredResult.Select(e => new DataSetOutputReturnModel
                //{
                //    CreatedDateTime = e.CreatedDateTime,
                //    CreatedDate = e.CreatedDateTime.ToString("yyyy-MM-dd"),
                //    Id = e.Id
                //}).ToList();
                //var dateFilteredCount = result.Where(p => p.CreatedDate == todayDate).ToList();

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return 0;
            }
        }

        public int? GetDataSetLatestRFQId(Guid tempalteTypeId, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestRFQId", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("DataJson.TemplateTypeId", tempalteTypeId.ToString()));

                var sortStage = new BsonDocument("$sort",
                    new BsonDocument("CreatedDateTime", -1));

                var limitStage = new BsonDocument("$limit", 1);

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(sortStage);
                stages.Add(limitStage);
                var pipeline = stages;

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();

                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList).ToList();
                if (dataSources != null && dataSources.Count > 0)
                {
                    var jsonData = JsonConvert.DeserializeObject<DataSetConversionOutputModel>(JsonConvert.SerializeObject(dataSources[0].DataJson));
                    if (jsonData.RFQId != null)
                    {
                        return jsonData.RFQId;
                    }
                    else
                    {
                        return 0;
                    }
                }
                else
                {
                    return 0;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return 0;
            }
        }

        public string GetDataSetLatestProgramId(Guid? countryId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestProgramId", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);

                var matchStage = new BsonDocument("$match",
                    new BsonDocument("DataJson.Template", "Programs"));

                var matchStage1 = new BsonDocument("$match",
                   new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString()));

                var matchStage2 = new BsonDocument("$match",
                   new BsonDocument("DataJson.CountryId", countryId.ToString()));
                var matchStage3 = new BsonDocument("$match",
                                    new BsonDocument("DataJson.ProgramUniqueId",
                                     new BsonDocument("$exists", true)));
                var matchStage4 = new BsonDocument("$match",
                                   new BsonDocument("DataJson.ProgramUniqueId",
                                         new BsonDocument("$nin",
                                         new BsonArray
                                                     {
                                                         BsonNull.Value,
                                                         ""
                                                     })));

                var sortStage = new BsonDocument("$sort",
                    new BsonDocument("CreatedDateTime", -1));

                var limitStage = new BsonDocument("$limit", 1);

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(matchStage1);
                stages.Add(matchStage2);
                stages.Add(matchStage3);
                stages.Add(matchStage4);
                stages.Add(sortStage);
                stages.Add(limitStage);
                var pipeline = stages;

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();

                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList).ToList();
                if (dataSources != null && dataSources.Count > 0)
                {
                    var jsonData = JsonConvert.SerializeObject(dataSources[0].DataJson);

                    var userObj = JObject.Parse(jsonData);
                    string programId = Convert.ToString(userObj["ProgramUniqueId"]);

                    return programId;

                }
                else
                {
                    return null;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetLatestProgramId", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }
        public List<DataSetOutputModel> GetLatestSwitchBlDataSets(bool isSwitchBl, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDataSetLatestRFQId", "DataSetRepository"));
                IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("DataJson.IsSwitchBl", isSwitchBl));
                var filter = new BsonArray
                {
                    new BsonDocument("CompanyId", loggedInContext.CompanyGuid.ToString())
                };

                var sortStage = new BsonDocument("$sort",
                    new BsonDocument("CreatedDateTime", -1));

                var limitStage = new BsonDocument("$limit", 1);

                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                stages.Add(sortStage);
                stages.Add(limitStage);
                var pipeline = stages;

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();

                var dataSources = BsonHelper.ConvertBsonDocumentListToModel<DataSetOutputModel>(aggregateDataList).ToList();
                if (dataSources != null && dataSources.Count > 0)
                {
                    return dataSources;
                }
                return null;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }

        public async Task<object> DeleteDatasetById(Guid? id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteDatasetById", "DataSetRepository"));
            IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(MongoDBCollectionConstants.DataSet);
            DeleteByIdResponse responce = new DeleteByIdResponse();
            try
            {
                var Result = await datasetCollection.DeleteOneAsync(x => x.Id == id);
                if (Result.DeletedCount != 0)
                {
                    responce.IsSuccess = true;
                    responce.Message = "Delete Record Successfully By Id";
                    return responce;
                }
                else
                {
                    responce.IsSuccess = false;
                    responce.Message = "Data not found in Collection, please Enter Valid id";
                    return responce;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteDatasetById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }

        public async Task<object> DeleteMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteDatasetById", "DataSetRepository"));
            IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(inputModel.AllowAnonymous ? MongoDBCollectionConstants.DataSetUnAuth : MongoDBCollectionConstants.DataSet);
            DeleteByIdResponse response = new DeleteByIdResponse();
            try
            {
                var filter = Builders<DataSetOutputModel>.Filter.In("_id", inputModel.GenericFormSubmittedIds);
                if (inputModel.Archive == false)
                {
                    var result = await datasetCollection.DeleteManyAsync(filter);
                    if (result.DeletedCount == inputModel.GenericFormSubmittedIds.Count)
                    {
                        response.IsSuccess = true;
                        response.Message = "Records deleted successfully";
                        return response;
                    }
                    else
                    {
                        response.IsSuccess = false;
                        response.Message = "Some of the records data not found in collection, please enter valid ids";
                        return response;
                    }
                }
                else
                {
                    // Update the filter to set IsArchived = true
                    var updateDefinition = Builders<DataSetOutputModel>.Update.Set("IsArchived", true);
                    var updateResult = await datasetCollection.UpdateManyAsync(filter, updateDefinition);

                    if (updateResult.ModifiedCount == inputModel.GenericFormSubmittedIds.Count)
                    {
                        response.IsSuccess = true;
                        response.Message = "Records updated for archiving successfully";
                        return response;
                    }
                    else
                    {
                        response.IsSuccess = false;
                        response.Message = "Some of the records data not found in collection, please enter valid ids";
                        return response;
                    }

                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteDatasetById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, "Unable to delete multiple datasets");
                return null;
            }
        }
        public async Task<object> UnArchiveMultipleDataSets(DeleteMultipleDataSetsInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UnArchiveMultipleDataSets", "DataSetRepository"));
            IMongoCollection<DataSetOutputModel> datasetCollection = GetMongoCollectionObject<DataSetOutputModel>(inputModel.AllowAnonymous ? MongoDBCollectionConstants.DataSetUnAuth : MongoDBCollectionConstants.DataSet);
            DeleteByIdResponse response = new DeleteByIdResponse();
            try
            {
                var filter = Builders<DataSetOutputModel>.Filter.In("_id", inputModel.GenericFormSubmittedIds);

                // Update the filter to set IsArchived = true
                var updateDefinition = Builders<DataSetOutputModel>.Update.Set("IsArchived", false);
                var updateResult = await datasetCollection.UpdateManyAsync(filter, updateDefinition);

                if (updateResult.ModifiedCount == inputModel.GenericFormSubmittedIds.Count)
                {
                    response.IsSuccess = true;
                    response.Message = "Records are unarchived successfully";
                    return response;
                }
                else
                {
                    response.IsSuccess = false;
                    response.Message = "Some of the records data not found in collection, please enter valid ids";
                    return response;
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteDatasetById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, "Unable to unarchive multiple records");
                return null;
            }
        }


        //================================================SGT1 Dashboard Repository===================================================
        public PositionDashboardOutputModel GetDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboard", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                IMongoCollection<BsonDocument> contractQunatityCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.ContractQuantity);

                DateTime fromDate = inputModel.FromDate ?? DateTime.UtcNow;
                DateTime toDate = inputModel.Todate ?? DateTime.UtcNow;
                int fromDay = fromDate.Day;
                int fromMonth = fromDate.Month;
                int fromYear = fromDate.Year;
                int toDay = toDate.Day;
                int toMonth = toDate.Month;
                int toYear = toDate.Year;
                string uniquekey;

                if (inputModel.ProductType == "IMPORTED")
                {
                    uniquekey = "DataJson.FormData.ImportUniqueId";
                }
                else
                {
                    uniquekey = "DataJson.FormData.localUniqueId";
                }

                List<BsonDocument> dashboardPipeline =
                new List<BsonDocument>
                          {
                            new BsonDocument("$addFields",
                            new BsonDocument
                                {
                                    { "datefilter",
                            new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") },
                                    { "Product-type",
                            new BsonDocument("$toLower", "$DataJson.FormData.type") }
                                }),
                            new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { uniquekey , inputModel.ContractUniqueId },
                                    { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                                { "datefilter",
                            new BsonDocument
                                    {
                                        { "$gte",
                            new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0) },
                                        { "$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0) }
                                    } },
                                    { "Product-type", inputModel.ProductType.ToLower() }
                                }),
                            new BsonDocument("$unwind",
                            new BsonDocument("path", "$DataJson.FormData")),
                            new BsonDocument("$project", new BsonDocument{  { "_id", 0 }, { "Data", "$DataJson.FormData.productGroup1" } })
                };

                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                BsonValue productCategory;
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(dashboardPipeline, aggregateOptions).FirstOrDefault();

                var pipeline = new List<BsonDocument>
                {new BsonDocument("$match",new BsonDocument
                    {
                    {"CompanyId", loggedInContext.CompanyGuid.ToString() },
                    {"UniqueId", inputModel.ContractUniqueId },
                    {"IsArchived", false} }),
                   new BsonDocument ( "$project", new BsonDocument { { "_id" , 0} ,{ "ContractQuantity", 1} })
                };
                var resultSet = contractQunatityCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).FirstOrDefault();
                var quantityArray = resultSet == null ? null : resultSet.TryGetValue("ContractQuantity", out BsonValue quantityValue) ? quantityValue : null;
                decimal quantity = (quantityArray == null ? 0 : quantityArray.ToDecimal());

                List<DashboardOutputModel> result = new List<DashboardOutputModel>();
                if (aggregateDataList != null && aggregateDataList != "{{}}" && (aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null) == "PALM OIL")
                {
                    if (inputModel.ProductType == "IMPORTED")
                    {
                        result = _dashboardRepository.GetPalmOilImportDashboard(inputModel, loggedInContext, validationMessages);
                    }
                    else if (inputModel.ProductType == "LOCAL")
                    {
                        result = _dashboardRepository.GetPalmOilLocalDashboard(inputModel, loggedInContext, validationMessages);
                    }
                }
                else if (aggregateDataList != null && aggregateDataList != "{{}}" && (aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null) == "SUNFLOWER OIL")
                {
                    if (inputModel.ProductType == "IMPORTED")
                    {
                        result = _dashboardRepository.GetSunflowerImportDashboard(inputModel, loggedInContext, validationMessages);
                    }
                    else if (inputModel.ProductType == "LOCAL")
                    {
                        result = _dashboardRepository.GetSunflowerLocalDashboard(inputModel, loggedInContext, validationMessages);
                    }
                }
                else if (aggregateDataList != null && aggregateDataList != "{{}}" && (aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null) == "RICEBRAN OIL")
                {
                    if (inputModel.ProductType == "IMPORTED")
                    {
                        result = _dashboardRepository.GetRiceBranImportDashboard(inputModel, loggedInContext, validationMessages);
                    }
                    else if (inputModel.ProductType == "LOCAL")
                    {
                        result = _dashboardRepository.GetRiceBranLocalDashboard(inputModel, loggedInContext, validationMessages);
                    }
                }
                else if (aggregateDataList != null && aggregateDataList != "{{}}" && (aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null) == "GLYCERIN")
                {
                    if (inputModel.ProductType == "IMPORTED")
                    {
                        result = _dashboardRepository.GetGlycerinImportDashboard(inputModel, loggedInContext, validationMessages);
                    }
                    else if (inputModel.ProductType == "LOCAL")
                    {
                        result = _dashboardRepository.GetGlycerinLocalDashboard(inputModel, loggedInContext, validationMessages);
                    }
                }
                else if (aggregateDataList != null && aggregateDataList != "{{}}" && (aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null) == "SOYABEAN OIL")
                {
                    if (inputModel.ProductType == "IMPORTED")
                    {
                        result = _dashboardRepository.GetSoyabeanOilImportDashboard(inputModel, loggedInContext, validationMessages);
                    }
                    if (inputModel.ProductType == "LOCAL")
                    {
                        result = _dashboardRepository.GetSoyabeanOilLocalDashboard(inputModel, loggedInContext, validationMessages);
                    }
                }

                PositionDashboardOutputModel finalResult = new PositionDashboardOutputModel();

                if (result == null || result.Count == 0)
                {
                    var defaultData = new List<BsonDocument>
                    {
                        new BsonDocument("$match",
                            new BsonDocument
                            {
                                { "IsArchived", false },
                                { "$and",
                        new BsonArray
                                {
                                    new BsonDocument("$or",
                                    new BsonArray
                                        {
                                         new BsonDocument( "DataJson.FormData.contractDetails", inputModel.ContractUniqueId),
                                         new BsonDocument("DataJson.FormData.uniqueIdLocal", inputModel.ContractUniqueId)
                                        })
                                } }
                            }),
                        new BsonDocument("$unwind",
                        new BsonDocument("path", "$DataJson.FormData")),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_Id", 1 },
                                { "ContractUniqueId", "$DataJson.FormData.contractDetails" },
                                { "Commodity", "$DataJson.FormData.commodity" },
                                { "OpeningBalance", new BsonDocument("$ifNull",
                                    new BsonArray
                                        { "$DataJson.FormData.contractDetails"+ inputModel.ContractUniqueId +"lookupchilddata.contractQuantity"
                                        ,"$DataJson.FormData.totalQuantityMt"
                                    })},
                                { "ProductGroup", "$DataJson.FormData.productGroup1" },
                                { "CompanyId", 1 }
                            })
                    };

                    var purchageDataSet = datasetCollection.Aggregate<BsonDocument>(defaultData, aggregateOptions).FirstOrDefault();
                    var commodity = purchageDataSet == null ? null : purchageDataSet.TryGetValue("Commodity", out BsonValue purchageCommodity) ? purchageCommodity.ToString() : null;
                    var openingBalanceLocal = purchageDataSet == null ? null : purchageDataSet.TryGetValue("OpeningBalance", out BsonValue purchageOpeningBalance) ? purchageOpeningBalance : null;
                    var productGroup = purchageDataSet == null ? null : purchageDataSet.TryGetValue("ProductGroup", out BsonValue purchageproductGroup) ? purchageproductGroup.ToString() : null;
                    decimal openingBalance = openingBalanceLocal == null ? 0 : openingBalanceLocal.ToDecimal();

                    if (commodity != null)
                    {
                        result = new List<DashboardOutputModel>();

                        DashboardOutputModel data = new DashboardOutputModel
                        {
                            ProductName = commodity,
                            OpeningBalance = openingBalance - quantity,
                            ClosingBalance = openingBalance - quantity,
                            Sales = 0,
                            Production = 0,
                            Consumption = 0
                        };

                        result.Add(data);

                        finalResult.GridData = result;
                        finalResult.UsedContractQuantity = quantity;
                        finalResult.TotalContractQuantity = openingBalance;
                        finalResult.OpeningBalance = openingBalance - finalResult.UsedContractQuantity;
                        finalResult.Avilablebalance = openingBalance;
                        finalResult.SourceCommodity = commodity;
                        finalResult.UniqueId = inputModel.ContractUniqueId;
                        finalResult.ProductGroup = productGroup;
                        return finalResult;
                    }
                }
                else
                {
                    int index = result.FindIndex(a => a.OpeningBalance != null && a.OpeningBalance > 0);
                    decimal totalContractQuantity = result[index].OpeningBalance ?? 0;
                    result[index].OpeningBalance = result[index].OpeningBalance - quantity;
                    result[index].ClosingBalance = result[index].OpeningBalance + result[index].Sales + result[index].Production + result[index].Consumption;

                    finalResult.GridData = result;
                    finalResult.UsedContractQuantity = quantity;
                    finalResult.TotalContractQuantity = totalContractQuantity;
                    finalResult.OpeningBalance = finalResult.TotalContractQuantity - finalResult.UsedContractQuantity;
                    finalResult.Avilablebalance = result.OrderByDescending(y => y.OpeningBalance).Where(x => x.OpeningBalance != null && x.OpeningBalance != 0).Select(Y => Y.ClosingBalance).FirstOrDefault() ?? 0;
                    finalResult.SourceCommodity = result.OrderByDescending(y => y.OpeningBalance).Where(x => x.OpeningBalance != null && x.OpeningBalance != 0).Select(Y => Y.ProductName).FirstOrDefault();
                    finalResult.UniqueId = inputModel.ContractUniqueId;
                    finalResult.ProductGroup = result.Where(x => x.ProductName.ToLower().Contains("product group:")).Select(x => x.ProductName).FirstOrDefault().Replace("Product Group: ", "");
                    return finalResult;
                }
                return new PositionDashboardOutputModel();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDataSetsById", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return new PositionDashboardOutputModel();
            }
        }

        //==================================================================P&L Realised API's===========================================
        public FinalReliasedOutputModel GetRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRealisedPandLDashboard", "DataSetRepository"));
                FinalReliasedOutputModel result = new FinalReliasedOutputModel();
                result = _dashboardRepository.GetRealisedPandLDashboard(inputModel, loggedInContext, validationMessages);
                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRealisedPandLDashboard", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return new FinalReliasedOutputModel();
            }
        }
        public FinalUnReliasedOutputModel GetUnRealisedPandLDashboard(DashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUnRealisedPandLDashboard", "DataSetRepository"));
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                List<DashboardOutputModel> closingbalanceData = new List<DashboardOutputModel>();
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                IMongoCollection<BsonDocument> contractQunatityCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.ContractQuantity);
                string DailyRatesFormId = "2dd458e8-af57-4f85-bc3d-cffafabbfcf1";
                string fx_ana_India = "dca15a7d-ff5f-4b73-aaf7-80d069923815"; //ana India fx form Id

                DateTime fromDate = inputModel.FromDate ?? DateTime.UtcNow;
                DateTime toDate = inputModel.Todate ?? DateTime.UtcNow;
                int fromDay = fromDate.Day;
                int fromMonth = fromDate.Month;
                int fromYear = fromDate.Year;
                int toDay = toDate.Day;
                int toMonth = toDate.Month;
                int toYear = toDate.Year;
                string uniquekey;

                if (inputModel.ProductType == "IMPORTED")
                {
                    uniquekey = "DataJson.FormData.ImportUniqueId";
                }
                else
                {
                    uniquekey = "DataJson.FormData.localUniqueId";
                }

                List<BsonDocument> dashboardPipeline =
                new List<BsonDocument>
                          {
                            new BsonDocument("$addFields",
                            new BsonDocument("datefilter",
                            new BsonDocument("$toDate", "$DataJson.FormData.tradeDate"))),
                            new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { uniquekey , inputModel.ContractUniqueId },
                                    { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                                { "datefilter",
                            new BsonDocument
                                    {
                                        { "$gte",
                            new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0) },
                                        { "$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0) }
                                    } },
                                    { "DataJson.FormData.type", inputModel.ProductType }
                                }),
                            new BsonDocument("$unwind",
                            new BsonDocument("path", "$DataJson.FormData")),
                            new BsonDocument("$project", new BsonDocument{  { "_id", 0 }, { "Data", "$DataJson.FormData.productGroup1" },{ "Location" , "$DataJson.FormData.location" } })
                };

                //Getting commodity value
                var defaultData = new List<BsonDocument>
                    {
                        new BsonDocument("$match",
                            new BsonDocument
                            {
                                { "IsArchived", false },
                                { "$and",
                        new BsonArray
                                {
                                    new BsonDocument("$or",
                                    new BsonArray
                                        {
                                         new BsonDocument( "DataJson.FormData.contractDetails", inputModel.ContractUniqueId),
                                         new BsonDocument("DataJson.FormData.uniqueIdLocal", inputModel.ContractUniqueId)
                                        })
                                } }
                            }),
                        new BsonDocument("$unwind",
                        new BsonDocument("path", "$DataJson.FormData")),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_Id", 1 },
                                { "Commodity", "$DataJson.FormData.commodity" }
                            })
                    };

                var purchageDataSet = datasetCollection.Aggregate<BsonDocument>(defaultData, aggregateOptions).FirstOrDefault();
                var commodity = "CPO";// purchageDataSet == null ? null : purchageDataSet.TryGetValue("Commodity", out BsonValue purchageCommodity) ? purchageCommodity.ToString() : null;

                BsonValue productCategory;
                BsonValue location;
                var aggregateDataList = datasetCollection == null ? null : datasetCollection.Aggregate<BsonDocument>(dashboardPipeline, aggregateOptions).FirstOrDefault();

                if (aggregateDataList != null)
                {
                    string productGroup = aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null;
                    string locationName = aggregateDataList.TryGetValue("Location", out location) ? location.ToString().ToLower() : null;

                    List<BsonDocument> mtmValue = new List<BsonDocument>{
                    new BsonDocument("$match",
                    new BsonDocument("DataJson.FormData.entryDate",
                    new BsonDocument("$nin",
                    new BsonArray
                                {
                                    "",
                                    " ",
                                    BsonNull.Value
                                }))),
                    new BsonDocument("$addFields",
                    new BsonDocument
                    {
                     { "Location",
                     new BsonDocument("$toLower", "$DataJson.FormData.location") },
                     { "EntryDate",
                     new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                                        }),
                     new BsonDocument("$match",
                     new BsonDocument
                     {
                     { "DataSourceId",  DailyRatesFormId},
                     { "Location", locationName },
                     { "EntryDate",new BsonDocument("$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0))
                                    },
                     { "DataJson.FormData.productGroup", productGroup }
                     }),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                     { "_id", "$DataJson.FormData.commodity1" },
                     { "EntryDate",
                     new BsonDocument("$max", "$EntryDate") },
                     { "FormData",
                     new BsonDocument("$push",
                     new BsonDocument("Data", "$DataJson.FormData")) }
                     }),
                     new BsonDocument("$unwind",
                     new BsonDocument("path", "$FormData")),
                     new BsonDocument("$addFields",
                     new BsonDocument("RateInr",
                     new BsonDocument("$cond",
                     new BsonDocument
                     {
                     { "if",
                     new BsonDocument("$and",
                     new BsonArray
                     {
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toDate", "$FormData.Data.entryDate"),
                     "$EntryDate"
                     }),
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toLower", "$FormData.Data.commodity1"),
                     new BsonDocument("$toLower", "$_id")
                     })
                     }) },
                     { "then", "$FormData.Data.rateInr" },
                     { "else", "0" }
                     }))),
                     new BsonDocument("$match",
                     new BsonDocument("RateInr",
                     new BsonDocument("$ne", "0"))),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                         { "_id", "$_id" },
                            { "Commodity",new BsonDocument("$first", "$_id") },
                     { "RateInr",
                     new BsonDocument("$first", "$RateInr") }
                     })
                    };

                    var mtmValueDataList = datasetCollection.Aggregate<BsonDocument>(mtmValue, aggregateOptions).ToList();
                    List<MTMModel> mTmVauesList = BsonHelper.ConvertBsonDocumentListToModel<MTMModel>(mtmValueDataList);

                    List<BsonDocument> mtmValueCentralePipeline = new List<BsonDocument>{
                    new BsonDocument("$match",
                    new BsonDocument("DataJson.FormData.entryDate",
                    new BsonDocument("$nin",
                    new BsonArray
                                {
                                    "",
                                    " ",
                                    BsonNull.Value
                                }))),
                    new BsonDocument("$addFields",
                    new BsonDocument
                    {
                     { "Location",
                     new BsonDocument("$toLower", "$DataJson.FormData.location") },
                     { "EntryDate",
                     new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                                        }),
                     new BsonDocument("$match",
                     new BsonDocument
                     {
                     { "DataSourceId",  DailyRatesFormId},
                     { "Location", "central" },
                     { "EntryDate",new BsonDocument("$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0))
                                    },
                     { "DataJson.FormData.productGroup", productGroup }
                     }),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                     { "_id", "$DataJson.FormData.commodity1" },
                     { "EntryDate",
                     new BsonDocument("$max", "$EntryDate") },
                     { "FormData",
                     new BsonDocument("$push",
                     new BsonDocument("Data", "$DataJson.FormData")) }
                     }),
                     new BsonDocument("$unwind",
                     new BsonDocument("path", "$FormData")),
                     new BsonDocument("$addFields",
                     new BsonDocument("RateInr",
                     new BsonDocument("$cond",
                     new BsonDocument
                     {
                     { "if",
                     new BsonDocument("$and",
                     new BsonArray
                     {
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toDate", "$FormData.Data.entryDate"),
                     "$EntryDate"
                     }),
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toLower", "$FormData.Data.commodity1"),
                     new BsonDocument("$toLower", "$_id")
                     })
                     }) },
                     { "then", "$FormData.Data.rateInr" },
                     { "else", "0" }
                     }))),
                     new BsonDocument("$match",
                     new BsonDocument("RateInr",
                     new BsonDocument("$ne", "0"))),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                         { "_id", "$_id" },
                            { "Commodity",new BsonDocument("$first", "$_id") },
                     { "RateInr",
                     new BsonDocument("$first", "$RateInr") }
                     })
                    };

                    var mtmValueCentralDataList = datasetCollection.Aggregate<BsonDocument>(mtmValueCentralePipeline, aggregateOptions).ToList();
                    List<MTMModel> mtmValueCentral = BsonHelper.ConvertBsonDocumentListToModel<MTMModel>(mtmValueCentralDataList);
                    mtmValueCentral = mtmValueCentral ?? new List<MTMModel>();
                    if (mtmValueCentral != null)
                        mTmVauesList.AddRange(mtmValueCentral);
                    BsonValue FxVaue = 0;
                    decimal fxRemittenceValue;

                    List<BsonDocument> fxRemittancePipeline = new List<BsonDocument>();

                    fxRemittancePipeline = new List<BsonDocument>
                        {
                    new BsonDocument("$match",
                    new BsonDocument("DataJson.FormData.entryDate",
                    new BsonDocument("$nin",
                    new BsonArray
                                {
                                    "",
                                    " ",
                                    BsonNull.Value
                                }))),
                    new BsonDocument("$addFields", new BsonDocument("EntryDate", new BsonDocument("$toDate", "$DataJson.FormData.entryDate"))),
                    new BsonDocument("$match",
                     new BsonDocument
                     {
                         { "DataSourceId" , fx_ana_India},
                     { "DataJson.FormData.sourceContract", inputModel.ContractUniqueId},
                     { "EntryDate",new BsonDocument("$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0))
                                    },
                     { "DataJson.FormData.mylookup" + inputModel.ContractUniqueId + "lookupchilddata.sourcecommodity", commodity}
                     }),
                    new BsonDocument("$sort", new BsonDocument("EntryDate", -1)),
                    new BsonDocument("$project", new BsonDocument { { "_id", 0 }, { "FxVaue", "$DataJson.FormData.fxValuePendingRemittance" } }),
                    new BsonDocument("$limit", 1)
                    };
                    var fxRemittenceDataList = datasetCollection.Aggregate<BsonDocument>(fxRemittancePipeline, aggregateOptions).FirstOrDefault();
                    var fx_temp = fxRemittenceDataList == null ? 0 : fxRemittenceDataList.TryGetValue("FxVaue", out BsonValue fx) ? fx == null ? 0 : fx : 0;
                    fxRemittenceValue = fx_temp == null ? 0 : fx_temp.ToDecimal();

                    List<BsonDocument> purchangeUSDToINR = new List<BsonDocument>();
                    List<MTMModel> usdtoInrVauesList = new List<MTMModel>();

                    purchangeUSDToINR = new List<BsonDocument>
                      {
                    new BsonDocument("$match",
                    new BsonDocument("DataJson.FormData.entryDate",
                    new BsonDocument("$nin",
                    new BsonArray
                                {
                                    "",
                                    " ",
                                    BsonNull.Value
                                }))),
                    new BsonDocument("$addFields",
                    new BsonDocument
                    {
                     { "Location",
                     new BsonDocument("$toLower", "$DataJson.FormData.location") },
                     { "EntryDate",
                     new BsonDocument("$toDate", "$DataJson.FormData.entryDate") }
                                        }),
                     new BsonDocument("$match",
                     new BsonDocument
                     {
                     { "DataSourceId",  DailyRatesFormId},
                     //{ "Location", locationName },
                     { "DataJson.FormData.productGroup", productGroup },
                     { "EntryDate",new BsonDocument("$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0))
                                    },
                     { "DataJson.FormData.commodity1", commodity}
                     }),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                     { "_id", "$DataJson.FormData.commodity1" },
                     { "EntryDate",
                     new BsonDocument("$max", "$EntryDate") },
                     { "FormData",
                     new BsonDocument("$push",
                     new BsonDocument("Data", "$DataJson.FormData")) }
                     }),
                     new BsonDocument("$unwind",
                     new BsonDocument("path", "$FormData")),
                     new BsonDocument("$addFields",
                     new BsonDocument("USDToINR",
                     new BsonDocument("$cond",
                     new BsonDocument
                     {
                     { "if",
                     new BsonDocument("$and",
                     new BsonArray
                     {
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toDate", "$FormData.Data.entryDate"),
                     "$EntryDate"
                     }),
                     new BsonDocument("$eq",
                     new BsonArray
                     {
                     new BsonDocument("$toLower", "$FormData.Data.commodity1"),
                     new BsonDocument("$toLower", "$_id")
                     })
                     }) },
                     { "then", "$FormData.Data.usdToInr" },
                     { "else", "0" }
                     }))),
                     new BsonDocument("$match",
                     new BsonDocument("USDToINR",
                     new BsonDocument("$ne", "0"))),
                     new BsonDocument("$group",
                     new BsonDocument
                     {
                     { "_id", "$_id" },
                            { "Commodity",new BsonDocument("$first", "$_id") },
                     { "USDToINR",
                     new BsonDocument("$first", "$USDToINR") }
                     })
                    };
                    var purchangeUSDToINRDataList = datasetCollection.Aggregate<BsonDocument>(purchangeUSDToINR, aggregateOptions).ToList();
                    usdtoInrVauesList = BsonHelper.ConvertBsonDocumentListToModel<MTMModel>(purchangeUSDToINRDataList);

                    List<BsonDocument> quantityUSDToINRPipeline = new List<BsonDocument>();
                    List<MTMModel> quantityUSDtoINRVauesList = new List<MTMModel>();

                    quantityUSDToINRPipeline = new List<BsonDocument>{
                                new BsonDocument("$match",
                                new BsonDocument
                                    {
                                        { "DataJson.FormData.selectSourceContract", inputModel.ContractUniqueId },
                                        { "DataJson.FormData.selectSourceContract" + inputModel.ContractUniqueId + "lookupchilddata.commodity1",commodity },
                                        { "DataJson.FormData.entryDate",
                                            new BsonDocument("$nin",
                                            new BsonArray
                                                        {""," ",BsonNull.Value}) }
                                    }),
                                new BsonDocument("$addFields",
                                new BsonDocument("EntryDate",
                                new BsonDocument("$toDate", "$DataJson.FormData.entryDate"))),
                                new BsonDocument("$match",
                                new BsonDocument("EntryDate",
                                new BsonDocument("$lte",
                                new DateTime(toYear, toMonth , toDay, 23, 0, 0)))),
                                                            new BsonDocument("$group",
                                new BsonDocument
                                    {
                                        { "_id", "$DataJson.FormData.selectSourceContract" + inputModel.ContractUniqueId + "lookupchilddata.commodity1" },
                                        { "EntryDate",
                                new BsonDocument("$max", "$EntryDate") },
                                        { "FormData",
                                new BsonDocument("$push",
                                new BsonDocument("Data", "$DataJson.FormData")) }
                                    }),
                                new BsonDocument("$unwind",
                                new BsonDocument("path", "$FormData")),
                                new BsonDocument("$addFields",
                                new BsonDocument("QuantityMTM",
                                new BsonDocument("$cond",
                                new BsonDocument
                                            {
                                                { "if",
                                new BsonDocument("$and",
                                new BsonArray
                                                    {
                            new BsonDocument("$eq",
                            new BsonArray
                                {
                                    new BsonDocument("$toDate", "$FormData.Data.entryDate"),
                                    "$EntryDate"
                                }),
                            new BsonDocument("$eq",
                            new BsonArray
                                {
                                    new BsonDocument("$toLower", "$FormData.Data.selectSourceContract" + inputModel.ContractUniqueId + "lookupchilddata.commodity1"),
                                    new BsonDocument("$toLower", "$_id")
                                })
                        }) },
                    { "then", "$FormData.Data.totalUnpaidDutyQuantityMt" },
                    { "else", "0" }
                }))),
                                    new BsonDocument("$match",
                                    new BsonDocument("QuantityMTM",
                                    new BsonDocument("$ne", "0"))),
                                    new BsonDocument("$group",
                                    new BsonDocument
                                        {
                                            { "_id", "$_id" },
                                            { "Commodity",
                                    new BsonDocument("$first", "$_id") },
                                             { "QuantityMTM",
                            new BsonDocument("$first", new BsonDocument("$round" ,new BsonArray {"$QuantityMTM", 4}))
                                }
                                })
                    };
                    var quantityusdtoinrValueDataList = datasetCollection.Aggregate<BsonDocument>(quantityUSDToINRPipeline, aggregateOptions).ToList();
                    quantityUSDtoINRVauesList = BsonHelper.ConvertBsonDocumentListToModel<MTMModel>(quantityusdtoinrValueDataList);

                    List<BsonDocument> quantitymtmPipeLine = new List<BsonDocument>();
                    List<MTMModel> quantitymtmDataListData = new List<MTMModel>();

                    quantitymtmPipeLine = new List<BsonDocument> {
                                new BsonDocument("$match",
                                new BsonDocument
                                    {
                                        { "DataJson.FormData.startDate",
                                new BsonDocument("$ne", "") },
                                        { "DataJson.FormData.productGroup", productGroup },
                                        { "DataJson.FormData.commodity",commodity}
                                    }),
                                new BsonDocument("$addFields",
                                new BsonDocument("EntryDate",
                                new BsonDocument("$toDate", "$DataJson.FormData.startDate"))),
                                 new BsonDocument("$match",
                                new BsonDocument("EntryDate",
                                new BsonDocument("$lte",
                                new DateTime(toYear, toMonth , toDay, 23, 0, 0)))),
                                new BsonDocument("$group",
                                new BsonDocument
                                {
                                { "_id", "$DataJson.FormData.commodity"
                                },
                                { "EntryDate",
                                    new BsonDocument("$max", "$EntryDate")
                                },
                                { "FormData",
                                    new BsonDocument("$push",
                                    new BsonDocument("Data", "$DataJson.FormData"))
                                }
                                }),
                                    new BsonDocument("$unwind",
                                    new BsonDocument("path", "$FormData")),
                                    new BsonDocument("$addFields",
                                    new BsonDocument("QuantityMTM",
                                    new BsonDocument("$cond",
                                    new BsonDocument
                                {
                                { "if",
                                    new BsonDocument("$and",
                                    new BsonArray
                                {
                                    new BsonDocument("$eq",
                                    new BsonArray
                                {
                                    new BsonDocument("$toDate", "$FormData.Data.startDate"),
                                    "$EntryDate"
                                }),
                                    new BsonDocument("$eq",
                                    new BsonArray
                                {
                                    new BsonDocument("$toLower", "$FormData.Data.commodity"),
                                    new BsonDocument("$toLower", "$_id")
                                })
                                }) },
                    { "then", "$FormData.Data.totalCustomsDutyInrPerMtWithIgst" },
                    { "else", "0" }
                                        }))),
                            new BsonDocument("$match",
                            new BsonDocument
                                {
                                    { "QuantityMTM",
                            new BsonDocument("$ne", "0") },
                                    { "_id",
                            new BsonDocument("$nin",
                            new BsonArray
                                        {
                                            BsonNull.Value,
                                            ""
                                        }) }
                                }),
                            new BsonDocument("$group",
                            new BsonDocument
                                {
                                    { "_id", "$_id" },
                                    { "Commodity",
                            new BsonDocument("$first", "$_id") },
                                    { "QuantityMTM",
                            new BsonDocument("$first", new BsonDocument("$round" ,new BsonArray {"$QuantityMTM",+4}))
                                }
                                })

                };
                    var quantitymtmDataList = datasetCollection.Aggregate<BsonDocument>(quantitymtmPipeLine, aggregateOptions).ToList();
                    quantitymtmDataListData = BsonHelper.ConvertBsonDocumentListToModel<MTMModel>(quantitymtmDataList);

                    closingbalanceData = GetDashboard(inputModel, loggedInContext, validationMessages).GridData.ToList();

                    FinalUnReliasedOutputModel result = new FinalUnReliasedOutputModel();
                    result = _dashboardRepository.GetUnRealisedPandLDashboard(inputModel, loggedInContext, validationMessages);
                    foreach (var data in result.GridData)
                    {
                        List<DashboardOutputModel> recordFetch = new List<DashboardOutputModel>();
                        MTMModel mtmrecordFetch = new MTMModel();
                        MTMModel usdToInrrecordFetch = new MTMModel();
                        MTMModel quantityusdToInrrecordFetch = new MTMModel();
                        MTMModel quantitymtmDataFetch = new MTMModel();

                        if (closingbalanceData != null)
                            recordFetch = closingbalanceData.Where(x => x.ProductName.ToLower() == data.Name.ToLower()).ToList();
                        if (mTmVauesList != null)
                        {
                            mTmVauesList.RemoveAll(x => x.Commodity == null);
                            mtmrecordFetch = mTmVauesList.Where(x => x.Commodity.ToLower() == data.Name.ToLower()).FirstOrDefault();
                        }
                        if (usdtoInrVauesList != null)
                        {
                            usdtoInrVauesList.RemoveAll(x => x.Commodity == null);
                            usdToInrrecordFetch = usdtoInrVauesList.Where(x => x.Commodity.ToLower() == data.Name.ToLower()).FirstOrDefault();
                        }
                        if (quantityUSDtoINRVauesList != null)
                        {
                            quantityUSDtoINRVauesList.RemoveAll(x => x.Commodity == null);
                            quantityusdToInrrecordFetch = quantityUSDtoINRVauesList.Where(x => x.Commodity.ToLower() == data.Name.ToLower()).FirstOrDefault();
                        }
                        if (quantitymtmDataListData != null)
                        {
                            quantitymtmDataListData.RemoveAll(x => x.Commodity == null);
                            quantitymtmDataFetch = quantitymtmDataListData.Where(x => x.Commodity.ToLower() == data.Name.ToLower()).FirstOrDefault();
                        }

                        if (recordFetch != null && recordFetch.Count != 0)
                        {
                            data.ClosingBalance = recordFetch.Sum(x => x.ClosingBalance) ?? 0;
                        }
                        if (mtmrecordFetch != null && mtmrecordFetch.RateInr != 0)
                        {
                            data.MTMValue = (data.ClosingBalance ?? 0) * mtmrecordFetch.RateInr;
                        }
                        if (usdToInrrecordFetch != null && usdToInrrecordFetch.USDToINR != 0)
                        {
                            data.PurchaseMTMRate = usdToInrrecordFetch.USDToINR ?? 0;
                        }
                        if (quantityusdToInrrecordFetch != null && quantityusdToInrrecordFetch.QuantityMTM != 0)
                        {
                            data.QuantityUnpaid = quantityusdToInrrecordFetch.QuantityMTM ?? 0;
                        }
                        if (quantitymtmDataFetch != null && quantitymtmDataFetch.QuantityMTM != 0)
                        {
                            data.QuantityDutyMTM = quantitymtmDataFetch.QuantityMTM ?? 0;
                        }
                        data.PurchaseFXValueInUSD = data.Name.ToLower() == (commodity == null ? null : commodity.ToLower()) ? fxRemittenceValue : 0;
                        data.PurchaseValueInINR = (data.PurchaseFXValueInUSD * data.PurchaseMTMRate) ?? 0;
                        data.QuantityUnPaidValueInINR = (data.QuantityUnpaid * data.QuantityDutyMTM) ?? 0;

                        //Converting to negative
                        data.PurchaseFXValueInUSD = (-1) * data.PurchaseFXValueInUSD;
                        data.PurchaseValueInINR = (-1) * data.PurchaseValueInINR;
                        data.QuantityUnPaidValueInINR = (-1) * data.QuantityUnPaidValueInINR;
                        data.QuantityUnpaid = (-1) * data.QuantityUnpaid;
                    }

                    return result;
                }
                else
                {
                    FinalUnReliasedOutputModel result = new FinalUnReliasedOutputModel();
                    result = _dashboardRepository.GetUnRealisedPandLDashboard(inputModel, loggedInContext, validationMessages);
                    return result;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUnRealisedPandLDashboard", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return new FinalUnReliasedOutputModel();
            }
        }
        public InstanceLevelPositionDashboardOutputModel GetInstanceLevelDashboard(DashboardInputModel salesDashboardInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetDashboard", "DataSetRepository"));
                InstanceLevelPositionDashboardOutputModel finalInstanceModel = new InstanceLevelPositionDashboardOutputModel();
                if (salesDashboardInput.ProductType.ToLower() == "sun flower oil")
                {
                    salesDashboardInput.ProductType = "sunflower oil";
                }
                if (salesDashboardInput.ProductType.ToLower() == "soya bean oil")
                {
                    salesDashboardInput.ProductType = "soyabean oil";
                }
                if (salesDashboardInput.ProductType.ToLower() == "ricebran oil")
                {
                    salesDashboardInput.ProductType = "rice bran oil";
                }

                if (!string.IsNullOrWhiteSpace(salesDashboardInput.ProductType))
                {
                    if (salesDashboardInput.ProductType.ToLower() == "palm oil")
                    {
                        finalInstanceModel = _dashboardRepository.GetPalmOilInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);
                    }
                    else if (salesDashboardInput.ProductType.ToLower() == "sunflower oil")
                    {
                        finalInstanceModel = _dashboardRepository.GetSunflowerInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);
                    }
                    else if (salesDashboardInput.ProductType.ToLower() == "glycerin")
                    {
                        finalInstanceModel = _dashboardRepository.GetGlycerinInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);
                    }
                    else if (salesDashboardInput.ProductType.ToLower() == "rice bran oil")
                    {
                        finalInstanceModel = _dashboardRepository.GetRiceBranInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);
                    }
                    else if (salesDashboardInput.ProductType.ToLower() == "soyabean oil")
                    {
                        finalInstanceModel = _dashboardRepository.GetSoyaBeanInstanceLevelDashboard(salesDashboardInput, loggedInContext, validationMessages);
                    }
                }

                Parallel.ForEach(finalInstanceModel.GridData, record =>
                {
                    record.OpeningBalance = record.OpeningBalance ?? 0;
                    record.Production = record.Production ?? 0;
                    record.Sales = (-1) * record.Sales ?? 0;
                    record.UnTaggedSales = (-1) * record.UnTaggedSales ?? 0;
                    record.Consumption = (-1) * record.Consumption ?? 0;
                    record.ClosingBalance = (record.OpeningBalance + record.UnTaggedSales + record.Consumption + record.Production + record.Sales);
                });

                finalInstanceModel.TotalImportContracts = finalInstanceModel.TotalImportContracts ?? 0;
                finalInstanceModel.TotalLocalContracts = finalInstanceModel.TotalLocalContracts ?? 0;
                finalInstanceModel.TotalSalesQuantity = finalInstanceModel.TotalSalesQuantity ?? 0;
                finalInstanceModel.TotalSourceQuantity = finalInstanceModel.TotalSourceQuantity ?? 0;

                return finalInstanceModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelDashboard", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return new InstanceLevelPositionDashboardOutputModel();
            }
        }

        //public List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelPandLDashboard", "DataSetRepository"));

        //        List<InstanceLevelPofitLossOutputModel> finalInstanceModel = new List<InstanceLevelPofitLossOutputModel>();

        //        finalInstanceModel = _dashboardRepository.GetInstanceLevelProfitLossdashboard(dashboardInputModel, loggedInContext, validationMessages);

        //        return finalInstanceModel;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelDashboard", "DataSetRepository", exception));
        //        SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
        //        return new List<InstanceLevelPofitLossOutputModel>();
        //    }
        //}

        public List<InstanceLevelPofitLossOutputModel> GetInstanceLevelProfitLossDashboard(DashboardInputModel dashboardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetInstanceLevelProfitLossdashboard", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                List<InstanceLevelPofitLossOutputModel> finalInstanceLevelProfitLossOutputModel = new List<InstanceLevelPofitLossOutputModel>();

                if (dashboardInputModel.ProductType.ToLower() == "sun flower oil")
                {
                    dashboardInputModel.ProductType = "sunflower oil";
                }
                if (dashboardInputModel.ProductType.ToLower() == "soya bean oil")
                {
                    dashboardInputModel.ProductType = "soyabean oil";
                }
                if (dashboardInputModel.ProductType.ToLower() == "ricebran oil")
                {
                    dashboardInputModel.ProductType = "rice bran oil";
                }

                if (dashboardInputModel.IsConsolidated == true)
                {
                    finalInstanceLevelProfitLossOutputModel = _dashboardRepository.GetConsolidatedProfitLossdashboard(dashboardInputModel, loggedInContext, validationMessages);
                    return finalInstanceLevelProfitLossOutputModel;
                }

                DateTime fromDate = dashboardInputModel.FromDate ?? DateTime.UtcNow;
                DateTime toDate = dashboardInputModel.Todate ?? DateTime.UtcNow;
                int fromDay = fromDate.Day;
                int fromMonth = fromDate.Month;
                int fromYear = fromDate.Year;
                int toDay = toDate.Day;
                int toMonth = toDate.Month;
                int toYear = toDate.Year;

                var importUniqueIdPipeLine = new List<BsonDocument>
                    {
                        new BsonDocument("$unwind",
                        new BsonDocument("path", "$DataJson.FormData.contractDetails")),
                        new BsonDocument("$addFields",
                        new BsonDocument("ProductGroup",
                        new BsonDocument("$toLower", "$DataJson.FormData.contractDetails.productGroup1"))),
                        new BsonDocument("$match",
                        new BsonDocument
                            {
                                { "IsArchived", false },
                                { "ProductGroup", dashboardInputModel.ProductType.ToLower() },
                                { "DataJson.FormData.contractDetails.contractUniqueId",
                        new BsonDocument
                                {
                                    { "$regex", dashboardInputModel.CompanyName.ToLower() },
                                    { "$options", "i" }
                                } }
                            }),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_id", 0 },
                                { "IsImportId",  new BsonDocument("$toBool", 1) },
                                { "UniqueId", "$DataJson.FormData.contractDetails.contractUniqueId" }
                            })
                    };
                var localUniqueIdPipeLine = new List<BsonDocument> {
                                new BsonDocument("$unwind",
                                new BsonDocument("path", "$DataJson.FormData")),
                                new BsonDocument("$addFields",
                                new BsonDocument("ProductGroup",
                                new BsonDocument("$toLower", "$DataJson.FormData.productGroup1"))),
                                new BsonDocument("$match",
                                new BsonDocument
                                    {
                                        { "IsArchived", false },
                                        { "ProductGroup", dashboardInputModel.ProductType.ToLower() },
                                        { "DataJson.FormData.uniqueIdLocal",
                                new BsonDocument
                                        {
                                            { "$regex", dashboardInputModel.CompanyName.ToLower() },
                                            { "$options", "i" }
                                        } }
                                    }),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 0 },
                                        { "UniqueId", "$DataJson.FormData.uniqueIdLocal" }
                                    })
                };
                var importIdList = datasetCollection.Aggregate<BsonDocument>(importUniqueIdPipeLine, aggregateOptions).ToList();
                var localIdList = datasetCollection.Aggregate<BsonDocument>(localUniqueIdPipeLine, aggregateOptions).ToList();
                List<VesselModel> vesselIds = new List<VesselModel>();
                vesselIds.AddRange(BsonHelper.ConvertBsonDocumentListToModel<VesselModel>(importIdList));
                vesselIds.AddRange(BsonHelper.ConvertBsonDocumentListToModel<VesselModel>(localIdList));

                List<BsonDocument> fxValuesPipeline = new List<BsonDocument>
                {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "$and",
                new BsonArray
                        {
                            new BsonDocument("DataJson.FormData.mylookup",
                            new BsonDocument("$ne", BsonNull.Value)),
                            new BsonDocument("DataJson.FormData.mylookup",
                            new BsonDocument("$in",
                            new BsonArray(vesselIds.Select(x => x.UniqueId).ToList())
                                    ))
                        } },
                        { "IsArchived", false }
                    }),
                new BsonDocument("$unwind",
                new BsonDocument("path", "$DataJson.FormData")),
                new BsonDocument("$addFields",
                new BsonDocument
                    {
                        { "Name", "$DataJson.FormData.mylookupstringlookupchilddata.sourcecommodity" },
                        { "TotalPurchaseFXInUSD",
                new BsonDocument("$round",
                new BsonArray
                            {
                                new BsonDocument("$toDecimal", "$DataJson.FormData.totalFxSettledInUsd"),
                                4
                            }) },
                        { "TotalPurchaseFXInINR",
                new BsonDocument("$round",
                new BsonArray
                            {
                                new BsonDocument("$toDecimal", "$DataJson.FormData.totalFxSettledValueInInr"),
                                4
                            }) }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "UniqueId", "$DataJson.FormData.mylookup" },
                        { "Name", 1 },
                        { "TotalPurchaseFXInUSD", 1 },
                        { "TotalPurchaseFXInINR", 1 },
                        { "_id", 0 }
                    })
                };
                List<BsonDocument> dutyValuesPipeline = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                    new BsonDocument
                        {
                            { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                            { "DataJson.FormData.totalDutyPaidQuantityMt",
                    new BsonDocument("$ne", BsonNull.Value) },
                            { "IsArchived", false }
                        }),
                    new BsonDocument("$unwind",
                    new BsonDocument("path", "$DataJson.FormData")),
                    new BsonDocument("$addFields",
                    new BsonDocument
                        {
                            { "Name", "$DataJson.FormData.selectSourceContractstringlookupchilddata.commodity1" },
                            { "DutyQuantityPaid",
                    new BsonDocument("$round",
                    new BsonArray
                                {
                                    new BsonDocument("$toDecimal", "$DataJson.FormData.totalDutyPaidQuantityMt"),
                                    4
                                }) },
                            { "DutyValueInINR",
                    new BsonDocument("$round",
                    new BsonArray
                                {
                                    new BsonDocument("$toDecimal", "$DataJson.FormData.totalPaidDutyInclIgstValueInr"),
                                    4
                                }) }
                        }),
                    new BsonDocument("$project",
                    new BsonDocument
                        {
                            { "_id", 0 },
                            { "UniqueId", "$DataJson.FormData.selectSourceContract" },
                            { "Name", 1 },
                            { "DutyQuantityPaid", 1 },
                            { "DutyValueInINR", 1 }
                        })
                };
                List<BsonDocument> refiningcostPipeline = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                    new BsonDocument("$or",
                    new BsonArray
                            {
                                new BsonDocument("DataJson.FormData.ImportUniqueId",
                                new BsonDocument("$nin",
                                new BsonArray
                                        {
                                            "",
                                            BsonNull.Value
                                        })),
                                new BsonDocument("DataJson.FormData.localUniqueId",
                                new BsonDocument("$nin",
                                new BsonArray
                                        {
                                            "",
                                            BsonNull.Value
                                        }))
                            })),
                    new BsonDocument("$addFields",
                    new BsonDocument
                        {
                            { "datefilter",
                    new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") },
                            { "UniqueId",
                    new BsonDocument("$concat",
                    new BsonArray
                                {
                                    new BsonDocument("$ifNull",
                                    new BsonArray
                                        {
                                            "$DataJson.FormData.ImportUniqueId",
                                            ""
                                        }),
                                    new BsonDocument("$ifNull",
                                    new BsonArray
                                        {
                                            "$DataJson.FormData.localUniqueId",
                                            ""
                                        })
                                }) }
                        }),
                    new BsonDocument("$match",
                    new BsonDocument
                        {
                            { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                            { "IsArchived", false },
                            { "datefilter",
                    new BsonDocument
                            {
                                { "$gte",
                            new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0) },
                                        { "$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0) }
                                    }}
                        }),
                    new BsonDocument("$unwind",
                    new BsonDocument("path", "$DataJson.FormData")),
                    new BsonDocument("$group",
                    new BsonDocument
                        {
                            { "_id", "$UniqueId" },
                            { "RefiningCostIncurred",
                    new BsonDocument("$sum",
                    new BsonDocument("$round",
                    new BsonArray
                                    {
                                        new BsonDocument("$toDecimal",
                                        new BsonDocument("$ifNull",
                                        new BsonArray
                                                {
                                                    "$DataJson.FormData.expectedRefiningCostInr1",
                                                    "0"
                                                })),
                                        4
                                    })) }
                        }),
                    new BsonDocument("$project",
                    new BsonDocument
                        {
                            { "_id", 0 },
                            { "UniqueId", "$_id" },
                            { "RefiningCostIncurred", 1 }
                        })
                };
                List<BsonDocument> dashboardPipeline = new List<BsonDocument>
                          {

                        new BsonDocument("$match",
                        new BsonDocument("$or",
                        new BsonArray
                                {
                                    new BsonDocument("DataJson.FormData.ImportUniqueId",
                                    new BsonDocument("$nin",
                                    new BsonArray
                                            {
                                                "",
                                                BsonNull.Value
                                            })),
                                    new BsonDocument("DataJson.FormData.localUniqueId",
                                    new BsonDocument("$nin",
                                    new BsonArray
                                            {
                                                "",
                                                BsonNull.Value
                                            }))
                                })),
                        new BsonDocument("$addFields",
                        new BsonDocument
                            {
                                { "datefilter",
                        new BsonDocument("$toDate", "$DataJson.FormData.tradeDate") },
                                { "UniqueId",
                        new BsonDocument("$concat",
                        new BsonArray
                                    {
                                        new BsonDocument("$ifNull",
                                        new BsonArray
                                            {
                                                "$DataJson.FormData.ImportUniqueId",
                                                ""
                                            }),
                                        new BsonDocument("$ifNull",
                                        new BsonArray
                                            {
                                                "$DataJson.FormData.localUniqueId",
                                                ""
                                            })
                                    }) }
                            }),
                        new BsonDocument("$match",
                        new BsonDocument
                            {
                                { "CompanyId", loggedInContext.CompanyGuid.ToString() },
                                { "UniqueId",
                        new BsonDocument("$nin",
                        new BsonArray
                                    {
                                        "",
                                        BsonNull.Value
                                    }) },
                                { "IsArchived", false },
                                { "datefilter",
                        new BsonDocument
                                {
                                    { "$gte",
                            new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0) },
                                        { "$lte",
                            new DateTime(toYear, toMonth, toDay, 23, 0, 0) }
                                    } }
                            }),
                        new BsonDocument("$group",
                        new BsonDocument
                            {
                                { "_id", "$UniqueId" },
                                { "Product-Sales",
                        new BsonDocument("$sum",
                        new BsonDocument("$round",
                        new BsonArray
                                        {
                                            new BsonDocument("$toDecimal",
                                            new BsonDocument("$ifNull",
                                            new BsonArray
                                                    {
                                                        "$DataJson.FormData.quantityMt2",
                                                        "0"
                                                    })),
                                            4
                                        })) },
                                { "valueInr1",
                        new BsonDocument("$sum",
                        new BsonDocument("$round",
                        new BsonArray
                                        {
                                            new BsonDocument("$toDecimal",
                                            new BsonDocument("$ifNull",
                                            new BsonArray
                                                    {
                                                        new BsonDocument("$cond",
                                                        new BsonDocument
                                                            {
                                                                { "if",
                                                        new BsonDocument("$eq",
                                                        new BsonArray
                                                                    {
                                                                        "$DataJson.FormData.salesType",
                                                                        "REGULAR"
                                                                    }) },
                                                                { "then", "$DataJson.FormData.valueInr1" },
                                                                { "else", 0 }
                                                            }),
                                                        "0"
                                                    })),
                                            4
                                        })) },
                                { "valueInr",
                        new BsonDocument("$sum",
                        new BsonDocument("$round",
                        new BsonArray
                                        {
                                            new BsonDocument("$toDecimal",
                                            new BsonDocument("$ifNull",
                                            new BsonArray
                                                    {
                                                        "$DataJson.FormData.valueInr1",
                                                        "0"
                                                    })),
                                            4
                                        })) },
                                { "PODateValueInr",
                        new BsonDocument("$sum",
                        new BsonDocument("$round",
                        new BsonArray
                                        {
                                            new BsonDocument("$toDecimal",
                                            new BsonDocument("$ifNull",
                                            new BsonArray
                                                    {
                                                        "$DataJson.FormData.PODateValueInr",
                                                        "0"
                                                    })),
                                            4
                                        })) },
                                { "DeliveryDateValueInr",
                        new BsonDocument("$sum",
                        new BsonDocument("$round",
                        new BsonArray
                                        {
                                            new BsonDocument("$toDecimal",
                                            new BsonDocument("$ifNull",
                                            new BsonArray
                                                    {
                                                        "$DataJson.FormData.DeliveryDateValueInr",
                                                        "0"
                                                    })),
                                            4
                                        })) }
                            }),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_id", 0 },
                                { "UniqueId", "$_id" },
                                { "SalesInQuantity", "$Product-Sales" },
                                { "SalesInValue",
                        new BsonDocument("$add",
                        new BsonArray
                                    {
                                        "$valueInr1",
                                        "$valueInr",
                                        "$PODateValueInr",
                                        "$DeliveryDateValueInr"
                                    }) }
                            })

                        };

                List<RealisedProfitAndLossOutputModel> dataSources = new List<RealisedProfitAndLossOutputModel>();
                var fxDataList = datasetCollection.Aggregate<BsonDocument>(fxValuesPipeline, aggregateOptions).ToList();
                var dutyDataList = datasetCollection.Aggregate<BsonDocument>(dutyValuesPipeline, aggregateOptions).ToList();
                var refiningcostData = datasetCollection.Aggregate<BsonDocument>(refiningcostPipeline, aggregateOptions).ToList();
                var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(dashboardPipeline, aggregateOptions).ToList();
                List<InstanceLevelPAndLDashboardModel> fxList = BsonHelper.ConvertBsonDocumentListToModel<InstanceLevelPAndLDashboardModel>(fxDataList);
                List<InstanceLevelPAndLDashboardModel> dutyList = BsonHelper.ConvertBsonDocumentListToModel<InstanceLevelPAndLDashboardModel>(dutyDataList);
                List<InstanceLevelPAndLDashboardModel> refiningcostList = BsonHelper.ConvertBsonDocumentListToModel<InstanceLevelPAndLDashboardModel>(refiningcostData);
                List<InstanceLevelPAndLDashboardModel> salesList = BsonHelper.ConvertBsonDocumentListToModel<InstanceLevelPAndLDashboardModel>(aggregateDataList);

                foreach (var data in vesselIds)
                {
                    DashboardInputModel input = new DashboardInputModel
                    {
                        ProductType = data.IsImportId == true ? "IMPORTED" : "LOCAL",
                        FromDate = dashboardInputModel.FromDate,
                        Todate = dashboardInputModel.Todate,
                        ContractUniqueId = data.UniqueId
                    };

                    decimal? unReliasedOutputModel = GetUnRealisedPandLDashboard(input, loggedInContext, validationMessages).GridData.Select(x => x.MTMValue + x.PurchaseValueInINR + x.QuantityUnPaidValueInINR).Sum();

                    var finalRealisedTotal = (salesList.Where(x => x.UniqueId == data.UniqueId).Select(x => x.SalesInValue).FirstOrDefault() ?? 0)
                                              - (fxList.Where(x => x.UniqueId == data.UniqueId).Select(x => x.TotalPurchaseFXInINR).FirstOrDefault() ?? 0)
                                              - (dutyList.Where(x => x.UniqueId == data.UniqueId).Select(x => x.DutyValueInINR).FirstOrDefault() ?? 0)
                                              - (refiningcostList.Where(x => x.UniqueId == data.UniqueId).Select(x => x.RefiningCostIncurred).FirstOrDefault() ?? 0);

                    finalInstanceLevelProfitLossOutputModel.Add(new InstanceLevelPofitLossOutputModel
                    {
                        VesselName = data.UniqueId,
                        RealisedTotal = finalRealisedTotal,
                        UnRealisedTotal = unReliasedOutputModel ?? 0
                    });
                }

                return finalInstanceLevelProfitLossOutputModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetInstanceLevelProfitLossdashboard", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return new List<InstanceLevelPofitLossOutputModel>();
            }
        }

        public Guid? CreateOrUpdateVesselSummary(VesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> mongoCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.VesselSummary);
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
                    LoggingManager.Info("Updating record with Id - " + inputModel.Id.ToString() + " from " + MongoDBCollectionConstants.VesselSummary + " Collection");

                    var update = new List<UpdateDefinition<BsonDocument>>
                    {
                        Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
                        Builders<BsonDocument>.Update.Set("ProductGroup", inputModel.ProductGroup),
                        Builders<BsonDocument>.Update.Set("RealisedTotal", inputModel.RealisedTotal),
                        Builders<BsonDocument>.Update.Set("UnRealisedTotal", inputModel.UnRealisedTotal)
                    };

                    var fBuilder = GetUpdateFilter(inputModel, loggedInContext);
                    FilterDefinition<BsonDocument> filter = fBuilder;
                    var updateFields = Builders<BsonDocument>.Update.Combine(update);
                    mongoCollection.UpdateOne(filter: fBuilder, update: updateFields);
                }
                else
                {
                    inputModel.Id = Guid.NewGuid();
                    LoggingManager.Info("Inserting new record with Id - " + inputModel.Id.ToString() + " into " + MongoDBCollectionConstants.VesselSummary + " Collection");
                    inputModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    inputModel.CreatedDateTime = DateTime.UtcNow;
                    inputModel.IsArchived = false;
                    mongoCollection.InsertOne(inputModel.ToBsonDocument());
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateOrUpdateVesselSummary", "DataSetRepository"));
                return inputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateOrUpdateVesselSummary", "DataSourceRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceKeys);
                return null;
            }
        }
        public FilterDefinition<BsonDocument> GetUpdateFilter(VesselSummaryInputModel inputModel, LoggedInContext loggedInContext)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", inputModel.Id.ToString()),
                         fBuilder.Eq("CompanyId", loggedInContext.CompanyGuid.ToString()),
                         fBuilder.Eq("UniqueId", inputModel.UniqueId)
                         );
        }

        public void RefreshVesselSummary(RefreshVesselSummaryInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RefreshVesselSummary", "DataSourceRepository"));
            IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
            var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };

            if (inputModel != null)
            {
                if (!inputModel.IsInstanceLevelRefresh)
                {
                    List<BsonDocument> dashboardPipeline =
                    new List<BsonDocument>
                              {
                                new BsonDocument("$match",
                                new BsonDocument
                                    {
                                        { "CompanyId", loggedInContext.CompanyGuid.ToString().ToLower() },
                                        { "$or",
                                new BsonArray
                                        {
                                            new BsonDocument("DataJson.FormData.ImportUniqueId", inputModel.UniqueId),
                                            new BsonDocument("DataJson.FormData.localUniqueId", inputModel.UniqueId)
                                        } }
                                    }),
                                new BsonDocument("$unwind",
                                new BsonDocument("path", "$DataJson.FormData")),
                                new BsonDocument("$limit", 1),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 0 },
                                        { "Data", "$DataJson.FormData.productGroup1" }
                                    })
                    };

                    BsonValue productCategory;
                    var aggregateDataList = datasetCollection.Aggregate<BsonDocument>(dashboardPipeline, aggregateOptions).FirstOrDefault();
                    if (aggregateDataList != null && aggregateDataList != "{{}}")
                        inputModel.ProductGroup = aggregateDataList.TryGetValue("Data", out productCategory) ? productCategory.ToString() : null;

                    VesselSummaryInputModel vesselSummaryInput = new VesselSummaryInputModel
                    {
                        UniqueId = inputModel.UniqueId,
                        ProductGroup = inputModel.ProductGroup,
                        RealisedTotal = inputModel.RealisedTotal,
                        UnRealisedTotal = inputModel.UnRealisedTotal
                    };

                    CreateOrUpdateVesselSummary(vesselSummaryInput, loggedInContext, validationMessages);
                }
                else
                {
                    var importUniqurIdPiprLine = new List<BsonDocument>
                    {
                        new BsonDocument("$unwind",
                        new BsonDocument("path", "$DataJson.FormData.contractDetails")),
                        new BsonDocument("$addFields",
                        new BsonDocument("ProductGroup",
                        new BsonDocument("$toLower", "$DataJson.FormData.contractDetails.productGroup1"))),
                        new BsonDocument("$match",
                        new BsonDocument
                            {
                                { "IsArchived", false },
                                { "ProductGroup", inputModel.ProductGroup.ToLower() },
                                { "DataJson.FormData.contractDetails.contractUniqueId",
                        new BsonDocument
                                {
                                    { "$regex", inputModel.CompanyName.ToLower() },
                                    { "$options", "i" }
                                } }
                            }),
                        new BsonDocument("$project",
                        new BsonDocument
                            {
                                { "_id", 0 },
                                { "UniqueId", "$DataJson.FormData.contractDetails.contractUniqueId" }
                            })
                    };
                    var localUniqurIdPiprLine = new List<BsonDocument> {
                                new BsonDocument("$unwind",
                                new BsonDocument("path", "$DataJson.FormData")),
                                new BsonDocument("$addFields",
                                new BsonDocument("ProductGroup",
                                new BsonDocument("$toLower", "$DataJson.FormData.productGroup1"))),
                                new BsonDocument("$match",
                                new BsonDocument
                                    {
                                        { "IsArchived", false },
                                        { "ProductGroup", inputModel.ProductGroup.ToLower() },
                                        { "DataJson.FormData.uniqueIdLocal",
                                new BsonDocument
                                        {
                                            { "$regex", inputModel.CompanyName.ToLower() },
                                            { "$options", "i" }
                                        } }
                                    }),
                                new BsonDocument("$project",
                                new BsonDocument
                                    {
                                        { "_id", 0 },
                                        { "UniqueId", "$DataJson.FormData.uniqueIdLocal" }
                                    })
                };

                    var importIdList = datasetCollection.Aggregate<BsonDocument>(importUniqurIdPiprLine, aggregateOptions).ToList();
                    var localIdList = datasetCollection.Aggregate<BsonDocument>(localUniqurIdPiprLine, aggregateOptions).ToList();

                    List<VesselModel> vesselIds = new List<VesselModel>();

                    vesselIds.AddRange(BsonHelper.ConvertBsonDocumentListToModel<VesselModel>(importIdList));
                    vesselIds.AddRange(BsonHelper.ConvertBsonDocumentListToModel<VesselModel>(localIdList));

                    //foreach (string id in vesselIds)
                    //{

                    //}
                }
            }
        }

        public List<string> GetUniqueValidation(UniqueValidateModel dataSetUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                IMongoCollection<BsonDocument> dataSourceKeysCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
                IMongoCollection<BsonDocument> dataSetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var pipeline = new List<BsonDocument>
                { new BsonDocument("$match",new BsonDocument
                    {
                    {"DataSourceId", dataSetUpsertInputModel.FormId.ToString() },
                    {"IsArchived", false },
                    {"Unique", true }
                }),
                   new BsonDocument ( "$project", new BsonDocument { { "_id" , 0}, { "Key", 1}, { "Path", 1} })
                };
                var jsonObj = JObject.Parse(dataSetUpsertInputModel.DataJson);
                //var v2 = jsonObj.SelectToken("FormData.name");
                //var v3 = v2.GetType();
                //var str = v2 + "Hi";
                var resultSet = dataSourceKeysCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                if (resultSet != null && resultSet.Count > 0)
                {
                    var uniqeList = new List<string>();
                    var rs = BsonHelper.ConvertBsonDocumentListToModel<DataSourceKeysOutputModel>(resultSet).ToList();
                    foreach (var item in rs)
                    {
                        var paths = item.Path.Split(".");
                        if (paths.Length < 2)
                        {
                            var v1 = jsonObj.SelectToken($"{item.Path}").ToObject<dynamic>();//For direct field
                            if (v1 != null && v1 != "")
                            {
                                var pipeline1 = new List<BsonDocument>
                            { new BsonDocument("$match",new BsonDocument
                                {
                                { "DataSourceId", dataSetUpsertInputModel.FormId.ToString()},
                                {$"DataJson.FormData.{item.Path}", v1},
                                {"IsArchived", false }
                            }),
                               //new BsonDocument ( "$project", new BsonDocument { { "_id" , 0}, { "Key", 1 } })
                            };
                                if (dataSetUpsertInputModel.GenericFormSubmittedId != null && dataSetUpsertInputModel.GenericFormSubmittedId != Guid.Empty)
                                {
                                    pipeline1.Add(new BsonDocument("$match", new BsonDocument("_id", new BsonDocument("$ne", dataSetUpsertInputModel.GenericFormSubmittedId.ToString()))));
                                }
                                var dataSets = dataSetCollection.Aggregate<BsonDocument>(pipeline1, aggregateOptions).ToList().Count;
                                if (dataSets != null && dataSets > 0)
                                {
                                    uniqeList.Add(item.Key);
                                }
                            }
                        }
                        else
                        {
                            //var a = JsonConvert.DeserializeObject<BsonDocument>(dataSetUpsertInputModel.DataJson);
                            var obj = JsonConvert.DeserializeObject<ExpandoObject>((dynamic)dataSetUpsertInputModel.DataJson);
                            IDictionary<string, dynamic> newpath = FindPathsToKey(obj, item.Key);
                            //if (dataSetUpsertInputModel.GenericFormSubmittedId != null && dataSetUpsertInputModel.GenericFormSubmittedId != Guid.Empty)
                            //{  //checking for exisiting record


                            //}
                            //else //checking for new record
                            //{
                            //checking if duplciates found in submitted record
                            var lst = newpath.Values.ToList();
                            var repatedValues = lst.GroupBy(x => x)
                                          .Where(g => g.Count() > 1)
                                          .Select(y => y)
                                          .ToList();
                            if (repatedValues != null && repatedValues.Count > 0)
                            {
                                uniqeList.Add(item.Key);
                            }
                            //checking if duplicates are found in existing records based on submitted records
                            foreach (var prop in lst)
                            {
                                var v1 = prop;
                                if (v1 != null && v1 != "")
                                {
                                    var pipeline1 = new List<BsonDocument>
                                        { new BsonDocument("$match",new BsonDocument
                                            {
                                            { "DataSourceId", dataSetUpsertInputModel.FormId.ToString()},
                                            {$"DataJson.FormData.{item.Path}", v1},
                                            {"IsArchived", false }
                                        }),
                                           //new BsonDocument ( "$project", new BsonDocument { { "_id" , 0}, { "Key", 1 } })
                                        };
                                    if (dataSetUpsertInputModel.GenericFormSubmittedId != null && dataSetUpsertInputModel.GenericFormSubmittedId != Guid.Empty)
                                    {
                                        pipeline1.Add(new BsonDocument("$match", new BsonDocument("_id", new BsonDocument("$ne", dataSetUpsertInputModel.GenericFormSubmittedId.ToString()))));
                                    }
                                    var dataSets = dataSetCollection.Aggregate<BsonDocument>(pipeline1, aggregateOptions).ToList().Count;
                                    if (dataSets != null && dataSets > 0)
                                    {
                                        uniqeList.Add(item.Key);
                                    }
                                }
                            }
                            //}
                        }
                    }
                    return uniqeList; ;
                }
                else
                {
                    return new List<string>();
                }
            }
            catch (Exception e)
            {
                return null;
            }
        }
        private IDictionary<string, dynamic> FindPathsToKey(dynamic obj, string key, string pathToKey = null)
        {
            try
            {
                IDictionary<string, dynamic> results = new Dictionary<string, dynamic>();
                results = findKey(obj, key, results, pathToKey);
                return results;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        private IDictionary<string, dynamic> findKey(dynamic obj, string key, IDictionary<string, dynamic> results, string pathToKey = null)
        {
            try
            {
                var oldPath = $"{(pathToKey != null ? pathToKey + "." : "")}";
                var expandoDict = obj as IDictionary<string, object>;
                var dj = JsonConvert.SerializeObject(obj);
                var jsonObj = JObject.Parse(dj);
                //if (obj.GetProperty(key) != null)
                if (expandoDict.ContainsKey(key))
                {
                    //results.Add($"{oldPath}{key}", getValueFromObject(obj, $"{oldPath}{key}"));
                    //expandoDict[$"{oldPath}{key}"]
                    results.Add($"{oldPath}{key}", jsonObj.SelectToken($"{key}").ToObject<dynamic>());
                }
                var objType = obj.GetType();
                if (obj != null && !(obj is Array) && !(obj is JArray))
                {
                    // var props = ((dynamic)obj).GetDynamicMemberNames();
                    //foreach (PropertyInfo prop in obj.GetType().GetProperties())
                    foreach (KeyValuePair<string, dynamic> prop in obj)
                    {
                        //var k = obj.GetProperty(prop.Key);
                        var k = expandoDict.ContainsKey(prop.Key) ? prop.Key : null;
                        if (k != null && !k.Contains("lookupchilddata"))
                        {
                            dynamic val = expandoDict[k];
                            var valType = val?.GetType();
                            //if (prop.GetValue(obj, null) is Array || prop.GetValue(obj, null) is JArray)
                            if (val != null)
                            {
                                if (val is Array || val is JArray || valType?.Name?.Contains("List"))
                                {
                                    var valc = val.Count;
                                    for (int j = 0; j < val.Count; j++)
                                    {
                                        //findKey(obj[k][j], key, results, $"{oldPath}{k}[{j}]");
                                        findKey(((dynamic)expandoDict[k])[j], key, results, $"{oldPath}{k}[{j}]");
                                    }
                                }

                                //if (obj[k] != null && !(obj[k] is Array) && !(obj[k] is JArray))

                                if (expandoDict[k] != null && !(expandoDict[k] is Array) && !(expandoDict[k] is JArray) && expandoDict[k]?.GetType()?.Name == "ExpandoObject")
                                {
                                    findKey(expandoDict[k], key, results, $"{oldPath}{k}");
                                }
                                continue;
                            }
                        }
                    }
                }
                return results;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        public string GetQueryData(GetQueryDataInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetQueryData", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(inputModel.CollectionName);

                var query = BsonSerializer.Deserialize<BsonDocument[]>(inputModel.MongoQuery).ToList();
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                string resultJson = string.Empty;

                if (inputModel.IsQueryHeaders == true)
                {
                    try
                    {
                        var headerPipeline = new List<BsonDocument>
                    {
                        new BsonDocument("$sample", new BsonDocument("size", 1)), // Sample one document that matches the query
                        new BsonDocument("$project", new BsonDocument("_id", 0).Add("document", "$$ROOT")), // Store the document in a field called "document"
                        new BsonDocument("$project", new BsonDocument("columnNames", new BsonDocument("$objectToArray", "$document"))), // Convert document to array of key-value pairs
                        new BsonDocument("$unwind", "$columnNames"), // Unwind the array
                        new BsonDocument("$project", new BsonDocument
                        {
                            { "columnName", "$columnNames.k" }, // Extract the key (column name)
                            { "dataType", new BsonDocument("$type", "$columnNames.v") }, // Determine the data type
                            //{ "length", new BsonDocument("$cond", new BsonArray
                            //    {
                            //        new BsonDocument("$eq", new BsonArray { "$columnNames.v", BsonNull.Value }), // Check if the value is null
                            //        BsonNull.Value, // Return null if the value is null
                            //        new BsonDocument("$strLenCP", new BsonArray
                            //            {
                            //                new BsonDocument("$ifNull", new BsonArray { "$columnNames.v", "" }), // Convert the value to string using $ifNull
                            //            })
                            //        }
                            //    )
                            //}
                        })
                    };

                        query.AddRange(headerPipeline);
                        var result = datasetCollection.Aggregate<BsonDocument>(query, aggregateOptions).ToList();
                        var queryOutput = BsonHelper.ConvertBsonDocumentListToModel<ColumnInfo>(result).ToList();

                        List<HeadersOutputModel> headersOutputModels = new List<HeadersOutputModel>();
                        foreach (var data in queryOutput)
                        {
                            var headerModel = new HeadersOutputModel();
                            headerModel.Title = data.columnName;
                            headerModel.Field = data.columnName;
                            headerModel.ColumnName = data.columnName;
                            headerModel.ColumnAltName = data.columnName;
                            //System.Type tp = data.Value.GetType();
                            headerModel.ColumnType = data.dataType ?? "string";
                            headerModel.Filter = data.dataType ?? "string";
                            headersOutputModels.Add(headerModel);
                        }
                        resultJson = headersOutputModels.ToJson();
                    }
                    catch (MongoCommandException ex)
                    {
                        // Handle MongoDB command exceptions (e.g., query syntax errors)
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = formioModels.MessageTypeEnum.Error,
                            ValidationMessaage = ex.Message
                        });
                        return null;
                    }
                    catch (Exception ex)
                    {
                        // Handle other exceptions
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = formioModels.MessageTypeEnum.Error,
                            ValidationMessaage = ex.Message
                        });
                        return null;
                    }
                }
                else
                {
                    var result = datasetCollection.Aggregate<BsonDocument>(query, aggregateOptions).ToList();
                    if (result != null)
                    {
                        var dotNetObjList = result.ConvertAll(BsonTypeMapper.MapToDotNetValue);
                        resultJson = JsonConvert.SerializeObject(dotNetObjList);
                    }
                    else
                    {
                        resultJson = string.Empty;
                    }
                }

                return resultJson;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetQueryData", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetQueryData);
                return string.Empty;
            }
        }

        public List<string> GetCollections(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCollections", "DataSetRepository"));

                IMongoDatabase imongoDb = GetMongoDbConnection();
                var collections = imongoDb.ListCollectionNames().ToList();
                return collections;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCollections", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetQueryData);
                return new List<string>();

            }
        }

        public VesselDashboardOutputModel GetVesselDashboard(VesselDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetVesselDashboard", "DataSetRepository"));

            VesselDashboardOutputModel result = _dashboardRepositoryNew.GetVesselDashboard(inputModel, loggedInContext, validationMessages);
            return result;
        }
        public List<PositionData> GetPositionsDashboard(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetPositionsDashboard", "DataSetRepository"));

            List<PositionData> result = _dashboardRepositoryNew.GetPositionsDashboard(inputModel, loggedInContext, validationMessages)?.OrderBy(x => x.Id).ToList();
            return result;
        }
        public void UpdateYTDPandLHistory(PositionsDashboardInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateYTDPandLHistory", "DataSetRepository"));

            inputModel.FromDate = inputModel.FromDate == null ? new DateTime(DateTime.Now.Year, 1, 1) : inputModel.FromDate;
            inputModel.Todate = inputModel.Todate == null ? DateTime.Now.AddDays(-1) : inputModel.Todate;

            List<PositionData> result = _dashboardRepositoryNew.GetPositionsDashboard(inputModel, loggedInContext, validationMessages)?.OrderBy(x => x.Id).ToList();

            DateTime date = (DateTime)inputModel.Todate;
            foreach (PositionData data in result.Where(x => x.CommodityKey != null && !x.CommodityKey.Contains("TOTAL")))
            {
                try
                {
                    IMongoCollection<BsonDocument> mongoCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.YTDPandLHistory);
                    var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                    YTDPandLHistory pandLHistory = new YTDPandLHistory
                    {
                        CompanyName = data.CompanyName,
                        CommodityId = data.Id,
                        Name = data.CommodityKey,
                        DisplayName = data.Commodity,
                        YTDRealisedPAndL = data.YTDRealisedPAndL,
                        YTDUnRealisedPAndL = data.YTDUnRealisedPAndL,
                        YTDTotalPAndL = data.YTDTotalPAndL,
                        NetClosing = data.NetClosing,
                        Date = date.Date,
                        CreatedDateTime = DateTime.UtcNow,
                        UpdatedDateTime = DateTime.UtcNow,
                        IsArchived = false
                    };

                    var pipeline = new List<BsonDocument>
                                    {new BsonDocument("$match",new BsonDocument {
                                        {"CompanyName", pandLHistory.CompanyName },
                                        {"Name", pandLHistory.Name },
                                        {"CommodityId", pandLHistory.CommodityId },
                                        {"Date", pandLHistory.Date} }),
                                       new BsonDocument ( "$project", new BsonDocument { { "_id" , 1} })
                                    };

                    var resultSet = mongoCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).FirstOrDefault();

                    var collectionId = resultSet == null ? null : resultSet.TryGetValue("_id", out BsonValue Id) ? Id.ToString() : null;

                    if (!string.IsNullOrWhiteSpace(collectionId))
                    {
                        pandLHistory.Id = Guid.Parse(collectionId);
                        LoggingManager.Info("Updating record with Id - " + pandLHistory.Id.ToString() + " from " + MongoDBCollectionConstants.YTDPandLHistory + " Collection");

                        var update = new List<UpdateDefinition<BsonDocument>>
                        {
                            Builders<BsonDocument>.Update.Set("DisplayName", pandLHistory.DisplayName),
                            Builders<BsonDocument>.Update.Set("YTDRealisedPAndL", pandLHistory.YTDRealisedPAndL),
                            Builders<BsonDocument>.Update.Set("YTDUnRealisedPAndL", pandLHistory.YTDUnRealisedPAndL),
                            Builders<BsonDocument>.Update.Set("YTDTotalPAndL", pandLHistory.YTDTotalPAndL),
                            Builders<BsonDocument>.Update.Set("NetClosing", pandLHistory.NetClosing),
                            Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow)
                        };

                        var fBuilder = GetPandLUpdateFilter(pandLHistory, collectionId);
                        FilterDefinition<BsonDocument> filter = fBuilder;
                        var updateFields = Builders<BsonDocument>.Update.Combine(update);
                        mongoCollection.UpdateOne(filter: fBuilder, update: updateFields);
                    }
                    else
                    {
                        pandLHistory.Id = Guid.NewGuid();
                        LoggingManager.Info("Inserting new record with Id - " + pandLHistory.Id.ToString() + " into " + MongoDBCollectionConstants.YTDPandLHistory + " Collection");
                        pandLHistory.UpdatedDateTime = null;
                        mongoCollection.InsertOne(pandLHistory.ToBsonDocument());
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateYTDPandLHistory", "DataSetRepository"));
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateYTDPandLHistory", "DataSetRepository", exception));
                    SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionCreateDataSourceKeys);
                    continue;
                }
            }
        }
        public FilterDefinition<BsonDocument> GetPandLUpdateFilter(YTDPandLHistory inputModel, string id)
        {
            var fBuilder = Builders<BsonDocument>.Filter;
            return fBuilder.And(fBuilder.Eq("_id", id),
                         fBuilder.Eq("CompanyName", inputModel.CompanyName),
                         fBuilder.Eq("Name", inputModel.Name),
                         fBuilder.Eq("CommodityId", inputModel.CommodityId),
                         fBuilder.Eq("Date", inputModel.Date)
                         );
        }

        public List<GetCO2EmmisionReportOutputModel> GetCO2EmmisionReport(GetCO2EmmisionReportInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetCO2EmmisionReport", "DataSetRepository"));
                IMongoCollection<BsonDocument> datasetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                List<GetCO2EmmisionReportOutputModel> result = new List<GetCO2EmmisionReportOutputModel>();
                List<BsonDocument> pipeline = new List<BsonDocument>();

                pipeline = new List<BsonDocument>
                {
                    new BsonDocument("$match",
                        new BsonDocument("DataSourceId",
                            new BsonDocument("$in",
                                new BsonArray
                                {
                                    "8740609b-0c8d-43cc-8630-75cc33f2a22b",
                                    "f2aaf2c9-8a72-49ec-a146-5f6171ce18da",
                                    "f556f3e2-78fe-4fb8-a042-9f420a1f9b3c",
                                    "1212c03b-029a-4d56-a8db-6f71f99086a1",
                                    "ebce21a4-70c1-4195-9e1b-5b406d13b884",
                                    "23f416b2-b36d-49ea-9e83-f541d43493c8",
                                    "280b5845-53a6-4f67-9437-81aa7cbc6ad5",
                                    "fbcfb182-4cc2-47e4-8b79-2eefcb111a51",
                                    "6f0ddf27-15bd-492d-9fe9-92c4e74dbaed",
                                    "da9001a1-28ae-430b-95fd-b4f9794e8361",
                                    "afbbb3e5-ce25-4533-ba83-98730c01ddaf",
                                    "4274fc8d-e1a6-41c1-a8c1-b6ad3bfd5684",
                                    "1491d574-8f82-4615-a923-05bc632f5cca"
                                }))),
                    new BsonDocument("$addFields",
                        new BsonDocument
                        {
                            { "Source",
                                new BsonDocument("$switch",
                                    new BsonDocument
                                    {
                                        { "branches",
                                            new BsonArray
                                            {
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "8740609b-0c8d-43cc-8630-75cc33f2a22b"
                                                            }) },
                                                    { "then", "Stationary Combustion" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "f2aaf2c9-8a72-49ec-a146-5f6171ce18da"
                                                            }) },
                                                    { "then", "Mobile Sources" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "f556f3e2-78fe-4fb8-a042-9f420a1f9b3c"
                                                            }) },
                                                    { "then", "Refrigeration and AC" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "1212c03b-029a-4d56-a8db-6f71f99086a1"
                                                            }) },
                                                    { "then", "Fire Suppression" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "ebce21a4-70c1-4195-9e1b-5b406d13b884"
                                                            }) },
                                                    { "then", "Purchased Gases" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "23f416b2-b36d-49ea-9e83-f541d43493c8"
                                                            }) },
                                                    { "then", "Waste Gases" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "280b5845-53a6-4f67-9437-81aa7cbc6ad5"
                                                            }) },
                                                    { "then", "Electricity" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "fbcfb182-4cc2-47e4-8b79-2eefcb111a51"
                                                            }) },
                                                    { "then", "Steam" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "6f0ddf27-15bd-492d-9fe9-92c4e74dbaed"
                                                            }) },
                                                    { "then", "Business Travel" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "da9001a1-28ae-430b-95fd-b4f9794e8361"
                                                            }) },
                                                    { "then", "Commuting" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "afbbb3e5-ce25-4533-ba83-98730c01ddaf"
                                                            }) },
                                                    { "then", "Product Transport" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "4274fc8d-e1a6-41c1-a8c1-b6ad3bfd5684"
                                                            }) },
                                                    { "then", "RECs-Green Power" }
                                                },
                                                new BsonDocument
                                                {
                                                    { "case",
                                                        new BsonDocument("$eq",
                                                            new BsonArray
                                                            {
                                                                "$DataSourceId",
                                                                "1491d574-8f82-4615-a923-05bc632f5cca"
                                                            }) },
                                                    { "then", "Offsets" }
                                                }
                                            } },
                                        { "default", "Other" }
                                    }) },
                            { "EntryDate",
                                new BsonDocument("$dateFromString",
                                    new BsonDocument
                                    {
                                        { "dateString", "$DataJson.FormData.entryDate" },
                                        { "onError", BsonNull.Value },
                                        { "onNull", BsonNull.Value }
                                    }) },
                            { "CO2Emmission",
                                new BsonDocument("$toDecimal", "$DataJson.FormData.totalCo2EquivalentEmissionsMetricTons") }
                        })
                };

                if (inputModel?.FromDate != null && inputModel?.Todate != null)
                {
                    DateTime fromDate = inputModel.FromDate ?? DateTime.UtcNow;
                    DateTime toDate = inputModel.Todate ?? DateTime.UtcNow;
                    int fromDay = fromDate.Day;
                    int fromMonth = fromDate.Month;
                    int fromYear = fromDate.Year;
                    int toDay = toDate.Day;
                    int toMonth = toDate.Month;
                    int toYear = toDate.Year;

                    pipeline.Add(new BsonDocument("$match",
                                  new BsonDocument
                                  {
                                   { "EntryDate", new BsonDocument
                                      {
                                          { "$gte", BsonDateTime.Create(new DateTime(fromYear, fromMonth, fromDay, 0, 0, 0)) },
                                          { "$lte", BsonDateTime.Create(new DateTime(toYear, toMonth, toDay, 23, 59, 59)) }
                                      }
                                   }
                    }));
                }

                pipeline.AddRange(new List<BsonDocument>
                {
                    new BsonDocument("$group",
                        new BsonDocument
                        {
                            { "_id", "$Source" },
                            { "CO2Emmission",
                                new BsonDocument("$sum", "$CO2Emmission") }
                        }),
                    new BsonDocument("$sort",
                        new BsonDocument("CO2Emmission", 1)),
                    new BsonDocument("$project",
                        new BsonDocument
                        {
                            { "_id", 0 },
                            { "Source","$_id"},
                            { "TotalCO2Emission",
                                new BsonDocument("$round",
                                    new BsonArray
                                    {
                                        "$CO2Emmission",
                                        3
                                    }) }
                        })
                });
                var sourceDataSet = datasetCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                result = BsonHelper.ConvertBsonDocumentListToModel<GetCO2EmmisionReportOutputModel>(sourceDataSet).ToList();

                return result;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetCO2EmmisionReport", "DataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetQueryData);
                return new List<GetCO2EmmisionReportOutputModel>();
            }
        }

        public void FieldUpdateWorkFlow(FieldUpdateWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FieldUpdateWorkFlow", "DataSetService"));

            IMongoCollection<BsonDocument> datsetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
            IMongoCollection<BsonDocument> datsourceKeysCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
            AggregateOptions aggregateOptions = new AggregateOptions() { AllowDiskUse = true };

            string uniqueKey = inputModel.FieldUniqueId;
            List<string> syncFormIds = inputModel.FieldUpdateModel.Where(x => x.SyncForm != null).Select(x => x.SyncForm.ToString()).Distinct().ToList();
            List<string> formkeys = inputModel.FieldUpdateModel.Where(x => !string.IsNullOrWhiteSpace(x.FieldName))
                                                      .Select(x => x.FieldName).ToList();
            formkeys.Add(uniqueKey);
            string formId = inputModel.FieldUpdateModel.Where(x => x.FormId != null).Select(x => x.FormId).FirstOrDefault().ToString();
            string dataSetId = inputModel.DataSetId.ToString();
            string uniquekeypath = uniqueKey;

            List<BsonDocument> keysPipeline = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId", formId },
                        { "Key",
                new BsonDocument("$in",
                new BsonArray(formkeys))},
                        { "IsArchived", false }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 1 },
                        { "Key", 1 },
                        { "Type", 1 },
                        { "Path", 1 }
                    })
            };
            var keysData = datsourceKeysCollection.Aggregate<BsonDocument>(keysPipeline, aggregateOptions).ToList();
            List<FormKeysModel> KeyList = BsonHelper.ConvertBsonDocumentListToModel<FormKeysModel>(keysData);

            List<BsonDocument> unwindStage = new List<BsonDocument>();
            BsonDocument test = new BsonDocument { { "_id", 1 }, };
            if (formkeys.Count > 0)
            {
                foreach (FormKeysModel keys in KeyList)
                {
                    try
                    {
                        if (keys.Key == uniqueKey)
                            uniquekeypath = keys.Path ?? uniquekeypath;

                        var path = keys.Path.Split('.');
                        if (path != null && path.Length > 1)
                        {
                            foreach (string data in path)
                            {
                                if (data != null && data != keys.Key)
                                    unwindStage.Add(new BsonDocument("$unwind",
                                           new BsonDocument("path", $"$DataJson.FormData.{data}")));
                            }
                            test.Add(keys.Key, $"$DataJson.FormData.{keys.Path}");
                        }
                        else
                            test.Add(keys.Key, $"$DataJson.FormData.{keys.Key}");
                    }
                    catch (Exception e)
                    {
                        LoggingManager.Error("Field Upddate workflow throw error while fetching key value - " + e);
                    }
                }
            }

            List<BsonDocument> formPipeline = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument("_id", dataSetId)),
            };
            formPipeline.AddRange(unwindStage);
            formPipeline.Add(new BsonDocument("$project", test));

            var resultSet = datsetCollection.Aggregate<BsonDocument>(formPipeline, aggregateOptions).FirstOrDefault();
            if (resultSet != null)
            {
                var uniqueKeyValue = resultSet.TryGetValue(uniqueKey, out BsonValue bson) ? bson.ToString() : null;
                if (!string.IsNullOrWhiteSpace(uniqueKeyValue))
                {
                    List<BsonDocument> syncFormPipeline = new List<BsonDocument>
                    {
                        new BsonDocument("$match",
                        new BsonDocument
                            {
                                { "DataSourceId", new BsonDocument("$in", new BsonArray(syncFormIds))},
                                //{ "DataJson.FormData." + uniquekeypath, uniqueKeyValue },
                                { "$and", new BsonArray {
                                                    new BsonDocument("$expr",
                                                    new BsonDocument("$eq",
                                                    new BsonArray
                                                            {
                                                                new BsonDocument("$toString", "$DataJson.FormData." + uniquekeypath),
                                                                uniqueKeyValue
                                                            }))
                                 } },
                                { "IsArchived", false }
                            }),
                        new BsonDocument("$project",
                        new BsonDocument("_id", 1))
                    };
                    var syncformData = datsetCollection.Aggregate<BsonDocument>(syncFormPipeline, aggregateOptions).ToList();
                    List<SyncFormModel> syncFormDataSetId = BsonHelper.ConvertBsonDocumentListToModel<SyncFormModel>(syncformData);

                    if (syncFormDataSetId != null && syncFormDataSetId.Count > 0)
                    {
                        var updateOptions = new UpdateOptions
                        {
                            IsUpsert = true // This option ensures that the document is created if it doesn't exist, and updated if it does
                        };

                        foreach (var syncForm in syncFormDataSetId)
                        {
                            try
                            {
                                var currentUtcTime = DateTime.UtcNow;
                                var update = new List<UpdateDefinition<BsonDocument>>
                                {
                                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
                                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString())
                                };

                                foreach (FormKeysModel keys in KeyList.Where(x => x.Key != uniqueKey))
                                {
                                    string formKeyPath = !string.IsNullOrWhiteSpace(keys.Path) ? keys.Path : keys.Key;
                                    string givenValue = inputModel.FieldUpdateModel.Where(x => x.FieldName == keys.Key).Select(x => x.FieldValue).FirstOrDefault();
                                    object formkeyValue = resultSet.TryGetValue(keys.Key, out BsonValue bsonValue) ? bsonValue.ToString() : null;

                                    if (keys.Type != null)
                                    {
                                        if (keys.Type == "number")
                                        {
                                            formkeyValue = formkeyValue != null && formkeyValue.ToString().Contains(".")
                                                                   ? (object)Convert.ToDouble(formkeyValue)
                                                                   : (object)Convert.ToInt32(formkeyValue);
                                        }
                                    }

                                    formkeyValue = !string.IsNullOrWhiteSpace(givenValue) ? givenValue : formkeyValue;
                                    update.Add(Builders<BsonDocument>.Update.Set($"DataJson.FormData.{formKeyPath}", formkeyValue));
                                }
                                var updateFields = Builders<BsonDocument>.Update.Combine(update);
                                var filterObject = GetUpdateDataSourceById(syncForm.Id, loggedInContext);
                                datsetCollection.UpdateOne(filter: filterObject, update: updateFields, updateOptions);
                            }
                            catch (Exception e)
                            {
                                LoggingManager.Error("Fields workflow throws error while updating data in the form with form Id : " + syncForm.Id.ToString() + " error : " + e);
                            }
                        }
                    }
                }
            }
        }

        public void UpdateDataSetWorkFlow(UpdateDataSetWorkFlowModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSetWorkFlow", "DataSetService"));

            IMongoCollection<BsonDocument> datsetCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSet);
            IMongoCollection<BsonDocument> datsourceKeysCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DataSourceKeys);
            AggregateOptions aggregateOptions = new AggregateOptions() { AllowDiskUse = true };

            List<string> mainformKeys = inputModel.KeyValueList.Select(x => x.Value.Replace("$", "")).ToList();
            List<string> subformKeys = inputModel.KeyValueList.Select(x => x.Key).ToList();
            string mainFormId = inputModel.DataSourceId.ToString();
            string subFormId = inputModel.NewRecordDataSourceId.ToString();
            string mainFormDataSetId = inputModel.DataSetId.ToString();
            Guid? subFormDataSetId = inputModel.NewRecordDataSetId;

            List<BsonDocument> mainKeysPipeline = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId", mainFormId },
                        { "Key",
                new BsonDocument("$in",
                new BsonArray(mainformKeys))},
                        { "IsArchived", false }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 1 },
                        { "Key", 1 },
                        { "Type", 1 },
                        { "Path", 1 }
                    })
            };
            var mainKeysData = datsourceKeysCollection.Aggregate<BsonDocument>(mainKeysPipeline, aggregateOptions).ToList();
            List<FormKeysModel> mainKeyList = BsonHelper.ConvertBsonDocumentListToModel<FormKeysModel>(mainKeysData);

            List<BsonDocument> subKeysPipeline = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument
                    {
                        { "DataSourceId", subFormId },
                        { "Key",
                new BsonDocument("$in",
                new BsonArray(subformKeys))},
                        { "IsArchived", false }
                    }),
                new BsonDocument("$project",
                new BsonDocument
                    {
                        { "_id", 1 },
                        { "Key", 1 },
                        { "Type", 1 },
                        { "Path", 1 }
                    })
            };
            var subKeysData = datsourceKeysCollection.Aggregate<BsonDocument>(subKeysPipeline, aggregateOptions).ToList();
            List<FormKeysModel> subKeyList = BsonHelper.ConvertBsonDocumentListToModel<FormKeysModel>(subKeysData);

            List<BsonDocument> unwindStage = new List<BsonDocument>();
            BsonDocument projectStage = new BsonDocument { { "_id", 1 }, };
            if (mainKeyList.Count > 0)
            {
                foreach (FormKeysModel keys in mainKeyList)
                {
                    try
                    {
                        if (keys.Path != null && keys.Path.Contains("."))
                        {
                            var path = keys.Path.Split('.');
                            if (path != null && path.Length > 1)
                            {
                                foreach (string data in path)
                                {
                                    if (data != null && data != keys.Key)
                                        unwindStage.Add(new BsonDocument("$unwind",
                                               new BsonDocument("path", $"$DataJson.FormData.{data}")));
                                }
                                projectStage.Add(keys.Key, $"$DataJson.FormData.{keys.Path}");
                            }
                            else
                                projectStage.Add(keys.Key, $"$DataJson.FormData.{keys.Key}");
                        }
                        else
                        {
                            projectStage.Add(keys.Key, $"$DataJson.FormData.{keys.Key}");
                        }

                    }
                    catch (Exception e)
                    {
                        LoggingManager.Error("Upddate workflow throw error while fetching key value - " + e);
                    }
                }
            }

            List<BsonDocument> formPipeline = new List<BsonDocument>
            {
                new BsonDocument("$match",
                new BsonDocument("_id", mainFormDataSetId)),
            };
            formPipeline.AddRange(unwindStage);
            formPipeline.Add(new BsonDocument("$project", projectStage));

            var resultSet = datsetCollection.Aggregate<BsonDocument>(formPipeline, aggregateOptions).FirstOrDefault();

            if (resultSet != null && subFormDataSetId != null && subFormDataSetId != Guid.Empty)
            {
                var updateOptions = new UpdateOptions
                {
                    IsUpsert = true // This option ensures that the document is created if it doesn't exist, and updated if it does
                };

                try
                {
                    var currentUtcTime = DateTime.UtcNow;

                    // Updating create details foe new record workflow
                    var update = new List<UpdateDefinition<BsonDocument>>
                                {
                                    Builders<BsonDocument>.Update.Set("CreatedDateTime", currentUtcTime),
                                    Builders<BsonDocument>.Update.Set("CreatedByUserId", loggedInContext.LoggedInUserId.ToString())
                                };

                    foreach (FormKeysModel keys in subKeyList)
                    {
                        string formKeyPath = !string.IsNullOrWhiteSpace(keys.Path) ? keys.Path : keys.Key;
                        string sourceKey = inputModel.KeyValueList.FirstOrDefault(x => x.Key == keys.Key).Value.Replace("$", "");
                        object formkeyValue = resultSet.TryGetValue(sourceKey, out BsonValue bsonValue) ? bsonValue.ToString() : null;

                        if (keys.Type != null)
                        {
                            if (keys.Type == "number")
                            {
                                formkeyValue = formkeyValue != null && formkeyValue.ToString().Contains(".")
                                                       ? (object)Convert.ToDouble(formkeyValue)
                                                       : (object)Convert.ToInt32(formkeyValue);
                            }
                        }
                        update.Add(Builders<BsonDocument>.Update.Set($"DataJson.FormData.{formKeyPath}", formkeyValue));
                    }
                    var updateFields = Builders<BsonDocument>.Update.Combine(update);
                    var filterObject = GetUpdateDataSourceById(subFormDataSetId ?? Guid.Empty, loggedInContext);
                    datsetCollection.UpdateOne(filter: filterObject, update: updateFields, updateOptions);
                }
                catch (Exception e)
                {
                    LoggingManager.Error("Fields workflow throws error while updating data in the form with form Id : " + subFormDataSetId.ToString() + " error : " + e);
                }
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