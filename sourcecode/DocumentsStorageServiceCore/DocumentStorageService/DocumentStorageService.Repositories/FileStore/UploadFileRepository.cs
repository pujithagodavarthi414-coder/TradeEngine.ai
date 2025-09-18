using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DocumentStorageService.Repositories.Helpers;

namespace DocumentStorageService.Repositories.FileStore
{
    public class UploadFileRepository
    {
        IConfiguration _iconfiguration;

        public UploadFileRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateFile(FileCollectionModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateFile", "UploadFileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                fileCollections.InsertOne(upsertFileInputModel.ToBsonDocument());

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateFile", "UploadFileRepository"));
                return upsertFileInputModel.FileId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateFile", "UploadFileRepository", exception.Message), exception);
                return null;
            }
        }
        public Guid? ArchiveFile(Guid? fileId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "UploadFileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", fileId.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("InActiveDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
                };
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "UploadFileRepository"));
                return fileId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "UploadFileRepository", exception.Message), exception);
                return null;
            }
        }

        public List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "UploadFileRepository"));

                IMongoCollection<FileApiReturnModel> fileCollections = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<FileApiReturnModel>.Filter;
                var filters = new List<FilterDefinition<FileApiReturnModel>>();
                List<FileApiReturnModel> filteredResult = new List<FileApiReturnModel>();

                //var sortDefinition = Builders<FileApiReturnModel>.Sort.Descending(a => a.CreatedDateTime);

                //if (fileSearchCriteriaInput.SortDirectionAsc)
                //{
                //    if (fileSearchCriteriaInput.SortBy == "FileName")
                //    {
                //        sortDefinition = Builders<FileApiReturnModel>.Sort.Ascending(a => a.FileName);
                //    }
                //    else
                //    {
                //        sortDefinition = Builders<FileApiReturnModel>.Sort.Ascending(a => a.CreatedDateTime);
                //    }
                //}
                //else
                //{
                //    if (fileSearchCriteriaInput.SortBy == "FileName")
                //    {
                //        sortDefinition = Builders<FileApiReturnModel>.Sort.Descending(a => a.FileName);
                //    }
                //    else
                //    {
                //        sortDefinition = Builders<FileApiReturnModel>.Sort.Descending(a => a.CreatedDateTime);
                //    }
                //}

                //if (fileSearchCriteriaInput.FileId != null)
                //{
                //    filters.Add(fBuilder.Eq("_id", fileSearchCriteriaInput.FileId.ToString()));
                //}

                //if (fileSearchCriteriaInput.FolderId != null)
                //{
                //    filters.Add(fBuilder.Eq("FolderId", fileSearchCriteriaInput.FolderId.ToString()));
                //}
                //if (fileSearchCriteriaInput.ReferenceId != null)
                //{
                //    filters.Add(fBuilder.Eq("ReferenceId", fileSearchCriteriaInput.ReferenceId.ToString()));
                //}
                //if (fileSearchCriteriaInput.ReferenceTypeId != null)
                //{
                //    filters.Add(fBuilder.Eq("ReferenceTypeId", fileSearchCriteriaInput.ReferenceTypeId.ToString()));
                //}

                //if (fileSearchCriteriaInput.StoreId != null)
                //{
                //    filters.Add(fBuilder.Eq("StoreId", fileSearchCriteriaInput.StoreId.ToString()));
                //}

                //if (fileSearchCriteriaInput.IsArchived == true)
                //{
                //    filters.Add(fBuilder.Eq("IsArchived", true));
                //}
                //else
                //{
                //    filters.Add(fBuilder.Eq("IsArchived", false));
                //}


                //if (fileSearchCriteriaInput.SearchText != null)
                //{
                //    var textToSearch = "/.*" + fileSearchCriteriaInput.SearchText + ".*/i";
                //    filters.Add(fBuilder.Eq("FileName", new BsonRegularExpression(textToSearch)));
                //}
                var match = new BsonArray{};
                if (fileSearchCriteriaInput.ReferenceId != null)
                {
                    match.Add(new BsonDocument("ReferenceId", fileSearchCriteriaInput.ReferenceId.ToString()));
                }
                if (fileSearchCriteriaInput.ReferenceTypeId != null)
                {
                    match.Add(new BsonDocument("ReferenceTypeId", fileSearchCriteriaInput.ReferenceTypeId.ToString()));
                }
                if (fileSearchCriteriaInput.ReferenceTypeName != null)
                {
                    match.Add(new BsonDocument("ReferenceTypeName", fileSearchCriteriaInput.ReferenceTypeName));
                }
                if (fileSearchCriteriaInput.FileName != null)
                {
                    match.Add(new BsonDocument("FileName", fileSearchCriteriaInput.FileName));
                }
                if (fileSearchCriteriaInput.IsArchived != null)
                {
                    match.Add(new BsonDocument("IsArchived", fileSearchCriteriaInput.IsArchived));
                }
                else
                {
                    match.Add(new BsonDocument("IsArchived", false));
                }
                if (fileSearchCriteriaInput.FileId != null)
                {
                    match.Add(new BsonDocument("_id", fileSearchCriteriaInput.FileId.ToString()));
                }
                var matchStage = new BsonDocument("$match",
                    new BsonDocument("$and", new BsonArray(match)));
                var stages = new List<BsonDocument>();
                stages.Add(matchStage);
                var pipeline = stages;
                var aggregateOptions = new AggregateOptions() { AllowDiskUse = true };
                var aggregateDataList = fileCollections.Aggregate<BsonDocument>(pipeline, aggregateOptions).ToList();
                filteredResult = BsonHelper.ConvertBsonDocumentListToModel<FileApiReturnModel>(aggregateDataList);

                //var filterObject = fBuilder.And(filters);
                //filteredResult = fileCollections.Find(filterObject)
                    //.Skip(fileSearchCriteriaInput.Skip)
                    //    .Limit(fileSearchCriteriaInput.PageSize).Sort(sortDefinition)
                       //.ToList();

                return filteredResult;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFilesFromFolder", "UploadFileRepository", exception.Message), exception);
                return null;
            }
        }
        public Guid? UpdateFile(FileCollectionModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", fileModel.Id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", fileModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("FileName", fileModel.FileName));
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return fileModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? UpdateDocumentVersion(FileCollectionModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", fileModel.Id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", fileModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("FilePath", fileModel.FilePath));
                updateList.Add(Builders<BsonDocument>.Update.Set("VersionNumber", fileModel.VersionNumber));
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return fileModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? UpdateReviewFile(FileCollectionModel fileModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateReviewFile", "FileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", fileModel.Id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", fileModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("IsToBeReviewed", fileModel.IsToBeReviewed));
                updateList.Add(Builders<BsonDocument>.Update.Set("ReviewedDateTime", fileModel.ReviewedDateTime));
                updateList.Add(Builders<BsonDocument>.Update.Set("ReviewedByUserId", fileModel.ReviewedByUserId));
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateReviewFile", "FileRepository"));
                return fileModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? AddVersionToDocument(FileCollectionModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddVersionToDocument", "FileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", upsertFileInputModel.Id.ToString());
                upsertFileInputModel.UpdatedDateTime = DateTime.UtcNow;
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", upsertFileInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                List<VersionModel> childrenCollectionModel = new List<VersionModel>();
               
                var versionModel = new VersionModel();
                versionModel.FilePath = upsertFileInputModel.FilePath;
                versionModel.VersionNumber = upsertFileInputModel.VersionNumber;
                childrenCollectionModel.Add(versionModel);

                List<BsonDocument> childFiles = childrenCollectionModel.Select(x => x.ToBsonDocument()).ToList();

                BsonDocument updateobject = BsonHelper.GetBsonPushArrayOfObjects("Versions", childFiles);

                UpdateResult updatedResult = fileCollections.UpdateOne(filterObject, updateobject);

                UpdateResult expectedResult = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddVersionToDocument", "FileRepository"));
                return upsertFileInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "AddVersionToDocument", "FileRepository", exception.Message), exception);
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
