using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.Partial;
using Btrak.Dapper.Dal.Repositories;
using Btrak.Models;
using Btrak.Models.CompanyStructure;
using Btrak.Models.EmailTemplates;
using Btrak.Models.Employee;
using Btrak.Models.MasterData;
using Btrak.Models.SoftLabelConfigurations;
using Btrak.Models.SystemManagement;
using Btrak.Models.User;
using Btrak.Models.Widgets;
using Btrak.Services.Account;
using Btrak.Services.Audit;
using Btrak.Services.CompanyStructure;
using Btrak.Services.Email;
using Btrak.Services.Helpers;
using Btrak.Services.HrManagement;
using BTrak.Common;
using BusinessView.Common;
using Hangfire;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using JsonDeserialiseData = BTrak.Common.JsonDeserialiseData;

namespace Btrak.Services.User
{
    public class UserService : IUserService
    {
        //NEW Code
        private readonly UserRepository _userRepository;
        private readonly GoalRepository _goalRepository = new GoalRepository();
        private readonly IAuditService _auditService;
        private readonly ICompanyStructureService _companyStructureService;
        private readonly IEmailService _emailService;
        private readonly IHrManagementService _hrManagementService;
        private readonly CompanyStructureRepository _companyStructureRepository = new CompanyStructureRepository();
        private readonly WidgetRepository _widgetRepository = new WidgetRepository();
        private readonly RoleFeatureRepository _roleFeatureRepository = new RoleFeatureRepository();
        private readonly MasterDataManagementRepository _masterDataManagementRepository = new MasterDataManagementRepository();

        public UserService(UserRepository userRepository, IHrManagementService hrManagementService, IAuditService auditService, ICompanyStructureService companyStructureService, IEmailService emailService)
        {
            _userRepository = userRepository;
            _auditService = auditService;
            _companyStructureService = companyStructureService;
            _hrManagementService = hrManagementService;
            _emailService = emailService;
        }

        public Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUser", "userModel", userModel, "User Service"));

            if (!UserValidationHelpers.UpsertUserValidation(userModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var result = ApiWrapper.PutentityToApi(RouteConstants.ASUpsertUser, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], userModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                var idGuid = Convert.ToString(responseJson.Data);
                userModel.UserAuthenticationId = new Guid(idGuid);
                bool isNewEmployee = userModel.UserId == null;
                UserDbEntity userOldData = null;

                if (userModel.UserId == null && userModel.Password == null)
                {
                    //userModel.Password = userModel.FirstName + "." + userModel.SurName + "!";
                    userModel.Password = "Test123!";
                }

                if (!string.IsNullOrEmpty(userModel.Password) && !string.IsNullOrWhiteSpace(userModel.Password))
                {
                    userModel.Password = Utilities.GetSaltedPassword(userModel.Password);
                }

                if (userModel != null && userModel.ModuleIds != null && userModel.ModuleIds.Count > 0)
                {
                    userModel.ModuleIdsXml = Utilities.GetXmlFromObject(userModel.ModuleIds);
                }

                if (!isNewEmployee)
                {
                    var userId = _userRepository.GetUserByUserAuthenticationIdAndCompanyId(userModel.UserAuthenticationId, loggedInContext, validationMessages);
                    userModel.UserId = userId;
                    userOldData = _userRepository.GetSingleUserDetails(userModel.UserId.GetValueOrDefault());
                }

                userModel.UserId = _userRepository.UpsertUser(userModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertUserCommandId, userModel, loggedInContext);

                LoggingManager.Debug(userModel.UserId?.ToString());

                if (isNewEmployee || (userModel.IsExternal && !userOldData.IsExternal))
                {
                    UserRegistrationDetailsModel userRegistrationDetails = new UserRegistrationDetailsModel()
                    {
                        UserName = userModel.Email,
                        FirstName = userModel.FirstName,
                        SurName = userModel.SurName,
                        RoleIds = userModel.RoleId,
                        Password = "Test123!"
                    };

                    if (userModel.IsExternal)
                    {
                        BackgroundJob.Enqueue(() => SendExternalUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
                    }
                    else
                    {
                        BackgroundJob.Enqueue(() => _hrManagementService.SendUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
                    }
                }

                return userModel.UserId;
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

        public Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserProfileDetails", "UpsertUserProfileDetails", userProfileInputModel, "User Service"));

            if (!UserValidationHelpers.UpsertUserProfileValidation(userProfileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            var result = ApiWrapper.PostentityToApi(RouteConstants.ASUpsertUserProfileDetails, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], userProfileInputModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                userProfileInputModel.UserId = new Guid(responseid);
                Guid? userId = _userRepository.UpsertUserProfileDetails(userProfileInputModel, loggedInContext, validationMessages);

                _auditService.SaveAudit(AppCommandConstants.UpsertUserCommandId, userProfileInputModel, loggedInContext);

                LoggingManager.Debug(userId?.ToString());

                return userId;
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

        public List<UserOutputModel> GetAllUsers(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "User Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllUsersCommandId, userSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }
            var configurationUrl = ConfigurationManager.AppSettings["AuthenticationServiceBasePath"];
           
            List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "userId";
            paramsModel.Value = userSearchCriteriaInputModel.UserId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "userName";
            paramsModel.Value = userSearchCriteriaInputModel.UserName;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "RoleIds";
            paramsModel.Value = userSearchCriteriaInputModel.RoleIds;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "roleId";
            paramsModel.Value = userSearchCriteriaInputModel.RoleId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "bool?";
            paramsModel.Key = "isUsersPage";
            paramsModel.Value = userSearchCriteriaInputModel.IsUsersPage;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "entityId";
            paramsModel.Value = userSearchCriteriaInputModel.EntityId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "branchId";
            paramsModel.Value = userSearchCriteriaInputModel.BranchId;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "bool?";
            paramsModel.Key = "isActive";
            paramsModel.Value = userSearchCriteriaInputModel.IsActive;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "employeeNameText";
            paramsModel.Value = userSearchCriteriaInputModel.EmployeeNameText;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "bool?";
            paramsModel.Key = "isEmployeeOverviewDetails";
            paramsModel.Value = userSearchCriteriaInputModel.IsEmployeeOverviewDetails;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "int";
            paramsModel.Key = "pageSize";
            paramsModel.Value = userSearchCriteriaInputModel.PageSize;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "int";
            paramsModel.Key = "pageNumber";
            paramsModel.Value = userSearchCriteriaInputModel.PageNumber;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "searchText";
            paramsModel.Value = userSearchCriteriaInputModel.SearchText;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "sortBy";
            paramsModel.Value = userSearchCriteriaInputModel.SortBy;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "bool";
            paramsModel.Key = "sortDirectionAsc";
            paramsModel.Value = userSearchCriteriaInputModel.SortDirectionAsc;
            inputParams.Add(paramsModel);

            paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "userIdsXML";
            paramsModel.Value = userSearchCriteriaInputModel.UserIdsXML;
            inputParams.Add(paramsModel);

            var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASGetAllUsers, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken);
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result.Result);
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var usersList = JsonConvert.DeserializeObject<List<UserOutputModel>>(jsonResponse);
                Parallel.ForEach(usersList, user =>
                {
                   user.Value = user.Id;
                    user.Label = user.FullName;
                    user.RoleIds = user.RoleIds;
                });
                return usersList;
                //List<UserOutputModel> userOutputModel = _userRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

                //return userOutputModel;
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
                return new List<UserOutputModel>();
            }
        }

        public List<UserOutputModel> GetUsersByRoles(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetUsersByRoles", "User Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllUsersCommandId, userSearchCriteriaInputModel, loggedInContext);

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<UserOutputModel> userOutputModel = _userRepository.GetUsersByRoles(userSearchCriteriaInputModel, loggedInContext, validationMessages);

            return userOutputModel;
        }

        public List<UserDropDownOutputModel> GetUsersDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Users drop down", "User Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllUsersCommandId, searchText, loggedInContext);

            List<UserDropDownOutputModel> userOutputModel = _userRepository.GetUsersDropDown(searchText, loggedInContext, validationMessages);

            userOutputModel = userOutputModel.OrderBy(s => s.FullName).ToList();

            return userOutputModel;

        }

        public List<UserDropDownOutputModel> GetAdhocUsersDropDown(string searchText, bool? isForDropDown, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Get Adhoc Users drop down", "User Service"));

            _auditService.SaveAudit(AppCommandConstants.GetAllUsersCommandId, searchText, loggedInContext);

            List<UserDropDownOutputModel> userOutputModel = _userRepository.GetAdhocUsersDropDown(searchText, isForDropDown, loggedInContext, validationMessages);

            userOutputModel = userOutputModel.OrderBy(s => s.FullName).ToList();

            return userOutputModel;
        }

        public UserOutputModel GetUserById(Guid? userId, bool? isEmployeeOverviewDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false)
        {
            LoggingManager.Debug("Entered to GetUserById." + "with userId =" + userId);

            if (!UserValidationHelpers.GetUserByIdValidation(userId, loggedInContext, validationMessages))
            {
                return null;
            }

            Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel = new Models.User.UserSearchCriteriaInputModel { UserId = userId, IsEmployeeOverviewDetails = isEmployeeOverviewDetails };

            _auditService.SaveAudit(AppCommandConstants.GetUserByIdCommandId, userSearchCriteriaInputModel, loggedInContext);

            if (importConfiguration == null || importConfiguration == false) {
                List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
                var paramsModel = new ParamsInputModel();
                paramsModel.Type = "Guid?";
                paramsModel.Key = "userId";
                paramsModel.Value = userId;
                inputParams.Add(paramsModel);

                var result = ApiWrapper.GetApiCallsWithAuthorisation(RouteConstants.ASGetUserById, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams, loggedInContext.AccessToken).Result;
                var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
                if (responseJson.Success)
                {
                    var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                    var userList = JsonConvert.DeserializeObject<UserOutputModel>(jsonResponse);
                    var EmployeeId = _userRepository.GetEmployeeId(userId, loggedInContext, validationMessages);
                    if(userList == null)
                    {
                        var userSearchModel = new Models.User.UserSearchCriteriaInputModel();
                        userSearchModel.UserId = userId;
                        List<UserOutputModel> userData = _userRepository.GetAllUsers(userSearchModel, loggedInContext, validationMessages);
                        if(userData.Count > 0)
                        {
                            userList = userData[0];
                        }
                    }
                    userList.EmployeeId = EmployeeId;
                    return userList;
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
                    return new UserOutputModel();
                }
            }
            else 
            {
                userSearchCriteriaInputModel.IsUsersPage = true;
                UserOutputModel userModel = _userRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

                return userModel;
            }
        }

        public Guid? ChangePassword(UserPasswordResetModel changePasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangePassword", "changePasswordModel", changePasswordModel, "User Service"));

            if (!UserValidationHelpers.ChangePasswordValidation(changePasswordModel, loggedInContext, validationMessages))
            {
                return null;
            }

            _auditService.SaveAudit(AppCommandConstants.ChangePasswordCommandId, changePasswordModel, loggedInContext);

            var result = ApiWrapper.PostentityToApi(RouteConstants.ASChangePassword, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], changePasswordModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            var id = JsonConvert.SerializeObject(responseJson.Data);
            var responseid = (id != null && id != "null") ? id : null;
            if (responseJson.Success && responseid != null)
            {
                var idGuid = Convert.ToString(responseJson.Data);
                return new Guid(idGuid);
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

            //Guid? userId = changePasswordModel.Type == AppConstants.OtherThanLoggedUserType ? changePasswordModel.UserId : loggedInContext.LoggedInUserId;

            //UserOutputModel userDetails = GetUserById(userId, null, loggedInContext, validationMessages);

            //if (userDetails == null)
            //{
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.NotFoundUserWithTheId, userId)
            //    });

            //    return null;
            //}

            //if (changePasswordModel.Type == AppConstants.LoggedUserType)
            //{
            //    string password = userDetails.Password;

            //    bool validUser = Utilities.VerifyPassword(password, changePasswordModel.OldPassword);

            //    if (validUser == false)
            //    {
            //        validationMessages.Add(new ValidationMessage
            //        {
            //            ValidationMessageType = MessageTypeEnum.Error,
            //            ValidationMessaage = ValidationMessages.NotMatchPasswordExistedPassword
            //        });
            //    }
            //}

            //if (validationMessages.Count > 0)
            //{
            //    return null;
            //}

            //changePasswordModel.NewPassword = Utilities.GetSaltedPassword(changePasswordModel.NewPassword);

            //if (changePasswordModel.ResetGuid != null && changePasswordModel.ResetGuid != Guid.Empty)
            //{
            //    return _userRepository.UpdateUserPassword(changePasswordModel, loggedInContext, validationMessages);
            //}

            //Guid? isSuccess = _userRepository.UpdatePassword(changePasswordModel, loggedInContext, validationMessages);

            //LoggingManager.Debug(isSuccess?.ToString());

            //return isSuccess;
        }

        public UsersModel GetUserDetails(Guid userId, LoggedInContext loggedInContext, string timeZone = null)
        {
            UsersModel userModel = _userRepository.UserDetails(userId, timeZone);
            if (userModel != null)
            {
                userModel.Password = null;
                userModel.CompaniesList = _userRepository.UserCompaniesList(userId);
            }

            return userModel;
        }

        public bool IsUserExisted(string email, string password, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered IsUserExisted with email " + email + ", password=" + password);

            email = email?.Trim();
            password = password?.Trim();

            if (!UserValidationHelpers.IsUserExistedValidation(email, password, validationMessages))
            {
                return false;
            }

            bool isValidAuth = new BackOfficeService().ValidateBackOfficeCredentials(email, password);
            if (isValidAuth == false)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NoUserExisted
                });
            }
            return true;
        }

        public UsersModel GetUserDetailsByName(string userName)
        {
            LoggingManager.Debug("Entered Get User Details ByName , userName is " + userName);


            //UserDbEntity user = _userRepository.GetUserDetailsByName(userName).FirstOrDefault();
            UserDbEntity user = _userRepository.GetLogInUserDetailsByName(userName);

            UsersModel userModel = new UsersModel
            {
                UserName = user.UserName,
                Id = user.Id,
                //RoleId = user.RoleId,
                IsActive = user.IsActive,
                IsAdmin = user.IsAdmin ?? false,
                FirstName = user.FirstName,
                SurName = user.SurName,
                //BranchId = user.BranchId,
                ProfileImage = user.ProfileImage
            };
            return userModel;
        }

        public bool? ForgotPassword(string email, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered ForgotPassword with email " + email);
            email = email?.Trim();

            List<ParamsInputModel>  inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "string";
            paramsModel.Key = "emailId";
            paramsModel.Value = email;
            inputParams.Add(paramsModel);

            var result = ApiWrapper.AnnonymousGetApiCalls(RouteConstants.ForgotPassword, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);

            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                var resetGuid = JsonConvert.DeserializeObject<Guid>(jsonResponse);

                if (!UserValidationHelpers.EmailValidation(email, validationMessages))
                {
                    return false;
                }

                ResetPasswordInputModel resetPasswordModel = _userRepository.GetUserDetailsByEmail(email, validationMessages, HttpContext.Current.Request.Url.Authority, CanByPassUserCompanyValidation(), resetGuid);
                //_userRepository.ForgotPassword(email, validationMessages, HttpContext.Current.Request.Url.Authority, CanByPassUserCompanyValidation(), resetGuid);
                if (resetPasswordModel == null)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.NotFoundResetPasswordWithTheEmail, email)
                    });
                    return null;
                }
                LoggingManager.Debug("Reset password details for the email " + email + " has been created.");

                LoggedInContext loggedInContext = new LoggedInContext();
                loggedInContext.LoggedInUserId = resetPasswordModel.UserId;
                SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, HttpContext.Current.Request.Url.Authority);

                string url = HttpContext.Current.Request.Url.Authority;

                var splits = url.Split('.');

                string siteUrl = "https://" + splits[0];

                string resetPasswordLink = "https://" + url + "/sessions/reset-password/" + resetPasswordModel.ResetGuid + "/";

                var html = _goalRepository.GetHtmlTemplateByName("ResetPasswordTemplate", null).Replace("##userName##", resetPasswordModel.FirstName).Replace("##resetPasswordLink##", resetPasswordLink);

                try
                {
                    var toMails = resetPasswordModel.UserName.Split('\n');
                    EmailGenericModel emailModel = new EmailGenericModel
                    {
                        SmtpServer = smtpDetails?.SmtpServer,
                        SmtpServerPort = smtpDetails?.SmtpServerPort,
                        SmtpMail = smtpDetails?.SmtpMail,
                        SmtpPassword = smtpDetails?.SmtpPassword,
                        ToAddresses = toMails,
                        HtmlContent = html,
                        Subject = "Snovasys Business Suite: Reset Password Request",
                        CCMails = null,
                        BCCMails = null,
                        MailAttachments = null,
                        IsPdf = null
                    };
                    _emailService.SendMail(loggedInContext, emailModel);
                }
                catch (Exception exception)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "Login Api", exception));
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = string.Format(ValidationMessages.MailNotSend)
                    });
                }
                return true;
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

        private bool CanByPassUserCompanyValidation()
        {
            if (!ConfigurationManager.AppSettings.AllKeys.Contains("EnvironmentName"))
            {
                return true;
            }

            return ConfigurationManager.AppSettings["EnvironmentName"] != "Production";
        }

        private static EmailTemplateInputModel SendResetPasswordMail(ResetPasswordInputModel model)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "Send Reset Password Mail", "Reset Password Service"));

            if (model?.UserId != null && model.IsExpired != true)
            {
                EmailTemplateInputModel email = new EmailTemplateInputModel("ResetPasswordTemplate")
                {
                    To = model.UserName,
                    ResetPasswordModel = model,
                    ToName = model.FullName

                };

                return email;
            }
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "Send Reset Password Mail", "Reset Password Service"));
            return null;
        }

        public bool? ResetPassword(Guid? resetGuid, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered ResetPassword with resetGuid " + resetGuid);

            if (!UserValidationHelpers.ResetGuidValidation(resetGuid, validationMessages))
            {
                return false;
            }

            List<ParamsInputModel> inputParams = new List<ParamsInputModel>();
            var paramsModel = new ParamsInputModel();
            paramsModel.Type = "Guid?";
            paramsModel.Key = "resetGuid";
            paramsModel.Value = resetGuid;
            inputParams.Add(paramsModel);

            var result = ApiWrapper.AnnonymousGetApiCalls(RouteConstants.ResetPassword, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], inputParams).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                bool? isExpired = JsonConvert.DeserializeObject<bool?>(jsonResponse);

                //bool? isExpired = _userRepository.ResetPassword(resetGuid, validationMessages);
                if (isExpired != null)
                {
                    return isExpired;
                }

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundResetPasswordWithTheResetGuid, resetGuid)
                });

                return null;
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

        public Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered UpdatePassword with resetPasswordModel " + resetPasswordModel);

            var result = ApiWrapper.AnnonymousPostentityToApi(RouteConstants.UpdatePassword, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], resetPasswordModel).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);

            if (responseJson.Success)
            {
                var jsonResponse = JsonConvert.SerializeObject(responseJson.Data);
                Guid? isSuccess = JsonConvert.DeserializeObject<Guid?>(jsonResponse);

                Guid? resetGuid = resetPasswordModel.ResetGuid;

                //if (!UserValidationHelpers.ResetPasswordValidation(resetPasswordModel, validationMessages))
                //{
                //    return null;
                //}

                //bool? isExpired = _userRepository.ResetPassword(resetPasswordModel.ResetGuid, validationMessages);

                //if (isExpired == true)
                //{
                //    validationMessages.Add(new ValidationMessage
                //    {
                //        ValidationMessageType = MessageTypeEnum.Error,
                //        ValidationMessaage = string.Format(ValidationMessages.LinkHasBeenExpired, resetGuid)
                //    });

                //    return null;
                //}

                //LoggedInContext loggedInContext = new LoggedInContext();
                //resetPasswordModel.NewPassword = Utilities.GetSaltedPassword(resetPasswordModel.NewPassword);

                //if (resetPasswordModel.ResetGuid != null && resetPasswordModel.ResetGuid != Guid.Empty)
                //{
                //    return _userRepository.UpdateUserPassword(resetPasswordModel, loggedInContext, validationMessages);
                //}

                //Guid? isSuccess = _userRepository.UpdatePassword(resetPasswordModel, loggedInContext, validationMessages);

                if (isSuccess != null)
                {
                    return isSuccess;
                }

                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundResetPasswordWithTheResetGuid, resetGuid)
                });

                return null;
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

        public List<Models.User.UserModel> GetAllUsersForSlackApp(Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsersForSlackApp", "ChatService"));

            LoggingManager.Debug("Entered to GetAllUsers." + "Logged in User Id=" + loggedInContext);

            if (loggedInContext.LoggedInUserId == Guid.Empty)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NullValue
                });
                return null;
            }

            if (userSearchCriteriaInputModel.PageNumber == 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageNumberRequired
                });
            }

            if (userSearchCriteriaInputModel.PageSize == 0)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.PageSizeRequired
                });
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            if (userSearchCriteriaInputModel.PageSize > AppConstants.InputWithMaxSize1000)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.MaximumLengthPageSize
                });
                return null;
            }

            List<Models.User.UserModel> userModels = _userRepository.GetAllUsersForSlack(loggedInContext).Select(x => new Models.User.UserModel
            {
                Id = x.Id,
                UserId = x.Id,
                CompanyId = x.CompanyId,
                FirstName = x.FirstName,
                SurName = x.SurName,
                FullName = x.FullName,
                Email = x.Email,
                Password = x.Password,
                RoleId = x.RoleId,
                IsPasswordForceReset = x.IsPasswordForceReset,
                IsActive = x.IsActive,
                TimeZoneId = x.TimeZoneId,
                MobileNo = x.MobileNo,
                IsAdmin = x.IsAdmin,
                IsActiveOnMobile = x.IsActiveOnMobile,
                ProfileImage = x.ProfileImage,
                RegisteredDateTime = x.RegisteredDateTime,
                LastConnection = x.LastConnection,
                CreatedDateTime = x.CreatedDateTime,
                CreatedByUserId = x.CreatedByUserId,
                UpdatedDateTime = x.UpdatedDateTime,
                UpdatedByUserId = x.UpdatedByUserId,
                RoleName = x.RoleName,
                DesignationName = x.DesignationName,
                DepartmentName = x.DepartmentName,
                TotalCount = x.TotalCount,
                MessagesUnReadCount = x.MessagesUnReadCount,
                ChannelId = x.ChannelId,
                UserName = x.UserName,
                IsMuted = x.IsMuted,
                IsStarred = x.IsStarred,
                IsLeave = x.IsLeave,
                IsOnLeave = x.IsOnLeave,
                StatusId = x.StatusId,
                IsClient = x.IsClient,
                ClientCompanyName = x.ClientCompanyName,
                PinnedMessageCount = x.PinnedMessageCount,
                StarredMessageCount = x.StarredMessageCount,
                IsExternal = x.IsExternal
            }).ToList();

            return userModels;
        }

        public List<string> GetLoggedInUserRelatedwebhook(LoggedInContext loggedInContext, Guid? userId, Guid? projectId)
        {
            List<WebhookSpEntity> webhooks = _userRepository.GetSlackWebhook(loggedInContext, userId, projectId);
            List<string> webhookUrls = new List<string>(from webhook in webhooks select webhook.WebHookUrl);
            return webhookUrls;
        }

        public Guid? UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "uploadProfileImage", "uploadProfileImageInputModel", uploadProfileImageInputModel, "User Service"));


            var result = ApiWrapper.PostentityToApi(RouteConstants.ASUploadProfileImage, ConfigurationManager.AppSettings["AuthenticationServiceBasePath"], uploadProfileImageInputModel, loggedInContext.AccessToken).Result;
            var responseJson = JsonConvert.DeserializeObject<JsonDeserialiseData>(result);
            if (responseJson.Success)
            {
                if (uploadProfileImageInputModel.UserId == null)
                {
                    uploadProfileImageInputModel.UserId = loggedInContext.LoggedInUserId;
                }

                UserOutputModel userModel = GetUserById(uploadProfileImageInputModel.UserId, null, loggedInContext, validationMessages, true);
                if (userModel != null)
                {
                    if (userModel.TotalCount > 0)
                    {
                        UserInputModel userInputModel = new UserInputModel
                        {
                            UserId = uploadProfileImageInputModel.UserId,
                            TimeStamp = userModel.TimeStamp,
                            ProfileImage = uploadProfileImageInputModel.ProfileImage,
                            Email = userModel.Email,
                            FirstName = userModel.FirstName,
                            TimeZoneId = userModel.TimeZoneId,
                            IsActive = userModel.IsActive,
                            IsActiveOnMobile = userModel.IsActiveOnMobile,
                            IsAdmin = userModel.IsAdmin,
                            IsArchived = userModel.IsArchived,
                            IsPasswordForceReset = userModel.IsPasswordForceReset,
                            SurName = userModel.SurName,
                            LastConnection = userModel.LastConnection,
                            MobileNo = userModel.MobileNo,
                            Password = userModel.Password,
                            RoleId = userModel.RoleIds,
                            DesktopId = userModel.DesktopId
                        };
                        Guid? userId = UpsertUser(userInputModel, loggedInContext, validationMessages);

                        return userId;
                    }
                }
                return null;
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

        public bool UpsertUserWebHooks(UserWebHookInputModel userWebHookInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserWebHooks", "UserWebHookInputModel", userWebHookInputModel, "User Service"));

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return false;
            }

            if (userWebHookInputModel.WebHooksList != null)
            {
                userWebHookInputModel.WebHookXml = Utilities.GetXmlFromObject(userWebHookInputModel.WebHooksList);
            }

            var result = _userRepository.UpsertUserWebHooks(userWebHookInputModel, loggedInContext, validationMessages);

            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoExitingValue, "UpsertUserWebHooks", "UserWebHookInputModel", userWebHookInputModel, "User Service"));

            return result;
        }

        public UserWebHookInputModel GetUserWebHooksById(Guid UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (!UserValidationHelpers.GetUserByIdValidation(UserId, loggedInContext, validationMessages))
            {
                return null;
            }

            var data = _userRepository.GetUserWebHooksById(UserId, loggedInContext, validationMessages);

            if (data != null && data.WebHookXml != null)
            {
                data.WebHooksList = Utilities.GetObjectFromXml<string>(data.WebHookXml, "ArrayOfString");
            }

            return data;
        }

        public InitialDetailsOutputModel GetLoggedInUserInitialDetails(UserAuthToken userAuthToken, string timeZone = null)
        {
            LoggedInContext loggedInUser = new LoggedInContext();
            loggedInUser.CompanyGuid = userAuthToken.CompanyId;
            var userId = _userRepository.GetUserByUserAuthenticationIdAndCompanyId(userAuthToken.UserId, loggedInUser, new List<ValidationMessage>());

            UsersModel loggedUserModel = GetUserDetails(userId, null, timeZone); //GetUserDetails(userAuthToken.UserId, null, timeZone);
            var initialDetails = new InitialDetailsOutputModel();
            initialDetails.AuthToken = userAuthToken.AuthToken;
            initialDetails.UsersModel = loggedUserModel;
            var WorkspaceInputModel = new WorkspaceSearchCriteriaInputModel();
            WorkspaceInputModel.IsHidden = false;
            WorkspaceInputModel.WorkspaceId = null;
            loggedInUser.LoggedInUserId = userId;

            var userDashboards = _widgetRepository.GetWorkspaces(WorkspaceInputModel, loggedInUser, null);
            initialDetails.Dashboards = userDashboards;
            if (userDashboards != null && userDashboards.Count > 0)
            {
                initialDetails.DefaultDashboardId = userDashboards.First();
            }

            //var searchCriteriaModel = new CompanySearchCriteriaInputModel();
            //searchCriteriaModel.CompanyId = userAuthToken.CompanyId;
            //initialDetails.CompanyDetails = _companyStructureRepository.SearchCompanies(searchCriteriaModel, loggedInUser, null).FirstOrDefault();
            initialDetails.RoleFeatures = _roleFeatureRepository.SearchRoleFeatures(loggedInUser.LoggedInUserId, null, loggedInUser, null);
            var softLabelsSearchInputModel = new SoftLabelsSearchInputModel();
            initialDetails.SoftLabels = _masterDataManagementRepository.GetSoftLabelConfigurations(softLabelsSearchInputModel, loggedInUser, null).ToList();
            //var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            //companySettingsSearchInputModel.IsArchived = false;
            //initialDetails.CompanySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInUser, null).ToList();
            initialDetails.DefaultAppId = _widgetRepository.GetWidgetIdByName(userAuthToken.CompanyId, loggedInUser, null);
            return initialDetails;
        }

        public UsersModel GetUserDetailsByMobile(string mobileNumber)
        {
            LoggingManager.Debug("Entered Get User Details By Mobile, Number is " + mobileNumber);


            //UserDbEntity user = _userRepository.GetUserDetailsByName(userName).FirstOrDefault();
            UserDbEntity user = _userRepository.GetLogInUserDetailsByMobileNumber(mobileNumber);

            UsersModel userModel = new UsersModel
            {
                UserName = user.UserName,
                Id = user.Id,
                //RoleId = user.RoleId,
                IsActive = user.IsActive,
                IsAdmin = user.IsAdmin ?? false,
                FirstName = user.FirstName,
                SurName = user.SurName,
                //BranchId = user.BranchId,
                ProfileImage = user.ProfileImage
            };
            return userModel;
        }

        public bool IsMobileNumberExists(string mobileNumber, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered mobile number" + mobileNumber + " is exists");

            mobileNumber = mobileNumber?.Trim();

            bool isValidAuth = new BackOfficeService().ValidateBackOfficeCredentialsWithMobile(mobileNumber);
            if (isValidAuth == false)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = ValidationMessages.NoUserExisted
                });
            }
            return true;
        }

        public void SendExternalUserRegistrationMail(UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CompanyOutputModel companyDetails = _companyStructureService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

            EmailGenericModel emailModel = new EmailGenericModel
            {
                SmtpServer = smtpDetails?.SmtpServer,
                SmtpServerPort = smtpDetails?.SmtpServerPort,
                SmtpMail = smtpDetails?.SmtpMail,
                SmtpPassword = smtpDetails?.SmtpPassword,
                ToAddresses = new[] { userRegistrationDetails.UserName },
                HtmlContent = string.Empty,
                Subject = "Snovasys office messenger feedback",
                CCMails = null,
                BCCMails = null,
                MailAttachments = null,
                IsPdf = null
            };

            _emailService.SendMail(loggedInContext, emailModel);
        }
    }
}
