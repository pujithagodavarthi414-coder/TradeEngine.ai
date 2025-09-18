using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Services.Role
{
    public interface IRoleService
    {
        Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        RolesOutputModel GetRoleById(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? featureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpdateRoleFeature(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
