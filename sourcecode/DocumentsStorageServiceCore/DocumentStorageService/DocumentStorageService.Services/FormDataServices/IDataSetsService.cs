using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System.Collections.Generic;

namespace DocumentStorageService.Services.FormDataServices
{
    public interface IDataSetsService
    {
        void SaveCreateFileHistory(UpsertFileInputModel fileUpsertInputModels, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SaveDeleteFileHistory(FileApiReturnModel file, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
