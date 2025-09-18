using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.User;
using Btrak.Services.Account;
using Btrak.Services.SMS;
using BTrak.Api.Helpers;
using BTrak.Api.Models;
using BTrak.Common;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Mail;
using System.Web;
using System.Web.Http;
using System.Web.Http.Results;
using UserModel = Btrak.Models.UserModel;
using Btrak.Models.Crm.Sms;
using BusinessView.Common;
using Newtonsoft.Json;
using ApiWrapper = BusinessView.Common.ApiWrapper;

namespace BTrak.Api.Controllers.Api
{
    public class LoginApiController : AuthTokenApiController
    {
        private readonly UserAuthTokenFactory _userAuthTokenFactory = new UserAuthTokenFactory();
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly CompanyStructureRepository _companyStructureRepository = new CompanyStructureRepository();
        private readonly RoleFeatureRepository _roleFeatureRepository = new RoleFeatureRepository();
        private readonly MasterDataManagementRepository _masterDataRepository = new MasterDataManagementRepository();
        private readonly Btrak.Services.User.IUserService _userService;
        private readonly UserRepository _userRepository = new UserRepository();
        private readonly ISmsService _smsService;

        public LoginApiController(Btrak.Services.User.IUserService userService, MasterDataManagementRepository masterDataManagementRepository,
            ISmsService smsService)
        {
            _userService = userService;
            _masterDataRepository = masterDataManagementRepository;
            _smsService = smsService;
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.Authorize)]
        public object Authorise(LoginModel auth)
        {
           // _userService.UpdateStatusesOfResignedUsers();
            if (auth == null)
            {
                return null;
            }

            auth.RequestedUrl = HttpContext.Current.Request.Url.Authority;
            string hostAddress = HttpContext.Current.Request.UserHostAddress;
            auth.HostAddress = hostAddress;
            LoggingManager.Info("Auth API Object - " + JsonConvert.SerializeObject(auth));
            var result = ApiWrapper.AnnonymousPostentityToApiAwait(RouteConstants.Authorize, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], auth).Result;
            var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);

            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var authDetails = JsonConvert.DeserializeObject<InitialDetailsOutputModel>(jsonResponse);

                //var isValidAuth = new BackOfficeService().ValidateBackOfficeCredentials(auth.UserName, auth.Password);

                string webBrowser = HttpContext.Current.Request.Browser.Browser.ToString();

                string timeZone = "Asia/Kolkata";
                //if (!string.IsNullOrEmpty(hostAddress) && hostAddress != "::1")
                //{
                //    LoggingManager.Info("Fecting details with ip address, ip address = " + hostAddress);
                //    timeZone = TimeZoneHelper.GetUserCurrentTimeByIp(hostAddress)?.TimeZone;
                //}

                //if (isValidAuth)
                //{

                //var authToken = new UserAuthTokenDbHelper().GetUserAuthToken(auth.UserName, auth.Password);
                var decodeJwt = authDetails.UserAuthToken;//_userAuthTokenFactory.DecodeUserAuthToken(authToken);

            //    TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(decodeJwt.UserId, webBrowser, hostAddress));

            //    if (auth.IsLiteLogin)
            //    {
            //        InitialDetailsOutputModel initialDetails = new InitialDetailsOutputModel();
            //        UsersModel userModel = _userService.GetUserDetails(decodeJwt.UserId, null, timeZone);

            //        //code for company log in
            //        if (userModel?.CompaniesList != null && userModel.CompaniesList.Count > 1)
            //        {
            //            userModel.CompaniesList.ForEach(x =>
            //            {
            //                if (x.AuthToken == null)
            //                {
            //                    UserAuthToken userAuthToken = new UserAuthToken
            //                    {
            //                        UserId = x.UserId.Value,
            //                        UserName = userModel.UserName,
            //                        CompanyId = x.CompanyId.Value
            //                    };

                if (auth.IsLiteLogin)
                {
                    InitialDetailsOutputModel initialDetails = new InitialDetailsOutputModel();
                    //new InitialDetailsOutputModel();
                    
                    LoggedInContext loggedInUser = new LoggedInContext();
                    loggedInUser.CompanyGuid = decodeJwt.CompanyId;
                    var userId = _userRepository.GetUserByUserAuthenticationIdAndCompanyId(decodeJwt.UserId, loggedInUser, new List<ValidationMessage>());
                    
                    UsersModel userModel = _userService.GetUserDetails(userId, null, timeZone);
                    initialDetails.UsersModel = userModel;
                    initialDetails.UsersModel.CompaniesList = authDetails.UsersModel.CompaniesList;
                    initialDetails.UsersModel.CompaniesListXml = authDetails.UsersModel.CompaniesListXml;
                    initialDetails.UsersModel.Id = authDetails.UsersModel.Id;
                    ////code for company log in
                    //if (userModel?.CompaniesList != null && userModel.CompaniesList.Count > 1)
                    //{
                    //    userModel.CompaniesList.ForEach(x =>
                    //    {
                    //        if (x.AuthToken == null)
                    //        {
                    //            UserAuthToken userAuthToken = new UserAuthToken
                    //            {
                    //                UserId = x.UserId.Value,
                    //                UserName = userModel.UserName,
                    //                CompanyId = x.CompanyId.Value
                    //            };

                    //            UserAuthToken userAuth = new UserAuthTokenDbHelper().GenerateAuth(userAuthToken);

                    //            x.AuthToken = userAuth.AuthToken;
                    //        }
                    //    });


                    //    initialDetails.UsersModel = userModel;
                    //}
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));

                    return Json(new BtrakJsonResult { Data = initialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                else
                {
                    InitialDetailsOutputModel InitialDetails = _userService.GetLoggedInUserInitialDetails(decodeJwt, timeZone);
                    InitialDetails.UsersModel.CompaniesList = authDetails.UsersModel.CompaniesList;
                    InitialDetails.UsersModel.CompaniesListXml = authDetails.UsersModel.CompaniesListXml;
                    InitialDetails.UsersModel.Id = authDetails.UsersModel.Id;
                    InitialDetails.CompanyDetails = authDetails.CompanyDetails;
                    InitialDetails.CompanySettings = authDetails.CompanySettings;
                    //if (InitialDetails.UsersModel.CompaniesList != null && InitialDetails.UsersModel.CompaniesList.Count > 1)
                    //{
                    //    InitialDetails.UsersModel.CompaniesList.ForEach(x =>
                    //    {
                    //        if (x.AuthToken == null)
                    //        {
                    //            UserAuthToken userAuthToken = new UserAuthToken
                    //            {
                    //                UserId = x.UserId.Value,
                    //                UserName = InitialDetails.UsersModel.UserName,
                    //                CompanyId = x.CompanyId.Value
                    //            };
                    //            UserAuthToken userAuth = new UserAuthTokenDbHelper().GenerateAuth(userAuthToken);
                    //            x.AuthToken = userAuth.AuthToken;
                    //        }
                    //    });
                    //}
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));
                    //return InitialDetails;
                    return Json(new BtrakJsonResult { Data = InitialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                //}

            }
            var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            throw new HttpResponseException(httpUnauthorized);
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.AuthorizeNewUser)]
        public object AuthoriseNewUser(LoginModel auth)
        {
            if (auth == null)
            {
                return null;
            }

            LoggingManager.Error("Host is - " + HttpContext.Current.Request.Url.Host);
            
            auth.RequestedUrl = HttpContext.Current.Request.Url.Authority;
            string hostAddress = HttpContext.Current.Request.UserHostAddress;
            string webBrowser = HttpContext.Current.Request.Browser.Browser.ToString();

            auth.HostAddress = hostAddress;
            //var companyId =
            //    new BackOfficeService().GetCompanyIdBySiteAddress(HttpContext.Current.Request.Url.Host);

            //if (companyId != null)
            //{
            //    var isValidAuth = new BackOfficeService().ValidateBackOfficeCredentialsByCompanyId(auth.UserName, auth.Password, (Guid)companyId);

            //    if (isValidAuth)
            //    {
            //        var authToken = new UserAuthTokenDbHelper().GetUserAuthToken(auth.UserName);
            //        return authToken;
            //    }
            //}
            var result = ApiWrapper.AnnonymousPostentityToApiAwait(RouteConstants.AuthorizeNewUser, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], auth).Result;
            var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);

            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var authDetails = JsonConvert.DeserializeObject<InitialDetailsOutputModel>(jsonResponse);

                var isValidAuth = new BackOfficeService().ValidateBackOfficeCredentials(auth.UserName);

                if (isValidAuth)
                {
                    //var authToken = new UserAuthTokenDbHelper().GetUserAuthToken(auth.UserName, auth.Password);
                    var decodeJwt = authDetails.UserAuthToken; // var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(authToken);
                    // UsersModel loggedUserModel = _userService.GetUserDetailsByName(auth.UserName);
                    InitialDetailsOutputModel InitialDetails = _userService.GetLoggedInUserInitialDetails(decodeJwt);
                    InitialDetails.UsersModel.CompaniesList = authDetails.UsersModel.CompaniesList;
                    InitialDetails.UsersModel.CompaniesListXml = authDetails.UsersModel.CompaniesListXml;
                    InitialDetails.UsersModel.Id = authDetails.UsersModel.Id;
                    InitialDetails.CompanyDetails = authDetails.CompanyDetails;
                    InitialDetails.CompanySettings = authDetails.CompanySettings;

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));
                    //return InitialDetails;
                    TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(decodeJwt.UserId, webBrowser, hostAddress));

                    return Json(new BtrakJsonResult { Data = InitialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
            }
            var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            throw new HttpResponseException(httpUnauthorized);
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.GetRootPathAccess)]
        public object GetRootPathAccess(Btrak.Models.AuthUser user)
        {
            var result = ApiWrapper.PostentityToApi(RouteConstants.GetRootPathAccess, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], user, user.AuthToken).Result;
            var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);

            //var validUser = new UserAuthTokenDbHelper().GetRootPathAccess(user.AuthToken, user.RootPath);
            //return validUser;
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var authDetails = JsonConvert.DeserializeObject<ValidUserOutputmodel>(jsonResponse);
                return authDetails;
            }
            else
            {
                return null;
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.AuthorizeUserFromGoogle)]
        public object AuthorizeUserFromGoogle(LoginModel auth)
        {
            if (auth == null)
            {
                return null;
            }

            LoggingManager.Error("Host is - " + HttpContext.Current.Request.Url.Host);

            var isValidAuth = new BackOfficeService().ValidateBackOfficeCredentials(auth.UserName);

            auth.RequestedUrl = HttpContext.Current.Request.Url.Authority;
            string hostAddress = HttpContext.Current.Request.UserHostAddress;
            string webBrowser = HttpContext.Current.Request.Browser.Browser.ToString();

            if (!isValidAuth)
            {
                List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                string url = HttpContext.Current.Request.Url.Authority;

                var splits = HttpContext.Current.Request.Url.Authority.Split('.');

                MailAddress address = new MailAddress(auth.UserName);

                var firstName = auth.Name.Split(' ')?.FirstOrDefault().Trim();

                var lastName = string.IsNullOrEmpty(auth.Name.Substring(firstName.Length, auth.Name.Length - firstName.Length)?.ToString()?.Trim()) ? auth.Name.Trim() : auth.Name.Substring(firstName.Length, auth.Name.Length - firstName.Length)?.ToString()?.Trim();

                GoogleNewUserModel googleNewUser = new GoogleNewUserModel()
                {
                    Email = auth.UserName,
                    FirstName = firstName,
                    SurName = lastName,
                    ProfileImage = auth.Image,
                    UserDomain = address.Host,
                    Password = Utilities.GetSaltedPassword("Test123!"),
                    SiteAddress = splits[0],
                    CanByPassUserCompanyValidation = !ConfigurationManager.AppSettings.AllKeys.Contains("EnvironmentName") ? true : ConfigurationManager.AppSettings["EnvironmentName"] != "Production"
                };

                Guid? userIdReturned = _masterDataRepository.ValidateAndUpsertGoogleUser(googleNewUser, validationMessages);

                if (validationMessages.Count > 0)
                {
                    throw new HttpResponseException(new HttpResponseMessage(HttpStatusCode.Unauthorized));
                }
                isValidAuth = true;
            }

            if (isValidAuth)
            {
                var authToken = new UserAuthTokenDbHelper().GetUserAuthToken(auth.UserName, auth.Password);
                var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(authToken);
                InitialDetailsOutputModel InitialDetails = _userService.GetLoggedInUserInitialDetails(decodeJwt); LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));
                TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(decodeJwt.UserId, webBrowser, hostAddress));
                return Json(new BtrakJsonResult { Data = InitialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
            throw new HttpResponseException(httpUnauthorized);
        }

        [HttpGet]
        [HttpOptions]
        [Route(RouteConstants.GetLoggedInUser)]
        public JsonResult<BtrakJsonResult> GetLoggedInUser()
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetLoggedInUser", "Login Api"));

                BtrakJsonResult btrakJsonResult;

                var result = BusinessView.Common.ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.GetLoggedInUser, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], new List<ParamsInputModel>(), LoggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);

                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    var authDetails = JsonConvert.DeserializeObject<UsersModel>(jsonResponse);
                    var userModel = new ValidUserOutputmodel()
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

                    UsersModel loggedUserModel = _userService.GetUserDetails(userModel.Id, LoggedInContext);
                    loggedUserModel.Id = (Guid)AuthorisedUser.UserAuthenticationId;
                    loggedUserModel.CompaniesList = authDetails.CompaniesList;
                    loggedUserModel.CompaniesListXml = authDetails.CompaniesListXml;

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLoggedInUser", "Login Api"));
                    return Json(new BtrakJsonResult { Data = loggedUserModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                else
                {
                    if (responseJson?.ApiResponseMessages.Count > 0)
                    {
                        List<ValidationMessage> validationMessages = new List<ValidationMessage>();

                        validationMessages.Add(new ValidationMessage()
                        {
                            ValidationMessaage = responseJson.ApiResponseMessages[0].Message,
                            ValidationMessageType = MessageTypeEnum.Error
                        });

                        if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                        {
                            validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                            LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "GetLoggedInUser", "Login Api"));
                            return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                        }
                        return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = new List<ApiResponseMessage>() }, UiHelper.JsonSerializerNullValueIncludeSettings);
                    }
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = new List<ApiResponseMessage>() }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLoggedInUser", "LoginApiController", exception.Message), exception);
                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [AllowAnonymous]
        [Route(RouteConstants.LoginUserForMobile)]
        public JsonResult<BtrakSlackJsonResult> LoginUserForMoble(string userName, string password)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "LoginUserForMoble",
                "LoginApiController"));

            var userModel = new UserModel();

            try
            {
                var isValidAuth = new BackOfficeService().ValidateBackOfficeCredentials(userName, password);

                if (isValidAuth)
                {
                    var user = new BackOfficeService().GetByUsername(userName, password);

                    if (user.Id != null)
                    {
                        var hasAuthToken = new UserAuthTokenDbHelper().GetAuthToken(user.Id);

                        if (hasAuthToken != null)
                        {
                            userModel.Token = hasAuthToken.AuthToken;
                        }
                        else
                        {
                            var newToken = new UserAuthToken
                            {
                                UserId = user.Id.Value,
                                UserName = user.UserName,
                                CompanyId = user.CompanyId
                            };

                            var authToken = _userAuthTokenFactory.GenerateUserAuthToken(newToken);

                            new UserAuthTokenDbHelper().InsertAuthToken(authToken);

                            userModel.Token = authToken.AuthToken;
                        }
                    }
                    else
                    {
                        throw new Exception("Unexpected exception.");
                    }

                    userModel.Id = user.Id;
                    userModel.IsPasswordForceReset = user.IsPasswordForceReset;
                    userModel.MobileNo = user.MobileNo;
                    userModel.Name = user.Name;
                    userModel.UserName = user.UserName;
                    userModel.CompanyGuid = user.CompanyId;
                    //userModel.RoleId = user.RoleId;
                    userModel.IsAdmin = user.IsAdmin;
                }
                else
                {
                    userModel = new UserModel
                    {
                        Token = "Invalid Email or Password"
                    };
                }
            }
            catch (Exception ex)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "LoginUserForMoble", "LoginApiController", ex.Message), ex);

            }

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue,
                "LoginUserForMoble", "LoginApiController"));

            return Json(new BtrakSlackJsonResult { Data = userModel }, UiHelper.JsonSerializerNullValueIncludeSettings);
        }

        [HttpGet]
        [HttpOptions]
        [ActionName("LogOut")]
        [Route(RouteConstants.ResetPassword)]
        [AllowAnonymous]
        public bool IsResetLinkExpired(Guid requestedId)
        {
            var resetPasswordRepository = new ResetPasswordRepository();
            var resetPasswordDbEntity = resetPasswordRepository.SelectAll().Where(x => x.IsExpired != null && x.ResetGuid == requestedId && !x.IsExpired.Value).Select(x => x).FirstOrDefault();
            bool isExpired = resetPasswordDbEntity == null;
            return isExpired;
        }

        [HttpGet]
        [HttpOptions]
        [ActionName("LogOut")]
        [Route(RouteConstants.LogOut)]
        public void LogOut()
        {
            try
            {
                new UserAuthTokenDbHelper().DeleteAuthToken(AuthorisedUser.Id);
                //UiHelper.LogOut();
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "LogOut", "LoginApiController", exception.Message), exception);

            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.Login)]
        public JsonResult<BtrakJsonResult> Login(string emailId, string password)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Login", "Login Api") + ", emailId =" + emailId);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                bool isExisted = _userService.IsUserExisted(emailId, password, validationMessages);
                if (isExisted)
                {
                    var token = new UserAuthTokenDbHelper().GetUserAuthToken(emailId, password);
                    var userModel = _userService.GetUserDetailsByName(emailId);
                    if (userModel != null)
                    {
                        userModel.Token = token;
                        UiHelper.SetUserModel(userModel);
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Login", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Login", "Login Api"));
                return Json(new BtrakJsonResult { Data = isExisted, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Login", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.ForgotPassword)]
        public JsonResult<BtrakJsonResult> ForgotPassword(string emailId)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ForgotPassword", "Login Api") + ", emailId =" + emailId);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var isMailSent = _userService.ForgotPassword(emailId, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ForgotPassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ForgotPassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = isMailSent, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpGet]
        [HttpOptions]
        [ActionName("LogOut")]
        [AllowAnonymous]
        [Route(RouteConstants.ResetPassword)]
        public JsonResult<BtrakJsonResult> ResetPassword(Guid? resetGuid)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "ResetPassword",
                    "Login Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var isExpired = _userService.ResetPassword(resetGuid, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetPassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "ResetPassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = isExpired, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ResetPassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [ActionName("LogOut")]
        [AllowAnonymous]
        [Route(RouteConstants.UpdatePassword)]
        public JsonResult<BtrakJsonResult> UpdatePassword(UserPasswordResetModel resetPasswordModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "UpdatePassword", "Login Api"));
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                var isSuccess = _userService.UpdatePassword(resetPasswordModel, validationMessages);
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePassword", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpdatePassword", "Login Api"));
                return Json(new BtrakJsonResult { Data = isSuccess, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdatePassword", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.CompanyLogin)]
        public JsonResult<BtrakJsonResult> UserLoginByCompany(CompaniesList companiesList)
        {

            var result = ApiWrapper.PostentityToApi(RouteConstants.CompanyLogin, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], companiesList, companiesList.AuthToken).Result;
            var responseJson = JsonConvert.DeserializeObject<BtrakJsonResult>(result);

            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var authDetails = JsonConvert.DeserializeObject<InitialDetailsOutputModel>(jsonResponse);
                
                string hostAddress = HttpContext.Current.Request.UserHostAddress;
                string webBrowser = HttpContext.Current.Request.Browser.Browser.ToString();

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
                InitialDetailsOutputModel initialDetailsOutputModel = _userService.GetLoggedInUserInitialDetails(userAuthToken);
                initialDetailsOutputModel.UsersModel.CompaniesList = authDetails.UsersModel.CompaniesList;
                initialDetailsOutputModel.UsersModel.CompaniesListXml = authDetails.UsersModel.CompaniesListXml;
                initialDetailsOutputModel.UsersModel.Id = authDetails.UsersModel.Id;
                initialDetailsOutputModel.CompanyDetails = authDetails.CompanyDetails;
                initialDetailsOutputModel.CompanySettings = authDetails.CompanySettings;

                if (userAuthToken != null)
                {
                    TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(userAuthToken.UserId, webBrowser, hostAddress));
                }

                //return InitialDetails;
                if (initialDetailsOutputModel != null)
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "CompanyLogin", "Login Api"));
                    return Json(new BtrakJsonResult { Data = initialDetailsOutputModel, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                else
                {
                    var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                    throw new HttpResponseException(httpUnauthorized);
                }
            }
            else
            {
                var httpUnauthorized = new HttpResponseMessage(HttpStatusCode.Unauthorized);
                throw new HttpResponseException(httpUnauthorized);
            }
        }

        [HttpPost]
        [HttpOptions]
        [AllowAnonymous]
        [Route(RouteConstants.MobileLogin)]
        public JsonResult<BtrakJsonResult> MobileLogin(MobileAuthenticationInputModel mobileAuthenticationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Login", "Login Api") + ", mobile number=" + mobileAuthenticationInputModel.MobileNumber);
                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                bool isExisted = _userService.IsMobileNumberExists(mobileAuthenticationInputModel.MobileNumber, validationMessages);
                if (isExisted)
                {
                    var userModel = _userService.GetUserDetailsByMobile(mobileAuthenticationInputModel.MobileNumber);

                    if (userModel != null)
                    {
                        SendSmsInputModel sendSmsInputModel = new SendSmsInputModel();
                        sendSmsInputModel.MobileNumber = string.Concat(mobileAuthenticationInputModel.CountryCode, mobileAuthenticationInputModel.MobileNumber); ;
                        sendSmsInputModel.IsOtp = true;
                        sendSmsInputModel.UserId = userModel.Id;
                        sendSmsInputModel.OtpNumber = mobileAuthenticationInputModel.otp;
                        SMSServiceResponse smsServiceResponse = _smsService.ValidateOTP(sendSmsInputModel, LoggedInContext, validationMessages);
                        if (smsServiceResponse.Type == "success")
                        {
                            var token = new UserAuthTokenDbHelper().GetUserAuthTokenFromMobileNumber(mobileAuthenticationInputModel.MobileNumber);
                            //var userModel = _userService.GetUserDetailsByMobile(mobileAuthenticationInputModel.MobileNumber);
                            if (userModel != null)
                            {
                                userModel.Token = token;
                                UiHelper.SetUserModel(userModel);

                                var decodeJwt = _userAuthTokenFactory.DecodeUserAuthToken(token);
                                // UsersModel loggedUserModel = _userService.GetUserDetailsByName(auth.UserName);
                                InitialDetailsOutputModel InitialDetails = _userService.GetLoggedInUserInitialDetails(decodeJwt);
                                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Authorise", "Login Api"));
                                //return InitialDetails;

                                string hostAddress = HttpContext.Current.Request.UserHostAddress;
                                string webBrowser = HttpContext.Current.Request.Browser.Browser.ToString();
                                TaskWrapper.ExecuteFunctionInNewThread(() => _userRepository.LoginAudit(decodeJwt.UserId, webBrowser, hostAddress));

                                return Json(new BtrakJsonResult { Data = InitialDetails, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);


                            }
                        }
                        else
                        {
                            validationMessages.Add(new ValidationMessage
                            {
                                ValidationMessageType = MessageTypeEnum.Error,
                                ValidationMessaage = smsServiceResponse.Message
                            });
                        }
                    }
                }

                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Login", "Login Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Login", "Login Api"));
                return Json(new BtrakJsonResult { Data = isExisted, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "Login", "LoginApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }

        [HttpPost]
        [HttpOptions]
        [Route(RouteConstants.SendLoginOTP)]
        [AllowAnonymous]
        public JsonResult<BtrakJsonResult> SendLoginOTP(MobileAuthenticationInputModel mobileAuthenticationInputModel)
        {
            try
            {
                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "SendOTP", "SMS Api") + " " + mobileAuthenticationInputModel);

                var validationMessages = new List<ValidationMessage>();
                BtrakJsonResult btrakJsonResult;
                bool isExisted = _userService.IsMobileNumberExists(mobileAuthenticationInputModel.MobileNumber, validationMessages);
                if (isExisted)
                {
                    var userModel = _userService.GetUserDetailsByMobile(mobileAuthenticationInputModel.MobileNumber);

                    SendSmsInputModel sendSmsInputModel = new SendSmsInputModel();
                    sendSmsInputModel.MobileNumber = string.Concat(mobileAuthenticationInputModel.CountryCode, mobileAuthenticationInputModel.MobileNumber);
                    sendSmsInputModel.IsOtp = true;
                    sendSmsInputModel.UserId = userModel.Id;
                    object smsResponse = _smsService.SendOTP(sendSmsInputModel, LoggedInContext, validationMessages);

                    LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendOTP", "SMS Api"));
                    return Json(new BtrakJsonResult { Data = smsResponse, Success = true }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }
                if (UiHelper.CheckForValidationMessages(validationMessages, out btrakJsonResult))
                {
                    validationMessages.ForEach(validationMessage => LoggingManager.Warn(validationMessage.ToString()));
                    LoggingManager.Warn(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendOTP", "SMS Api"));
                    return Json(new BtrakJsonResult { Success = false, ApiResponseMessages = btrakJsonResult.ApiResponseMessages }, UiHelper.JsonSerializerNullValueIncludeSettings);
                }

                LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "SendOTP", "SMS Api"));
                return Json(new BtrakJsonResult { Data = isExisted, Success = false }, UiHelper.JsonSerializerNullValueIncludeSettings);
            }
            catch (Exception exception)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SendOTP", "SmsApiController", exception.Message), exception);

                return Json(new BtrakJsonResult(exception.Message), UiHelper.JsonSerializerNullValueIncludeSettings);
            }
        }
    }
}
