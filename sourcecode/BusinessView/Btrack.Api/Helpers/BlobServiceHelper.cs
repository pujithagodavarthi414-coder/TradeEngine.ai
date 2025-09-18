
//using BTrak.Common;
//using BusinessView.Services.Interfaces;
//using System;
//using Microsoft.Azure;
//using Microsoft.WindowsAzure.Storage;
//using Microsoft.WindowsAzure.Storage.Blob;
//using System.Web;
//using System.IO;
//namespace Btrak.Api.Helpers
//{
//    public class BlobServiceHelper
//    {
//        private CloudStorageAccount _storageAccount;

//        public string PostFile(HttpPostedFile imagefile)
//        {
//            try
//            {
//                LoggingManager.Info("Entering into PostFile method of blob service");

//                CloudBlobContainer container = SetupFileContainer();

//                var fileName = Path.GetFileName(imagefile.FileName);

//                fileName = fileName.Replace(" ", "_");

//                var fileExtension = Path.GetExtension(fileName);

//                var fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName);

//                var convertedFileName = fileNameWithOutExtension + "-" + Guid.NewGuid() +
//                                        fileExtension;

//                CloudBlockBlob blockBlob = container.GetBlockBlobReference(convertedFileName);
//                blockBlob.Properties.ContentType = imagefile.ContentType;
//                blockBlob.Properties.CacheControl = "public, max-age=2592000";
//                blockBlob.UploadFromStream(imagefile.InputStream);
//                var fileurl = blockBlob.Uri.AbsoluteUri;

//                LoggingManager.Info("Exit from PostFile method of blob service");

//                return fileurl;
//            }
//            catch (Exception exception)
//            {
//                LoggingManager.Error("Exception occurred while uploading file" + exception);
//                throw;
//            }
//        }

//        private CloudBlobContainer SetupFileContainer()
//        {
//            try
//            {
//                LoggingManager.Info("Entering into SetupFileContainer method of blob service");

//                _storageAccount = GetStorageAccount();

//                CloudBlobClient blobClient = _storageAccount.CreateCloudBlobClient();

//                string containerReference = AppConstants.LocalBlobContainerReference;

//                var container = blobClient.GetContainerReference(containerReference);

//                container.CreateIfNotExists();

//                container.SetPermissions(new BlobContainerPermissions
//                {
//                    PublicAccess = BlobContainerPublicAccessType.Blob
//                });

//                LoggingManager.Info("Exit from SetupFileContainer method of blob service");

//                return container;
//            }
//            catch (Exception exception)
//            {
//                LoggingManager.Error("Exception occurred while uploading file" + exception);
//                throw;
//            }
//        }

//        private CloudStorageAccount GetStorageAccount()
//        {
//            try
//            {
//                LoggingManager.Info("Entering into GetStorageAccount method of blob service");

//                string account = CloudConfigurationManager.GetSetting("StorageAccountName");
//                string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
//                string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
//                _storageAccount = CloudStorageAccount.Parse(connectionString);

//                LoggingManager.Info("Exit from GetStorageAccount method of blob service");

//                return _storageAccount;
//            }
//            catch (Exception exception)
//            {
//                LoggingManager.Error("Exception occurred while uploading file" + exception);
//                throw;
//            }
//        }
//    }
//}