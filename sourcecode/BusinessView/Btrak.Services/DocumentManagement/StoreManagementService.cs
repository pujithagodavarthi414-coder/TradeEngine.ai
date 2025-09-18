using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.DocumentManagement;
using Btrak.Models.File;
using Btrak.Services.Audit;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.DocumentManagement;
using BTrak.Common;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;

namespace Btrak.Services.DocumentManagement
{
    public class StoreManagementService : IStoreManagementService
    {
        private readonly StoreManagementRepository _storeManagementRepository;
        private readonly IAuditService _auditService;
        private readonly FileRepository _fileRepository;

        public StoreManagementService(StoreManagementRepository storeManagementRepository, FileRepository fileRepository, IAuditService auditService)
        {
            _storeManagementRepository = storeManagementRepository;
            _fileRepository = fileRepository;
            _auditService = auditService;
        }

        public List<StoreReturnModel> GetStores(StoreSearchCriteriaInputModel storeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStores", "StoreManagement Service"));

            LoggingManager.Debug(storeSearchCriteriaInputModel.ToString());

            _auditService.SaveAudit(AppCommandConstants.GetStoresCommandId, storeSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<StoreReturnModel> storeReturnModel = _storeManagementRepository.GetStores(storeSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return storeReturnModel;
        }

        public Guid? UpsertStore(StoreInputModel storeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpsertStore", "StoreManagement Service"));

            LoggingManager.Debug(storeInputModel.ToString());

            if (!StoreManagementValidationHelper.ValidateUpsertStore(storeInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            storeInputModel.StoreId = _storeManagementRepository.UpsertStore(storeInputModel, loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.UpsertStoreCommandId, storeInputModel, loggedInContext);

            LoggingManager.Debug(storeInputModel.StoreId?.ToString());

            return storeInputModel.StoreId;
        }

        public StoreConfigurationOutputModel GetStoreConfiguration(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetStoreConfiguration", "StoreManagement Service"));

            StoreConfigurationOutputModel storeConfigurationOutputModel = _storeManagementRepository.GetStoreConfiguration(loggedInContext, validationMessages);

            _auditService.SaveAudit(AppCommandConstants.GetStoreConfigurationCommandId, storeConfigurationOutputModel, loggedInContext);

            LoggingManager.Debug(storeConfigurationOutputModel.ToString());

            return storeConfigurationOutputModel;
        }

        public bool IsUsersStore(string folderId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "IsUsersStore", "StoreManagement Service"));

            Guid? usersStoreId = _storeManagementRepository.IsUsersStore(folderId, loggedInContext, validationMessages);

            bool isUsersStore = usersStoreId == loggedInContext.LoggedInUserId;

            _auditService.SaveAudit(AppCommandConstants.IsUsersStoreCommandId, isUsersStore, loggedInContext);

            LoggingManager.Debug(isUsersStore.ToString());

            return isUsersStore;
        }

        public string FolderTreeView(SearchFolderInputModel searchFolderInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            var folderJson = "";

            List<FolderTreeStructureModel> folderTreeStructureModels =_fileRepository.FolderTreeView(searchFolderInputModel, loggedInContext, validationMessages);

            foreach (FolderTreeStructureModel folder in folderTreeStructureModels)
            {
                if (folder.FileId == null)
                {
                    var folders = folderTreeStructureModels.Where(x => ((x.FileId == null && x.ParentFolderId == folder.FolderId) || (x.FileId != null && x.FolderId == folder.FolderId))).ToList();
                    if (folders.Count() > 0)
                    {
                        folder.Children = new List<FolderTreeStructureModel>();
                        folder.Children.AddRange(folderTreeStructureModels.Where(x => ((x.FileId == null && x.ParentFolderId == folder.FolderId) || (x.FileId != null && x.FolderId == folder.FolderId && folder.FileId == null))).ToList());
                    }
                }
            }

            //var root;// = folderTreeStructureModels.Where(x => folderTreeStructureModels.All(y => y.FolderId != x.ParentFolderId && x.FileId == null)).ToList();


            var folderList= new List<FolderTreeStructureModel>();
            foreach(var n in folderTreeStructureModels)
            {
                if(n.FileId == null)
                {
                    int i = 0;
                    foreach (var j in folderTreeStructureModels)
                    {
                        if((n.ParentFolderId == j.FolderId && j.FileId==null) || (n.ParentFolderId != null && j.FolderId == null))
                        {
                            i = i + 1;
                        }
                    }
                    if(i == 0)
                    {
                        folderList.Add(n);
                    }
                }

            }

            JsonSerializerSettings settings = new JsonSerializerSettings
            {
                ContractResolver = new CamelCasePropertyNamesContractResolver(),
                Formatting = Formatting.Indented,
                NullValueHandling=NullValueHandling.Ignore
            };

            folderJson = JsonConvert.SerializeObject(folderList,settings);

            return folderJson;
        }
    }
}
