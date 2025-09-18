using Btrak.Models;
using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace Btrak.Services.DocumentStorageServices
{
    public interface IDocumentStorageService
    {
        Task<List<FileApiServiceReturnModel>> SearchFiles(Guid? referenceId, Guid? referenceTypeId, string referenceTypeName, string documentUrl, string fileName, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<FileApiServiceReturnModel>> GetFilesByReferenceId(Guid? referenceId, Guid? referenceTypeId, string referenceTypeName, string documentUrl, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<Guid?>> UpsertMultipleFiles(UpsertFileInputModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
        Task<List<Guid?>> CreateMultipleFiles(UpsertFileInputModel upsertFileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationmessages);
    }
}
