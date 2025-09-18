using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.User;
using AuthenticationServices.Services.UserManagement;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using AuthenticationServices.Api.Controllers.Api;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Api.Controllers.UserManagement
{
    [ApiController]
    public class UserManagementApiController : AuthTokenApiController
    {
        private BtrakJsonResult _btrakJsonResult;
        IConfiguration _iconfiguration;
        private readonly IUserManagementService _userManagementService;

        public UserManagementApiController(IUserManagementService userManagementService, IConfiguration iconfiguration)
        {
            _btrakJsonResult = new BtrakJsonResult();
            _iconfiguration = iconfiguration;
            _userManagementService = userManagementService;
        }

        [HttpPut]
        [HttpOptions]
        [Route(RouteConstants.UpsertUser)]
        public JsonResult UpsertUser(UserInputModel userModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUser", "userModel", userModel, "User Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                userModel.IdentityServerCallback = _iconfiguration["IdentityServerUrl"];

                Guid? userIdReturned = _userManagementService.UpsertUser(userModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User is completed. Return Guid is " + userIdReturned + ", source command is " + userModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUser", "User Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUser", "Users Management Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUser", "UserManagementApi ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAllUsers)]
        public JsonResult GetAllUsers(Guid? userId = null, string userName = null, Guid? roleId = null, bool? isUsersPage = null, Guid? entityId = null, Guid? branchId = null, bool? isActive = null, string employeeNameText = null, bool? isEmployeeOverviewDetails = null, int pageSize = 100, int pageNumber = 1, string searchText = null,
            string sortBy = null, bool sortDirectionAsc = false, string roleIds = null)
        {
            try
            {
                UserSearchCriteriaInputModel userSearchCriteriaInputModel = ConvertToUserSearchCriteriaInputModel(userId, userName, roleId, isUsersPage, entityId, branchId, isActive, employeeNameText, isEmployeeOverviewDetails,
                    pageSize, pageNumber, searchText, sortBy, sortDirectionAsc, roleIds);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "User Management Api"));

                if (userSearchCriteriaInputModel == null)
                {
                    userSearchCriteriaInputModel = new UserSearchCriteriaInputModel();
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserOutputModel> userModels = _userManagementService.GetAllUsers(userSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers", "User Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers", "User Management Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsers", "UserManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserById)]
        public JsonResult GetUserById(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserById", "User Management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                UserOutputModel userModel = _userManagementService.GetUserById(userId, true, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserById", "User Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserById", "User Management Api"));
                return Json(new BtrakJsonResult { Data = userModel, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserById", "UserManagementApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserProfileDetails)]
        public JsonResult UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserProfileDetails", "userProfileInputModel", userProfileInputModel, "User Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? userIdReturned = _userManagementService.UpsertUserProfileDetails(userProfileInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User is completed. Return Guid is " + userIdReturned + ", source command is " + userProfileInputModel);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserProfileDetails", "User Management Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserProfileDetails", "UserManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ChangePassword)]
        public JsonResult ChangePassword(UserPasswordResetModel changePasswordModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangePassword", "changePasswordModel", changePasswordModel, "User Management Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? isSuccess = _userManagementService.ChangePassword(changePasswordModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangePassword", "User Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangePassword", "User Management Api"));
                return Json(new BtrakJsonResult { Data = isSuccess, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ChangePassword", "UserManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadProfileImage)]
        public JsonResult UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "uploadProfileImage", "uploadProfileImageInputModel", uploadProfileImageInputModel, "User Management Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? userIdReturned = _userManagementService.UploadProfileImage(uploadProfileImageInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User profile image is completed. Return Guid is " + userIdReturned + ", source command is " + uploadProfileImageInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "uploadProfile", "User Management Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "uploadProfile", "User Management Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadProfileImage", "UserManagementApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        private UserSearchCriteriaInputModel ConvertToUserSearchCriteriaInputModel(Guid? userId, string userName, Guid? roleId, bool? isUsersPage, Guid? entityId, Guid? branchId, bool? isActive, string employeeNameText, bool? isEmployeeOverviewDetails, int pageSize, 
            int pageNumber, string searchText, string sortBy, bool sortDirectionAsc, string roleIds)
        {
            UserSearchCriteriaInputModel userSearchCriteriaInputModel = new UserSearchCriteriaInputModel
            {
                UserId = userId,
                UserName = userName,
                RoleId = roleId,
                IsUsersPage = isUsersPage,
                EntityId = entityId,
                BranchId = branchId,
                IsActive = isActive,
                EmployeeNameText = employeeNameText,
                IsEmployeeOverviewDetails = isEmployeeOverviewDetails,
                PageSize = pageSize,
                PageNumber = pageNumber,
                SearchText = searchText,
                SortBy = sortBy,
                SortDirectionAsc = sortDirectionAsc,
                RoleIds = roleIds
            };
            return userSearchCriteriaInputModel;
        }
    }
}
