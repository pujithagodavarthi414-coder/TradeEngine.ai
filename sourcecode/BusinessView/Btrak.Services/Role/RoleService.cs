using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.Role;
using Btrak.Services.Audit;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using Btrak.Services.Helpers;
using Btrak.Services.Helpers.RolesValidationHelpers;
using Btrak.Services.Notification;
using Newtonsoft.Json;
using BusinessView.Common;
using System.Configuration;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.Role
{
    public class RoleService : IRoleService
    {
        private readonly RoleRepository _roleRepository;

        private readonly IAuditService _auditService;

        public RoleService(RoleRepository roleRepository, IAuditService auditService, INotificationService notificationService)
        {
            _roleRepository = roleRepository;
            _auditService = auditService;
        }

        public Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRole", "roleModel", roleModel, "Role Api"));
            if (!RolesValidationHelper.UpsertRoleValidation(roleModel, loggedInContext, validationMessages))
            {
                return null;
            }
            if(roleModel.RoleId == null)
            {
                roleModel.IsNewRole = true;
            }
            if(roleModel.FeatureIds != null && roleModel.FeatureIds.Count > 0)
            {
                roleModel.FeatureIdXml = Utilities.ConvertIntoListXml(roleModel.FeatureIds);
            }
            if(!string.IsNullOrEmpty(loggedInContext.AccessToken))
            {
                var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpsertRole, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], roleModel, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                var id = responseJson.Data.ToString();
                var responseid = (id != null && id != "null") ? id : null;
                if (responseJson.Success && responseid != null)
                {
                    roleModel.RoleId = new Guid(responseid);
                    roleModel.FeatureIdXml = Utilities.ConvertIntoListXml(roleModel.FeatureIds);

                    roleModel.RoleId = _roleRepository.UpsertRole(roleModel, loggedInContext, validationMessages);

                    LoggingManager.Debug(roleModel.RoleId?.ToString());

                    _auditService.SaveAudit(AppCommandConstants.UpsertRoleCommandId, roleModel, loggedInContext);

                    return roleModel.RoleId;
                }
                else
                {
                    if (responseJson?.ApiResponseMessages.Count > 0)
                    {
                        var validationMessage = new ValidationMessage()
                        {
                            ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                            ValidationMessageType = MessageTypeEnum.Error,
                            Field = responseJson.ApiResponseMessages[0].FieldName
                        };
                        validationMessages.Add(validationMessage);
                    }
                    return null;
                }
            }
            else
            {
               
                roleModel.FeatureIdXml = Utilities.ConvertIntoListXml(roleModel.FeatureIds);

                roleModel.RoleId = _roleRepository.UpsertRole(roleModel, loggedInContext, validationMessages);

                LoggingManager.Debug(roleModel.RoleId?.ToString());

                _auditService.SaveAudit(AppCommandConstants.UpsertRoleCommandId, roleModel, loggedInContext);

                return roleModel.RoleId;
            }
        }

        public Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteRole", "roleModel", roleModel, "Role Api"));

            var result = ApiWrapper.PostentityToApi(RouteConstants.ASDeleteRole, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], roleModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                if (!RolesValidationHelper.DeleteRoleValidation(roleModel, loggedInContext, validationMessages))
                {
                    return null;
                }

                roleModel.RoleId = _roleRepository.DeleteRole(roleModel, loggedInContext, validationMessages);

                LoggingManager.Debug(roleModel.RoleId?.ToString());

                _auditService.SaveAudit(AppCommandConstants.DeleteRoleCommandId, roleModel, loggedInContext);

                return roleModel.RoleId;
            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return null;
            }
        }

        public List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRoles", "roleSearchCriteriaInputModel", roleSearchCriteriaInputModel, "RoleService"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, roleSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllRolesCommandId, roleSearchCriteriaInputModel, loggedInContext);

            List<RolesOutputModel> roleModels = _roleRepository.GetAllRoles(roleSearchCriteriaInputModel, loggedInContext, validationMessages).ToList();

            return roleModels;
        }

        public List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRolesDropDown", "searchText", searchText, "RoleService"));

            if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.GetAllRolesCommandId, searchText, loggedInContext);

            List<RoleDropDownOutputModel> roleModels = _roleRepository.GetAllRolesDropDown(searchText, loggedInContext, validationMessages).ToList();

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
                new RolesSearchCriteriaInputModel {RoleId = roleId, IsArchived = false};
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

            _auditService.SaveAudit(AppCommandConstants.GetRolesByFeatureIdCommandId, featureId, loggedInContext);

            List<RoleFeatureOutputModel> roleModels = _roleRepository.GetRolesByFeatureId(featureId, loggedInContext, validationMessages);

            return roleModels;
        }

        public Guid? UpdateRoleFeature(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRoleFeature", "searchText", updateFeatureInputModel, "RoleService"));

            var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpdateRoleFeature, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], updateFeatureInputModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                if ((CommonValidationHelper.CheckValidationForLoggedInUser(loggedInContext, validationMessages)).Count > 0)
                {
                    return null;
                }

                Guid? roleFeatureId = _roleRepository.updateFeatureInputModel(updateFeatureInputModel, loggedInContext, validationMessages);

                return roleFeatureId;
            }
            else
            {
                if (responseJson?.ApiResponseMessages.Count > 0)
                {
                    var validationMessage = new ValidationMessage()
                    {
                        ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                        ValidationMessageType = MessageTypeEnum.Error,
                        Field = responseJson.ApiResponseMessages[0].FieldName
                    };
                    validationMessages.Add(validationMessage);
                }
                return null;
            }
        }
    }
}
