using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Repositories.Fake;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Services.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;


namespace DocumentStorageService.Services.Fake
{
    public class FakeStoreService : IFakeStoreService
    {
        private FakeStoreRepository _fakeStoreRepository;

        public FakeStoreService(FakeStoreRepository fakeStoreRepository)
        {
            _fakeStoreRepository = fakeStoreRepository;
        }
        public Guid? ArchiveStore(Guid? storeId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "DeleteFolder", "FileService"));
            if (!FileValidations.ValidateDeleteFile(storeId, loggedInContext, validationMessages))
            {
                return null;
            }

            var searchStoreInputModel = new StoreCriteriaSearchInputModel();
            searchStoreInputModel.Id = storeId;
            searchStoreInputModel.IsArchived = false;
            StoreOutputReturnModels storeDetails =
                SearchStore(searchStoreInputModel, loggedInContext, validationMessages).FirstOrDefault();
            if (storeDetails == null)
            {
                return null;
            }
            Guid? deleteStoreId = _fakeStoreRepository.ArchiveStore(storeId, loggedInContext, validationMessages);
            return deleteStoreId;
        }

        public List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeCriteriaInput, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchStore." + "StoreCriteriaSearchInputModel=" + storeCriteriaInput + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, storeCriteriaInput, validationMessages))
            {
                return null;
            }

            List<StoreOutputReturnModels> storeApiReturnModels = _fakeStoreRepository.SearchStore(storeCriteriaInput, loggedInContext, validationMessages);
            return storeApiReturnModels;
        }

        public Guid? UpsertStore(StoreInputModel storeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertFolder",
                "StoreService"));
            LoggingManager.Debug(storeUpsertInputModel.ToString());

            if (!StoreManagementHelper.ValidateUpsertStore(storeUpsertInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            StoreCollectionModel storeCollectionModel =
                StoreModelConverter.ConvertStoreUpsertInputModelToCollectionModel(storeUpsertInputModel);
            if (storeUpsertInputModel.StoreId == null)
            {
                storeCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
                storeCollectionModel.CreatedDateTime = DateTime.UtcNow;
                storeCollectionModel.CompanyId = loggedInContext.CompanyGuid;
                storeUpsertInputModel.StoreId = _fakeStoreRepository.CreateStore(storeCollectionModel, loggedInContext, validationMessages);
            }
            else
            {
                storeCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                storeCollectionModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                storeUpsertInputModel.StoreId = _fakeStoreRepository.UpdateStore(storeCollectionModel, loggedInContext, validationMessages);
            }

            LoggingManager.Debug(storeUpsertInputModel.StoreId?.ToString());

            return storeUpsertInputModel.StoreId;
        }
    }
}
