using Btrak.Models.PolicyReviewTool;
using BTrak.Common;
using Microsoft.Azure;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Web;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Dapper.Dal.Partial;

namespace Btrak.Services.PolicyReviewTool
{
    public class PolicyReviewService : IPolicyReviewService
    {
        private readonly PolicyRepository _policyRepository = new PolicyRepository();
        private readonly PolicyReviewUserRepository _policyReviewUserRepository = new PolicyReviewUserRepository();
        private readonly PolicyReviewAuditRepository _policyReviewAuditRepository = new PolicyReviewAuditRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();

        public void AddOrUpdateNewPolicy(CreateNewPolicyModel createNewPolicyModel, LoggedInContext loggedInContext)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Add Or Update New Policy", "Policy Review Service"));

            PolicyDbEntity policyDbEntity;
            Guid policyId = new Guid();

            if (createNewPolicyModel.Id == Guid.Empty)
            {
                policyDbEntity = new PolicyDbEntity
                {
                    Id = Guid.NewGuid(),
                    RefId = createNewPolicyModel.RefId,
                    Description = createNewPolicyModel.Description,
                    PdfFileBlobPath = createNewPolicyModel.PdfFileBlobPath,
                    WordFileBlobPath = createNewPolicyModel.WordFileBlobPath,
                    ReviewDate = createNewPolicyModel.ReviewDate,
                    CategoryId = createNewPolicyModel.CategoryId,
                    MustRead = createNewPolicyModel.MustRead,
                    CreatedDateTime = DateTime.Now,
                    CreatedByUserId = loggedInContext.LoggedInUserId
                };
                _policyRepository.Insert(policyDbEntity);
                policyId = policyDbEntity.Id;
            }
            else
            {
                policyDbEntity = _policyRepository.GetPolicy(createNewPolicyModel.Id);

                if (policyDbEntity == null)
                {
                    throw new Exception($"Policy with the given id {createNewPolicyModel.Id} is not found in the database.");
                }

                policyDbEntity.Description = createNewPolicyModel.Description;
                policyDbEntity.PdfFileBlobPath = createNewPolicyModel.PdfFileBlobPath;
                policyDbEntity.WordFileBlobPath = createNewPolicyModel.WordFileBlobPath;
                policyDbEntity.ReviewDate = createNewPolicyModel.ReviewDate;
                policyDbEntity.CategoryId = createNewPolicyModel.CategoryId;
                policyDbEntity.MustRead = createNewPolicyModel.MustRead;
                policyDbEntity.UpdatedDateTime = DateTime.Now;
                policyDbEntity.UpdatedByUserId = loggedInContext.LoggedInUserId;

                _policyRepository.Update(policyDbEntity);



            }
            PolicyReviewUserDbEntity policyReviewUserDbEntity;


            if (createNewPolicyModel.Id == Guid.Empty)
            {
                policyReviewUserDbEntity = new PolicyReviewUserDbEntity
                {
                    Id = Guid.NewGuid(),
                    PolicyId = policyId,
                    HasRead = createNewPolicyModel.HasRead,  // To be Modify
                    StartTime = DateTime.Now, // To be Modify
                    EndTime = DateTime.Now,  // To be Modify
                    UserId = loggedInContext.LoggedInUserId,
                    CreatedDateTime = DateTime.Now,
                    CreatedByUserId = loggedInContext.LoggedInUserId
                };

                _policyReviewUserRepository.Insert(policyReviewUserDbEntity);

            }

            else
            {
                policyReviewUserDbEntity = _policyRepository.GetPolicyReviewUserDetails(createNewPolicyModel.Id);
                if (policyReviewUserDbEntity == null)
                {
                    throw new Exception($"Policy  with the given id {createNewPolicyModel.Id} is not found in the database.");
                }

                policyReviewUserDbEntity.HasRead = createNewPolicyModel.HasRead;
                policyReviewUserDbEntity.StartTime = createNewPolicyModel.StartTime;
                policyReviewUserDbEntity.EndTime = createNewPolicyModel.EndTime;
                policyReviewUserDbEntity.UpdatedDateTime = DateTime.Now;
                policyReviewUserDbEntity.UpdatedByUserId = loggedInContext.LoggedInUserId;

                _policyReviewUserRepository.Update(policyReviewUserDbEntity);
            }

            PolicyReviewAuditDbEntity policyReviewAuditDbEntity;

            if (createNewPolicyModel.Id == Guid.Empty)
            {
                policyReviewAuditDbEntity = new PolicyReviewAuditDbEntity
                {
                    Id = Guid.NewGuid(),
                    PolicyId = policyId,
                    OpenedDate = DateTime.Now,
                    ReadDate = DateTime.Now,  // To be Modify from here to last
                    InsertedDate = DateTime.Now,
                    DeletedDate = DateTime.Now,
                    UpdatedDate = DateTime.Now,
                    PrintedDate = DateTime.Now,
                    DownloadedDate = DateTime.Now,
                    ImportedDate = DateTime.Now,
                    ExportedDate = DateTime.Now,
                    CreatedDateTime = DateTime.Now,
                    CreatedByUserId = loggedInContext.LoggedInUserId
                };
                _policyReviewAuditRepository.Insert(policyReviewAuditDbEntity);

            }
            else
            {
                policyReviewAuditDbEntity = _policyRepository.GetPolicyReviewAuditDetails(createNewPolicyModel.Id);

                policyReviewAuditDbEntity.OpenedDate = createNewPolicyModel.OpenedDate;
                policyReviewAuditDbEntity.ReadDate = createNewPolicyModel.ReadDate;
                policyReviewAuditDbEntity.InsertedDate = createNewPolicyModel.InsertedDate;
                policyReviewAuditDbEntity.DeletedDate = createNewPolicyModel.DeletedDate;
                policyReviewAuditDbEntity.UpdatedDate = DateTime.Now;
                policyReviewAuditDbEntity.PrintedDate = DateTime.Now;
                policyReviewAuditDbEntity.DownloadedDate = DateTime.Now;
                policyReviewAuditDbEntity.ImportedDate = DateTime.Now;
                policyReviewAuditDbEntity.ExportedDate = DateTime.Now;

                _policyReviewAuditRepository.Update(policyReviewAuditDbEntity);
            }
        }

        public List<PolicyDetailsToTable> GetPolicyDetailsToTheTable()
        {
            List<PolicyDetailsToTable> detailsOfPolicy = _policyRepository.GetPolicyDetailsToTheTable();
            return detailsOfPolicy;
        }

        public List<PolicyCategoryDbEntity> GetAllPolicyCategoriesIdAndValue()
        {
            List<PolicyCategoryDbEntity> dropDownList = _policyRepository.GetAllPolicyCategoriesIdAndValue();
            return dropDownList;
        }

        public List<PolicyUsersModel> GetAllPolicyUsersIdAndValue()
        {
            List<PolicyUsersModel> listOfPolicyUsers = _policyRepository.GetAllPolicyUsersIdAndValue();
            return listOfPolicyUsers;
        }


        // Service code for PDF File upload to blob


        public async Task<string> UploadFile(HttpPostedFileBase fileName)
        {
            LoggingManager.Debug("Entering into PostFile method of blob service");

            CloudBlobContainer container = SetupFileContainer();

            string filename = Path.GetFileName(fileName.FileName);           
            string fileExtension = Path.GetExtension(fileName.FileName);
            string fileNameWithOutExtension = Path.GetFileNameWithoutExtension(fileName.FileName);
            

            if(fileNameWithOutExtension != null )
            {
                string name = filename.Replace(" ", "_") + "-" + DateTime.Now.GetHashCode() + fileExtension;
                CloudBlockBlob blockBlob = container.GetBlockBlobReference(name);
                blockBlob.Properties.ContentType = fileName.ContentType;
                blockBlob.Properties.CacheControl = "public, max-age=2592000";
                blockBlob.UploadFromStream(fileName.InputStream);
                string  fileurl =  blockBlob.Uri.AbsoluteUri;

                LoggingManager.Debug("Exit from PostFile method of blob service");

                return  fileurl;

            }
            LoggingManager.Debug("Upload  File returned null");

            return null;

        }




        private CloudBlobContainer SetupFileContainer()
        {
            try
            {
                LoggingManager.Debug("Entering into SetupFileContainer method of blob service");

                CloudStorageAccount storageAccount = GetStorageAccount();

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
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SetupFileContainer", "PolicyReviewService ", exception.Message), exception);

                throw;
            }
        }

        private CloudStorageAccount GetStorageAccount()
        {
            try
            {
                LoggingManager.Debug("Entering into GetStorageAccount method of blob service");

                string account = CloudConfigurationManager.GetSetting("StorageAccountName");
                string key = CloudConfigurationManager.GetSetting("StorageAccountAccessKey");
                string connectionString = $"DefaultEndpointsProtocol=https;AccountName={account};AccountKey={key}";
                CloudStorageAccount storageAccount = CloudStorageAccount.Parse(connectionString);

                LoggingManager.Debug("Exit from GetStorageAccount method of blob service");

                return storageAccount;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStorageAccount", "PolicyReviewService ", exception.Message), exception);

                throw;
            }
        }
    }
}
