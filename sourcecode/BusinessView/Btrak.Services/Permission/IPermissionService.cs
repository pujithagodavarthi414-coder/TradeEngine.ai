using Btrak.Models;
using Btrak.Models.CrudOperation;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Permission
{
    public interface IPermissionService
    {
        Guid? UpsertPermission(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<CrudOperationApiReturnModel> GetAllPermissions(CrudOperationInputModel crudOperationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CrudOperationApiReturnModel GetPermissionById(Guid? permissionId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
