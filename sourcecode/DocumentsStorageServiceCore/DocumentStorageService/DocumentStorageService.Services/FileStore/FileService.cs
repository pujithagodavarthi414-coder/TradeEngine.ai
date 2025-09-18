
using DocumentStorageService.Models;
using DocumentStorageService.Models.CompanyStructure;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Repositories.FileStore;
using DocumentStorageService.Services.Helpers;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.WindowsAzure.Storage;
using Microsoft.Extensions.Configuration;
using DocumentStorageService.Common;
using System.Net;
using DocumentStorageService.Helpers.Constants;
using SharpCompress.Common;

namespace DocumentStorageService.Services.FileStore
{
    public class FileService : IFileService
    {
        private readonly IFileStoreService _fileStoreService;
        private readonly FileRepository _fileRepository;
        private readonly StoreRepository _storeRepository;
        private IWebHostEnvironment _hostingEnvironment;
        IConfiguration _iconfiguration;
        private readonly IFileUploadService _fileService;
        public FileService(IFileStoreService fileStoreService, FileRepository fileRepository, StoreRepository storeRepository, IWebHostEnvironment environment, IConfiguration iConfiguration, IFileUploadService fileService)
        {
            _fileStoreService = fileStoreService;
            _fileRepository = fileRepository;
            _storeRepository = storeRepository;
            _hostingEnvironment = environment;
            _iconfiguration = iConfiguration;
            _fileService = fileService;
        }
        public Guid? ArchiveFolder(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFolder", "FileService"));

            List<SearchFolderOutputModel> searchFolderModel =
                _fileRepository.GetParentAndChildFolders(folderId, loggedInContext, validationMessages);
            if (searchFolderModel.Count > 0)
            {
                foreach (var folder in searchFolderModel)
                {
                    Guid? deleteFolderId = _fileRepository.ArchiveFolder(folder.Id, loggedInContext, validationMessages);
                    List<UploadFileReturnModel> uploadFileList =
                        _fileRepository.GetFilesFromFolder(folderId, loggedInContext, validationMessages);
                    foreach (var uploadFile in uploadFileList)
                    {
                        Guid? fileId =
                            _fileRepository.ArchiveFile(uploadFile.Id, loggedInContext, validationMessages);
                    }
                }
                Task.Factory.StartNew(() =>
                {
                    DecrementFolderAndStoreSize(searchFolderModel, folderId, loggedInContext);
                });
            }

            return folderId;
        }

        public Guid? CreateFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder",
               "FileService"));
            Guid? customFolderId = null;
            Guid? folderId = null;
            Guid? parentFolderId = null;
            if (upsertFolderInputModel.FolderId == Guid.Empty)
            {
                upsertFolderInputModel.FolderId = null;
            }

            if (upsertFolderInputModel.FolderReferenceId == Guid.Empty)
            {
                upsertFolderInputModel.FolderReferenceId = null;
            }

            if (upsertFolderInputModel.FolderReferenceTypeId == Guid.Empty)
            {
                upsertFolderInputModel.FolderReferenceTypeId = null;
            }

            if (upsertFolderInputModel.StoreId == Guid.Empty)
            {
                upsertFolderInputModel.StoreId = null;
            }

            if (!FolderValidations.ValidateUpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            foreach (var folderName in upsertFolderInputModel.ParentFolderNames)
            {
                var folderSearchInputModel = new SearchFolderInputModel();
                folderSearchInputModel.FolderName = folderName;
                folderSearchInputModel.StoreId = upsertFolderInputModel.StoreId;
                folderSearchInputModel.FolderReferenceTypeId = upsertFolderInputModel.FolderReferenceTypeId;
                folderSearchInputModel.IsArchived = false;
                SearchFolderOutputModel folderOutputModel = _fileRepository
                    .SearchFolders(folderSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
                if (folderOutputModel == null)
                {
                    folderId = Guid.NewGuid();
                    var parentFolderInputModel = new UpsertFolderInputModel();
                    parentFolderInputModel.FolderName = folderName;
                    parentFolderInputModel.StoreId = upsertFolderInputModel.StoreId;
                    parentFolderInputModel.ParentFolderId = parentFolderId;
                    parentFolderInputModel.FolderReferenceId = upsertFolderInputModel.FolderReferenceId;
                    parentFolderInputModel.FolderReferenceTypeId = upsertFolderInputModel.FolderReferenceTypeId;
                    FolderCollectionModel folderCollectionModel =
                        FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(parentFolderInputModel);
                    folderCollectionModel.Id = folderId;
                    folderCollectionModel.CreatedDateTime = DateTime.UtcNow;
                    folderCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                    Guid? createdFolderId = _fileRepository.CreateFolder(folderCollectionModel,
                        loggedInContext, validationMessages);
                    parentFolderId = folderId;
                }
                else
                {
                    parentFolderId = folderOutputModel.Id;
                }
            }

            if (upsertFolderInputModel.ParentFolderId == null)
            {
                upsertFolderInputModel.ParentFolderId = parentFolderId;
            }
            FolderCollectionModel childCollectionModel =
                FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel);
            childCollectionModel.Id = Guid.NewGuid();
            childCollectionModel.CreatedDateTime = DateTime.UtcNow;
            childCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
            customFolderId = _fileRepository.CreateFolder(childCollectionModel,
                loggedInContext, validationMessages);


            return customFolderId;
        }

        public SearchFolderOutputModel SearchFolder(SearchFolderInputModel searchFolderInputModel,
           LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchFolder." + "SearchFolderInputModel=" + searchFolderInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            SearchFolderOutputModel fileApiReturnModels = _fileRepository.SearchFoldersAndFiles(searchFolderInputModel, loggedInContext, validationMessages);
            return fileApiReturnModels;
        }

        public string FolderTreeView(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to FolderTreeView." + "SearchFolderInputModel=" + searchFolderInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            var folderJson = "";

            List<FolderTreeStructureModel> folderTreeStructureModels = _fileRepository.FolderTreeView(searchFolderInputModel, loggedInContext, validationMessages);
            foreach (FolderTreeStructureModel folder in folderTreeStructureModels)
            {
                if (folder.FileId == null)
                {
                    var folders = folderTreeStructureModels.Where(x => ((x.FileId == null && x.ParentFolderId == folder.FolderId) || (x.FileId != null && x.FolderId == folder.FolderId))).ToList();
                    if (folders.Count() > 0)
                    {
                        folder.Children = new List<FolderTreeStructureModel>();
                        folder.Children.AddRange(folderTreeStructureModels.Where(x => ((x.FileId == null && x.ParentFolderId == folder.FolderId) || (x.FileId != null && x.FolderId == folder.FolderId && folder.FileId == null))).ToList());
                    }
                }
            }
            var folderList = new List<FolderTreeStructureModel>();
            foreach (var n in folderTreeStructureModels)
            {
                if (n.FileId == null)
                {
                    int i = 0;
                    foreach (var j in folderTreeStructureModels)
                    {
                        if ((n.ParentFolderId == j.FolderId && j.FileId == null) || (n.ParentFolderId != null && j.FolderId == null))
                        {
                            i = i + 1;
                        }
                    }
                    if (i == 0)
                    {
                        folderList.Add(n);
                    }
                }

            }

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
                NullValueHandling = NullValueHandling.Ignore
            };

            folderJson = JsonConvert.SerializeObject(folderList, settings);

            return folderJson;
        }

        public Guid? UpdateFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolder",
                "FileService"));

            if (!FolderValidations.ValidateUpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            FolderCollectionModel updateFolderCollectionModel = FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(
                upsertFolderInputModel ?? new UpsertFolderInputModel());
            updateFolderCollectionModel.Id = upsertFolderInputModel.FolderId;
            updateFolderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            Guid? folderId = _fileRepository.UpdateFolder(updateFolderCollectionModel, loggedInContext, validationMessages);
            return folderId;
        }

        public Guid? UpdateFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdateFolderDescription",
                "FileService"));

            FolderCollectionModel updateFolderCollectionModel = FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(
                upsertFolderInputModel ?? new UpsertFolderInputModel());
            updateFolderCollectionModel.Id = upsertFolderInputModel.FolderId;
            updateFolderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
            Guid? folderId = _fileRepository.UpdateFolderDescription(updateFolderCollectionModel, loggedInContext, validationMessages);
            return folderId;
        }


        public async Task UploadFilesChunk(IFormFile file, int id, int moduleTypeId, string fileName, string contentType, Guid? parentDocumentId, LoggedInContext loggedInContext, IHttpContextAccessor httpContextAccessor, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UploadFilesChunk", "file", "", "BlobService"));
            byte[] bytes;
            var chunkId = Convert.ToBase64String(Encoding.UTF8.GetBytes(id.ToString("d6")));
            try
            {
                var companyModel = new CompanyOutputModel();
                string serviceUrl = RouteConstants.GetCompanyById;
                var configurationUrl = _iconfiguration["AuthenticationServerApiUrl"];
                MemoryStream ms = new MemoryStream();
                var fileStream = file.OpenReadStream();
                fileStream.CopyTo(ms);
                bytes = ms.ToArray();
                List<ParamsInputModel> paramsInput = new List<ParamsInputModel>();
                var paramsInputModel = new ParamsInputModel();
                paramsInputModel.Key = "CompanyId";
                paramsInputModel.Type = "Guid?";
                paramsInputModel.Value = loggedInContext.CompanyGuid;
                paramsInput.Add(paramsInputModel);
                var result = ApiWrapper.GetApiCallsWithAuthorisation(serviceUrl, configurationUrl, paramsInput, httpContextAccessor).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    companyModel = JsonConvert.DeserializeObject<CompanyOutputModel>(jsonResponse);

                }
                var _task = Task.Run(() => this.UploadFileToBlobAsync(fileName, bytes, companyModel, parentDocumentId, loggedInContext, contentType, moduleTypeId, chunkId));
                _task.Wait();
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", " BlobService", ex.Message), ex);
            }
        }

        public async Task UploadFileToBlobAsync(string strFileName, byte[] fileData, CompanyOutputModel companyModel, Guid? parentDocumentId, LoggedInContext loggedInContext, string contentType, int moduleTypeId, string chunkId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UploadFileToBlobAsync", "file", "", "BlobService"));
                List<ValidationMessages> validationMessages = new List<ValidationMessages>();
                string versionNames = "";
                if (parentDocumentId != null)
                {
                    FileApiReturnModel fileDetails =
                   _fileRepository.GetFileDetails(parentDocumentId,strFileName, loggedInContext, validationMessages);
                    if (fileDetails != null)
                    {
                        int? versionsList = fileDetails.Versions.Count;
                        versionNames = "version-" + versionsList + 1;
                    }
                    else
                    {
                        versionNames = "version-1";
                    }
                }
                else
                {
                    versionNames = "version-1";
                }

                CloudBlobDirectory directory = SetupCompanyFileContainer(companyModel, moduleTypeId, parentDocumentId, versionNames, loggedInContext.LoggedInUserId);
                if (strFileName != null)
                {
                    strFileName = strFileName.Replace(" ", "_");

                    var fileExtension = Path.GetExtension(strFileName);

                    var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(strFileName);
                    var convertedFileName = fileNameWithOutExtension + fileExtension;
                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);
                    blockBlob.Properties.ContentType = contentType;
                    await blockBlob.PutBlockAsync(chunkId, new MemoryStream(fileData), null);
                }


            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileToBlobAsync", " BlobService", exception.Message), exception);
            }

        }

        public string GetChunkBlobUrl(string fileName, int moduleTypeId, string[] ids, string contentType, Guid? parentDocumentId, LoggedInContext loggedInContext, IHttpContextAccessor httpContextAccessor)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetChunkBlobUrl", "", "", "BlobService"));
            string fileurl = "";
            string versionNames = "";
            var companyModel = new CompanyOutputModel();
            string serviceUrl = RouteConstants.GetCompanyById;
            var configurationUrl = _iconfiguration["AuthenticationServerApiUrl"];

            List<ValidationMessages> validationMessages = new List<ValidationMessages>();
            try
            {
                if (parentDocumentId != null)
                {
                    FileApiReturnModel fileDetails =
                       _fileRepository.GetFileDetails(parentDocumentId,fileName, loggedInContext, validationMessages);
                    if (fileDetails != null)
                    {
                        int? versionsList = (fileDetails.VersionNumber) + 1;
                        versionNames = "version-" + versionsList;
                    }
                    else
                    {
                        versionNames = "version-1";
                    }
                }
                else
                {
                    versionNames = "version-1";
                }

                List<ParamsInputModel> paramsInput = new List<ParamsInputModel>();
                var paramsInputModel = new ParamsInputModel();
                paramsInputModel.Key = "CompanyId";
                paramsInputModel.Type = "Guid?";
                paramsInputModel.Value = loggedInContext.CompanyGuid;
                paramsInput.Add(paramsInputModel);
                var result = ApiWrapper.GetApiCallsWithAuthorisation(serviceUrl, configurationUrl, paramsInput, httpContextAccessor).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    companyModel = JsonConvert.DeserializeObject<CompanyOutputModel>(jsonResponse);

                }
                CloudBlobDirectory directory = SetupCompanyFileContainer(companyModel, moduleTypeId, parentDocumentId, versionNames, loggedInContext.LoggedInUserId);
                if (fileName != null)
                {
                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = Path.GetExtension(fileName);

                    var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);
                    var convertedFileName = fileNameWithOutExtension + fileExtension;
                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);
                    blockBlob.Properties.ContentType = contentType;
                    blockBlob.PutBlockListAsync(ids);
                    fileurl = blockBlob.Uri.AbsoluteUri.ToString();
                }

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFileToBlobAsync", " BlobService", exception.Message), exception);
            }

            return fileurl;
        }

        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyOutputModel, int moduleTypeId, Guid? parentDocumentId, string versionNames, Guid loggedInUserId)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount();

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();
            string company = null;

            if (companyOutputModel != null)
            {
                companyOutputModel.CompanyName = companyOutputModel.CompanyName.Replace(" ", string.Empty);
                company = (companyOutputModel.CompanyId.ToString()).ToLower();
            }

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                container.CreateIfNotExistsAsync();
                LoggingManager.Debug($"Created container {container.Name}");

                container.SetPermissionsAsync(new BlobContainerPermissions
                {
                    PublicAccess = BlobContainerPublicAccessType.Blob
                });
            }

            catch (StorageException storageException)
            {

                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetupCompanyFileContainer", "FileStoreService ", storageException.Message), storageException);

                throw;
            }



            string directoryReference = moduleTypeId == (int)Enumerators.ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)Enumerators.ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)Enumerators.ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)Enumerators.ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)Enumerators.ModuleTypeEnum.Cron ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            if (parentDocumentId != null)
            {
                CloudBlobDirectory parentLevelDirectory =
               userLevelDirectory.GetDirectoryReference(parentDocumentId.ToString());

                CloudBlobDirectory versionLevelDirectory =
                    parentLevelDirectory.GetDirectoryReference(versionNames.ToString());
                return versionLevelDirectory;
            }
            else
            {
                CloudBlobDirectory versionLevelDirectory =
                   userLevelDirectory.GetDirectoryReference(versionNames.ToString());
                return versionLevelDirectory;
            }

        }
        private CloudStorageAccount StorageAccount()
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");

            string account = _iconfiguration.GetValue<string>("StorageAccountName");
            string key = _iconfiguration.GetValue<string>("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public void DecrementFolderAndStoreSize(List<SearchFolderOutputModel> upsertFolderAndStoreSizeModel, Guid? folderId, LoggedInContext loggedInContext)
        {
            List<ValidationMessage> validationMessages = new List<ValidationMessage>();
            var filteredResult = new SearchFolderOutputModel();

            if (upsertFolderAndStoreSizeModel.Count > 0)
            {
                filteredResult = upsertFolderAndStoreSizeModel.Where(x => x.Id == folderId).FirstOrDefault();
            }

            if (filteredResult != null)
            {
                foreach (var folderData in upsertFolderAndStoreSizeModel)
                {
                    if (folderData.FolderSize == null)
                    {
                        folderData.FolderSize = 0;
                    }
                    var folderSize = folderData.FolderSize - filteredResult.FolderSize;
                    var upsertFolderInputModel = new UpsertFolderInputModel();
                    upsertFolderInputModel.FolderId = folderData.ParentFolderId;
                    upsertFolderInputModel.Size = folderSize;
                    FolderCollectionModel folderCollectionModel =
                        FolderModelConverter.ConvertFolderUpsertInputModelToCollectionModel(upsertFolderInputModel);
                    folderCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                    Guid? updateFolderId = _fileRepository.UpdateFolderSize(folderCollectionModel, loggedInContext, validationMessages);

                }

                if (filteredResult.StoreId != null)
                {
                    var storeInputModel = new StoreInputModel();
                    var storeSearchCriteriaInputModel = new StoreCriteriaSearchInputModel();
                    storeSearchCriteriaInputModel.Id = filteredResult.StoreId;

                    StoreOutputReturnModels storeOutputModel = _storeRepository
                        .SearchStore(storeSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (storeOutputModel != null)
                    {
                        if (storeOutputModel.StoreSize == null)
                        {
                            storeOutputModel.StoreSize = 0;
                        }
                        var storeSize = storeOutputModel.StoreSize - filteredResult.FolderSize;
                        storeInputModel.StoreId = filteredResult.StoreId;
                        storeInputModel.StoreSize = storeSize;
                    }


                    StoreCollectionModel updateStoreSize =
                        StoreModelConverter.ConvertStoreUpsertInputModelToCollectionModel(storeInputModel);
                    updateStoreSize.UpdatedDateTime = DateTime.UtcNow;
                    Guid? storeId =
                        _storeRepository.UpdateStoreSize(updateStoreSize, loggedInContext, validationMessages);
                }
            }
        }

        public string UploadLocalFileToBlob(UploadFileToBlobInputModel uploadFileToBlobInputModel, LoggedInContext loggedInContext, IHttpContextAccessor httpContextAccessor)
        {
            List<ValidationMessages> validationMessages = new List<ValidationMessages>();

            string fileName = uploadFileToBlobInputModel.LocalFilePath.Substring(uploadFileToBlobInputModel.LocalFilePath.LastIndexOf("/") + 1);
            fileName = fileName.Replace("_", " ");
            string contentType = GetContentType(uploadFileToBlobInputModel.LocalFilePath);
            int moduleTypeId = uploadFileToBlobInputModel.ModuleTypeId;
            Guid? parentDocumentId = uploadFileToBlobInputModel.ParentDocumentId;
            byte[] buffer = uploadFileToBlobInputModel.Bytes;

            if (uploadFileToBlobInputModel.Bytes == null)
            {
                buffer = _fileService.DownloadFile(uploadFileToBlobInputModel.LocalFilePath, loggedInContext, new List<ValidationMessage>());
            }
           
            try
            {
                if ((buffer == null || buffer.Length == 0) || fileName == null)
                {
                    return null;
                }
                else
                {
                    var companyModel = new CompanyOutputModel();
                    string serviceUrl = RouteConstants.GetCompanyById;
                    var configurationUrl = _iconfiguration["AuthenticationServerApiUrl"];
                    List<ParamsInputModel> paramsInput = new List<ParamsInputModel>();
                    var paramsInputModel = new ParamsInputModel();
                    paramsInputModel.Key = "CompanyId";
                    paramsInputModel.Type = "Guid?";
                    paramsInputModel.Value = loggedInContext.CompanyGuid;
                    paramsInput.Add(paramsInputModel);
                    var result = ApiWrapper.GetApiCallsWithAuthorisation(serviceUrl, configurationUrl, paramsInput, httpContextAccessor).Result;
                    var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                    if (responseJson.Success)
                    {
                        var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                        companyModel = JsonConvert.DeserializeObject<CompanyOutputModel>(jsonResponse);
                    }

                    string versionNames;
                    if (parentDocumentId != null || !string.IsNullOrEmpty(fileName))
                    {
                        FileApiReturnModel fileDetails =
                           _fileRepository.GetFileDetails(parentDocumentId, fileName, loggedInContext, validationMessages);
                        if (fileDetails != null)
                        {
                            int? versionsList = (fileDetails.VersionNumber) + 1;
                            versionNames = "version-" + versionsList;
                        }
                        else
                        {
                            versionNames = "version-1";
                        }
                    }
                    else
                    {
                        versionNames = "version-1";
                    }

                    CloudBlobDirectory directory = SetupCompanyFileContainer(companyModel, moduleTypeId, parentDocumentId, versionNames, loggedInContext.LoggedInUserId);
                    fileName = fileName.Replace(" ", "_");
                    var fileExtension = Path.GetExtension(fileName);
                    var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);
                    var convertedFileName = fileNameWithOutExtension + fileExtension;
                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);
                    blockBlob.Properties.ContentType = contentType;
                    blockBlob.Properties.CacheControl = "public, max-age=2592000";
                    blockBlob.UploadFromByteArrayAsync(buffer, 0, buffer.Length);
                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                    return fileurl;
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", " BlobService", ex.Message), ex);
            }

            return null;
        }

        private string GetContentType(string filePath)
        {
            
            var fileName = filePath.Substring(filePath.LastIndexOf("/") + 1);
            if(!string.IsNullOrEmpty(fileName))
            {
                var fileExtension = Path.GetExtension(fileName);
                switch (fileExtension)
                {
                    case ".ai":
                        return "application/postscript";
                    case ".aif":
                    case ".aifc":
                    case ".aiff":
                        return "audio/x-aiff";
                    case ".asc":
                        return "text/plain";
                    case ".atom":
                        return "application/atom+xml";
                    case ".au":
                        return "audio/basic";
                    case ".avi":
                        return "video/x-msvideo";
                    case ".bcpio":
                        return "application/x-bcpio";
                    case ".bin":
                    case ".class":
                    case ".dll":
                    case ".dmg":
                    case "dms":
                    case ".exe":
                        return "application/octet-stream";
                    case ".bmp":
                        return "image/bmp";
                    case ".cdf":
                        return "application/x-netcdf";
                    case ".cgm":
                        return "image/cgm";
                    case ".cpio":
                        return "application/x-cpio";
                    case ".cpt":
                        return "application/mac-compactpro";
                    case "csh":
                        return "application/x-csh";
                    case ".css":
                        return "text/css";
                    case ".dcr":
                    case "dir":
                        return "application/x-director";
                    case "dif":
                        return "video/x-dv";
                    case "djv":
                    case ".djvu":
                        return "image/vnd.djvu";
                    case ".doc":
                    case ".docx":
                        return "application/msword";
                    case ".dtd":
                        return "application/xml-dtd";
                    case ".dv":
                        return "video/x-dv";
                    case ".dvi":
                        return "application/x-dvi";
                    case ".dxr":
                        return "application/x-director";
                    case ".eps":
                        return "application/postscript";
                    case ".etx":
                        return "text/x-setext";
                    case ".ez":
                        return "application/andrew-inset";
                    case ".gif":
                        return "image/gif";
                    case ".gram":
                        return "application/srgs";
                    case ".grxml":
                        return "application/srgs+xml";
                    case ".htm":
                    case ".html":
                        return "text/html";
                    case ".ico":
                        return "image/x-icon";
                    case ".ics":
                        return "text/calendar";
                    case ".jp2":
                        return "image/jp2";
                    case ".jpeg":
                        return "image/jpeg";
                    case ".jpg":
                        return "image/jpg";
                    case ".js":
                        return "application/x-javascript";
                    case ".pdf":
                        return "application/pdf";
                    case ".png":
                        return "image/png";
                    case ".ppt":
                        return "application/vnd.ms-powerpoint";
                    case ".svg":
                        return "image/svg+xml";
                    case ".txt":
                        return "text/plain";
                    case ".xls":
                        return "application/vnd.ms-excel";
                    case ".xml":
                    case ".xsl":
                        return "application/xml";
                    case ".zip":
                        return "application/zip";
                    default:
                        return "image/jpg";
                }
            }
            return null;
        }
    }
}
