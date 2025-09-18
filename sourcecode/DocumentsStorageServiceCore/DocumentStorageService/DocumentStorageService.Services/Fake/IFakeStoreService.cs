using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;


namespace DocumentStorageService.Services.Fake
{
    public interface IFakeStoreService
    {
        Guid? UpsertStore(StoreInputModel storeUpsertInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
