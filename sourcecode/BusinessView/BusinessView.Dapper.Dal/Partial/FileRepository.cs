using Btrak.Models;
using Btrak.Models.File;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.DocumentManagement;
using System.Text.RegularExpressions;
using System.Configuration;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class FileRepository
    {
        public List<FileUpsertReturnModel> UpsertFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertFile, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertCustomFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertCustomFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertFormFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertFormFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFormFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertCustomDocFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@IsTobeReviewed", fileUpsertInputModel.IsToBeReviewed);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertCustomDocFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertCustomDocFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertProjectFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsFromFeedback", fileUpsertInputModel.IsFromFeedback);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertUserStoryFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertProjectFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertFoodOrderFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertFoodOrderFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFoodOrderFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertHrmFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertHrmFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertHrmFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertTestSuiteFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertTestSuiteFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestSuiteFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertTestRunFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertTestRunFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTestRunFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public DeleteFileReturnModel DeleteFile(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", deleteFileInputModel.FileId);
                    vParams.Add("@TimeStamp", deleteFileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DeleteFileReturnModel>(StoredProcedureConstants.SpDeleteFile, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new DeleteFileReturnModel();
            }
        }

        public FileModel ReviewFile(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", fileInputModel.FileId);
                    vParams.Add("@TimeStamp", fileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileModel>(StoredProcedureConstants.SpReviewFile, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ReviewFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new FileModel();
            }
        }

        public Guid? UpsertFileName(FileModel fileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", fileInputModel.FileId);
                    vParams.Add("@FileName", fileInputModel.FileName);
                    vParams.Add("@FileSize", fileInputModel.FileSize);
                    vParams.Add("@FilePath", fileInputModel.FilePath);
                    vParams.Add("@FileExtension", fileInputModel.FileExtension);
                    vParams.Add("@IsArchived", fileInputModel.IsArchived);
                    vParams.Add("@TimeStamp", fileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFileName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFileName", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return null;
            }
        }

        public DeleteFileReturnModel DeleteFileByReferenceId(DeleteFileInputModel deleteFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", deleteFileInputModel.ReferenceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DeleteFileReturnModel>(StoredProcedureConstants.SpDeleteFileByReferenceId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFileByReferenceId", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new DeleteFileReturnModel();
            }
        }

        public bool? UpsertFolderAndStoreSize(UpsertFolderAndStoreSizeModel upsertFolderAndStoreSizeModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", upsertFolderAndStoreSizeModel.FolderId);
                    vParams.Add("@StoreId", upsertFolderAndStoreSizeModel.StoreId);
                    vParams.Add("@FilesSize", upsertFolderAndStoreSizeModel.Size);
                    vParams.Add("@IsDeletion", upsertFolderAndStoreSizeModel.IsDeletion);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpUpsertFolderAndStoreSize, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolderAndStoreSize", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return null;
            }
        }

        public bool? UpdateFolderAndStoreSizeByFolderId(Guid? folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", folderId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpUpsertFolderAndStoreSizeByFolderId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateFolderAndStoreSizeByFolderId", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdateFolderAndStore);
                return null;
            }
        }

        public IList<FilesModel> SelectFileByUserStoryId(Guid userStoryId)
        {
            return new List<FilesModel>();
            //throw new NotImplementedException();
        }

        public List<FileApiReturnModel> GetFileDetailById(string fileIdsXml, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileIdsXml", fileIdsXml);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileApiReturnModel>(StoredProcedureConstants.SpGetFileDetailsById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFileDetailById", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new List<FileApiReturnModel>();
            }
        }

        public List<FileApiReturnModel> SearchFile(FileSearchCriteriaInputModel fileSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", fileSearchCriteriaInputModel.FileId);
                    vParams.Add("@FolderId", fileSearchCriteriaInputModel.FolderId);
                    vParams.Add("@StoreId", fileSearchCriteriaInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileSearchCriteriaInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileSearchCriteriaInputModel.ReferenceTypeId);
                    vParams.Add("@IsArchived", fileSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@SearchText", fileSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", fileSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", fileSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNumber", fileSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", fileSearchCriteriaInputModel.PageSize);
                    vParams.Add("@UserStoryId", fileSearchCriteriaInputModel.UserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileApiReturnModel>(StoredProcedureConstants.SpSearchFile, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new List<FileApiReturnModel>();
            }
        }

        public UpsertFolderInputModel UpsertFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", upsertFolderInputModel.FolderId);
                    vParams.Add("@ParentFolderId", upsertFolderInputModel.ParentFolderId);
                    vParams.Add("@StoreId", upsertFolderInputModel.StoreId);
                    vParams.Add("@FolderReferenceId", upsertFolderInputModel.FolderReferenceId);
                    vParams.Add("@FolderReferenceTypeId", upsertFolderInputModel.FolderReferenceTypeId);
                    vParams.Add("@FolderName", upsertFolderInputModel.FolderName);
                    vParams.Add("@IsArchived", upsertFolderInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertFolderInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UpsertFolderInputModel>(StoredProcedureConstants.SpUpsertFolder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolder", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFolderUpsert);
                return null;
            }
        }

        public Guid? UpsertFileDetails(UpsertUploadFileInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", upsertFolderInputModel.UploadFileId);
                    vParams.Add("@FileName", upsertFolderInputModel.FileName);
                    vParams.Add("@FilePath", upsertFolderInputModel.FilePath);
                    vParams.Add("@FileExtension", upsertFolderInputModel.FileExtension);
                    vParams.Add("@FileSize", upsertFolderInputModel.FileSize);
                    vParams.Add("@FolderId", upsertFolderInputModel.FolderId);
                    vParams.Add("@StoreId", upsertFolderInputModel.StoreId);
                    vParams.Add("@ReferenceId", upsertFolderInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", upsertFolderInputModel.ReferenceTypeId);
                    vParams.Add("@IsArchived", upsertFolderInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertFolderInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFileDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFileDetails", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFolderUpsert);
                return null;
            }
        }

        public Guid? UpsertFolderDescription(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", upsertFolderInputModel.FolderId);
                    vParams.Add("@FolderReferenceId", upsertFolderInputModel.FolderReferenceId);
                    vParams.Add("@FolderReferenceTypeId", upsertFolderInputModel.FolderReferenceTypeId);
                    vParams.Add("@Description", upsertFolderInputModel.Description);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertFolderDescription, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertFolderDescription", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFolderUpsertDescription);
                return null;
            }
        }

        public DeleteFolderReturnModel DeleteFolder(UpsertFolderInputModel upsertFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", upsertFolderInputModel.FolderId);
                    vParams.Add("@TimeStamp", upsertFolderInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DeleteFolderReturnModel>(StoredProcedureConstants.SpDeleteFolder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteFolder", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionFolderUpsert);
                return new DeleteFolderReturnModel();
            }
        }

        public SearchFolderOutputModel SearchFolder(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", searchFolderInputModel.FolderId);
                    vParams.Add("@ParentFolderId", searchFolderInputModel.ParentFolderId);
                    vParams.Add("@StoreId", searchFolderInputModel.StoreId);
                    vParams.Add("@FolderReferenceId", searchFolderInputModel.FolderReferenceId);
                    vParams.Add("@FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId);
                    vParams.Add("@IsArchived", searchFolderInputModel.IsArchived);
                    vParams.Add("@SearchText", searchFolderInputModel.SearchText);
                    vParams.Add("@SortBy", searchFolderInputModel.SortBy);
                    vParams.Add("@SortDirection", searchFolderInputModel.SortDirection);
                    vParams.Add("@PageNumber", searchFolderInputModel.PageNumber);
                    vParams.Add("@PageSize", searchFolderInputModel.PageSize);
                    vParams.Add("@UserStoryId", searchFolderInputModel.UserStoryId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchFolderOutputModel>(StoredProcedureConstants.SpGetFolders, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFolder", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFolders);
                return new SearchFolderOutputModel();
            }
        }

        public List<FolderTreeStructureModel> FolderTreeView(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", searchFolderInputModel.FolderId);
                    vParams.Add("@ParentFolderId", searchFolderInputModel.ParentFolderId);
                    vParams.Add("@StoreId", searchFolderInputModel.StoreId);
                    vParams.Add("@FolderReferenceId", searchFolderInputModel.FolderReferenceId);
                    vParams.Add("@FolderReferenceTypeId", searchFolderInputModel.FolderReferenceTypeId);
                    vParams.Add("@IsArchived", searchFolderInputModel.IsArchived);
                    vParams.Add("@SearchText", searchFolderInputModel.SearchText);
                    vParams.Add("@SortBy", searchFolderInputModel.SortBy);
                    vParams.Add("@SortDirection", searchFolderInputModel.SortDirection);
                    vParams.Add("@PageNumber", searchFolderInputModel.PageNumber);
                    vParams.Add("@PageSize", searchFolderInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsTreeView", searchFolderInputModel.IsTreeView);
                    vParams.Add("@UserStoryId", searchFolderInputModel.UserStoryId);
                    return vConn.Query<FolderTreeStructureModel>(StoredProcedureConstants.SpGetFolders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "FolderTreeView", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFolders);
                return new List<FolderTreeStructureModel>();
            }
        }


        public Guid? UpsertUploadFile(UpsertUploadFileInputModel upsertUploadFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", upsertUploadFileInputModel.FolderId);
                    vParams.Add("@StoreId", upsertUploadFileInputModel.StoreId);
                    vParams.Add("@ReferenceId", upsertUploadFileInputModel.ReferenceId);
                    vParams.Add("@FileName", upsertUploadFileInputModel.FileName);
                    vParams.Add("@IsArchived", upsertUploadFileInputModel.IsArchived);
                    vParams.Add("@TimeStamp", upsertUploadFileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@ReferenceTypeName", upsertUploadFileInputModel.ReferenceTypeName);
                    vParams.Add("@UploadFileId", upsertUploadFileInputModel.UploadFileId);
                    vParams.Add("@FilePath", upsertUploadFileInputModel.FilePath);
                    vParams.Add("@FileSize", upsertUploadFileInputModel.FileSize);
                    vParams.Add("@FileExtension", upsertUploadFileInputModel.FileExtension);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUploadFile, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUploadFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUploadFileUpsert);
                return null;
            }
        }

        public List<SearchFileHistoryOutputModel> SearchFileHistory(SearchFileHistoryInputModel searchFileHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", searchFileHistoryInputModel.FileId);
                    vParams.Add("@SearchText", searchFileHistoryInputModel.SearchText);
                    vParams.Add("@operationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchFileHistoryOutputModel>(StoredProcedureConstants.SpGetFileHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchFileHistory", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFolders);
                return new List<SearchFileHistoryOutputModel>();
            }
        }

        public SearchFoldersAndFilesReturnModel GetFoldersAndFiles(SearchFoldersAndFilesInputModel searchFoldersAndFilesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ParentFolderId", searchFoldersAndFilesInputModel.ParentFolderId);
                    vParams.Add("@StoreId", searchFoldersAndFilesInputModel.StoreId);
                    vParams.Add("@IsArchived", searchFoldersAndFilesInputModel.IsArchived);
                    vParams.Add("@SearchText", searchFoldersAndFilesInputModel.SearchText);
                    vParams.Add("@operationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SearchFoldersAndFilesReturnModel>(StoredProcedureConstants.SpGetFoldersAndFiles, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFoldersAndFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFoldersAndFiles);
                return new SearchFoldersAndFilesReturnModel();
            }
        }

        public List<FileUpsertReturnModel> UpsertExpensesFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertExpensesFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertExpensesFile", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertAuditFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertAuditFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertPayRollFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertPayRollFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertPayRollFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public FolderApiReturnModel GetFolderDetailById(Guid folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FolderId", folderId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FolderApiReturnModel>(StoredProcedureConstants.SpGetFolderDetailsById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFolderDetailById", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new FolderApiReturnModel();
            }
        }

        public FileApiReturnModel GetGenericFileDetails(Guid fileId,List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FileId", fileId);
                    return vConn.Query<FileApiReturnModel>(StoredProcedureConstants.SpGetGenericFileDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGenericFileDetails", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new FileApiReturnModel();
            }
        }

        public FileSystemConfigModel GetFileSystemConfiguration(Guid? userId, string deviceId)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId ?? Guid.Empty);
                    vParams.Add("@DeviceId", string.IsNullOrEmpty(deviceId) ? null : deviceId);

                    var fileConfig = vConn.Query<FileSystemConfigModel>(StoredProcedureConstants.SpGetFileSystemConfiguration, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();

                    fileConfig.CompanyName = Regex.Replace(fileConfig.CompanyName, "[^a-zA-Z0-9\\s.]", "");
                    fileConfig.EnvironmenName = ConfigurationManager.AppSettings[AppConstants.EnvironmentName];

                    return fileConfig;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFileSystemConfiguration", "FileRepository", sqlException.Message), sqlException);

                //SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchFile);
                return new FileSystemConfigModel();
            }
        }
        public List<FileUpsertReturnModel> UpsertRecruitmentCandidateFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertCandidateFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }
        public List<FileUpsertReturnModel> UpsertFormDocumentFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@Description", fileUpsertInputModel.Description);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertFormDocumentFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertEntryFormFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertEntryFormFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertContractFiles(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertEntryFormFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertClientSettingsFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertEntryFormFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }

        public List<FileUpsertReturnModel> UpsertClientStampFile(FileUpsertInputModel fileUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FilesXML", fileUpsertInputModel.FilesXML);
                    vParams.Add("@FolderId", fileUpsertInputModel.FolderId);
                    vParams.Add("@StoreId", fileUpsertInputModel.StoreId);
                    vParams.Add("@ReferenceId", fileUpsertInputModel.ReferenceId);
                    vParams.Add("@ReferenceTypeId", fileUpsertInputModel.ReferenceTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<FileUpsertReturnModel>(StoredProcedureConstants.SpUpsertEntryFormFiles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertAuditFiles", "FileRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertFile);
                return null;
            }
        }
    }
}
