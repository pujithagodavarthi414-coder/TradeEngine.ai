using DocumentStorageService.Models.CompanyStructure;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Services.FileStore
{
    public interface IFileStoreService
    {
        string PostFileAsChunks(FilePostInputModel filePostInputModel);
        string UploadFiles(BtrakPostedFile filePostInputModel, CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId);
        byte[] DownloadFile(string filePath);
    }
}
