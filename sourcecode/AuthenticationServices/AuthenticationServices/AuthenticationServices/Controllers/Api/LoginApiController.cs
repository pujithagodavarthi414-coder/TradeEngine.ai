using System;
using System.Collections.Generic;
using System.Net;
using AuthenticationServices.Common;
//using IdentityServer4.Services;
//using IdentityServer4.Stores;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Mvc;
using System.Net.Http;
using System.Text;
//using System.Web.Http;
using AuthenticationServices.Models;
using AuthenticationServices.Services.Account;
using IdentityModel.Client;
using System.Threading.Tasks;
using System.Web.Http;
using AuthenticationServices.Api.Helpers;
using AuthenticationServices.Api.Models;
using AuthenticationServices.Models.User;
using AuthenticationServices.Services.UserManagement;
using RouteAttribute = Microsoft.AspNetCore.Mvc.RouteAttribute;
using HttpGetAttribute = Microsoft.AspNetCore.Mvc.HttpGetAttribute;
using HttpOptionsAttribute = Microsoft.AspNetCore.Mvc.HttpOptionsAttribute;
using ActionNameAttribute = Microsoft.AspNetCore.Mvc.ActionNameAttribute;
using HttpPostAttribute = Microsoft.AspNetCore.Mvc.HttpPostAttribute;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;

namespace AuthenticationServices.Api.Controllers.Api
{
    [ApiController]
    public class LoginApiController : AuthTokenApiController
    {
        private readonly IAuthenticationSchemeProvider _schemeProvider;
        private readonly BackOfficeService _backOfficeService;

        private readonly IUserManagementService _userManagementService;
        private readonly UserAuthTokenDbHelper _userAuthTokenDbHelper;
        IConfiguration _iconfiguration;
        public LoginApiController(IConfiguration iconfiguration, IAuthenticationSchemeProvider schemeProvider, BackOfficeService backOfficeService,
                IUserManagementService userManagementService, UserAuthTokenDbHelper userAuthTokenDbHelper)
        {
            _iconfiguration = iconfiguration;
            _schemeProvider = schemeProvider;
            _backOfficeService = backOfficeService;
            _userManagementService = userManagementService;
            _userAuthTokenDbHelper = userAuthTokenDbHelper;
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.Authorize)]
        public async Task<object> Authorise(LoginModel auth)
        {
            if (auth == null)
            {
                return null;
            }
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                        "Authorise", "Login Api"));

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue,
                        "Authorise", auth.RequestedUrl));

            LoggingManager.Info("Auth Authentication Object - " + JsonConvert.SerializeObject(auth));

            var isValidAuth = _backOfficeService.ValidateBackOfficeCredentials(auth.UserName, auth.Password,
                auth.RequestedUrl);

            LoggingManager.Debug("Is valid auth" + isValidAuth);


            string hostAddress = auth.HostAddress;
            string webBrowser = HttpContext.Request.Headers["User-Agent"].ToString();

            string timeZone = "Asia/Kolkata";
            if (!string.IsNullOrEmpty(hostAddress) && hostAddress != "::1")
            {
                LoggingManager.Info("Fecting details with ip address, ip address = " + hostAddress);
                var timeZoneApi = _iconfiguration["TimeZoneApi"];
                var timeZoneApiFree = _iconfiguration["TimeZoneApiFree"];
                timeZone = TimeZoneHelper.GetUserCurrentTimeByIp(hostAddress, timeZoneApi, timeZoneApiFree)?.TimeZone;
                LoggingManager.Debug("Timezone details for timezone " + timeZone);

            }

            if (isValidAuth)
            {
                var tokenDetails =
                    await _backOfficeService.GetUserAuthTokenAsync(auth.UserName, auth.Password, auth.RequestedUrl);
                if (auth.IsLiteLogin)
                {
                    InitialDetailsOutputModel initialDetails = new InitialDetailsOutputModel();
                    initialDetails.AuthToken = tokenDetails.AccessToken;
                    UsersModel userModel = _userManagementService.GetUserDetails(tokenDetails.UserId,
                        tokenDetails.CompanyId, null, timeZone);
                    if (userModel?.CompaniesList != null && userModel.CompaniesList.Count > 0)
                    {
                        UserModel userDetailsModel = new UserModel
                        {
                            Id = userModel.Id,
                            Name = userModel.FirstName + ' ' + userModel.SurName,
                            UserName = userModel.UserName,
                            CompanyId = userModel.CompanyId,
                            IsAdmin = false,
                            MobileNo = userModel.MobileNo,
                        };

                        userModel.CompaniesList.ForEach(async x =>
                        {
                            if (x.AuthToken == null)
                            {
                                if (tokenDetails.CompanyId != x.CompanyId)
                                {
                                    var authToken = await _backOfficeService.AuthTokenGeneratorAsync(userDetailsModel);
                                    x.AuthToken = authToken;
                                }
                                else
                                {
                                    x.AuthToken = tokenDetails.AccessToken;
                                }
                            }
                        });

                        initialDetails.UsersModel = userModel;

                        var userAuthToken = new UserAuthToken();
                        userAuthToken.Id = tokenDetails.UserId;
                        userAuthToken.UserId = tokenDetails.UserId;
                        userAuthToken.CompanyId = tokenDetails.CompanyId;
                        userAuthToken.AuthToken = tokenDetails.AccessToken;
                        initialDetails.UserAuthToken = userAuthToken;
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                        "Authorise", "Login Api"));

                    return Json(new BtrakJsonResult { Data = initialDetails, Success = true });
                }
                else
                {
                    var userAuthToken = new UserAuthToken();
                    userAuthToken.Id = tokenDetails.UserId;
                    userAuthToken.UserId = tokenDetails.UserId;
                    userAuthToken.CompanyId = tokenDetails.CompanyId;
                    userAuthToken.AuthToken = tokenDetails.AccessToken;

                    InitialDetailsOutputModel initialDetails =
                        _userManagementService.GetLoggedInUserInitialDetails(userAuthToken, timeZone);
                    initialDetails.AuthToken = userAuthToken.AuthToken;
                    if (initialDetails.UsersModel.CompaniesList != null &&
                        initialDetails.UsersModel.CompaniesList.Count > 1)
                    {
                        UserModel userDetailsModel = new UserModel
                        {
                            Id = initialDetails.UsersModel.Id,
                            Name = initialDetails.UsersModel.FirstName + ' ' + initialDetails.UsersModel.SurName,
                            UserName = initialDetails.UsersModel.UserName,
                            CompanyId = initialDetails.UsersModel.CompanyId,
                            IsAdmin = false,
                            MobileNo = initialDetails.UsersModel.MobileNo,
                        };

                        initialDetails.UsersModel.CompaniesList.ForEach(async x =>
                        {
                            if (x.AuthToken == null)
                            {

                                if (x.CompanyId != null)
                                    userDetailsModel.CompanyId = (Guid)x.CompanyId;
                                //if (userAuthToken.CompanyId != x.CompanyId)
                                //{
                                    var authToken = await _backOfficeService.AuthTokenGeneratorAsync(userDetailsModel);
                                    x.AuthToken = authToken;
                                //}
                                //else
                                //{
                                //    x.AuthToken = userAuthToken.AuthToken;
                                //}
                            }
                        });
                    }

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                        "Authorise", "Login Api"));
                    return Json(new BtrakJsonResult { Data = initialDetails, Success = true });
                }
            }
            var apiResponseMessages = new List<ApiResponseMessage>();
            var validationMessage = new ApiResponseMessage();
            validationMessage.Message = "Unauthorized";
            apiResponseMessages.Add(validationMessage);
            return Json(new BtrakJsonResult { Data = null, Success = false,ApiResponseMessages = apiResponseMessages });
            //var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            //throw new HttpResponseException(httpUnauthorized);
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.AuthorizeNewUser)]
        public async Task<object> AuthoriseNewUser(LoginModel auth)
        {
            if (auth == null)
            {
                return null;
            }

            LoggingManager.Error("Host is - " + HttpContext.Request.Host);

            string hostAddress = auth.HostAddress;
            string webBrowser = HttpContext.Request.Headers["User-Agent"].ToString();

            var isValidAuth = _backOfficeService.ValidateBackOfficeCredentials(auth.UserName, auth.RequestedUrl);

            if (isValidAuth)
            {
                var tokenDetails =
                    await _backOfficeService.GetUserAuthTokenAsync(auth.UserName, auth.Password, auth.RequestedUrl);

                var userAuthToken = new UserAuthToken();
                userAuthToken.Id = tokenDetails.UserId;
                userAuthToken.UserId = tokenDetails.UserId;
                userAuthToken.CompanyId = tokenDetails.CompanyId;
                userAuthToken.AuthToken = tokenDetails.AccessToken;

                InitialDetailsOutputModel initialDetails =
                    _userManagementService.GetLoggedInUserInitialDetails(userAuthToken);

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                    "Authorise", "Login Api"));

                return Json(new BtrakJsonResult { Data = initialDetails, Success = true });

                //var authToken = new UserAuthTokenDbHelper().GetUserAuthToken(auth.UserName, auth.Password);
                //var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(authToken);
                //// UsersModel loggedUserModel = _userService.GetUserDetailsByName(auth.UserName);
                //InitialDetailsOutputModel InitialDetails = _userService.GetLoggedInUserInitialDetails(decodeJwt);
                //LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));
                ////return InitialDetails;
                //TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(decodeJwt.UserId, webBrowser, hostAddress));

                //return Json(new BtrakJsonResult { Data = InitialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }

            var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            throw new HttpResponseException(httpUnauthorized);
        }


        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.ForgotPassword)]
        public JsonResult ForgotPassword(string emailId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ForgotPassword", "Login Api") + ", emailId =" + emailId);
                var validationMessages = new List<ValidationMessage>();
                var resetGuid = _userManagementService.ForgotPassword(emailId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ForgotPassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ForgotPassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = resetGuid, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [ActionName("LogOut")]
        [AllowAnonymous]
        [Route(RouteConstants.ResetPassword)]
        public JsonResult ResetPassword(Guid? resetGuid, int? otp = null)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ResetPassword", "Login Api"));
                var validationMessages = new List<ValidationMessage>();

                var isExpired = _userManagementService.ResetPassword(resetGuid, otp, validationMessages);
                
                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetPassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetPassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = isExpired, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ResetPassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [ActionName("LogOut")]
        [AllowAnonymous]
        [Route(RouteConstants.UpdatePassword)]
        public JsonResult UpdatePassword(UserPasswordResetModel resetPasswordModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePassword", "Login Api"));
                var validationMessages = new List<ValidationMessage>();
                var isSuccess = _userManagementService.UpdatePassword(resetPasswordModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out BtrakJsonResult btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages });
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = isSuccess, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CompanyLogin)]
        public JsonResult UserLoginByCompany(CompaniesList companiesList)
        {
            var userAuthToken = new UserAuthToken
            {
                UserId = companiesList.UserId.Value,
                AuthToken = companiesList.AuthToken,
                CompanyId = companiesList.CompanyId.Value
            };
            if (userAuthToken == null)
            {
                return null;
            }
            InitialDetailsOutputModel initialDetailsOutputModel = _userManagementService.GetLoggedInUserInitialDetails(userAuthToken);

            //return InitialDetails;
            if (initialDetailsOutputModel != null)
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CompanyLogin", "Login Api"));
                return Json(new BtrakJsonResult { Data = initialDetailsOutputModel, Success = true });
            }
            else
            {
                var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                throw new HttpResponseException(httpUnauthorized);
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLoggedInUser)]
        public JsonResult GetLoggedInUser()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLoggedInUser", "Login Api"));

                BtrakJsonResult btrakJsonResult;

                var userModel = new AuthenticationServices.Models.ValidUserOutputmodel()
                {
                    //UserName = AuthorisedUser.UserName,
                    Id = AuthorisedUser.Id,
                    //IsActive = AuthorisedUser.IsActive,
                    IsAdmin = AuthorisedUser.IsAdmin,
                    FirstName = AuthorisedUser.FirstName,
                    SurName = AuthorisedUser.SurName,
                    FullName = AuthorisedUser.FullName,
                    // BranchId = AuthorisedUser.BranchId,
                    ProfileImage = AuthorisedUser.ProfileImage,
                    CompanyId = AuthorisedUser.CompanyId,
                    Email = AuthorisedUser.Email
                    //OriginalId = AuthorisedUser.OriginalId
                };

                UsersModel loggedUserModel = _userManagementService.GetUserDetails(userModel.Id, userModel.CompanyId, LoggedInContext);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLoggedInUser", "Login Api"));
                return Json(new BtrakJsonResult { Data = loggedUserModel, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLoggedInUser", "LoginApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.RefreshAccessToken)]
        public async Task<JsonResult> RefreshAccessToken()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "RefreshAccessToken", "Login Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                UserModel userModel = new UserModel
                {
                    Id = LoggedInContext.LoggedInUserId,
                    CompanyId = LoggedInContext.CompanyGuid
                };
                var accessToken = await _backOfficeService.RefreshAuthTokenGeneratorAsync(userModel);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RefreshAccessToken", "Login Api"));
                return Json(new BtrakJsonResult { Data = accessToken, Success = true });
            }
            catch(Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "RefreshAccessToken", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message));
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRootPathAccess)]
        public JsonResult GetRootPathAccess(AuthUser authUser)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetRootPathAccess", "Login Api"));

                UserAuthToken userAuth = new UserAuthToken()
                {
                    UserId = LoggedInContext.LoggedInUserId,
                    CompanyId = LoggedInContext.CompanyGuid,
                    AuthToken = authUser.AuthToken
                };

                var userDetails = _userAuthTokenDbHelper.IsTokenValid(userAuth, authUser.RootPath);
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "RefreshAccessToken", "Login Api"));

                return Json(new BtrakJsonResult { Data = userDetails, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRootPathAccess", "LoginApiController", exception.Message), exception);
                return Json(new BtrakJsonResult { Data = null, Success = true });
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.GetUserAuthToken)]
        public JsonResult GetUserAuthToken(Guid CompanyId,Guid UserId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUserAuthToken", "Login Api"));

                var userDetails = _backOfficeService.GetUserAuthToken(CompanyId,UserId);
               
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetUserAuthToken", "Login Api"));

                return Json(new BtrakJsonResult { Data = userDetails, Success = true });
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserAuthToken", "LoginApiController", exception.Message), exception);
                return Json(new BtrakJsonResult { Data = null, Success = true });
            }
        }
    }
}
