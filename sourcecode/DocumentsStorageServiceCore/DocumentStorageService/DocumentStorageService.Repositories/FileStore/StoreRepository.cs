using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DocumentStorageService.Repositories.FileStore
{
    public class StoreRepository 
    {
        IConfiguration _iconfiguration;
        public StoreRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }

        [Obsolete]
        public List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchReferenceType", "ReferenceTypeRepository"));

                IMongoCollection<StoreOutputReturnModels> storeCollections = GetMongoCollectionObject<StoreOutputReturnModels>(MongoDBCollectionConstants.StoreCollection);
                IMongoCollection<FileApiReturnModel> fileCollection = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<StoreOutputReturnModels>.Filter;
                var filters = new List<FilterDefinition<StoreOutputReturnModels>>();
                List<StoreOutputReturnModels> filteredResult = new List<StoreOutputReturnModels>();
                List<StoreOutputReturnModels> storeOutputReturnModels = new List<StoreOutputReturnModels>();
                if (storeSearchCriteriaInput.Id != null)
                {
                    filters.Add(fBuilder.Eq("_id", storeSearchCriteriaInput.Id.ToString()));
                }

                if (storeSearchCriteriaInput.StoreName != null)
                {
                    filters.Add(fBuilder.Eq("StoreName", storeSearchCriteriaInput.StoreName.ToString()));
                }
                if (storeSearchCriteriaInput.CompanyId != null)
                {
                    filters.Add(fBuilder.Eq("CompanyId", storeSearchCriteriaInput.CompanyId.ToString()));
                }

                filters.Add(fBuilder.Eq("IsArchived", false));


                var filterObject = fBuilder.And(filters);
                filteredResult = storeCollections.Find(filterObject).ToList();
                Parallel.ForEach(filteredResult, (storeDetails) =>
                {
                    var storeBuilder = Builders<FileApiReturnModel>.Filter;
                    var storefilters = new List<FilterDefinition<FileApiReturnModel>>();
                   
                    storefilters.Add(storeBuilder.Eq("_id", storeDetails.Id.ToString()));
                    storefilters.Add(storeBuilder.Eq("IsArchived", false));
                    var storeFilterObject = storeBuilder.And(storefilters);
                    long storeCount = fileCollection.Find(storeFilterObject).Count();
                    var storeOutputModel = new StoreOutputReturnModels();
                    storeOutputModel.Id = storeDetails.Id;
                    //storeOutputModel.StoreId = storeDetails.Id;
                    storeOutputModel.CompanyId = storeDetails.CompanyId;
                    storeOutputModel.StoreName = storeDetails.StoreName;
                    storeOutputModel.StoreSize = storeDetails.StoreSize;
                    storeOutputModel.IsDefault = storeDetails.IsDefault;
                    storeOutputModel.IsCompany = storeDetails.IsCompany;
                    storeOutputModel.IsArchived = storeDetails.IsArchived;
                    storeOutputModel.StoreCount = storeCount;
                    storeOutputReturnModels.Add(storeOutputModel);
                });

                return storeOutputReturnModels;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchReferenceType", "ReferenceTypeRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? UpdateStoreSize(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> storeCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.StoreCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", storeInputModel.Id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", storeInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("StoreSize", storeInputModel.StoreSize));

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = storeCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return storeInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? CreateStore(StoreCollectionModel upsertStoreCollectionModelInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateStore", "StoreRepository"));

                IMongoCollection<BsonDocument> storeCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.StoreCollection);

                storeCollections.InsertOne(upsertStoreCollectionModelInputModel.ToBsonDocument());

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateStore", "StoreRepository"));
                return upsertStoreCollectionModelInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateStore", "StoreRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionStoreUpsert
                });
                return null;
            }
        }

        public Guid? UpdateStore(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> storeCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.StoreCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", storeInputModel.Id.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", storeInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("StoreName", storeInputModel.StoreName),
                    Builders<BsonDocument>.Update.Set("IsCompany", storeInputModel.IsCompany),
                    Builders<BsonDocument>.Update.Set("IsDefault", storeInputModel.IsDefault),
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", storeInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = storeCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return storeInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFile", "UploadFileRepository"));

                IMongoCollection<BsonDocument> storeCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.StoreCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", storeId.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("InActiveDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
                };
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = storeCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFile", "UploadFileRepository"));
                return storeId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "UploadFileRepository", exception.Message), exception);
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
