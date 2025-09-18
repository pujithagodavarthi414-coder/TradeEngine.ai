using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Models.CompanyStructure;
using DocumentStorageService.Models.FileStore;
using Microsoft.Azure;
using Microsoft.Extensions.Configuration;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using static DocumentStorageService.Models.Enumerators;

namespace DocumentStorageService.Services.FileStore
{
    public class FileStoreService : IFileStoreService
    {
        IConfiguration _iconfiguration;
        public FileStoreService(IConfiguration iConfiguration)
        {
            _iconfiguration = iConfiguration;
        }
        public string PostFileAsChunks(FilePostInputModel filePostInputModel)
        {
            LoggingManager.Debug("Entering into PostFile method of blob service");

            CloudBlobContainer container = SetupFileContainer();

            var fileName = Path.GetFileName(filePostInputModel.FileName);

            using (MemoryStream memoryStream = new MemoryStream(filePostInputModel.MemoryStream))
            {
                if (fileName != null)
                {
                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = Path.GetExtension(fileName);

                    var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                    string id = Convert.ToBase64String(Encoding.ASCII.GetBytes($"BlockId{filePostInputModel.ChunkId:0000000}"));

                    var convertedFileName = fileNameWithOutExtension + fileExtension;

                    CloudBlockBlob blockBlob = container.GetBlockBlobReference(convertedFileName);
                    blockBlob.Properties.ContentType = filePostInputModel.ContentType;
                    blockBlob.Properties.CacheControl = "public, max-age=2592000";
                    blockBlob.PutBlockAsync(id, memoryStream, null);
                    var fileurl = id;

                    LoggingManager.Debug("Exit from PostFile method of blob service");

                    return fileurl;
                }

                return null;
            }
        }
        public string UploadFiles(BtrakPostedFile filePostInputModel, CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId)
        {
            try
            {
                LoggingManager.Debug("Entering into PostFile method of blob service");

                var directory = SetupCompanyFileContainer(companyModel, moduleTypeId, loggedInUserId);

                var fileName = Path.GetFileNameWithoutExtension(filePostInputModel.FileName);

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName.Replace(" ", "_");

                var fileExtension = Path.GetExtension(filePostInputModel.FileName);

                var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() + fileExtension;

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.ContentType = filePostInputModel.ContentType;

                blockBlob.Properties.CacheControl = "public, max-age=2592000";

                blockBlob.UploadFromStreamAsync(filePostInputModel.InputStream);

                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                return fileurl;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", "FileStoreService ", exception.Message), exception);

                throw;
            }
        }
        private CloudBlobContainer SetupFileContainer()
        {
            LoggingManager.Debug("Entering into SetupFileContainer method of blob service");

            CloudStorageAccount storageAccount = StorageAccount();

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            string containerReference = AppConstants.LocalBlobContainerReference;

            var container = blobClient.GetContainerReference(containerReference);

            container.CreateIfNotExistsAsync();

            container.SetPermissionsAsync(new BlobContainerPermissions
            {
                PublicAccess = BlobContainerPublicAccessType.Blob
            });

            LoggingManager.Debug("Exit from SetupFileContainer method of blob service");

            return container;
        }
        private CloudBlobDirectory SetupCompanyFileContainer(CompanyOutputModel companyOutputModel, int moduleTypeId, Guid loggedInUserId)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount();

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            companyOutputModel.CompanyName = companyOutputModel.CompanyName.Replace(" ", string.Empty);

            string company = (companyOutputModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(company);

            try
            {
                var isCreated = container.CreateIfNotExistsAsync();
                if (isCreated.Result)
                {
                    LoggingManager.Debug($"Created container {container.Name}");

                    container.SetPermissionsAsync(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }

            catch (StorageException storageException)
            {

                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetupCompanyFileContainer", "FileStoreService ", storageException.Message), storageException);

                throw;
            }

            string directoryReference = moduleTypeId == (int)ModuleTypeEnum.Hrm ? AppConstants.HrmBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Assets ? AppConstants.AssetsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.FoodOrder ? AppConstants.FoodOrderBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Projects ? AppConstants.ProjectsBlobDirectoryReference :
                 moduleTypeId == (int)ModuleTypeEnum.Cron ? AppConstants.ProjectsBlobDirectoryReference : AppConstants.LocalBlobContainerReference;

            CloudBlobDirectory moduleDirectory = container.GetDirectoryReference(directoryReference);

            CloudBlobDirectory userLevelDirectory = moduleDirectory.GetDirectoryReference(loggedInUserId.ToString());

            return userLevelDirectory;
        }
        private CloudStorageAccount StorageAccount()
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");

            string account = CloudConfigurationManager.GetSetting(_iconfiguration["StorageAccountName"]);
            string key = CloudConfigurationManager.GetSetting(_iconfiguration["StorageAccountAccessKey"]);
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public byte[] DownloadFile(string filePath)
        {
            byte[] buffer = null;

            if (filePath != null)
            {
                using (var client = new WebClient())
                {
                    var content = client.DownloadData(filePath);
                    using (var stream = new MemoryStream(content))
                    {
                        int length = (int)stream.Length;

                        using (BinaryReader br = new BinaryReader(stream))
                        {
                            buffer = br.ReadBytes(length);
                        }
                    }
                }
            }

            return buffer;
        }
    }
}
