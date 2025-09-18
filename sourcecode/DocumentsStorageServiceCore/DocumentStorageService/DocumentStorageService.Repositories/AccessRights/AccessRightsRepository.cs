using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Repositories.Helpers;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;

namespace DocumentStorageService.Repositories.AccessRights
{
   public  class AccessRightsRepository
    {
        IConfiguration _iconfiguration;

        public AccessRightsRepository(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }

        public Guid? InsertAccessRightsForDocuments(AccessRightsCollectionModel accessRightsCollectionModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "AddVersionToDocument", "FileRepository"));

                IMongoCollection<BsonDocument> fileCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", accessRightsCollectionModel.DocumentId.ToString());
               
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);
                List<AccessModel> childrenCollectionModel = new List<AccessModel>();

                var accessModel = new AccessModel();
                accessModel.Id = accessRightsCollectionModel.Id;
                accessModel.UserId = accessRightsCollectionModel.UserId;
                accessModel.RoleId = accessRightsCollectionModel.RoleId;
                accessModel.IsCreateAccess = accessRightsCollectionModel.IsCreateAccess;
                accessModel.IsEditAccess = accessRightsCollectionModel.IsEditAccess;
                accessModel.IsViewAccess = accessRightsCollectionModel.IsViewAccess;
                accessModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                accessModel.CreatedDateTime = DateTime.UtcNow;
                accessModel.IsArchived = false;
                childrenCollectionModel.Add(accessModel);

                List<BsonDocument> childFiles = childrenCollectionModel.Select(x => x.ToBsonDocument()).ToList();

                BsonDocument updateobject = BsonHelper.GetBsonPushArrayOfObjects("AccessRights", childFiles);

                UpdateResult updatedResult = fileCollections.UpdateOne(filterObject, updateobject);

                UpdateResult expectedResult = fileCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "AddVersionToDocument", "FileRepository"));
                return accessRightsCollectionModel.DocumentId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertAccessRightsForDocuments", "AccessRightsRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionAccessRightsUpsert
                });
                return null;
            }
        }

        public Guid? UpdateAccessRightsPermissionForDocumentsBasedOnDocumentId(AccessRightsCollectionModel permissionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository"));

                IMongoCollection<FileApiReturnModel> accessRightsCollections = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<FileApiReturnModel>.Filter;
                var filterObject = fBuilder.Eq("DocumentId", permissionInputModel.DocumentId.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var updateList = new List<UpdateDefinition<FileApiReturnModel>>
                {
                    Builders<FileApiReturnModel>.Update.Set("UpdatedDateTime", permissionInputModel.UpdatedDateTime),
                    Builders<FileApiReturnModel>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
               
                var updateObject = Builders<FileApiReturnModel>.Update.Combine(updateList);

                UpdateResult result = accessRightsCollections.UpdateOne(filterObject, updateObject);

                //Update access documents
                var documentAndAccessFilter = fBuilder.And(
                    fBuilder.Eq(x => x.Id, permissionInputModel.DocumentId),
                    fBuilder.ElemMatch(x => x.AccessRights, c => c.Id == permissionInputModel.Id));
                // find student with id and course id
                var documents = accessRightsCollections.Find(documentAndAccessFilter).SingleOrDefault();

                // update with positional operator
               
                var accessRightsupdateList = new List<UpdateDefinition<FileApiReturnModel>>
                {
                    Builders<FileApiReturnModel>.Update.Set("AccessRights.$.UpdatedDateTime", permissionInputModel.UpdatedDateTime),
                    Builders<FileApiReturnModel>.Update.Set("AccessRights.$.UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                if (permissionInputModel.UserId != null)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.UserId", permissionInputModel.UserId));
                }
                if (permissionInputModel.RoleId != null)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.RoleId", permissionInputModel.RoleId));
                }

                if (permissionInputModel.IsCreateAccess != null)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.IsCreateAccess", permissionInputModel.IsCreateAccess));
                }
                if (permissionInputModel.IsEditAccess != null)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.IsEditAccess", permissionInputModel.IsEditAccess));
                }
                if (permissionInputModel.IsViewAccess != null)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.IsViewAccess", permissionInputModel.IsViewAccess));
                }
                
                if (permissionInputModel.IsArchived == true)
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.IsArchived", true));
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.ArchivedDateTime", DateTime.UtcNow));
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.ArchivedByUserId", loggedInContext.LoggedInUserId));
                }
                else
                {
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.IsArchived", false));
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.ArchivedDateTime", ""));
                    accessRightsupdateList.Add(Builders<FileApiReturnModel>.Update.Set("AccessRights.$.ArchivedByUserId", ""));
                }
                var accessRightsUpdateObject = Builders<FileApiReturnModel>.Update.Combine(accessRightsupdateList);

                accessRightsCollections.UpdateOne(documentAndAccessFilter, accessRightsUpdateObject);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository"));
                return permissionInputModel.DocumentId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionAccessRightsUpsert
                });
                return null;
            }
        }

        public Guid? UpdateAccessRightsPermissionForDocuments(AccessRightsCollectionModel permissionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository"));

                IMongoCollection<BsonDocument> accessRightsCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.AccessRightsCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", permissionInputModel.Id.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", permissionInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                if (permissionInputModel.UserId != null)
                {
                    updateList.Add(Builders<BsonDocument>.Update.Set("UserId", permissionInputModel.UserId));
                }
                if (permissionInputModel.RoleId != null)
                {
                    updateList.Add(Builders<BsonDocument>.Update.Set("RoleId", permissionInputModel.RoleId));
                }

                if (permissionInputModel.IsCreateAccess != null)
                {
                    updateList.Add(Builders<BsonDocument>.Update.Set("IsCreateAccess", permissionInputModel.IsCreateAccess));
                }
                if (permissionInputModel.IsEditAccess != null)
                {
                    updateList.Add(Builders<BsonDocument>.Update.Set("IsEditAccess", permissionInputModel.IsEditAccess));
                }
                if (permissionInputModel.IsViewAccess != null)
                {
                    updateList.Add(Builders<BsonDocument>.Update.Set("IsViewAccess", permissionInputModel.IsViewAccess));
                }

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = accessRightsCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository"));
                return permissionInputModel.DocumentId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateAccessRightsPermissionForDocuments", "AccessRightsRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionAccessRightsUpsert
                });
                return null;
            }
        }

        public List<AccessRightsReturnModel> SearchAccessRightsForDocuments(AccessRightsSearchInputModel accessRightsSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "UploadFileRepository"));

                IMongoCollection<BsonDocument> accessRightsCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.DocumentsCollection);
                var pipeline = GetPipelineArrayToFetchAccessRights(accessRightsSearchCriteriaInput);

                var filteredResult = accessRightsCollections.Aggregate<BsonDocument>(pipeline, BsonHelper.GetAggregateOptionsObject()).ToList();
                

                var result = BsonHelper.ConvertBsonDocumentListToModel<AccessRightsReturnModel>(filteredResult); 
                Parallel.ForEach(result, (file) =>
                {
                    file.AccessRights = GetDocumentAccessRights(file.AccessRights, accessRightsSearchCriteriaInput);
                });
                return result;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFilesFromFolder", "UploadFileRepository", exception.Message), exception);
                return null;
            }
        }

        private List<AccessModel> GetDocumentAccessRights(List<AccessModel> accessRights,
            AccessRightsSearchInputModel searchInput)
        {
            List<AccessModel> filteredRights = accessRights.Where(x => x.IsArchived == false).ToList();
            return filteredRights;
        }

        public BsonDocument[] GetPipelineArrayToFetchAccessRights(
            AccessRightsSearchInputModel accessRightsSearchInputModel)
        {
            var stages = new List<BsonDocument>();

            var matchStageConditions = new List<BsonDocument>
            {
                new BsonDocument("IsArchived",
                    new BsonDocument("$ne", true))
            };

            if (accessRightsSearchInputModel.DocumentId != null)
            {
                matchStageConditions.Add(new BsonDocument("_id",
                    accessRightsSearchInputModel.DocumentId.ToString()));
            }
           
           

            var matchStage = new BsonDocument("$match",
                BsonHelper.GetBsonDocumentWithConditionalObject("$and", matchStageConditions));
            var projectStage = new BsonDocument("$project", GetAccessDocumentFields(accessRightsSearchInputModel));
            stages.Add(projectStage);
            stages.Add(matchStage);

            return stages.ToArray();
        }

        private BsonDocument GetAccessDocumentFields(AccessRightsSearchInputModel accessRightsSearchInputModel)
        {
            var outputFields = new BsonDocument
            {
                { "Id", 1 },
                { "FileName", 1 },
                { "AccessRights", 1 },
                {"FilePath", 1}
               
            };

            return outputFields;
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
