using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using AuthenticationServices.Repositories.Helpers;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Repositories.Repositories.RoleManagement
{
    public interface IRoleRepository
    {
        Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? updateFeatureInputModel(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
