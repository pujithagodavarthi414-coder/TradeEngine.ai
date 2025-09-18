using System;
using System.Collections.Generic;
using System.Text;
using DocumentStorageService.Models;
using DocumentStorageService.Models.AccessRights;
using DocumentStorageService.Repositories.AccessRights;

namespace DocumentStorageService.Services.AccessRights
{
    public interface IAccessService
    {
        List<Guid?> InsertAccessRightsPrmissionToDocuments(DocumentRightAccessModel accessRightsModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<AccessRightsReturnModel> SearchAccessRightPermissionsForDocuments(
            AccessRightsSearchInputModel accessRightsSearchInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
    }
}
