using System;
using System.Collections.Generic;
using System.Web;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.File;
using Btrak.Models.Widgets;
using BTrak.Common;
using Btrak.Models.ActivityTracker;
using System.Net;

namespace Btrak.Services.FileUploadDownload
{
    public interface IFileStoreService
    {
        string PostFile(FilePostInputModel filePostInputModel);

        byte[] DownloadFile(string filePath);

        string PostFiles(HttpPostedFile file);
        string PostFileAsChunks(FilePostInputModel filePostInputModel);
        FileSystemReturnModel UploadFiles(HttpPostedFile filePostInputModel, CompanyOutputModel companyModel,int moduleTypeId, Guid loggedInUserId);
        string UploadFiles(BtrakPostedFile filePostInputModel, CompanyOutputModel companyModel, int moduleTypeId, Guid loggedInUserId);
        List<FileDetailsModel> UploadFiles(CompanyOutputModel companyOutputModel, CronExpressionInputModel cronExpressionInputModel,  LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string CombineChunksAndReturnFileUrl(string fileName, string[] ids, string fileType);
        byte[] DownloadFileWithContentType(string filePath, out WebHeaderCollection contentType);

        string UploadActivityTrackerScreenShotInBlob(InsertUserActivityScreenShotInputModel filePostInputModel, CompanyOutputModel companyModel,
            Guid loggedInUserId);
        FileDetailsModel UploadFilesUsingBase64(CompanyOutputModel companyModel, FileDataForBase64 base64, LoggedInContext loggedInContext, List<ValidationMessage> validationMessage);
    }
}