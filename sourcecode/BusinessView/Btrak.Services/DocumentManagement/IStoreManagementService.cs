using Btrak.Models;
using Btrak.Models.DocumentManagement;
using Btrak.Models.File;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.DocumentManagement
{
    public interface IStoreManagementService
    {
        List<StoreReturnModel> GetStores(StoreSearchCriteriaInputModel storeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertStore(StoreInputModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        StoreConfigurationOutputModel GetStoreConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool IsUsersStore(string folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string FolderTreeView(SearchFolderInputModel searchFolderInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}