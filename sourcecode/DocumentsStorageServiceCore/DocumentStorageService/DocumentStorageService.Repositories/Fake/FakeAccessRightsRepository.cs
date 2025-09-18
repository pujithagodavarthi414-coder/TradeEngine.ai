using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.AccessRights;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Repositories.Fake
{
   public  class FakeAccessRightsRepository
    {
        public Guid? InsertAccessRightsPrmissionToDocuments(AccessRightsCollectionModel documentAccessModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return documentAccessModel.DocumentId;
        }

        public List<DocumentRightAccessModel> SearchAccessRightsForDocuments(AccessRightsSearchInputModel accessRightsSearchCriteriaInput,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new List<DocumentRightAccessModel>
            {
                new DocumentRightAccessModel
                {
                    DocumentId = Guid.Parse("38b9969f-5e31-46f9-b244-c86e02f51d3c"),
                    UserIds = null,
                    RoleIds = new List<Guid?>(),
                    IsCreateAccess = false,
                    IsViewAccess = false,
                    IsEditAccess = true,
                    IsArchived = false
                }
            };
        }
    }
}
