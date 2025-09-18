using System;
using System.IO;
using System.Net;
using System.Web;
using Btrak.Models;
using BTrak.Common;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Microsoft.Azure;
using Btrak.Models.CompanyStructure;
using System.Collections.Generic;
using static BTrak.Common.Enumerators;
using Btrak.Models.Widgets;
using System.Text;
using Btrak.Models.ActivityTracker;
using Btrak.Models.File;
using Btrak.Dapper.Dal.Repositories;
using System.Text.RegularExpressions;

namespace Btrak.Services.FileUploadDownload
{
    public class FileStoreService : IFileStoreService
    {

        public string PostFile(FilePostInputModel filePostInputModel)
        {
            LoggingManager.Debug("Entering into PostFile method of blob service");

            CloudBlobContainer container = SetupFileContainer();

            var fileName = Path.GetFileName(filePostInputModel.FileName);

            using (MemoryStream memoryStream = new MemoryStream(filePostInputModel.MemoryStream))
            {
                if (fileName != null)
                {
                    //var fileConfig = new FileRepository().GetFileSystemConfiguration(, null);

                    fileName = fileName.Replace(" ", "_");

                    var fileExtension = Path.GetExtension(fileName);

                    var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                    var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() +
                                            fileExtension;

                    CloudBlockBlob blockBlob = container.GetBlockBlobReference(convertedFileName);
                    blockBlob.Properties.ContentType = filePostInputModel.ContentType;
                    blockBlob.Properties.CacheControl = "public, max-age=2592000";
                    blockBlob.UploadFromStream(memoryStream);
                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    LoggingManager.Debug("Exit from PostFile method of blob service");
                    return fileurl;
                }

                return null;
            }
        }

        public string CombineChunksAndReturnFileUrl(string fileName, string[] ids, string fileType)
        {
            LoggingManager.Info("CombineChunksAndReturnFileUrl fileName: " + fileName);

            fileName = fileName.Replace(" ", "_");

            var fileExtension = Path.GetExtension(fileName);

            var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

            CloudBlobContainer container = SetupFileContainer();

            var convertedFileName = fileNameWithOutExtension + fileExtension;

            CloudBlockBlob blockBlob = container.GetBlockBlobReference(convertedFileName);

            blockBlob.Properties.ContentType = fileType;
            blockBlob.Properties.CacheControl = "public, max-age=2592000";
            blockBlob.PutBlockList(ids);

            var fileurl = blockBlob.Uri.AbsoluteUri;
            LoggingManager.Info("CombineChunksAndReturnFileUrl fileurl: " + fileurl);

            return fileurl;
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
                    blockBlob.PutBlock(id, memoryStream, null);
                    var fileurl = id;

                    LoggingManager.Debug("Exit from PostFile method of blob service");

                    return fileurl;
                }

                return null;
            }
        }

        public string PostFiles(HttpPostedFile filePostInputModel)
        {
            LoggingManager.Debug("Entering into PostFile method of blob service");

            var container = SetupFileContainer();

            var fileName = Path.GetFileNameWithoutExtension(filePostInputModel.FileName);

            LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

            fileName = fileName.Replace(" ", "_");

            var fileExtension = Path.GetExtension(filePostInputModel.FileName);

            var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

            var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() + fileExtension;

            CloudBlockBlob blockBlob = container.GetBlockBlobReference(convertedFileName);

            blockBlob.Properties.ContentType = filePostInputModel.ContentType;

            blockBlob.Properties.CacheControl = "public, max-age=2592000";

            blockBlob.UploadFromStream(filePostInputModel.InputStream);

            var fileurl = blockBlob.Uri.AbsoluteUri;

            LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

            return fileurl;
        }

        private CloudBlobContainer SetupFileContainer()
        {
            LoggingManager.Debug("Entering into SetupFileContainer method of blob service");

            CloudStorageAccount storageAccount = StorageAccount();

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            string containerReference = AppConstants.LocalBlobContainerReference;

            var container = blobClient.GetContainerReference(containerReference);

            container.CreateIfNotExists();

            container.SetPermissions(new BlobContainerPermissions
            {
                PublicAccess = BlobContainerPublicAccessType.Blob
            });

            LoggingManager.Debug("Exit from SetupFileContainer method of blob service");

            return container;
        }

        private CloudStorageAccount StorageAccount()
        {
            LoggingManager.Debug("Entering into GetStorageAccount method of blob service");

            string account = CloudConfigurationManager.GetSetting("StorageAccountName");
            string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
            string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
            CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

            LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

            return storageAccount;
        }

        public byte[] DownloadFileWithContentType(string filePath,out WebHeaderCollection contentType)
        {
            byte[] buffer = null;
            contentType = null;

            if (filePath != null)
            {
                using (var client = new WebClient())
                {                   
                    var content = client.DownloadData(filePath);
                    contentType = client.ResponseHeaders;
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

        public FileSystemReturnModel UploadFiles(HttpPostedFile filePostInputModel, CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId)
        {
            try
            {
                var fileReturnData = new FileSystemReturnModel();
                //var fileConfig = new FileRepository().GetFileSystemConfiguration(loggedInUserId, null);
                //fileReturnData.FileSystemTypeEnum = fileConfig.FileSystemTypeEnum;

                //if (fileConfig.FileSystemTypeEnum == FileSystemType.Azure)
                if (true)
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

                    blockBlob.UploadFromStream(filePostInputModel.InputStream);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                    fileReturnData.BlobFilePath = fileurl;
                }
                //else if (fileConfig.FileSystemTypeEnum == FileSystemType.Local)
                //{
                //    fileReturnData.LocalFilePath = SaveFileIntoLocalPath(fileConfig, filePostInputModel);
                //}

                return fileReturnData;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", "FileStoreService ", exception.Message), exception);

                throw;
            }
        }
        public FileDetailsModel UploadFilesUsingBase64(CompanyOutputModel companyModel, FileDataForBase64 file, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                FileDetailsModel fileUrls = new FileDetailsModel();
                LoggingManager.Debug("Entering into PostFile method of blob service");

                var directory = SetupCompanyFileContainer(companyModel, 5, loggedInContext.LoggedInUserId);

                var fileName = file.FileName;

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName?.Replace(" ", "_");

                var fileExtension = file.ContentType;

                var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                    var convertedFileName = fileNameWithOutExtension +"."+fileExtension;

                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                    blockBlob.Properties.CacheControl = "public, max-age=2592000";

                    string[] filebytes = file.Base64.Split(',');

                    string[] fileContent = filebytes[0].Split(':');

                    string[] fileContentType = fileContent[1].Split(';');

                    blockBlob.Properties.ContentType = fileContentType[0];

                    Byte[] bytes = Convert.FromBase64String(filebytes[1]);

                    blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                    fileUrls=new FileDetailsModel
                    {
                        FileName = file.FileName,
                        FileUrl = fileurl,
                        Filetype = file.ContentType
                    };

                return fileUrls;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", "FileStoreService ", exception.Message), exception);

                throw;
            }
        }

        public string UploadActivityTrackerScreenShotInBlob(InsertUserActivityScreenShotInputModel filePostInputModel, CompanyOutputModel companyModel, Guid loggedInUserId)
        {
            try
            {
                LoggingManager.Debug("Entering into PostFile method of blob service");

                var directory = SetupActivityTrackerScreeShotFileContainer(companyModel, loggedInUserId);

                var fileName = Path.GetFileNameWithoutExtension(filePostInputModel.FileName);

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName.Replace(" ", "_");

                var fileExtension = Path.GetExtension(filePostInputModel.FileName);

                var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() + fileExtension;

                CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                blockBlob.Properties.ContentType = filePostInputModel.FileType;

                blockBlob.Properties.CacheControl = "public, max-age=2592000";
                using (MemoryStream memoryStream = new MemoryStream(filePostInputModel.FileStream))
                {
                    blockBlob.UploadFromStream(memoryStream);
                }
                var fileurl = blockBlob.Uri.AbsoluteUri;

                LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                return fileurl;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadActivityTrackerScreenShotInBlob", "FileStoreService ", exception.Message), exception);

                throw;
            }
        }

        public List<FileDetailsModel> UploadFiles(CompanyOutputModel companyModel, CronExpressionInputModel cronExpressionInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<FileDetailsModel> fileUrls = new List<FileDetailsModel>();

                LoggingManager.Debug("Entering into PostFile method of blob service");

                var directory = SetupCompanyFileContainer(companyModel, 5, loggedInContext.LoggedInUserId);

                var fileName = Path.GetFileNameWithoutExtension(cronExpressionInputModel.CronExpressionName);

                LoggingManager.Debug("UploadCourseFile input fileName:" + fileName);

                fileName = fileName?.Replace(" ", "_");

                var fileExtension = Path.GetExtension(cronExpressionInputModel.CronExpressionName);

                var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

                foreach (var fileByte in cronExpressionInputModel.FileBytes)
                {
                    var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() + fileExtension;

                    CloudBlockBlob blockBlob = directory.GetBlockBlobReference(convertedFileName);

                    blockBlob.Properties.CacheControl = "public, max-age=2592000";

                    string[] filebytes = fileByte.FileByteStrings.Split(',');

                    string[] fileContent = filebytes[0].Split(':');

                    string[] fileContentType = fileContent[1].Split(';');

                    blockBlob.Properties.ContentType = fileContentType[0];

                    Byte[] bytes = Convert.FromBase64String(filebytes[1]);

                    blockBlob.UploadFromByteArray(bytes, 0, bytes.Length);

                    var fileurl = blockBlob.Uri.AbsoluteUri;

                    LoggingManager.Debug("UploadCourseFile returned: " + fileurl);

                    fileUrls.Add(new FileDetailsModel
                    {
                        FileName = fileByte.VisualizationName,
                        FileUrl = fileurl,
                        Filetype = blockBlob.Properties.ContentType
                    });
                }

                return fileUrls;
            }

            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadFiles", "FileStoreService ", exception.Message), exception);

                throw;
            }
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
                bool isCreated = container.CreateIfNotExists();
                if (isCreated)
                {
                    LoggingManager.Debug($"Created container {container.Name}");

                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }

            catch (StorageException storageException)
            {
             
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetupCompanyFileContainer", "FileStoreService ",storageException .Message), storageException);

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

        private CloudBlobDirectory SetupActivityTrackerScreeShotFileContainer(CompanyOutputModel companyOutputModel, Guid loggedInUserId)
        {
            LoggingManager.Info("SetupCompanyFileContainer");

            CloudStorageAccount storageAccount = StorageAccount();

            CloudBlobClient blobClient = storageAccount.CreateCloudBlobClient();

            companyOutputModel.CompanyName = companyOutputModel.CompanyName.Replace(" ", string.Empty);

            string company = (companyOutputModel.CompanyId.ToString()).ToLower();

            CloudBlobContainer container = blobClient.GetContainerReference(AppConstants.ActivityTrackerBlobContainerName);

            try
            {
                bool isCreated = container.CreateIfNotExists();
                if (isCreated)
                {
                    LoggingManager.Debug($"Created container {container.Name}");

                    container.SetPermissions(new BlobContainerPermissions
                    {
                        PublicAccess = BlobContainerPublicAccessType.Blob
                    });
                }
            }

            catch (StorageException storageException)
            {
                
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetupActivityTrackerScreeShotFileContainer", "FileStoreService ", storageException.Message), storageException);

                throw;
            }


            CloudBlobDirectory companyDirectory = container.GetDirectoryReference(company);

            CloudBlobDirectory userLevelDirectory = companyDirectory.GetDirectoryReference(loggedInUserId.ToString());

            CloudBlobDirectory dateLevelDirectory = userLevelDirectory.GetDirectoryReference(DateTime.Now.ToString("dd MMM yyyy"));

            return dateLevelDirectory;
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

                blockBlob.UploadFromStream(filePostInputModel.InputStream);

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

        public string SaveFileIntoLocalPath(FileSystemConfigModel fileConfig, HttpPostedFile filePostInputModel)
        {
            var directory = GetDirectory(fileConfig);

            var fileName = Path.GetFileNameWithoutExtension(filePostInputModel.FileName);
            fileName = Regex.Replace(fileName, "[^a-zA-Z0-9\\s.]", "_");
            fileName = $"{Path.GetFileNameWithoutExtension(fileName)}-{Guid.NewGuid()}{Path.GetExtension(filePostInputModel.FileName)}";

            var fullPath = $"{directory}\\{fileName}";
            return SaveFile(fullPath, filePostInputModel.InputStream);
        }

        public string GetDirectory(FileSystemConfigModel fileConfig)
        {
            var path = Path.GetFullPath(fileConfig.LocalFileBasePath);
            path = Path.GetFullPath($"{path}/{fileConfig.EnvironmenName}/{fileConfig.CompanyName}/{fileConfig.ModuleType}");
            Directory.CreateDirectory(path);
            return path;
        }

        public string SaveFile(string path, Stream stream)
        {
            using (var fileStream = new FileStream(path, FileMode.Create))
            {
                stream.Seek(0, SeekOrigin.Begin);
                stream.CopyTo(fileStream);
            }

            return path;
        }
    }
}