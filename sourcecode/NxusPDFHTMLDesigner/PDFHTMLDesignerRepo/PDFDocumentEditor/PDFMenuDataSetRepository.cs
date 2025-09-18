using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Driver;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel;
using PDFHTMLDesignerModels.DocumentOutputModel;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerModels.SFDTParameterModel;
using PDFHTMLDesignerRepo.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDFHTMLDesignerRepo.PDFDataSet
{
    public class PDFMenuDataSetRepository : IPDFMenuDataSetRepository
    {

        //IConfiguration _iconfiguration;
        //public PDFMenuDataSetRepository(IConfiguration iConfiguration)
        //{
        //    _iconfiguration = iConfiguration;
        //}
        //Guid? IPDFMenuDataSetRepository.CreatePDFMenuDataSet(PDFDatasetInputModel pdfdatasetInputModel, string commodityName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    throw new NotImplementedException();
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

        //public List<PDFDesignerDatasetOutputModel> GetAllPDFMenuDataSet(string TemplateId , LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.PDFDesignerMenuDataSetCollection);
        //        var fBuilder = Builders<BsonDocument>.Filter;
        //        var filterObject = fBuilder.Eq("TemplateId", TemplateId);
        //        filterObject &= fBuilder.Eq("Archive", false);
        //        var documents = dataCollection.Find(filter: filterObject).ToList();
                
        //        var pdfoutput = BsonHelper.ConvertBsonDocumentListToModel<PDFDesignerDatasetOutputModel>(documents);

        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository"));
        //        return pdfoutput;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchPDFMenuDataSet", "PDFMenuDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}

        //public List<DataSetMenuModel> GetSelectedMenu(string InputFilterQuery, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        //{
        //    try
        //    {
        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetSelectedMenu", "PDFMenuDataSetRepository"));
        //        IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.MenuDataSetCollection);
        //        var filter = //new BsonArray { InputFilterQuery };
        //           new BsonArray
        //        {
        //            new BsonDocument("DataJson.FormData.contractNumber", "ANA-2022-S0195 DT. 4/10/22"),
        //            new BsonDocument("DataJson.FormData.dataGrid.invoiceNumber", "ANA-2022-B0067")
        //        };
        //        var matchStage = new BsonDocument("$match", new BsonDocument("$and", new BsonArray(filter)));
        //        var stages = new List<BsonDocument>();
        //        stages.Add(matchStage);
        //        var pipeline = stages;
        //        var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
        //        var aggregateDataList = dataCollection.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
        //        var pdfoutput = BsonHelper.ConvertBsonDocumentListToModel<DataSetMenuModel>(aggregateDataList);

        //        LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetSelectedMenu", "PDFMenuDataSetRepository"));
        //        return pdfoutput;
        //    }
        //    catch (Exception exception)
        //    {
        //        LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSelectedMenu", "PDFMenuDataSetRepository", exception.Message), exception);
        //        return null;
        //    }
        //}
    }
}
