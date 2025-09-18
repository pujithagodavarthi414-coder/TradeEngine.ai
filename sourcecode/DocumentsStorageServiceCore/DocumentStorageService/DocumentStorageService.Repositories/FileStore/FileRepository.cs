using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using Microsoft.Extensions.Configuration;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace DocumentStorageService.Repositories.FileStore
{
    public class FileRepository
    {
        IConfiguration _iconfiguration;
        private readonly StoreRepository _storeRepository;
        public FileRepository(StoreRepository storeRepository, IConfiguration iConfiguration)
        {
            _storeRepository = storeRepository;
            _iconfiguration = iConfiguration;
        }
        public Guid? CreateFolder(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                folderCollections.InsertOne(upsertFolderInputModel.ToBsonDocument());

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateFolder", "FileRepository"));
                return upsertFolderInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateFolder", "FileRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionFolderUpsert
                });
                return null;
            }
        }
        public bool? GetFolderDetails(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "CreateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                var filter = Builders<BsonDocument>.Filter.Eq("_id", folderId);
                var filteredResult = folderCollections.Find(filter).FirstOrDefault();

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CreateFolder", "FileRepository"));
                if (filteredResult == null)
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "CreateFolder", "FileRepository", exception.Message), exception);
                return null;
            }
        }
        public Guid? UpdateFolder(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", upsertFolderInputModel.Id.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", upsertFolderInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("FolderName", upsertFolderInputModel.FolderName));
                updateList.Add(Builders<BsonDocument>.Update.Set("ParentFolderId", upsertFolderInputModel.ParentFolderId));

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = folderCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return upsertFolderInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionFolderUpsert
                });
                return null;
            }
        }
        public Guid? UpdateFolderDescription(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", upsertFolderInputModel.Id.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", upsertFolderInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("Description", upsertFolderInputModel.Description));

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = folderCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return upsertFolderInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionFolderUpsert
                });
                return null;
            }
        }
        public Guid? ArchiveFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", folderId.ToString());
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId),
                    Builders<BsonDocument>.Update.Set("IsArchived", true),
                    Builders<BsonDocument>.Update.Set("InActiveDateTime", DateTime.UtcNow),
                    Builders<BsonDocument>.Update.Set("ArchivedByUserId", loggedInContext.LoggedInUserId),
                };

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = folderCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteFolder", "FileRepository"));
                return folderId;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFolder", "FileRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionFolderDelete
                });
                return null;
            }
        }

        public List<UploadFileReturnModel> GetFilesFromFolder(Guid? folderId, LoggedInContext loggedInContext,
          List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFilesFromFolder", "UploadFileRepository"));

                IMongoCollection<UploadFileReturnModel> fileCollections = GetMongoCollectionObject<UploadFileReturnModel>(MongoDBCollectionConstants.DocumentsCollection);

                List<UploadFileReturnModel> filteredResult = fileCollections.AsQueryable<UploadFileReturnModel>().Where(p => p.FolderId == folderId && p.InActiveDateTime == null).ToList();

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetFilesFromFolder", "UploadFileRepository"));

                return filteredResult;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFilesFromFolder", "UploadFileRepository", exception.Message), exception);
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
       public List<SearchFolderOutputModel> SearchFolders(SearchFolderInputModel folderInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchReferenceType", "ReferenceTypeRepository"));

                IMongoCollection<SearchFolderOutputModel> referenceTypeCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);

                var fBuilder = Builders<SearchFolderOutputModel>.Filter;
                var filters = new List<FilterDefinition<SearchFolderOutputModel>>();
                List<SearchFolderOutputModel> filteredResult = new List<SearchFolderOutputModel>();

                if (folderInputModel.FolderReferenceTypeId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceTypeId", folderInputModel.FolderReferenceTypeId.ToString()));
                }

                if (folderInputModel.StoreId != null)
                {
                    filters.Add(fBuilder.Eq("StoreId", folderInputModel.StoreId.ToString()));
                }
                if (folderInputModel.FolderReferenceId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceId", folderInputModel.FolderReferenceId.ToString()));
                }

                if (folderInputModel.FolderId != null)
                {
                    filters.Add(fBuilder.Eq("_id", folderInputModel.FolderId.ToString()));
                }
                if (folderInputModel.ParentFolderId != null)
                {
                    filters.Add(fBuilder.Eq("ParentFolderId", folderInputModel.ParentFolderId.ToString()));
                }
                if (folderInputModel.FolderName != null)
                {
                    filters.Add(fBuilder.Eq("FolderName", folderInputModel.FolderName.ToString()));
                }
                filters.Add(fBuilder.Eq("IsArchived", false));
                var filterObject = fBuilder.And(filters);
                filteredResult = referenceTypeCollections.Find(filterObject).ToList();

                return filteredResult;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchReferenceType", "ReferenceTypeRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionSearchFolders
                });
                return null;
            }
        }
        public Guid? UpdateFolderSize(FolderCollectionModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder", "FileRepository"));

                IMongoCollection<BsonDocument> folderCollections = GetMongoCollectionObject<BsonDocument>(MongoDBCollectionConstants.FoldersCollection);

                var fBuilder = Builders<BsonDocument>.Filter;
                var filterObject = fBuilder.Eq("_id", upsertFolderInputModel.Id.ToString());
                filterObject &= fBuilder.Eq("IsArchived", false);
                var updateList = new List<UpdateDefinition<BsonDocument>>
                {
                    Builders<BsonDocument>.Update.Set("UpdatedDateTime", upsertFolderInputModel.UpdatedDateTime),
                    Builders<BsonDocument>.Update.Set("UpdatedByUserId", loggedInContext.LoggedInUserId)
                };
                updateList.Add(Builders<BsonDocument>.Update.Set("FolderSize", upsertFolderInputModel.FolderSize));

                var updateObject = Builders<BsonDocument>.Update.Combine(updateList);

                UpdateResult result = folderCollections.UpdateOne(filterObject, updateObject);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateFolder", "FileRepository"));
                return upsertFolderInputModel.Id;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolder", "FileRepository", exception.Message), exception);
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.ExceptionFolderUpsert
                });
                return null;
            }
        }
        public List<SearchFolderOutputModel> GetParentAndChildFolders(Guid? folderId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetParentAndChildFolders", "FileRepository"));

                IMongoCollection<SearchFolderOutputModel> folderCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);
                var fBuilder = Builders<SearchFolderOutputModel>.Filter;
                var filters = new List<FilterDefinition<SearchFolderOutputModel>>();
                List<SearchFolderOutputModel> filteredResult = new List<SearchFolderOutputModel>();
                List<SearchFolderOutputModel> combinedResult = new List<SearchFolderOutputModel>();

                List<SearchFolderOutputModel> foldersList = folderCollections.AsQueryable<SearchFolderOutputModel>()
                    .Where(p => p.Id == folderId && p.IsArchived == false).ToList();
                foreach (var folder in foldersList)
                {
                    folder.ChildFolders = GetChildren(folder.Id);
                    filteredResult.Add(folder);
                }

                if (filteredResult.Count > 0)
                {

                    foreach (var filteredData in filteredResult)
                    {
                        combinedResult.Add(filteredData);
                        if (filteredData.ChildFolders.Count > 0)
                        {
                            foreach (var child in filteredData.ChildFolders)
                            {
                                combinedResult.Add(child);
                                combinedResult = GetChildFolders(combinedResult, child);
                            }
                        }
                    }
                }

                return combinedResult;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetParentAndChildFolders", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        public SearchFolderOutputModel SearchFoldersAndFiles(SearchFolderInputModel searchFolderInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFoldersAndFiles", "FileRepository"));

                IMongoCollection<SearchFolderOutputModel> folderCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);
                var fBuilder = Builders<SearchFolderOutputModel>.Filter;
                var filters = new List<FilterDefinition<SearchFolderOutputModel>>();
                var outputModel = new SearchFolderOutputModel();
                List<FileFolderModel> fileFolderList = new List<FileFolderModel>();
                List<Guid?> folderIds = new List<Guid?>();

                string FolderAndFiles = "";
                string store = "";
                string breadcrumb = null;

                if (searchFolderInputModel.FolderReferenceId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId.ToString()));
                }

                if (searchFolderInputModel.FolderReferenceTypeId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId.ToString()));
                }

                if (searchFolderInputModel.StoreId != null)
                {
                    filters.Add(fBuilder.Eq("StoreId", searchFolderInputModel.StoreId.ToString()));
                }

                if (searchFolderInputModel.FolderId != null)
                {
                    filters.Add(fBuilder.Eq("FolderId", searchFolderInputModel.FolderId.ToString()));
                }

                if (searchFolderInputModel.ParentFolderId != null)
                {
                    filters.Add(fBuilder.Eq("ParentFolderId", searchFolderInputModel.ParentFolderId.ToString()));
                }

                if (searchFolderInputModel.UserStoryId != null)
                {
                    filters.Add(fBuilder.Eq("UserStoryId", searchFolderInputModel.UserStoryId.ToString()));
                }
                filters.Add(fBuilder.Eq("IsArchived", false));
                var filterObject = fBuilder.And(filters);
                List<SearchFolderOutputModel> foldersList = folderCollections.Find(filterObject).ToList();

                //Getting file details
                IMongoCollection<FileApiReturnModel> fileCollections = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);
                List<FileApiReturnModel> fileOutputReturnModel = fileCollections.AsQueryable()
                    .Where(file => file.FolderId == searchFolderInputModel.ParentFolderId && file.IsArchived == false).OrderBy(x => x.CreatedDateTime).ToList();
                Parallel.ForEach(foldersList, (folder) =>
                {
                    var folderModel = new FileFolderModel();
                    folderModel.Id = folder.Id;
                    folderModel.ParentFolderId = folder.ParentFolderId;
                    folderModel.Name = folder.FolderName;
                    folderModel.StoreId = folder.StoreId;
                    folderModel.Size = folder.FolderSize;
                    folderModel.CreatedDateTime = folder.CreatedDateTime;
                    folderModel.IsFolder = true;
                    folderModel.Count = GetChildCount(folder.Id);
                    fileFolderList.Add(folderModel);
                    folderIds.Add(folder.Id);

                });
                Parallel.ForEach(fileOutputReturnModel, (file) =>
                {
                    var fileModel = new FileFolderModel();
                    fileModel.Id = file.Id;
                    fileModel.ParentFolderId = file.FolderId;
                    fileModel.Name = file.FileName;
                    fileModel.Size = file.FileSize;
                    fileModel.StoreId = file.StoreId;
                    fileModel.CreatedDateTime = file.CreatedDateTime;
                    fileModel.IsFolder = false;
                    fileModel.ReviewedByUserId = file.ReviewedByUserId;
                    fileModel.ReviewedByUserName = file.ReviewedByUserName;
                    fileModel.ReviewedDateTime = file.ReviewedDateTime;
                    fileModel.IsToBeReviewed = file.IsToBeReviewed;
                    fileModel.FilePath = file.FilePath;
                    fileModel.Extension = file.FileExtension;
                    fileModel.Count = 0;
                    fileFolderList.Add(fileModel);
                });
                if (searchFolderInputModel.SearchText != null)
                {
                    fileFolderList = (List<FileFolderModel>)fileFolderList.Where(x =>
                       (x.Name.IndexOf(searchFolderInputModel.SearchText) != -1) ||
                       (x.Size.ToString().IndexOf(searchFolderInputModel.SearchText) != -1) ||
                                    (x.Extension.ToString().IndexOf(searchFolderInputModel.SearchText) != -1) ||
                       (x.Count.ToString().IndexOf(searchFolderInputModel.SearchText) != -1))
                        .ToList();
                }
                fileFolderList = fileFolderList.Skip(searchFolderInputModel.Skip).Take(searchFolderInputModel.PageSize).ToList();
                switch (searchFolderInputModel.SortBy)
                {
                    case "Name":
                        if (searchFolderInputModel.SortDirectionAsc)
                        {
                            fileFolderList = fileFolderList.OrderBy(x => x.Name).ToList();
                        }
                        else
                        {
                            fileFolderList = fileFolderList.OrderByDescending(x => x.Name).ToList();
                        }
                        break;
                    case "Size":
                        if (searchFolderInputModel.SortDirectionAsc)
                        {
                            fileFolderList = fileFolderList.OrderBy(x => x.Size).ToList();
                        }
                        else
                        {
                            fileFolderList = fileFolderList.OrderByDescending(x => x.Size).ToList();
                        }
                        break;
                    case "CreatedDateTime":
                        if (searchFolderInputModel.SortDirectionAsc)
                        {
                            fileFolderList = fileFolderList.OrderBy(x => x.CreatedDateTime).ToList();
                        }
                        else
                        {
                            fileFolderList = fileFolderList.OrderByDescending(x => x.CreatedDateTime).ToList();
                        }
                        break;
                    case "Count":
                        if (searchFolderInputModel.SortDirectionAsc)
                        {
                            fileFolderList = fileFolderList.OrderBy(x => x.Count).ToList();
                        }
                        else
                        {
                            fileFolderList = fileFolderList.OrderByDescending(x => x.Count).ToList();
                        }
                        break;
                }

                JsonSerializerSettings settings = new JsonSerializerSettings
                {
                    ContractResolver = new CamelCasePropertyNamesContractResolver(),
                    Formatting = Formatting.Indented,
                    NullValueHandling = NullValueHandling.Ignore
                };

                FolderAndFiles = JsonConvert.SerializeObject(fileFolderList, settings);

                //Getting store details
                var storeSearchCriteriaInputModel = new StoreCriteriaSearchInputModel();
                storeSearchCriteriaInputModel.Id = searchFolderInputModel.StoreId;
                storeSearchCriteriaInputModel.IsArchived = false;
                storeSearchCriteriaInputModel.CompanyId = loggedInContext.CompanyGuid;
                StoreOutputReturnModels storeOutputModels = _storeRepository
                    .SearchStore(storeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

                store = JsonConvert.SerializeObject(storeOutputModels, settings);

                //breadcrumb details
                List<SearchFolderOutputModel> breadcrumbDetails =
                    GetParentAndChildFolders(searchFolderInputModel.ParentFolderId, loggedInContext,
                        validationMessages);
                breadcrumb = JsonConvert.SerializeObject(breadcrumbDetails, settings);

                //Getting parent folder details
                SearchFolderOutputModel parentFolderDetails = folderCollections.AsQueryable()
                    .Where(x => x.Id == searchFolderInputModel.ParentFolderId).FirstOrDefault();


                outputModel.FoldersAndFiles = FolderAndFiles;
                outputModel.Store = store;
                outputModel.BreadCrumb = breadcrumb;
                if (parentFolderDetails != null)
                {
                    outputModel.Description = parentFolderDetails.Description;
                    outputModel.FolderName = parentFolderDetails.FolderName;
                }

                return outputModel;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFoldersAndFiles", "FileRepository", exception.Message), exception);
                return null;
            }
        }

        private int GetChildCount(Guid? parentFolderId)
        {
            if (parentFolderId == null)
            {
                return 0;
            }
            IMongoCollection<SearchFolderOutputModel> folderCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);
            List<SearchFolderOutputModel> filteredResult = new List<SearchFolderOutputModel>();
            filteredResult = folderCollections.AsQueryable<SearchFolderOutputModel>()
                .Where(p => p.ParentFolderId == parentFolderId && p.IsArchived == false).ToList();
            if (filteredResult.Count > 0)
            {
                return filteredResult.Count;
            }
            else
            {
                return 0;
            }
        }
        public List<FolderTreeStructureModel> FolderTreeView(SearchFolderInputModel searchFolderInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFoldersAndFiles", "FileRepository"));

                IMongoCollection<SearchFolderOutputModel> folderCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);
                var fBuilder = Builders<SearchFolderOutputModel>.Filter;
                var filters = new List<FilterDefinition<SearchFolderOutputModel>>();
                List<FolderTreeStructureModel> folderTreeModel = new List<FolderTreeStructureModel>();
                List<SearchFolderOutputModel> combinedResult = new List<SearchFolderOutputModel>();
                List<SearchFolderOutputModel> filteredResult = new List<SearchFolderOutputModel>();

                if (searchFolderInputModel.FolderReferenceId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId.ToString()));
                }

                if (searchFolderInputModel.FolderReferenceTypeId != null)
                {
                    filters.Add(fBuilder.Eq("FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId.ToString()));
                }

                if (searchFolderInputModel.StoreId != null)
                {
                    filters.Add(fBuilder.Eq("StoreId", searchFolderInputModel.StoreId.ToString()));
                }

                if (searchFolderInputModel.FolderId != null)
                {
                    filters.Add(fBuilder.Eq("FolderId", searchFolderInputModel.FolderId.ToString()));
                }

                if (searchFolderInputModel.UserStoryId != null)
                {
                    filters.Add(fBuilder.Eq("UserStoryId", searchFolderInputModel.UserStoryId.ToString()));
                }
                if (searchFolderInputModel.ParentFolderId != null)
                {
                    filters.Add(fBuilder.Eq("ParentFolderId", searchFolderInputModel.ParentFolderId.ToString()));
                }
                filters.Add(fBuilder.Eq("IsArchived", false));

                var filterObject = fBuilder.And(filters);
                List<SearchFolderOutputModel> foldersList = folderCollections.Find(filterObject).ToList();
                foreach (var folder in foldersList)
                {
                    folder.ChildFolders = GetChildren(folder.Id);
                    filteredResult.Add(folder);
                }

                if (filteredResult.Count > 0)
                {

                    foreach (var filteredData in filteredResult)
                    {
                        combinedResult.Add(filteredData);
                        if (filteredData.ChildFolders.Count > 0)
                        {
                            foreach (var child in filteredData.ChildFolders)
                            {
                                combinedResult.Add(child);
                                combinedResult = GetChildFolders(combinedResult, child);
                            }
                        }
                    }
                }

                List<Guid?> folderIds = new List<Guid?>();
                Parallel.ForEach(combinedResult, (folder) =>
                {
                    var folderModel = new FolderTreeStructureModel();
                    folderModel.FolderId = folder.Id;
                    folderModel.FolderName = folder.FolderName;
                    folderModel.ParentFolderId = folder.ParentFolderId;
                    folderModel.FolderReferenceId = folder.FolderReferenceId;
                    folderModel.FolderReferenceTypeId = folder.FolderReferenceTypeId;
                    folderModel.FolderSize = folder.FolderSize;
                    folderModel.StoreId = folder.StoreId;
                    folderTreeModel.Add(folderModel);
                    folderIds.Add(folderModel.FolderId);
                });


                IMongoCollection<FileApiReturnModel> fileCollections = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);
                List<FileApiReturnModel> fileOutputReturnModel = fileCollections.AsQueryable()
                    .Where(file => folderIds.Contains(file.FolderId) && file.IsArchived == false).OrderBy(x => x.CreatedDateTime).ToList();
                Parallel.ForEach(fileOutputReturnModel, (file) =>
                {
                    var folderModel = new FolderTreeStructureModel();
                    folderModel.FolderId = file.FolderId;
                    folderModel.FileId = file.FileId;
                    folderModel.FolderName = file.FileName;
                    folderModel.ParentFolderId = null;
                    folderModel.FolderReferenceId = file.ReferenceId;
                    folderModel.FolderReferenceTypeId = file.ReferenceTypeId;
                    folderModel.FileSize = file.FileSize;
                    folderModel.StoreId = file.StoreId;
                    folderModel.FilePath = file.FilePath;
                    folderModel.Extension = file.FileExtension;
                    folderTreeModel.Add(folderModel);
                });

                return folderTreeModel;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFoldersAndFiles", "FileRepository", exception.Message), exception);
                return null;
            }
        }
        private List<SearchFolderOutputModel> GetChildren(Guid? parentFolderId)
        {
            IMongoCollection<SearchFolderOutputModel> folderCollections = GetMongoCollectionObject<SearchFolderOutputModel>(MongoDBCollectionConstants.FoldersCollection);
            List<SearchFolderOutputModel> filteredResult = new List<SearchFolderOutputModel>();
            filteredResult = folderCollections.AsQueryable<SearchFolderOutputModel>()
                .Where(p => p.ParentFolderId == parentFolderId && p.IsArchived == false).ToList();
            foreach (var folder in filteredResult)
            {
                folder.ChildFolders = GetChildren(folder.Id);
            }

            return filteredResult;
        }
        private List<SearchFolderOutputModel> GetChildFolders(List<SearchFolderOutputModel> combinedResult,
            SearchFolderOutputModel childFolders)
        {
            if (childFolders.ChildFolders.Count > 0)
            {
                foreach (var child in childFolders.ChildFolders)
                {
                    combinedResult.Add(child);
                    combinedResult = GetChildFolders(combinedResult, child);
                }
            }

            return combinedResult;
        }

        public FileApiReturnModel GetFileDetails(Guid? fileId, string fileName, LoggedInContext loggedInContext,
            List<ValidationMessages> validationMessages)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "UploadFileRepository"));

                IMongoCollection<FileApiReturnModel> fileCollections = GetMongoCollectionObject<FileApiReturnModel>(MongoDBCollectionConstants.DocumentsCollection);

                var fBuilder = Builders<FileApiReturnModel>.Filter;
                var filters = new List<FilterDefinition<FileApiReturnModel>>();
                FileApiReturnModel filteredResult = new FileApiReturnModel();

                var filter = new List<BsonDocument>
                {
                    new BsonDocument("IsArchived", false)
                };
                if (fileId != null)
                {
                    filters.Add(fBuilder.Eq("DocumentId", fileId.ToString()));
                }
                if (!string.IsNullOrEmpty(fileName))
                {
                    filters.Add(fBuilder.Eq("FileName", fileName.ToString()));
                }
                var filterObject = fBuilder.And(filters);
                filteredResult = fileCollections.Find(filterObject)
                    .FirstOrDefault();
                return filteredResult;

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFilesFromFolder", "UploadFileRepository", exception.Message), exception);
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
