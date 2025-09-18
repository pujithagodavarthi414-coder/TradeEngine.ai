using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using DocumentStorageService.Models.FileStore;
using DocumentStorageService.Repositories.AccessRights;
using DocumentStorageService.Repositories.FileStore;
using DocumentStorageService.Services.Helpers;
using DocumentStorageService.Helpers.Constants;

namespace DocumentStorageService.Services.AccessRights
{
    public class AccessService : IAccessService
    {
        private readonly AccessRightsRepository _accessRightsRepository;
        private readonly UploadFileRepository _uploadFileRepository;
        public AccessService(AccessRightsRepository accessRightsRepository, UploadFileRepository uploadFileRepository)
        {
            _accessRightsRepository = accessRightsRepository;
            _uploadFileRepository = uploadFileRepository;
        }
        public List<Guid?> InsertAccessRightsPrmissionToDocuments(DocumentRightAccessModel accessRightsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            
                List<Guid?> accessIds = new List<Guid?>();
               
                List<Guid?> existingRightsUserIds = new List<Guid?>();
                List<Guid?> existingRightsRoleIds = new List<Guid?>();
               
               
                if (!AccessRightsValidations.ValidateAccessFileFile(accessRightsModel, loggedInContext, validationMessages))
                {
                    return null;
                }

            var accessRightsSearchInputModel = new AccessRightsSearchInputModel();
            accessRightsSearchInputModel.DocumentId = accessRightsModel.DocumentId;
            AccessRightsReturnModel fileApiReturnModels = _accessRightsRepository.SearchAccessRightsForDocuments(accessRightsSearchInputModel, loggedInContext, validationMessages).FirstOrDefault();
            var accessRightsList = fileApiReturnModels?.AccessRights;
            var existedEditedAccessModel = accessRightsList
                .Where(x => x.IsEditAccess == true || x.IsViewAccess == true).ToList();
            var existedCreatedAccessModel = accessRightsList.Where(x => x.IsCreateAccess == true).ToList();
            foreach (var data in existedCreatedAccessModel)
            {
                existingRightsRoleIds.Add(data.RoleId);
            }
            foreach (var roleData in existedEditedAccessModel)
            {
                existingRightsUserIds.Add(roleData.UserId);
            }

            foreach (var roleId in existingRightsRoleIds)
            {
                if (!accessRightsModel.RoleIds.Contains(roleId))
                {
                    var filteredData = existedCreatedAccessModel.Where(x => x.RoleId == roleId)
                        .FirstOrDefault();
                    if (filteredData != null)
                    {
                        var accessData = new DocumentRightAccessModel();
                        accessData.Id = filteredData.Id;
                        accessData.IsCreateAccess = filteredData.IsCreateAccess;
                        accessData.UserId = filteredData.UserId;
                        accessData.RoleId = filteredData.RoleId;
                        accessData.DocumentId = accessRightsModel.DocumentId;
                        accessData.IsViewAccess = filteredData.IsViewAccess;
                        accessData.IsEditAccess = filteredData.IsEditAccess;
                        AccessRightsCollectionModel accessRightsInsertModel =
                            AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessData);
                        accessRightsInsertModel.UpdatedDateTime = DateTime.UtcNow;
                        accessRightsInsertModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                        accessRightsInsertModel.IsArchived = true;
                        Guid? accessId = _accessRightsRepository.UpdateAccessRightsPermissionForDocumentsBasedOnDocumentId(accessRightsInsertModel,
                            loggedInContext, validationMessages);
                        accessIds.Add(accessData.Id);
                    }
                }
            }

            foreach (var userId in existingRightsUserIds)
            {
                if (!accessRightsModel.UserIds.Contains(userId))
                {
                    var filteredData = existedEditedAccessModel.Where(x => x.UserId == userId)
                        .FirstOrDefault();
                    if (filteredData != null)
                    {
                        var accessData = new DocumentRightAccessModel();
                        accessData.Id = filteredData.Id;
                        accessData.IsCreateAccess = filteredData.IsCreateAccess;
                        accessData.UserId = filteredData.UserId;
                        accessData.RoleId = filteredData.RoleId;
                        accessData.IsViewAccess = filteredData.IsViewAccess;
                        accessData.IsEditAccess = filteredData.IsEditAccess; 
                        accessData.DocumentId = accessRightsModel.DocumentId;
                        AccessRightsCollectionModel accessRightsInsertModel =
                            AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessData);
                        accessRightsInsertModel.UpdatedDateTime = DateTime.UtcNow;
                        accessRightsInsertModel.UpdatedByUserId = loggedInContext.LoggedInUserId;
                        accessRightsInsertModel.IsArchived = true;
                        Guid? accessId = _accessRightsRepository.UpdateAccessRightsPermissionForDocumentsBasedOnDocumentId(accessRightsInsertModel,
                            loggedInContext, validationMessages);
                        accessIds.Add(accessData.Id);
                    }

                }
            }

            foreach (var userId in accessRightsModel.UserIds)
            {
                if (existedEditedAccessModel != null && existedEditedAccessModel.Count > 0)
                {
                    var filteredData = existedEditedAccessModel.Where(x =>
                        x.UserId == userId && (x.IsEditAccess == true || x.IsViewAccess == true)).FirstOrDefault();
                    if (filteredData == null)
                    {
                        var accessModel = new DocumentRightAccessModel();
                        accessModel.UserId = userId;
                        accessModel.IsCreateAccess = accessRightsModel.IsCreateAccess;
                        accessModel.DocumentId = accessRightsModel.DocumentId;
                        AccessRightsCollectionModel accessRightsCollectionModel =
                            AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessModel);
                        Guid? accessId = _accessRightsRepository.InsertAccessRightsForDocuments(accessRightsCollectionModel,
                            loggedInContext, validationMessages);
                        accessIds.Add(accessRightsCollectionModel.Id);
                    }

                }
                else
                {
                    var accessModel = new DocumentRightAccessModel();
                    accessModel.UserId = userId;
                    accessModel.IsEditAccess = accessRightsModel.IsEditAccess;
                    accessModel.IsViewAccess = accessRightsModel.IsViewAccess;
                    accessModel.DocumentId = accessRightsModel.DocumentId;
                    AccessRightsCollectionModel accessRightsCollectionModel =
                        AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessModel);
                    Guid? accessId = _accessRightsRepository.InsertAccessRightsForDocuments(accessRightsCollectionModel,
                        loggedInContext, validationMessages);
                    accessIds.Add(accessRightsCollectionModel.Id);
                }


            }
            foreach (var roleId in accessRightsModel.RoleIds)
            {
                if (existedCreatedAccessModel != null && existedCreatedAccessModel.Count > 0)
                {
                    var filteredData = existedCreatedAccessModel.Where(x =>
                        x.RoleId == roleId && x.IsCreateAccess == true).FirstOrDefault();
                    if (filteredData == null)
                    {
                        var accessModel = new DocumentRightAccessModel();
                        accessModel.RoleId = roleId;
                        accessModel.IsCreateAccess = accessRightsModel.IsCreateAccess;
                        accessModel.DocumentId = accessRightsModel.DocumentId;
                        AccessRightsCollectionModel accessRightsCollectionModel =
                            AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessModel);
                        Guid? accessId = _accessRightsRepository.InsertAccessRightsForDocuments(accessRightsCollectionModel,
                            loggedInContext, validationMessages);
                        accessIds.Add(accessRightsCollectionModel.Id);

                    }
                }
                else
                {
                    var accessModel = new DocumentRightAccessModel();
                    accessModel.RoleId = roleId; 
                    accessModel.DocumentId = accessRightsModel.DocumentId;
                    accessModel.IsCreateAccess = accessRightsModel.IsCreateAccess;
                    AccessRightsCollectionModel accessRightsCollectionModel =
                        AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessModel);
                    Guid? accessId = _accessRightsRepository.InsertAccessRightsForDocuments(accessRightsCollectionModel,
                        loggedInContext, validationMessages);
                    accessIds.Add(accessRightsCollectionModel.Id);
                }
                
            }

            return accessIds;
           
        }

        public List<AccessRightsReturnModel> SearchAccessRightPermissionsForDocuments(AccessRightsSearchInputModel accessRightsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info("Entered to SearchAccessRightPermissionsForDocuments." + "AccessRightsSearchInputModel=" + accessRightsSearchInputModel + ", loggedInContext=" + loggedInContext.LoggedInUserId);
            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, accessRightsSearchInputModel, validationMessages))
            {
                return null;
            }
            List<AccessRightsReturnModel> fileApiReturnModels = _accessRightsRepository.SearchAccessRightsForDocuments(accessRightsSearchInputModel, loggedInContext, validationMessages);
            return fileApiReturnModels;
        }
    }
}
