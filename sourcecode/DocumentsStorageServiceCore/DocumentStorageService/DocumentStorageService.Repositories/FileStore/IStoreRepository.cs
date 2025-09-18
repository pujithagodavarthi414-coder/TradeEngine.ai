using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.FileStore
{
    public interface IStoreRepository
    {
        List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateStoreSize(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext,
                    List<ValidationMessage> validationMessages);
        Guid? CreateStore(StoreCollectionModel upsertStoreCollectionModelInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateStore(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
