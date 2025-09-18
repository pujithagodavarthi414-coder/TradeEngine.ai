using Btrak.Models;
using Btrak.Models.User;
using Btrak.Services.User;
using BTrak.Api.Controllers.Api;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using System.Web.Http.Results;

namespace BTrak.Api.Controllers.User
{
    public class UsersApiController : AuthTokenApiController
    {
        private readonly IUserService _userService;
        private BtrakJsonResult _btrakJsonResult;

        public UsersApiController(IUserService userService)
        {
            _userService = userService;
            _btrakJsonResult = new BtrakJsonResult();
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUser)]
        public JsonResult<BtrakJsonResult> UpsertUser(UserInputModel userModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUser", "userModel", userModel, "Users Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? userIdReturned = _userService.UpsertUser(userModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User is completed. Return Guid is " + userIdReturned + ", source command is " + userModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUser", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUser", "Users Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUser", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserProfileDetails)]
        public JsonResult<BtrakJsonResult> UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserProfileDetails", "userProfileInputModel", userProfileInputModel, "Users Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? userIdReturned = _userService.UpsertUserProfileDetails(userProfileInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User is completed. Return Guid is " + userIdReturned + ", source command is " + userProfileInputModel);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserProfileDetails", "Users Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserProfileDetails", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

       

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetAllUsers)]
        public JsonResult<BtrakJsonResult> GetAllUsers(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "Users Api"));

                if (userSearchCriteriaInputModel == null)
                {
                    userSearchCriteriaInputModel = new Btrak.Models.User.UserSearchCriteriaInputModel();
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserOutputModel> userModels = _userService.GetAllUsers(userSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsers", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }


        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUsersMiniData)]
        public JsonResult<BtrakJsonResult> GetUsersMiniData()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersMiniData", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserOutputModel> userModels = _userService.GetAllUsers(new Btrak.Models.User.UserSearchCriteriaInputModel(), LoggedInContext, validationMessages);

                var result = userModels.Select(user => new GetUsersMiniData
                {
                    FullName = user.FullName,
                    MailId = user.Email,
                    UserId = user.Id ?? Guid.Empty,
                    DisplayName = user.FullName + " (" + user.Email + ")"
                });

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersMiniData", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersMiniData", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = result, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersMiniData", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUsersByRoles)]
        public JsonResult<BtrakJsonResult> GetUsersByRoles(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersByRoles", "Users Api"));

                if (userSearchCriteriaInputModel == null)
                {
                    userSearchCriteriaInputModel = new Btrak.Models.User.UserSearchCriteriaInputModel();
                }

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserOutputModel> userModels = _userService.GetUsersByRoles(userSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersByRoles", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersByRoles", "Users Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersByRoles", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUsersList)]
        public JsonResult<BtrakJsonResult> GetUsersList()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "Users Api"));

                Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel = new Btrak.Models.User.UserSearchCriteriaInputModel();

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                //List<UserOutputModel> userModels = new List<UserOutputModel>();
                //userModels.Add(new UserOutputModel { FullName = "Praveen Baruri" });
                //userModels.Add(new UserOutputModel { FullName = "Srihari Kothapalli" });
                //userModels.Add(new UserOutputModel { FullName = "Manoj Gurram" });
                //userModels.Add(new UserOutputModel { FullName = "Sahithi Shaik" });
                //userModels.Add(new UserOutputModel { FullName = "Mounika Gadupudi" });
                //userModels.Add(new UserOutputModel { FullName = "Anupam Vuyyuru" });

                List<UserOutputModel> userModels = _userService.GetAllUsers(userSearchCriteriaInputModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersList", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUsersDropDown)]
        public JsonResult<BtrakJsonResult> GetUsersDropDown(string searchText)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersDropDown", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserDropDownOutputModel> userModels = _userService.GetUsersDropDown(searchText, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersDropDown", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUsersDropDown ", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersDropDown", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetAdhocUsersDropDown)]
        public JsonResult<BtrakJsonResult> GetAdhocUsersDropDown(string searchText,bool? isForDropDown)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Adhoc Users DropDown", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakApiResult;

                List<UserDropDownOutputModel> userModels = _userService.GetAdhocUsersDropDown(searchText, isForDropDown, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakApiResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Adhoc Users DropDown", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakApiResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Get Adhoc Users DropDown ", "Users Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAdhocUsersDropDown", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserById)]
        public JsonResult<BtrakJsonResult> GetUserById(Guid? userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserById", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                UserOutputModel userModel = _userService.GetUserById(userId, true, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserById", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserById", "Users Api"));
                return Json(new BtrakJsonResult { Data = userModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserById", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.ChangePassword)]
        public JsonResult<BtrakJsonResult> ChangePassword(UserPasswordResetModel changePasswordModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangePassword", "changePasswordModel", changePasswordModel, "User Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                Guid? isSuccess = _userService.ChangePassword(changePasswordModel, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangePassword", "User Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ChangePassword", "User Api"));
                return Json(new BtrakJsonResult { Data = isSuccess, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ChangePassword", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetUsersForSlack)]
        public JsonResult<BtrakJsonResult> GetAllUsersForSlackApp(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel)
        {
            if (userSearchCriteriaInputModel == null)
            {
                userSearchCriteriaInputModel = new Btrak.Models.User.UserSearchCriteriaInputModel();
            }

            try
            {
                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                List<Btrak.Models.User.UserModel> userModels = _userService.GetAllUsersForSlackApp(userSearchCriteriaInputModel, LoggedInContext, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    if (_btrakJsonResult.ApiResponseMessages.Count > 0)
                    {
                        return Json(
                            new BtrakJsonResult
                            { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages },
                            UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                }

                LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetAllUsers Test Suite", "Test Suite Api"));
                return Json(new BtrakJsonResult { Data = userModels, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsersForSlackApp", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UploadProfileImage)]
        public JsonResult<BtrakJsonResult> UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "uploadProfileImage", "uploadProfileImageInputModel", uploadProfileImageInputModel, "Users Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                Guid? userIdReturned = _userService.UploadProfileImage(uploadProfileImageInputModel, LoggedInContext, validationMessages);
                LoggingManager.Info("Upsert User profile image is completed. Return Guid is " + userIdReturned + ", source command is " + uploadProfileImageInputModel);

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "uploadProfile", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "uploadProfile", "Users Api"));
                return Json(new BtrakJsonResult { Data = userIdReturned, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UploadProfileImage", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.UpsertUserWebHooks)]
        public JsonResult<BtrakJsonResult> UpsertUserWebHooks(UserWebHookInputModel userWebHookInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "uploadProfileImage", "uploadProfileImageInputModel", userWebHookInputModel, "Users Api"));
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                bool result = _userService.UpsertUserWebHooks(userWebHookInputModel, LoggedInContext, validationMessages);

                LoggingManager.Info("Upsert User Webhook is completed");

                if (UiHelper.CheckForValidationMessages(validationMessages, out _btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWebHook", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = _btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertWebHook", "Users Api"));
                return Json(new BtrakJsonResult { Data = result ,Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserWebHooks", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetUserWebHooksById)]
        public JsonResult<BtrakJsonResult> GetUserWebHooksById(Guid userId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserWebHooksById", "Users Api"));

                List<ValidationMessage> validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;

                UserWebHookInputModel userWebHooks = _userService.GetUserWebHooksById(userId, LoggedInContext, validationMessages);

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserWebHooksById", "Users Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserWebHooksById", "Users Api"));
                return Json(new BtrakJsonResult { Data= userWebHooks , Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserWebHooksById", "UsersApiController ", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [Route("Company/GetAllCompanies")]
        public List<string> GetAllCompanies()
        {
            List<string> companies = new List<string>();
            companies.Add("Snovasys");
            companies.Add("Raster");
            companies.Add("Access");
            companies.Add("Barclays");

            return companies;
        }
    }
}