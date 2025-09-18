using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using AuthenticationServices.Repositories.Repositories.RoleManagement;
using AuthenticationServices.Services.Helpers;
using AuthenticationServices.Services.Helpers.RolesValidationHelpers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace AuthenticationServices.Services.Role
{
    public class RoleService : IRoleService
    {
        private readonly IRoleRepository _roleRepository;

        public RoleService(IRoleRepository roleRepository)
        {
            _roleRepository = roleRepository;
        }
        public Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRole", "roleModel", roleModel, "Role Api"));

            roleModel.FeatureIdXml = Utilities.ConvertIntoListXml(roleModel.FeatureIds);

            if (!RolesValidationHelper.UpsertRoleValidation(roleModel, loggedInContext, validationMessages))
            {
                return null;
            }

            roleModel.RoleId = _roleRepository.UpsertRole(roleModel, loggedInContext, validationMessages);

            LoggingManager.Debug(roleModel.RoleId?.ToString());

            return roleModel.RoleId;
        }

        public Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteRole", "roleModel", roleModel, "Role Api"));

            if (!RolesValidationHelper.DeleteRoleValidation(roleModel, loggedInContext, validationMessages))
            {
                return null;
            }

            roleModel.RoleId = _roleRepository.DeleteRole(roleModel, loggedInContext, validationMessages);

            LoggingManager.Debug(roleModel.RoleId?.ToString());

            return roleModel.RoleId;
        }

        public List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRoles", "roleSearchCriteriaInputModel", roleSearchCriteriaInputModel, "RoleService"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, roleSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<RolesOutputModel> roleModels = _roleRepository.GetAllRoles(roleSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return roleModels;
        }

        public RolesOutputModel GetRoleById(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRoleById", "Role Service"));

            if (!RolesValidationHelper.GetRoleDetailsByIdValidation(roleId, loggedInContext, validationMessages))
            {
                return null;
            }

            RolesSearchCriteriaInputModel rolesSearchCriteriaInputModel =
                new RolesSearchCriteriaInputModel { RoleId = roleId, IsArchived = false };
            RolesOutputModel roleModel = _roleRepository.GetAllRoles(rolesSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            if (!RolesValidationHelper.ValidateRoleFoundWithId(roleId, validationMessages, roleModel))
            {
                return null;
            }
            if (roleModel != null && roleModel.Features != null)
            {
                List<FeatureModel> features = Utilities.GetObjectFromXml<FeatureModel>(roleModel.Features, "Features");
                var jsonSerializerSettings = new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
                roleModel.Features = JsonConvert.SerializeObject(features, jsonSerializerSettings);
            }
            return roleModel;
        }

        public List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? featureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRolesByFeatureId", "searchText", featureId, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            List<RoleFeatureOutputModel> roleModels = _roleRepository.GetRolesByFeatureId(featureId, loggedInContext, validationMessages);

            return roleModels;
        }

        public List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRolesDropDown", "searchText", searchText, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            List<RoleDropDownOutputModel> roleModels = _roleRepository.GetAllRolesDropDown(searchText, loggedInContext, validationMessages).ToList();

            return roleModels;
        }

        public Guid? UpdateRoleFeature(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRoleFeature", "searchText", updateFeatureInputModel, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            Guid? roleFeatureId = _roleRepository.updateFeatureInputModel(updateFeatureInputModel, loggedInContext, validationMessages);

            return roleFeatureId;
        }
    }
}
