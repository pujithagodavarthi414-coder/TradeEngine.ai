using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.File;
using Btrak.Services.Audit;
using Btrak.Services.FileUploadDownload;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.File;
using Btrak.Services.CompanyStructure;
using Btrak.Models.CompanyStructure;
using Btrak.Models.DocumentManagement;
using System.IO;
using Btrak.Services.AntiVirusScanner;
using System.Threading.Tasks;
using static BTrak.Common.Enumerators;
using Hangfire;
using System.Net.Http;
using Btrak.Models.ActivityTracker;
using System.Net;
using Btrak.Services.ComplianceAudit;
using Btrak.Models.WorkflowManagement;
using Btrak.Services.AutomatedWorkflowmanagement;
using Btrak.Services.FormDataServices;
using Btrak.Models.FormDataServices;

namespace Btrak.Services.FileUpload
{
    public class FileService : IFileService
    {
        private readonly FileRepository _fileRepository;
        private readonly IFileStoreService _fileStoreService;
        private readonly IAuditService _auditService;
        private readonly CompanyStructureService _companyStructureService;
        private readonly IAutomatedWorkflowmanagementServices _automatedWorkflowmanagementServices;
        private readonly IDataSetService _dataSetService;

        public FileService(IAutomatedWorkflowmanagementServices automatedWorkflowmanagementServices,FileRepository fileRepository, IAuditService auditService, IFileStoreService fileStoreService, CompanyStructureService companyStructureService, AntiVirusScannerService antiVirusScannerService, IDataSetService dataSetService)
        {
            _fileRepository = fileRepository;
            _auditService = auditService;
            _fileStoreService = fileStoreService;
            _companyStructureService = companyStructureService;
            _automatedWorkflowmanagementServices = automatedWorkflowmanagementServices;
            _dataSetService = dataSetService;
        }

        public override List<Guid?> UpsertMultipleFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFile", "File Service and logged details=" + loggedInContext));

            List<FileUpsertReturnModel> fileUpsertReturnModels = null;

            List<Guid?> fileIds = new List<Guid?>();

            if (fileUpsertInputModel != null)
            {
                LoggingManager.Debug(fileUpsertInputModel.ToString());

                if (fileUpsertInputModel.ReferenceTypeId == Guid.Empty || fileUpsertInputModel.ReferenceTypeId == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.NotEmptyReferenceTypeId)
                    });
                    return null;
                }

                var filesWithoutErrors = new List<FileModel>();

                foreach (var file in fileUpsertInputModel.FilesList)
                {
                    List<ValidationMessage> validations = new List<ValidationMessage>();

                    FileValidations.ValidateUpsertFile(file, loggedInContext, validations);

                    if (validations.Count > 0)
                    {
                        validationMessages.AddRange(validations);
                    }
                    else
                    {
                        filesWithoutErrors.Add(file);
                    }
                }

                fileUpsertInputModel.FilesList = filesWithoutErrors;

                fileUpsertInputModel.FilesXML = Utilities.ConvertIntoListXml(fileUpsertInputModel.FilesList);
            }

            if (fileUpsertInputModel != null)
            {
                int fileType = fileUpsertInputModel.FileType;

                switch (fileType)
                {
                    case (int)FileTypeEnum.HrmFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertHrmFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.FoodOrderFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertFoodOrderFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.ProjectFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertProjectFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.CustomFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertCustomFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.TestSuiteFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertTestSuiteFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.TestCaseFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertTestRunFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.CustomDocFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertCustomDocFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.PayRoll:
                        fileUpsertReturnModels = _fileRepository.UpsertPayRollFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.ExpensesFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertExpensesFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.AuditFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertAuditFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.RecruitmentFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertRecruitmentCandidateFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.EntryFormInvoice:
                        fileUpsertReturnModels = _fileRepository.UpsertEntryFormFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.ContractFiles:
                        fileUpsertReturnModels = _fileRepository.UpsertContractFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.ClientSettingsFile:
                        fileUpsertReturnModels = _fileRepository.UpsertClientSettingsFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.ClientStampDetails:
                        fileUpsertReturnModels = _fileRepository.UpsertClientStampFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    case (int)FileTypeEnum.FormDocumentFile:
                        fileUpsertReturnModels = _fileRepository.UpsertFormDocumentFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                    default:
                        fileUpsertReturnModels = _fileRepository.UpsertCustomFile(fileUpsertInputModel, loggedInContext, validationMessages);
                        break;
                }
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertMultipleFilesCommandId, fileUpsertInputModel, loggedInContext);

            if (fileUpsertReturnModels != null && fileUpsertReturnModels.Count > 0)
            {
                BackgroundJob.Enqueue(() => IncrementFolderAndStoreSize(fileUpsertReturnModels, loggedInContext));

                fileIds = fileUpsertReturnModels.Select(x => x.FileId).ToList();

                Task.Factory.StartNew(() =>
                {

                    Guid referenceTypeId = Guid.Empty;
                    var workflowModel = new WorkFlowTriggerModel
                    {
                        ReferenceTypeId = AppConstants.EvidenceUploadReferenceTypeId

                    };

                    var workflowTrigger = _automatedWorkflowmanagementServices.GetWorkFlowTriggers(workflowModel, loggedInContext, validationMessages).FirstOrDefault();
                    if (workflowTrigger != null)
                    {
                        workflowTrigger.ReferenceId = fileUpsertInputModel.FileTypeReferenceId != null ? fileUpsertInputModel.FileTypeReferenceId : fileUpsertInputModel.FolderId;
                        if (workflowTrigger.ReferenceId != null)
                        {
                            workflowTrigger.IsForAuditRecurringMail = true;
                            workflowTrigger.FileIds = string.Join(",", fileIds.Select(g => g.ToString()).ToArray());
                            _automatedWorkflowmanagementServices.StartWorkflowProcessInstance(workflowTrigger, loggedInContext, validationMessages);
                        }
                    }
                });
            }

            return fileIds;
        }

        public Guid? UpdateDataSet(Guid? referenceId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var dataSetUpdateModel = new UpdateDataSetJsonModel();
            dataSetUpdateModel.Id = referenceId;
            List<ParamsKeyModel> paramsModel = new List<ParamsKeyModel>();

            var jsonModel = new ParamsKeyModel();
            jsonModel.KeyName = "IsFileReUploaded";
            jsonModel.KeyValue = "true";
            jsonModel.Type = "boolean";
            paramsModel.Add(jsonModel);

            dataSetUpdateModel.ParamsJsonModel = paramsModel;

            var id = _dataSetService.UpdateDataSetJson(dataSetUpdateModel, loggedInContext, validationMessages).GetAwaiter().GetResult();
            return id;
        }

        public void IncrementFolderAndStoreSize(List<FileUpsertReturnModel> fileUpsertReturnModels, LoggedInContext loggedInContext)
        {

            long? fileSize = 0;

            foreach (var fileModel in fileUpsertReturnModels)
            {
                fileSize += fileModel.FileSize;
            }

            UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel = new UpsertFolderAndStoreSizeModel
            {
                FolderId = fileUpsertReturnModels.FirstOrDefault().FolderId,
                StoreId = fileUpsertReturnModels.FirstOrDefault().StoreId,
                Size = fileSize,
                IsDeletion = false,
            };

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            _fileRepository.UpsertFolderAndStoreSize(upsertFolderAndStoreSizeModel, loggedInContext, validationMessages);
        }

        public void DecrementFolderAndStoreSize(UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel, LoggedInContext loggedInContext)
        {
            upsertFolderAndStoreSizeModel.IsDeletion = true;

            List<ValidationMessage> validationMessages = new List<ValidationMessage>();

            _fileRepository.UpsertFolderAndStoreSize(upsertFolderAndStoreSizeModel, loggedInContext, validationMessages);
        }

        public override byte[] DownloadFile(string filePath, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Download File with filePath" + filePath + ",Logged in User Id=" + loggedInContext);

            LoggingManager.Debug(filePath);

            if (!FileValidations.ValidateDownloadFile(filePath, validationMessages))
            {
                return null;
            }

            byte[] fileData = _fileStoreService.DownloadFile(filePath);

            if (!FileValidations.ValidateDownloadFile(validationMessages, fileData))
            {
                return null;
            }

            LoggingManager.Debug(fileData?.ToString());

            return fileData;
        }

        public override List<FileApiReturnModel> GetFileDetailById(List<Guid?> fileIds, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetFileDetailById." + "fileId=" + fileIds + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            LoggingManager.Debug(fileIds?.ToString());

            var FileIdsWithoutErrors = new List<Guid?>();

            foreach (var fileId in fileIds)
            {
                List<ValidationMessage> validations = new List<ValidationMessage>();

                FileValidations.ValidateFileDetailById(fileId, loggedInContext, validations);

                if (validations.Count > 0)
                {
                    validationMessages.AddRange(validations);
                    validations = new List<ValidationMessage>();
                }
                else
                {
                    FileIdsWithoutErrors.Add(fileId);
                }
            }

            fileIds = FileIdsWithoutErrors;

            var fileIdsXml = Utilities.ConvertIntoListXml(fileIds);

            List<FileApiReturnModel> fileModel = _fileRepository.GetFileDetailById(fileIdsXml, loggedInContext, validationMessages);

            if (!FileValidations.ValidateFileDetailFoundWithId(fileIds, validationMessages, fileModel))
            {
                return null;
            }

            return fileModel;
        }

        public override Guid? DeleteFile(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to DeleteFile." + "deleteFileInputModel=" + deleteFileInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            LoggingManager.Debug(deleteFileInputModel.ToString());

            if (!FileValidations.ValidateDeleteFile(deleteFileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            DeleteFileReturnModel deleteFileReturnModel = _fileRepository.DeleteFile(deleteFileInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.DeleteFileCommandId, deleteFileInputModel, loggedInContext);

            LoggingManager.Debug(deleteFileReturnModel.FileId?.ToString());

            UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel = new UpsertFolderAndStoreSizeModel
            {
                FolderId = deleteFileReturnModel.FolderId,
                StoreId = deleteFileReturnModel.StoreId,
                Size = deleteFileReturnModel.FileSize,
                IsDeletion = true,
            };

            BackgroundJob.Enqueue(() => DecrementFolderAndStoreSize(upsertFolderAndStoreSizeModel, loggedInContext));

            return deleteFileReturnModel.FileId;
        }

        public override Guid? DeleteFileByReferenceId(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to DeleteFileByReferenceId." + "deleteFileInputModel=" + deleteFileInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            DeleteFileReturnModel deleteFileReturnModel = _fileRepository.DeleteFileByReferenceId(deleteFileInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.DeleteFileCommandId, deleteFileInputModel, loggedInContext);

            UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel = new UpsertFolderAndStoreSizeModel
            {
                FolderId = deleteFileReturnModel.FolderId,
                StoreId = deleteFileReturnModel.StoreId,
                Size = deleteFileReturnModel.FileSize,
                IsDeletion = true,
            };

            BackgroundJob.Enqueue(() => DecrementFolderAndStoreSize(upsertFolderAndStoreSizeModel, loggedInContext));

            return deleteFileReturnModel.ReferenceId;
        }

        public async override Task<List<FileResult>> UploadFileFromForms(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int moduleTypeId, Guid referenceId)
        {
            LoggingManager.Info("Entered Upload File with Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var fileData = new List<FileResult>();

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (httpRequest.Files.Count > 0)
            {
                foreach (string file in httpRequest.Files)
                {
                    var result = new FileResult();
                    var postedFile = httpRequest.Files[file];
                    if (postedFile != null && string.IsNullOrEmpty(postedFile.FileName))
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                        });
                        return null;
                    }

                    if (postedFile != null)
                    {
                        result.FileName = postedFile.FileName;
                        var fileReturnData = _fileStoreService.UploadFiles(postedFile, companyModel, moduleTypeId, loggedInContext.LoggedInUserId);
                        result.FilePath = fileReturnData.BlobFilePath;
                        result.FileExtension = Path.GetExtension(postedFile.FileName);
                        result.FileSize = postedFile.ContentLength;
                        FileUpsertInputModel fileUpsertInputModel = new FileUpsertInputModel();
                        List<FileModel> filesList = new List<FileModel>();
                        FileModel fileModel = new FileModel();
                        fileModel.FileName = postedFile.FileName;
                        fileModel.FileExtension = Path.GetExtension(postedFile.FileName);
                        fileModel.FilePath = fileReturnData.BlobFilePath;
                        fileModel.FileSize = postedFile.ContentLength;
                        fileModel.IsArchived = false;
                        fileModel.IsQuestionDocuments = false;
                        filesList.Add(fileModel);
                        fileUpsertInputModel.FileType = 5;
                        fileUpsertInputModel.FilesList = filesList;
                        fileUpsertInputModel.ReferenceId= referenceId;
                        fileUpsertInputModel.ReferenceTypeId = new Guid("91D885A6-B48E-4574-8853-90E09F784134");

                            LoggingManager.Debug(fileUpsertInputModel.ToString());

                            if (fileUpsertInputModel.ReferenceTypeId == Guid.Empty || fileUpsertInputModel.ReferenceTypeId == null)
                            {
                                validationMessages.Add(new ValidationMessage
                                {
                                    ValidationMessageType = MessageTypeEnum.Error,
                                    ValidationMessaage = string.Format(ValidationMessages.NotEmptyReferenceTypeId)
                                });
                                return null;
                            }

                            fileUpsertInputModel.FilesXML = Utilities.ConvertIntoListXml(fileUpsertInputModel.FilesList);
                        List<FileUpsertReturnModel> fileUpsertReturnModels = _fileRepository.UpsertFormFiles(fileUpsertInputModel, loggedInContext, validationMessages);
                        result.FileId = fileUpsertReturnModels[0].FileId;
                        result.TimeStamp = fileUpsertReturnModels[0].TimeStamp;
                    }


                    fileData.Add(result);
                }
            }

            return fileData;
        }
         public async override Task<List<FileResult>> UploadFile(HttpRequest httpRequest, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, int moduleTypeId)
        {
            LoggingManager.Info("Entered Upload File with Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var fileData = new List<FileResult>();

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (httpRequest.Files.Count > 0)
            {
                foreach (string file in httpRequest.Files)
                {
                    var result = new FileResult();
                    var postedFile = httpRequest.Files[file];
                    //if (await new AntiVirusScannerService().IsPotentiallyContainingVirus(postedFile.InputStream))
                    //{
                    //    throw new Exception("Virus found. So, blocking the upload");
                    //}
                    if (postedFile != null && string.IsNullOrEmpty(postedFile.FileName))
                    {
                        validationMessages.Add(new ValidationMessage
                        {
                            ValidationMessageType = MessageTypeEnum.Error,
                            ValidationMessaage = string.Format(ValidationMessages.NotEmptyFileName)
                        });
                        return null;
                    }

                    if (postedFile != null)
                    {
                        result.FileName = postedFile.FileName;
                        var fileReturnData = _fileStoreService.UploadFiles(postedFile, companyModel, moduleTypeId, loggedInContext.LoggedInUserId);
                        result.FilePath = fileReturnData.BlobFilePath;
                        //result.LocalFilePath = fileReturnData.LocalFilePath;
                        result.FileExtension = Path.GetExtension(postedFile.FileName);
                        result.FileSize = postedFile.ContentLength;
                    }

                    fileData.Add(result);
                }
            }

            return fileData;
        }

        public override List<FileResult> UploadActivityTrackerScreenShot(InsertUserActivityScreenShotInputModel insertUserActivityScreenShotInputModel, List<ValidationMessage> validationMessages, UploadScreenshotInputModel uploadScreenshotInputModel)
        {

            var fileData = new List<FileResult>();


            if (validationMessages.Count > 0)
            {
                return null;
            }
            LoggedInContext loggedInContext = new LoggedInContext();

            loggedInContext.CompanyGuid = uploadScreenshotInputModel.CompanyId;
            loggedInContext.LoggedInUserId = uploadScreenshotInputModel.UserId;

            CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            if (insertUserActivityScreenShotInputModel != null &&
                !string.IsNullOrWhiteSpace(insertUserActivityScreenShotInputModel.FileType))
            {
                var result = new FileResult();

                result.FileName = insertUserActivityScreenShotInputModel.FileName;
                result.FileUrl = _fileStoreService.UploadActivityTrackerScreenShotInBlob(insertUserActivityScreenShotInputModel, companyModel, loggedInContext.LoggedInUserId);

                fileData.Add(result);

            }

            return fileData;
        }

        public override List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFile", "File Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, fileSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchFileCommandId, fileSearchCriteriaInputModel, loggedInContext);

            return _fileRepository.SearchFile(fileSearchCriteriaInputModel, loggedInContext, validationMessages);
        }

        public override Guid? UpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder", "File Service and logged details=" + loggedInContext));

            LoggingManager.Debug(upsertFolderInputModel.ToString());

            if (!FileValidations.ValidateUpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            if (upsertFolderInputModel.IsArchived == true)
            {
                DeleteFolderReturnModel deleteFolderReturnModel = _fileRepository.DeleteFolder(upsertFolderInputModel, loggedInContext, validationMessages);

                upsertFolderInputModel.FolderId = deleteFolderReturnModel.FolderId;

                UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel = new UpsertFolderAndStoreSizeModel
                {
                    FolderId = deleteFolderReturnModel.FolderId,
                    StoreId = deleteFolderReturnModel.StoreId,
                    Size = deleteFolderReturnModel.FolderSize,
                    IsDeletion = true,
                };

                BackgroundJob.Enqueue(() => DecrementFolderAndStoreSize(upsertFolderAndStoreSizeModel, loggedInContext));
            }
            else
            {
                upsertFolderInputModel = _fileRepository.UpsertFolder(upsertFolderInputModel, loggedInContext, validationMessages);
            }

            _auditService.SaveAudit(AppCommandConstants.UpsertFolderCommandId, upsertFolderInputModel, loggedInContext);

            LoggingManager.Debug(upsertFolderInputModel.FolderId?.ToString());

            return upsertFolderInputModel.FolderId;
        }

        public override Guid? UpsertFileDetails(UpsertUploadFileInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFileDetails", "File Service and logged details=" + loggedInContext));

            if (!FileValidations.ValidateUpsertFileDetails(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }
            upsertFolderInputModel.UploadFileId = _fileRepository.UpsertFileDetails(upsertFolderInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertFolderCommandId, upsertFolderInputModel, loggedInContext);

            LoggingManager.Debug(upsertFolderInputModel.FolderId?.ToString());

            return upsertFolderInputModel.FolderId;
        }

        public override Guid? UpsertFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolderDescription", "File Service and logged details=" + loggedInContext));

            LoggingManager.Debug(upsertFolderInputModel.ToString());

            if (!FileValidations.ValidateUpsertFolderDescription(upsertFolderInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertFolderInputModel.FolderId = _fileRepository.UpsertFolderDescription(upsertFolderInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertFolderDescriptionCommandId, upsertFolderInputModel, loggedInContext);

            LoggingManager.Debug(upsertFolderInputModel.FolderId?.ToString());

            return upsertFolderInputModel.FolderId;
        }

        public override SearchFolderOutputModel SearchFolder(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFolder", "File Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, searchFolderInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchFolderCommandId, searchFolderInputModel, loggedInContext);

            return _fileRepository.SearchFolder(searchFolderInputModel, loggedInContext, validationMessages);
        }

        public override Guid? UpsertUploadFile(UpsertUploadFileInputModel upsertUploadFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder", "File Service and logged details=" + loggedInContext));

            LoggingManager.Debug(upsertUploadFileInputModel.ToString());

            if (!FileValidations.ValidateUpsertUploadFile(upsertUploadFileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            upsertUploadFileInputModel.UploadFileId = _fileRepository.UpsertUploadFile(upsertUploadFileInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertUploadFileCommandId, upsertUploadFileInputModel, loggedInContext);

            LoggingManager.Debug(upsertUploadFileInputModel.UploadFileId?.ToString());

            return upsertUploadFileInputModel.UploadFileId;
        }

        public override List<SearchFileHistoryOutputModel> SearchFileHistory(SearchFileHistoryInputModel searchFileHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SearchFolder", "File Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, searchFileHistoryInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.SearchFileCommandId, searchFileHistoryInputModel, loggedInContext);

            return _fileRepository.SearchFileHistory(searchFileHistoryInputModel, loggedInContext, validationMessages);
        }

        public override SearchFoldersAndFilesReturnModel GetFoldersAndFiles(SearchFoldersAndFilesInputModel searchFoldersAndFilesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetFoldersAndFiles", "File Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, searchFoldersAndFilesInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetFoldersAndFileCommandId, searchFoldersAndFilesInputModel, loggedInContext);

            return _fileRepository.GetFoldersAndFiles(searchFoldersAndFilesInputModel, loggedInContext, validationMessages);
        }

        public override Guid? ReviewFile(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to ReviewFile." + "fileInputModel=" + fileInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            LoggingManager.Debug(fileInputModel.ToString());

            if (!FileValidations.ValidateReviewFile(fileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            FileModel reviewFileReturnModel = _fileRepository.ReviewFile(fileInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.DeleteFileCommandId, fileInputModel, loggedInContext);

            return reviewFileReturnModel.FileId;
        }

        public override Guid? UpsertFileName(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to UpsertFileName." + "fileInputModel=" + fileInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            LoggingManager.Debug(fileInputModel.ToString());

            if (!FileValidations.ValidateReviewFile(fileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? fileReturnModel = _fileRepository.UpsertFileName(fileInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.DeleteFileCommandId, fileInputModel, loggedInContext);

            return fileReturnModel;
        }

        public async override Task<object> UploadFile(MultipartFormDataStreamProvider provider, HttpRequestMessage requestMessage, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered Upload File with Logged in User Id=" + loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            var fileData = new List<FileResult>();
            if (await readPart(provider, requestMessage))
            {
                ResumableConfiguration configuration = GetUploadConfiguration(provider);
                if (AllChunksAreHere(configuration))
                {
                    // Assemble chunks into single file if they're all here
                    var fileStream = TryAssembleFile(configuration);

                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                    var result = new FileResult();
                    BtrakPostedFile filePostInputModel = new BtrakPostedFile();

                    filePostInputModel.FileName = configuration.FileName;
                    filePostInputModel.ContentType = MimeMapping.GetMimeMapping(configuration.FileName);
                    filePostInputModel.InputStream = fileStream;

                    result.FileName = configuration.FileName;
                    result.FilePath = _fileStoreService.UploadFiles(filePostInputModel, companyModel, configuration.ModuleTypeId, loggedInContext.LoggedInUserId);
                    result.FileExtension = Path.GetExtension(filePostInputModel.FileName);
                    result.FileSize = fileStream.Length;

                    fileData.Add(result);
                    return fileData;
                }
                // Success
                return fileData;
            }
            else
            {
                // Fail
                var message = DeleteInvalidChunkData(provider) ? ValidationMessages.ExceptionFileCannotReadMultiPartData : ValidationMessages.ExceptionFileCannotDeleteChunckData;

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = message
                });
                return fileData;
            }
        }

        private static bool DeleteInvalidChunkData(MultipartFormDataStreamProvider provider)
        {
            try
            {
                var localFileName = provider.FileData[0].LocalFileName;
                if (System.IO.File.Exists(localFileName))
                {
                    System.IO.File.Delete(localFileName);
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        private async Task<bool> readPart(MultipartFormDataStreamProvider provider, HttpRequestMessage requestMessage)
        {
            try
            {
                await requestMessage.Content.ReadAsMultipartAsync(provider);
                ResumableConfiguration configuration = GetUploadConfiguration(provider);
                int chunkNumber = GetChunkNumber(provider);

                // Rename generated file
                MultipartFileData chunk = provider.FileData[0]; // Only one file in multipart message
                RenameChunk(chunk, chunkNumber, configuration.Identifier);

                return true;
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "readPart", "FileService ", exception.Message), exception);

                return false;
            }
        }

        public async override Task<FileResult> ReadPart(DriveFile file, MultipartFormDataStreamProvider provider, object path, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages)
        {
            try
            {
                if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
                {
                    return null;
                }

                //if (System.IO.File.Exists(path.ToString()))
                //{
                    CompanyOutputModel companyModel = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);
                    var result = new FileResult();
                    var fileData = new FileResult();
                    BtrakPostedFile filePostInputModel = new BtrakPostedFile();
                    using (FileStream fileStream = new FileStream(path.ToString(), FileMode.Open))
                    {
                        // or
                        //TextReader textReader = System.IO.File.OpenText(path.ToString()); // or   
                        //StreamReader sreamReader = new StreamReader(path.ToString());
                        //await fileStream.ReadAsMultipartAsync(provider);
                        // ResumableConfiguration configuration = GetUploadConfiguration(provider);
                        //int chunkNumber = GetChunkNumber(provider);

                        // Rename generated file
                        // MultipartFileData chunk = provider.FileData[0]; // Only one file in multipart message
                        //RenameChunk(chunk, chunkNumber, configuration.Identifier);
                        filePostInputModel.FileName = file.Name;
                        filePostInputModel.ContentType = MimeMapping.GetMimeMapping(file.Name);
                        filePostInputModel.InputStream = fileStream;

                        result.FileName = file.Name;
                        result.FilePath = _fileStoreService.UploadFiles(filePostInputModel, companyModel, file.ModuleTypeId, loggedInContext.LoggedInUserId);
                        result.FileExtension = Path.GetExtension(filePostInputModel.FileName);
                        result.FileSize = fileStream.Length;

                        fileData = result;
                        fileStream.Close();
                        System.IO.File.Delete(path.ToString());
                }

                    if (System.IO.File.Exists(path.ToString()))
                    {
                        System.IO.File.Create(path.ToString()).Close();
                        System.IO.File.Delete(path.ToString());
                    }
                    return fileData;
                //}
                //await fileStream.ReadAsMultipartAsync(provider);
                //ResumableConfiguration configuration = GetUploadConfiguration(provider);
                //int chunkNumber = GetChunkNumber(provider);

                //// Rename generated file
                //MultipartFileData chunk = provider.FileData[0]; // Only one file in multipart message
                //RenameChunk(chunk, chunkNumber, configuration.Identifier);

            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "readPart", "FileService ", exception.Message), exception);

                return null;
            }
        }

        #region Get configuration


        private ResumableConfiguration GetUploadConfiguration(MultipartFormDataStreamProvider provider)
        {

            return ResumableConfiguration.Create(identifier: GetId(provider), filename: GetFileName(provider), chunks: GetTotalChunks(provider), moduleTypeId: GetModuleTypeId(provider));
        }


        private string GetFileName(MultipartFormDataStreamProvider provider)
        {
            var filename = provider.FormData["resumableFilename"];
            return !String.IsNullOrEmpty(filename) ? filename : provider.FileData[0].Headers.ContentDisposition.FileName.Trim('\"');
        }


        private string GetId(MultipartFormDataStreamProvider provider)
        {
            var id = provider.FormData["resumableIdentifier"];
            return !String.IsNullOrEmpty(id) ? id : Guid.NewGuid().ToString();
        }

        private int GetModuleTypeId(MultipartFormDataStreamProvider provider)
        {
            var moduleTypeId = provider.FormData["moduleTypeId"];
            int id;
            if (Int32.TryParse(moduleTypeId, out id))
            {
                return id;
            }
            else
            {
                return 0;
            }
        }

        private int GetTotalChunks(MultipartFormDataStreamProvider provider)
        {
            var total = provider.FormData["resumableTotalChunks"];
            return !String.IsNullOrEmpty(total) ? Convert.ToInt32(total) : 1;
        }


        private int GetChunkNumber(MultipartFormDataStreamProvider provider)
        {
            var chunk = provider.FormData["resumableChunkNumber"];
            return !String.IsNullOrEmpty(chunk) ? Convert.ToInt32(chunk) : 1;
        }

        #endregion

        #region Chunk methods


        private string GetChunkFileName(int chunkNumber, string identifier)
        {
            return Path.Combine(AppConstants.uploadFileChunkPath, string.Format("{0}_{1}", identifier, chunkNumber.ToString()));
        }


        private void RenameChunk(MultipartFileData chunk, int chunkNumber, string identifier)
        {
            string generatedFileName = chunk.LocalFileName;
            string chunkFileName = GetChunkFileName(chunkNumber, identifier);
            if (System.IO.File.Exists(chunkFileName)) System.IO.File.Delete(chunkFileName);
            System.IO.File.Move(generatedFileName, chunkFileName);
        }


        private string GetFilePath(ResumableConfiguration configuration)
        {
            return Path.Combine(AppConstants.uploadFileChunkPath, configuration.Identifier);
        }


        public override bool ChunkIsHere(int chunkNumber, string identifier)
        {
            string fileName = GetChunkFileName(chunkNumber, identifier);
            return System.IO.File.Exists(fileName);
        }


        private bool AllChunksAreHere(ResumableConfiguration configuration)
        {
            for (int chunkNumber = 1; chunkNumber <= configuration.Chunks; chunkNumber++)
                if (!ChunkIsHere(chunkNumber, configuration.Identifier)) return false;
            return true;
        }


        private Stream TryAssembleFile(ResumableConfiguration configuration)
        {
            // Create a single file
            var fileStream = new MemoryStream(ConsolidateFile(configuration));

            //Delete all the chunks
            DeleteChunks(configuration);
            return fileStream;
        }


        private void DeleteChunks(ResumableConfiguration configuration)
        {
            for (int chunkNumber = 1; chunkNumber <= configuration.Chunks; chunkNumber++)
            {
                var chunkFileName = GetChunkFileName(chunkNumber, configuration.Identifier);
                System.IO.File.Delete(chunkFileName);
            }
        }


        private byte[] ConsolidateFile(ResumableConfiguration configuration)
        {
            var path = GetFilePath(configuration);
            using (MemoryStream destStream = new MemoryStream())
            {
                for (int chunkNumber = 1; chunkNumber <= configuration.Chunks; chunkNumber++)
                {
                    var chunkFileName = GetChunkFileName(chunkNumber, configuration.Identifier);
                    using (var sourceStream = System.IO.File.OpenRead(chunkFileName))
                    {
                        sourceStream.CopyTo(destStream);
                    }
                }
                byte[] destinationStream = destStream.ToArray();
                return destinationStream;
            }
        }

        #endregion


        private string RenameFile(string sourceName, string targetName)
        {
            targetName = Path.GetFileName(targetName); // Strip to filename if directory is specified (avoid cross-directory attack)
            string realFileName = Path.Combine(AppConstants.uploadFileChunkPath, targetName);
            if (System.IO.File.Exists(realFileName)) System.IO.File.Delete(realFileName);
            System.IO.File.Move(sourceName, realFileName);
            return targetName;
        }

        public override FolderApiReturnModel GetFolderDetailById(Guid folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to GetFolderDetailById." + "folderId=" + folderId + ", loggedInContext=" + loggedInContext.LoggedInUserId);

            FolderApiReturnModel fileModel = _fileRepository.GetFolderDetailById(folderId, loggedInContext, validationMessages);

            return fileModel;
        }

        public override byte[] GetFileDetails(Guid fileId,List<ValidationMessage> validationMessages,out WebHeaderCollection contentType)
        {
            FileApiReturnModel fileModel = _fileRepository.GetGenericFileDetails(fileId, validationMessages);

            byte[] fileData = _fileStoreService.DownloadFileWithContentType(fileModel.FilePath,out contentType);

            return fileData;
        }
    }
}