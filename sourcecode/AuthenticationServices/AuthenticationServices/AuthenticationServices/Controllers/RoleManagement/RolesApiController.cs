using AuthenticationServices.Api.Controllers.Api;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using AuthenticationServices.Services.Role;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Api.Controllers.RoleManagement
{
    [ApiController]
    public class RolesApiController : AuthTokenApiController
    {
        private BtrakJsonResult _btrakJsonResult;
        IConfiguration _iconfiguration;
        private readonly IRoleService _roleService;
        public RolesApiController(IConfiguration iconfiguration, IRoleService roleService)
        {
            _roleService = roleService;
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertRole)]
        public JsonResult UpsertRole(RolesInputModel roleModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertRole", "roleModel", roleModel, "Role Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? roleIdReturned = _roleService.UpsertRole(roleModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                LoggingManager.Info("Role Upsert is completed. Return Guid is " + roleIdReturned + ", source command is " + roleModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRole", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertRole", "Role Api"));
                return Json(new BtrakJsonResult { Data = roleIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " UpsertRole", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.DeleteRole)]
        public JsonResult DeleteRole(RolesInputModel roleModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "DeleteRole", "roleModel", roleModel, "Role Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? roleIdReturned = _roleService.DeleteRole(roleModel, LoggedInContext, validationMessages);

                BtrakJsonResult btrakJsonResult;

                LoggingManager.Info("Role deletion is completed. Return Guid is " + roleIdReturned + ", source command is " + roleModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteRole", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "DeleteRole", "Role Api"));
                return Json(new BtrakJsonResult { Data = roleIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteRole ", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllRoles)]
        public JsonResult GetAllRoles(Guid? RoleId, string RoleName, string SearchText,Guid? CompanyId, int PageSize, int PageNumber, bool? IsArchived)
        {
            try
            {
                RolesSearchCriteriaInputModel roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel()
                {
                    RoleId = RoleId,
                    RoleName = RoleName,
                    SearchText = SearchText,
                    PageSize = PageSize,
                    PageNumber = PageNumber,
                    IsArchived = IsArchived,
                    CompanyId = CompanyId
                };

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRoles", "roleSearchCriteriaInputModel", roleSearchCriteriaInputModel, "Role Api"));
                if (roleSearchCriteriaInputModel == null)
                {
                    roleSearchCriteriaInputModel = new RolesSearchCriteriaInputModel();
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<RolesOutputModel> getAllRoles = _roleService.GetAllRoles(roleSearchCriteriaInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllRoles", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllRoles", "Role Api"));
                return Json(new BtrakJsonResult { Data = getAllRoles, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllRoles ", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetRoleById)]
        public JsonResult GetRoleById(Guid? roleId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRoleById", "roleId", roleId, "Role Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                RolesOutputModel roleModel = _roleService.GetRoleById(roleId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRoleById", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRoleById", "Role Api"));
                return Json(new BtrakJsonResult { Data = roleModel, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRoleById ", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetRolesByFeatureId)]
        public JsonResult GetRolesByFeatureId(Guid? featureId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetRolesByFeatureId", "roleId", featureId, "Role Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<RoleFeatureOutputModel> roleFeatureOutputModel = _roleService.GetRolesByFeatureId(featureId, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRolesByFeatureId", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetRolesByFeatureId", "Role Api"));
                return Json(new BtrakJsonResult { Data = roleFeatureOutputModel, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, " GetRolesByFeatureId", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }

        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllRolesDropDown)]
        public JsonResult GetAllRolesDropDown()
        {
            try
            {
                var searchText = string.Empty;
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "GetAllRolesDropDown", "searchText", searchText, "Role Api"));


                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<RoleDropDownOutputModel> getAllRoles = _roleService.GetAllRolesDropDown(searchText, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllRolesDropDown", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllRolesDropDown", "Role Api"));
                return Json(new BtrakJsonResult { Data = getAllRoles, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllRolesDropDown ", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpdateRoleFeature)]
        public JsonResult UpdateRoleFeature(UpdateFeatureInputModel updateFeatureInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpdateRoleFeature", "roleSearchCriteriaInputModel", updateFeatureInputModel, "Role Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                Guid? roleFeatureId = _roleService.UpdateRoleFeature(updateFeatureInputModel, LoggedInContext, validationMessages);
                BtrakJsonResult btrakJsonResult;
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateRoleFeature", "Role Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdateRoleFeature", "Role Api"));
                return Json(new BtrakJsonResult { Data = roleFeatureId, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateRoleFeature ", " RolesApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

    }
}
