using Microsoft.Extensions.Configuration;
using Models.DeletePDFHTMLDesigner;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.HTMLDocumentEditorModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerRepo.Helpers;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace PDFHTMLDesignerRepo.HTMLDataSet
{
    public class HTMLDataSetRepository : IHTMLDataSetRepository
    {

        //IConfiguration _iconfiguration;
        //public HTMLDataSetRepository(IConfiguration iConfiguration)
        //{
        //    _iconfiguration = iConfiguration;
        //}
        //protected IMongoDatabase GetMongoDbConnection()
        //{
        //    MongoClient client = new MongoClient(_iconfiguration["MongoDBConnectionString"]);
        //    return client.GetDatabase(_iconfiguration["MongoCommunicatorDB"]);
        //}
        //protected IMongoCollection<T> GetMongoCollectionObject<T>(string collectionName)
        //{
        //    IMongoDatabase imongoDb = GetMongoDbConnection();
        //    return imongoDb.GetCollection<T>(collectionName);
        //}

        //public HTMLDatasetOutputModel InsertHTMLDataSet(HTMLDatasetInputModel htmlDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertHTMLDataSet", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
        //        fileCollections.InsertOne(htmlDatasetInputModel.ToBsonDocument());

        //        var documents = fileCollections.Find(new BsonDocument()).ToList();
        //        var output = BsonHelper.ConvertBsonDocumentListToModel<HTMLDatasetInputModel>(documents);
        //        var filteredResult = output.AsQueryable<HTMLDatasetInputModel>().LastOrDefault();
        //        HTMLDatasetOutputModel hTMLDatasetOutput = new HTMLDatasetOutputModel();
        //        hTMLDatasetOutput._id = htmlDatasetInputModel._id;
        //        hTMLDatasetOutput.HTMLFile = htmlDatasetInputModel.HTMLFile;
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertHTMLDataSet", "HTMLDataSetRepository"));
        //        return hTMLDatasetOutput;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertHTMLDataSet", "HTMLDataSetRepository", exception.Message), exception);
        //        validationMessages.Add(new ValidationMessage
        //        {
        //            ValidationMessageType = MessageTypeEnum.Error,
        //            ValidationMessaage = ValidationMessages.FileIdNotExists
        //        });
        //        return null;
        //    }
        //}

        //public string UpdateHTMLDataSetById(HTMLDatasetEditModel inputModel, string HTMLFile, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository"));

        //        IMongoCollection<BsonDocument> htmlDatasetCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
        //        var currentUtcTime = DateTime.UtcNow;

        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("_id", inputModel._id.ToString());
        //        filterObject &= fBuilder.Eq("IsArchived", false);
        //        var unixDateTime = DateTimeOffset.Now.ToUnixTimeMilliseconds();
        //        string filename = inputModel.FileName;
        //        string filepath = null;
        //        var updateList = new List<UpdateDefinition<BsonDocument>>
        //        {
        //            Builders<BsonDocument>.Update.Set("FileId", "Getting_Started_" + inputModel._id),
        //            Builders<BsonDocument>.Update.Set("FileExtension", ".html"),
        //            Builders<BsonDocument>.Update.Set("FileName", filename),
        //            Builders<BsonDocument>.Update.Set("FilePath", filepath),
        //            Builders<BsonDocument>.Update.Set("FileSize", 84827),
        //            Builders<BsonDocument>.Update.Set("Description", inputModel._id + filename + unixDateTime),
        //            Builders<BsonDocument>.Update.Set("HTMLFile", HTMLFile),
        //            Builders<BsonDocument>.Update.Set("UpdatedDateTime", currentUtcTime),
        //            Builders<BsonDocument>.Update.Set("DataSources", inputModel.DataSources),
        //            Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId.ToString()),
        //        };

        //        var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

        //        UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

        //        if (result == null || result.ModifiedCount < 1)
        //        {
        //            validationMessages.Add(new ValidationMessage
        //            {
        //                ValidationMessageType = MessageTypeEnum.Error,
        //                ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
        //            });
        //            return null;
        //        }

        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository"));
        //        return inputModel._id;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}


        //public Guid? RemoveHTMLDataSetById(RemoveByIdInputModel removeById, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> htmlDatasetCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);

        //        var currentUtcTime = DateTime.UtcNow;

        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("_id", removeById._id.ToString());
        //        filterObject &= fBuilder.Eq("IsArchived", removeById.status);
                
        //        if (removeById.status == false)
        //        {
        //            var updateList = new List<UpdateDefinition<BsonDocument>>
        //        {
        //            Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
        //            Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
        //            Builders<BsonDocument>.Update.Set("IsArchived", true),
        //            Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow),
        //            Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
        //        };
        //            var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

        //            UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

        //            if (result == null || result.ModifiedCount < 1)
        //            {
        //                validationMessages.Add(new ValidationMessage
        //                {
        //                    ValidationMessageType = MessageTypeEnum.Error,
        //                    ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
        //                });
        //                return null;
        //            }
        //            else
        //            {
        //                return removeById._id;
        //            }
        //        }
        //        else if(removeById.status == true)
        //        {
        //            var updateList = new List<UpdateDefinition<BsonDocument>>
        //        {
        //            Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
        //            Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
        //            Builders<BsonDocument>.Update.Set("IsArchived", false),
                    
        //        };
        //            var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

        //            UpdateResult result = htmlDatasetCollections.UpdateOne(filter: filterObject, update: updateObject);

        //            if (result == null || result.ModifiedCount < 1)
        //            {
        //                validationMessages.Add(new ValidationMessage
        //                {
        //                    ValidationMessageType = MessageTypeEnum.Error,
        //                    ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
        //                });
        //                return null;
        //            }
        //            else 
        //            {
        //                return removeById._id;
        //            }

        //        }
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository"));
        //        return removeById._id;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RemoveHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
        //        validationMessages.Add(new ValidationMessage
        //        {
        //            ValidationMessageType = MessageTypeEnum.Error,
        //            ValidationMessaage = ValidationMessages.FileIdNotExists
        //        });
        //        return null;
        //    }
        //}

        //public List<TemplateOutputModel> GetHTMLDataSetById(Guid id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
        //        var currentUtcTime = DateTime.UtcNow;

        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("IsArchived", false);
        //        filterObject &= fBuilder.Eq("IsArchived", false);
        //        filterObject &= fBuilder.Eq("_id", id);
        //        //List<HTMLDatasetInputModel> filteredResult = dataCollection.AsQueryable<HTMLDatasetInputModel>().Where(p => p._id == id).ToList();
        //        var documents = dataCollection.Find(filter: filterObject).ToList();
        //        var htmloutput = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(documents);
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetHTMLDataSetById", "HTMLDataSetRepository"));
        //        return htmloutput;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetHTMLDataSetById", "HTMLDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}

        //public List<TemplateOutputModel> GetAllHTMLDataSet(bool IsArchived, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllHTMLDataSet", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.HTMLDataSetCollection);
        //        var currentUtcTime = DateTime.UtcNow;

        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("IsArchived", IsArchived);
        //        filterObject &= fBuilder.Eq("IsArchived", IsArchived);
        //        var documents = dataCollection.Find(filter: filterObject).ToList();
        //        var htmloutput = BsonHelper.ConvertBsonDocumentListToModel<TemplateOutputModel>(documents);

        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllHTMLDataSet", "HTMLDataSetRepository"));
        //        return htmloutput;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllHTMLDataSet", "HTMLDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}

        //public string SaveDataSource(DataSourceDetailsInputModel dataSourceDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveDataSource", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.MenuDataSetCollection);

        //        var query = BsonSerializer.Deserialize<BsonDocument[]>(dataSourceDetailsInputModel.DataSourceMongoQuery.MongoQueryWithDummyValues).ToList();

        //        var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
        //        var result = dataCollection.Aggregate<BsonDocument>(query, aggregateOptions).FirstOrDefault();
        //        string resultJson = result.ToJson();
        //        //var result = dataCollection.Find(query).ToList();

        //        return resultJson;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveDataSource", "HTMLDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}

        //public string SaveMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SaveMenuDataSet", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PDFDesignerMenuDataSetCollection);
        //        dataCollection.InsertOne(menuDatasetInputModel.ToBsonDocument());

        //        var documents = dataCollection.Find(new BsonDocument()).ToList();
        //        var output = BsonHelper.ConvertBsonDocumentListToModel<MenuDatasetInputModel>(documents);
        //        var filteredResult = output.AsQueryable<MenuDatasetInputModel>().LastOrDefault();
        //        HTMLDatasetOutputModel hTMLDatasetOutput = new HTMLDatasetOutputModel();
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SaveMenuDataSet", "HTMLDataSetRepository"));
        //        return menuDatasetInputModel.DataSource;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SaveMenuDataSet", "HTMLDataSetRepository", exception.Message), exception);
        //        validationMessages.Add(new ValidationMessage
        //        {
        //            ValidationMessageType = MessageTypeEnum.Error,
        //            ValidationMessaage = ValidationMessages.FileIdNotExists
        //        });
        //        return null;
        //    }
        //}

        //public string UpdateMenuDataSet(MenuDatasetInputModel menuDatasetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateDataSet", "HTMLDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PDFDesignerMenuDataSetCollection);
        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("_id", menuDatasetInputModel._id.ToString());
        //        var updateList = new List<UpdateDefinition<BsonDocument>>
        //        {
        //            Builders<BsonDocument>.Update.Set("MongoResult",   menuDatasetInputModel.MongoResult),
        //            Builders<BsonDocument>.Update.Set("TemplateId", menuDatasetInputModel.TemplateId),
        //            Builders<BsonDocument>.Update.Set("DataSource", menuDatasetInputModel.DataSource),
        //            Builders<BsonDocument>.Update.Set("MongoQuery", menuDatasetInputModel.MongoQuery),
        //            Builders<BsonDocument>.Update.Set("MongoParamsType", menuDatasetInputModel.MongoParamsType),
        //            Builders<BsonDocument>.Update.Set("MongoDummyParams", menuDatasetInputModel.MongoDummyParams),
        //            Builders<BsonDocument>.Update.Set("UpdatedByUserId", menuDatasetInputModel.UpdatedByUserId),
        //            Builders<BsonDocument>.Update.Set("UpdatedDateTime", menuDatasetInputModel.UpdatedDateTime),
        //            Builders<BsonDocument>.Update.Set("Archive", menuDatasetInputModel.Archive),

        //        };

        //        var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

        //        UpdateResult result = dataCollection.UpdateOne(filter: filterObject, update: updateObject);

        //        if (result == null || result.ModifiedCount < 1)
        //        {
        //            validationMessages.Add(new ValidationMessage
        //            {
        //                ValidationMessageType = MessageTypeEnum.Error,
        //                ValidationMessaage = ValidationMessages.ExceptionUpdateDataSet
        //            });
        //            return null;
        //        }


        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateMenuDataSet", "HTMLDataSetRepository"));
        //        return menuDatasetInputModel.DataSource;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateMenuDataSet", "HTMLDataSetRepository", exception.Message), exception);
        //        validationMessages.Add(new ValidationMessage
        //        {
        //            ValidationMessageType = MessageTypeEnum.Error,
        //            ValidationMessaage = ValidationMessages.FileIdNotExists
        //        });
        //        return null;
        //    }
        //}

        //private static void OnOutputDataRecived(object sender, DataReceivedEventArgs e)
        //{
        //    //do something with your data
        //    Console.WriteLine(e.Data);
        //}

        ////Handle the error
        //private static void OnErrorDataReceived(object sender, DataReceivedEventArgs e)
        //{
        //    Console.WriteLine(e.Data);
        //}


    }
}
