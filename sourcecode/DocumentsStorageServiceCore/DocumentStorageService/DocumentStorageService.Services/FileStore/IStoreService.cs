using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;

namespace DocumentStorageService.Services.FileStore
{
    public interface IStoreService
    {
        Guid? UpsertStore(StoreInputModel storeUpsertInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
