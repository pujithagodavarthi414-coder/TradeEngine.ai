using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.AccessRights;
using System;
using System.Collections.Generic;
using System.Text;

namespace DocumentStorageService.Services.Fake
{
    public interface IFakeAccessService
    {
        Guid? InsertAccessRightsPrmissionToDocuments(DocumentRightAccessModel accessRightsModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<DocumentRightAccessModel> SearchAccessRightPermissionsForDocuments(
            AccessRightsSearchInputModel accessRightsSearchInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
