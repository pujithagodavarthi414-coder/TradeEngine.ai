using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Bson.IO;
using MongoDB.Bson.Serialization;
using MongoDB.Driver;
using PDFHTMLDesignerCommon.Constants;
using PDFHTMLDesignerModels;
using PDFHTMLDesignerModels.DocumentModel.file;
using PDFHTMLDesignerModels.PDFDocumentEditorModel;
using PDFHTMLDesignerRepo.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static MongoDB.Bson.Serialization.Serializers.SerializerHelper;

namespace PDFHTMLDesignerRepo.FileDataSet
{
    public class FileDataSetRepository : IFileDataSetRepository
    {
        IConfiguration _iconfiguration;
        public FileDataSetRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
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

        public List<FileDatasetOutputModel> GetAllFileDataSet(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AllFileDataSet", "FileDataSetRepository"));
                IMongoCollection<BsonDocument> dataCollection = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FileDataSetCollection);
                var documents = dataCollection.Find(new BsonDocument()).ToList();
                var output = BsonHelper.ConvertBsonDocumentListToModel<FileDatasetOutputModel>(documents);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AllFileDataSet", "FileDataSetRepository"));
                return output;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AllFileDataSet", "FileDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public List<FileDatasetOutputModel> GetFileDataSetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "FileDataSetById", "FileDataSetRepository"));
                IMongoCollection<FileDatasetOutputModel> dataCollection = GetMongoCollectionObject<FileDatasetOutputModel>(MongoDBCollectionConstants.FileDataSetCollection);
                List<FileDatasetOutputModel> filteredResult = dataCollection.AsQueryable<FileDatasetOutputModel>().Where(p => p._id == id).ToList();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "FileDataSetById", "FileDataSetRepository"));
                return filteredResult;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FileDataSetById", "FileDataSetRepository", exception.Message), exception);
                return null;
            }
        }

        public FileDatasetOutputModel InsertFileDataSet(FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "InsertFileDataSet", "FileRepository"));
                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FileDataSetCollection);
                fileCollections.InsertOne(fileInputModel.ToBsonDocument());
                
                var documents = fileCollections.Find(new BsonDocument()).ToList();
                var output = BsonHelper.ConvertBsonDocumentListToModel<FileDatasetOutputModel>(documents);
                var filteredResult = output.AsQueryable<FileDatasetOutputModel>().LastOrDefault();
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "InsertFileDataSet", "FileDataSetRepository"));
                return filteredResult;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertFileDataSet", "FileDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }
        
        public string ArchiveFileById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "FileDataSetRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FileDataSetCollection);

                var documents = fileCollections.Find(new BsonDocument()).ToList();
                var output = BsonHelper.ConvertBsonDocumentListToModel<FileDatasetOutputModel>(documents);
                var filteredResult = output.AsQueryable().Where(p => p._id == id).FirstOrDefault();
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("ArchivedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "FileDataSetRepository"));
                return id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "FileDataSetRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.FileIdNotExists
                });
                return null;
            }
        }

        public async Task<object> DeleteFileDatasetById(string id, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFileDatasetById", "FileDataSetRepository"));
            IMongoCollection<FileDatasetOutputModel> FileCollections = GetMongoCollectionObject<FileDatasetOutputModel>(MongoDBCollectionConstants.FileDataSetCollection);
            List<FileDatasetOutputModel> filteredResult = FileCollections.AsQueryable<FileDatasetOutputModel>().Where(p => p._id == id).ToList();

            DeleteByIdResponse responce = new DeleteByIdResponse();
            try
            {
                var Result = await FileCollections.DeleteOneAsync(x => x._id == id);
                if (Result.DeletedCount != 0)
                {
                    responce.IsSuccess = true;
                    responce.Massage = "Delete Record Successfully By Id";
                    return responce;
                }
                else
                {
                    responce.IsSuccess = false;
                    responce.Massage = "Data not found in Collection, please Enter Valid id";
                    return responce;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFileDatasetById", "FileDataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionGetDataSetsById);
                return null;
            }
        }

        public string UpdateFileDataSet(string id, FileDatasetInputModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFileDataSet", "FileDataSetRepository"));
                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FileDataSetCollection);
               
                var documents = fileCollections.Find(new BsonDocument()).ToList();
                var output = BsonHelper.ConvertBsonDocumentListToModel<FileDatasetOutputModel>(documents);
                var filteredResult = output.AsQueryable().Where(p => p._id == id).FirstOrDefault();
                //var filterset = Builders<FileDatasetOutputModel>.Filter.Eq(x => x._id, id);
                var updateList = new List<UpdateDefinition<BsonDocument>>();
   
                foreach (var dataSFDT in fileInputModel.SFDTFile)
                {
                    updateList = new List<UpdateDefinition<BsonDocument>>
                    {
                        Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                        Builders<BsonDocument>.Update.Set("folderId",fileInputModel.FolderId),
                        Builders<BsonDocument>.Update.Set("storeId",fileInputModel.StoreId),
                        Builders<BsonDocument>.Update.Set("referenceId",fileInputModel.ReferenceId),
                        Builders<BsonDocument>.Update.Set("referenceTypeId",fileInputModel.ReferenceTypeId),
                        Builders<BsonDocument>.Update.Set("referenceTypeName",fileInputModel.ReferenceTypeName),

                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].UpdatedByUserId", loggedInContext.LoggedInUserId),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileType", dataSFDT.FileType),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileId", dataSFDT.FileId),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileName", dataSFDT.FileName),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileSize", dataSFDT.FileSize),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].filePath", dataSFDT.FilePath),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].description", dataSFDT.Description),
                        Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileExtension", dataSFDT.FileExtension),

                        Builders<BsonDocument>.Update.Set("HTMLFile.$[].UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("HTMLFile.$[].UpdatedByUserId", loggedInContext.LoggedInUserId),

                        Builders<BsonDocument>.Update.Set("PDFFile.$[].UpdatedDateTime", DateTime.UtcNow),
                        Builders<BsonDocument>.Update.Set("PDFFile.$[].UpdatedByUserId", loggedInContext.LoggedInUserId),
                    };

                    updateList.Add(Builders<BsonDocument>.Update.Set("folderId", fileInputModel.FolderId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("storeId", fileInputModel.StoreId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("referenceId", fileInputModel.ReferenceId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("referenceTypeId", fileInputModel.ReferenceTypeId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("referenceTypeName", fileInputModel.ReferenceTypeName));

                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].UpdatedDateTime", DateTime.UtcNow));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].UpdatedByUserId", loggedInContext.LoggedInUserId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileType", dataSFDT.FileType));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileId", dataSFDT.FileId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileName", dataSFDT.FileName));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileSize", dataSFDT.FileSize));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].filePath", dataSFDT.FilePath));

                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].description", dataSFDT.Description));
                    updateList.Add(Builders<BsonDocument>.Update.Set("SFDTFile.$[].fileExtension", dataSFDT.FileExtension));

                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].UpdatedDateTime", DateTime.UtcNow));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].UpdatedByUserId", loggedInContext.LoggedInUserId));

                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                    UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);
                }
                foreach (var dataHTML in fileInputModel.HTMLFile)
                {
                    //updateList = new List<UpdateDefinition<BsonDocument>>
                    //{
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileType", dataHTML.FileType),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileId", dataHTML.FileId),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileName", dataHTML.FileName),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileSize", dataHTML.FileSize),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].filePath", dataHTML.FilePath),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].description", dataHTML.Description),
                    //    Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileExtension", dataHTML.FileExtension),
                    //};

                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileType", dataHTML.FileType));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileId", dataHTML.FileId));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileName", dataHTML.FileName));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileSize", dataHTML.FileSize));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].filePath", dataHTML.FilePath));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].description", dataHTML.Description));
                    updateList.Add(Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileExtension", dataHTML.FileExtension));

                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                    UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);
                }

                foreach (var dataPDF in fileInputModel.PDFFile)
                {
                    //updateList = new List<UpdateDefinition<BsonDocument>>
                    //{
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].fileType", dataPDF.FileType),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].fileId", dataPDF.FileId),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].fileName", dataPDF.FileName),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].fileSize", dataPDF.FileSize),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].filePath", dataPDF.FilePath),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].description", dataPDF.Description),
                    //    Builders<BsonDocument>.Update.Set("PDFFile.$[].fileExtension", dataPDF.FileExtension),
                    //};

                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].fileType", dataPDF.FileType));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].fileId", dataPDF.FileId));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].fileName", dataPDF.FileName));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].fileSize", dataPDF.FileSize));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].filePath", dataPDF.FilePath));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].description", dataPDF.Description));
                        updateList.Add(Builders<BsonDocument>.Update.Set("PDFFile.$[].fileExtension", dataPDF.FileExtension));


                    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                    UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);
                }
                
                //UpdateResult result1 = fileCollections.UpdateOne(dataSFDT.ToBsonDocument(), updateObject);



                //foreach (var dataHTML in fileInputModel.HTMLFile)
                //{
                //    updateList = new List<UpdateDefinition<BsonDocument>>
                //    {
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileType", dataHTML.FileType),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileId", dataHTML.FileId),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileName", dataHTML.FileName),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileSize", dataHTML.FileSize),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].filePath", dataHTML.FilePath),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].description", dataHTML.Description),
                //        Builders<BsonDocument>.Update.Set("HTMLFile.$[].fileExtension", dataHTML.FileExtension),
                       
                //    };
                //    var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                //    //UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);
                //    UpdateResult result = fileCollections.UpdateOne(dataHTML.ToBsonDocument(), updateObject);
                //}

                //foreach (var dataPDF in fileInputModel.PDFFile)
                //{
                //    updateList = new List<UpdateDefinition<BsonDocument>>
                //    {
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].fileType", dataPDF.FileType),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].fileId", dataPDF.FileId),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].fileName", dataPDF.FileName),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].fileSize", dataPDF.FileSize),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].filePath", dataPDF.FilePath),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].description", dataPDF.Description),
                //        Builders<BsonDocument>.Update.Set("PDFFile.$[].fileExtension", dataPDF.FileExtension),
                       
                //    };
                //    var updateObject  = Builders<BsonDocument>.Update.Combine(updateList);
                //    UpdateResult result = fileCollections.UpdateOne(filteredResult.ToBsonDocument(), updateObject);
                //    UpdateResult result1 = fileCollections.UpdateOne(dataPDF.ToBsonDocument(), updateObject);
                //}

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFileDataSet", "FileDataSetRepository"));
                return id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFileDataSet", "FileDataSetRepository", exception));
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, exception, ValidationMessages.ExceptionUpdateDataSourceKeys);
                return null;
            }
        }
    }
}
