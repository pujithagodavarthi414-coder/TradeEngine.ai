using Btrak.Models.FieldPermissions;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.Permissions
{
    public interface IFieldPermissionsService
    {
        FieldPermissionViewModel GetFieldPermission(Guid id);
        List<FieldPermissionViewModel> GetFieldPermissionsBasedOnConfigurationId(Guid configurationId);
        void AddOrUpdateFieldPermission(FieldPermissionViewModel fieldPermissionViewModel, LoggedInContext loggedInContext);
    }
}
