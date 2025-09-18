using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.Fake
{
    public class FakeStoreRepository
    {
        public Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return storeId;
        }

        public Guid? CreateStore(StoreCollectionModel upsertStoreCollectionModelInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return upsertStoreCollectionModelInputModel.Id;
        }

        public List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeSearchCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<StoreOutputReturnModels>
            {
                new StoreOutputReturnModels
                {
                    Id = new Guid("2EE26168-6F94-4CF1-9385-FDF084BD91F3"),
                    StoreName = "priya doc store",
                    StoreSize = 156250,
                    CompanyId = new Guid("CF1C6756-936F-4A19-9D48-468D343F10CB"),
                    IsDefault = false,
                    IsCompany = true,
                    IsArchived = false
                }
            };
        }

        public Guid? UpdateStore(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return storeInputModel.Id;
        }

        public Guid? UpdateStoreSize(StoreCollectionModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return storeInputModel.Id;
        }
    }
}
