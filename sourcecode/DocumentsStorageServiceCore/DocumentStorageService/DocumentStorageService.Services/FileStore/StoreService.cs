using DocumentStorageService.Models;
using DocumentStorageService.Models.FileStore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DocumentStorageService.Helpers.Constants;
using DocumentStorageService.Services.Helpers;
using DocumentStorageService.Repositories.FileStore;

namespace DocumentStorageService.Services.FileStore
{
   public class StoreService : IStoreService
   {
       private readonly StoreRepository _storeRepository;
        public StoreService(StoreRepository storeRepository)
        {
            _storeRepository = storeRepository;
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
                storeUpsertInputModel.StoreId = _storeRepository.CreateStore(storeCollectionModel, loggedInContext, validationMessages);
            }
            else
            {
                storeCollectionModel.UpdatedDateTime = DateTime.UtcNow;
                storeCollectionModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                storeUpsertInputModel.StoreId = _storeRepository.UpdateStore(storeCollectionModel, loggedInContext, validationMessages);
            }

            LoggingManager.Debug(storeUpsertInputModel.StoreId?.ToString());

            return storeUpsertInputModel.StoreId;
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
            Guid? deleteStoreId = _storeRepository.ArchiveStore(storeId, loggedInContext, validationMessages);
            return deleteStoreId;
        }

        public List<StoreOutputReturnModels> SearchStore(StoreCriteriaSearchInputModel storeCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchStore." + "StoreCriteriaSearchInputModel=" + storeCriteriaInput + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, storeCriteriaInput, validationMessages))
            {
                return null;
            }

            List<StoreOutputReturnModels> storeApiReturnModels = _storeRepository.SearchStore(storeCriteriaInput, loggedInContext, validationMessages);
            return storeApiReturnModels;
        }
    }
}
