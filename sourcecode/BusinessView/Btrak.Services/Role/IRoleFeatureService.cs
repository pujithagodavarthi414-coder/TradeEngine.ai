using System;
using System.Collections.Generic;
using Btrak.Models;
using Btrak.Models.Role;
using BTrak.Common;

namespace Btrak.Services.Role
{
    public interface IRoleFeatureService
    {
        List<RoleFeatureApiReturnModel> SearchRoleFeatures(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RoleFeatureApiReturnModel> GetAllPermittedRoleFeatures(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
