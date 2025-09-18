using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.AccessRights;
using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Repositories.Fake;
using DocumentStorageService.Services.Helpers;

namespace DocumentStorageService.Services.Fake
{
    public class FakeAccessService : IFakeAccessService
    {
        private readonly FakeAccessRightsRepository _fakeAccessRightsRepository;
        public FakeAccessService(FakeAccessRightsRepository fakeAccessRightsRepository)
        {
            _fakeAccessRightsRepository = fakeAccessRightsRepository;
        }
        public Guid? InsertAccessRightsPrmissionToDocuments(DocumentRightAccessModel accessRightsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!AccessRightsValidations.ValidateAccessFileFile(accessRightsModel, loggedInContext, validationMessages))
            {
                return null;
            }
            AccessRightsCollectionModel accessRightsCollectionModel = AccessRightsModelConverter.ConvertAccessRightsModelToCollectionModel(accessRightsModel ?? new DocumentRightAccessModel());
            accessRightsCollectionModel.Id = accessRightsModel?.DocumentId;
            accessRightsCollectionModel.CreatedByUserId = loggedInContext.LoggedInUserId;
            accessRightsCollectionModel.CreatedDateTime = DateTime.UtcNow;
            Guid? folderId = _fakeAccessRightsRepository.InsertAccessRightsPrmissionToDocuments(accessRightsCollectionModel, loggedInContext, validationMessages);
            return folderId;
        }

        public List<DocumentRightAccessModel> SearchAccessRightPermissionsForDocuments(AccessRightsSearchInputModel accessRightsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<DocumentRightAccessModel> documentAccessModel =
                _fakeAccessRightsRepository.SearchAccessRightsForDocuments(accessRightsSearchInputModel,
                    loggedInContext, validationMessages);
            return documentAccessModel;
        }
    }
}
