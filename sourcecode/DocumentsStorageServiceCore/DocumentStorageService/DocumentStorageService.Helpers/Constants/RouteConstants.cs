using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DocumentStorageService.Helpers.Constants
{
    public class RouteConstants
    {
        public const string UploadFileInChunks = "FileStore/FileStoreApi/UploadFileInChunks";
        public const string UploadFileChunks = "File/FileApi/UploadFileChunks";
        public const string GetChunkBlobUrl = "File/FileApi/GetChunkBlobUrl";
        public const string CreateFolder = "File/FileApi/UpsertFolder";
        public const string ArchiveFolder = "File/FileApi/DeleteFolder";
        public const string CreateMultipleFiles = "File/FileApi/UpsertMultipleFiles";
        public const string ActivateAndArchiveFiles = "File/FileApi/ActivateAndArchiveFiles";
        public const string ArchiveFile = "File/FileApi/DeleteFile";
        public const string SearchFiles = "File/FileApi/SearchFile";
        public const string UpdateFile = "File/FileApi/UpsertFileName";
        public const string UpdateFolder = "File/FileApi/UpdateFolder";
        public const string SearchFolder = "File/FileApi/SearchFolder";
        public const string FolderTreeView = "File/FileApi/FolderTreeView";
        public const string UpdateFolderDescription = "File/FileApi/UpdateFolderDescription";
        public const string ReviewFile = "File/FileApi/ReviewFile";
        public const string DownloadFile = "File/FileApi/DownloadFile";
        public const string UpsertStore = "Store/StoreApi/UpsertStore";
        public const string GetStore = "Store/StoreApi/GetStore";
        public const string ArchiveStore = "Store/StoreApi/ArchiveStore";
        public const string InsertAccessRightPermissionForDocuments = "AccessRights/AccessRightsApi/UpsertAccessRightsForDocuments";
        public const string GetAccessRightPermissionsForDocuments = "AccessRights/AccessRightsApi/GetAccessRightsForDocuments";
        public const string GetCompanyById = "CompanyManagement/CompanyManagementApi/GetCompanyById";
        public const string UploadLocalFileToBlob = "File/FileApi/UploadLocalFileToBlob";
    }
}
