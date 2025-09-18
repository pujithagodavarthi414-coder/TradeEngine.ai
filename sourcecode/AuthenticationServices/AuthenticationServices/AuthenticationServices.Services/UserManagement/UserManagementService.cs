using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.CompanyStructure;
using AuthenticationServices.Models.Employee;
using AuthenticationServices.Models.HrManagement;
using AuthenticationServices.Models.MasterData;
using AuthenticationServices.Models.SystemManagement;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Models;
using AuthenticationServices.Repositories.Repositories;
using AuthenticationServices.Repositories.Repositories.CompanyManagement;
using AuthenticationServices.Repositories.Repositories.UserManagement;
using AuthenticationServices.Services.CompanyManagement;
using AuthenticationServices.Services.Email;
using AuthenticationServices.Services.Helpers;
using Hangfire;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using AuthenticationServices.Repositories.Repositories.MasterDataManagement;

namespace AuthenticationServices.Services.UserManagement
{
    public class UserManagementService : IUserManagementService
    {
        private readonly IUserManagementRepository _userManagementRepository;
        private readonly ICompanyManagementRepository _companyManagementRepository;
        private readonly ICompanyManagementService _companyManagementService;
        private readonly IMasterDataManagementRepository _masterDataManagementRepository;
        private readonly IEmailService _emailService;
        IConfiguration _iconfiguration;

        public UserManagementService(IUserManagementRepository userManagementRepository, ICompanyManagementRepository companyManagementRepository, ICompanyManagementService companyManagementService, IEmailService emailService, IConfiguration iconfiguration, IMasterDataManagementRepository masterDataManagementRepository)
        {
            _userManagementRepository = userManagementRepository;
            _companyManagementRepository = companyManagementRepository;
            _companyManagementService = companyManagementService;
            _masterDataManagementRepository = masterDataManagementRepository;
            _emailService = emailService;
            _iconfiguration = iconfiguration;
        }

        public Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUser", "userModel", userModel, "User Management Service"));

            if (!userModel.UpdateProfileDetails && !UserManagementValidationHelpers.UpsertUserValidation(userModel, loggedInContext, validationMessages))
            {
                return null;
            }

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
                userOldData = _userManagementRepository.GetSingleUserDetails(userModel.UserId.GetValueOrDefault());
            }

            //userModel.IsActive = userOldData.IsActive;
            //userModel.IsActiveOnMobile = userOldData.IsActiveOnMobile;

            userModel.UserId = _userManagementRepository.UpsertUser(userModel, loggedInContext, validationMessages);

            LoggingManager.Debug(userModel.UserId?.ToString());

            //if (isNewEmployee || (userModel.IsExternal && !userOldData.IsExternal))
            //{
            //    UserRegistrationDetailsModel userRegistrationDetails = new UserRegistrationDetailsModel()
            //    {
            //        UserName = userModel.Email,
            //        FirstName = userModel.FirstName,
            //        SurName = userModel.SurName,
            //        RoleIds = userModel.RoleId,
            //        Password = "Test123!"
            //    };

            //    //EnqueueBackgroundJob(userModel, userRegistrationDetails, loggedInContext, validationMessages);

            //}
            return userModel.UserId;
        }

        public List<UserOutputModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetAllUsers", "User Management Service"));

            if (!CommonValidationHelper.ValidateSearchCriteria(loggedInContext, userSearchCriteriaInputModel, validationMessages))
            {
                return null;
            }

            List<UserOutputModel> userOutputModel = _userManagementRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages);

            return userOutputModel;
        }

        public Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "UpsertUserProfileDetails", "UpsertUserProfileDetails", userProfileInputModel, "User Service"));

            if (!UserManagementValidationHelpers.UpsertUserProfileValidation(userProfileInputModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? userId = _userManagementRepository.UpsertUserProfileDetails(userProfileInputModel, loggedInContext, validationMessages);
            return userId;
        }

        public Guid? ChangePassword(UserPasswordResetModel changePasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "ChangePassword", "changePasswordModel", changePasswordModel, "User Service"));

            if (!UserManagementValidationHelpers.ChangePasswordValidation(changePasswordModel, loggedInContext, validationMessages))
            {
                return null;
            }

            Guid? userId = changePasswordModel.Type == AppConstants.OtherThanLoggedUserType ? changePasswordModel.UserId : loggedInContext.LoggedInUserId;

            UserOutputModel userDetails = GetUserById(userId, null, loggedInContext, validationMessages);

            if (userDetails == null)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.NotFoundUserWithTheId, userId)
                });

                return null;
            }

            if (changePasswordModel.Type == AppConstants.LoggedUserType)
            {
                string password = userDetails.Password;

                bool validUser = Utilities.VerifyPassword(password, changePasswordModel.OldPassword);

                if (validUser == false)
                {
                    validationMessages.Add(new ValidationMessage
                    {
                        ValidationMessageType = MessageTypeEnum.Error,
                        ValidationMessaage = ValidationMessages.NotMatchPasswordExistedPassword
                    });
                }
            }

            if (validationMessages.Count > 0)
            {
                return null;
            }

            changePasswordModel.NewPassword = Utilities.GetSaltedPassword(changePasswordModel.NewPassword);

            if (changePasswordModel.ResetGuid != null && changePasswordModel.ResetGuid != Guid.Empty)
            {
                return _userManagementRepository.UpdateUserPassword(changePasswordModel, loggedInContext, validationMessages);
            }

            Guid? isSuccess = _userManagementRepository.UpdatePassword(changePasswordModel, loggedInContext, validationMessages);

            LoggingManager.Debug(isSuccess?.ToString());

            return isSuccess;
        }

        public Guid? UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerDebugValue, "uploadProfileImage", "uploadProfileImageInputModel", uploadProfileImageInputModel, "User Service"));

            if (uploadProfileImageInputModel.UserId == null)
            {
                uploadProfileImageInputModel.UserId = loggedInContext.LoggedInUserId;
            }

            UserOutputModel userModel = GetUserById(uploadProfileImageInputModel.UserId, null, loggedInContext, validationMessages);

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
            return null;
        }

        public UserOutputModel GetUserById(Guid? userId, bool? isEmployeeOverviewDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered to GetUserById." + "with userId =" + userId);

            if (!UserManagementValidationHelpers.GetUserByIdValidation(userId, loggedInContext, validationMessages))
            {
                return null;
            }

            UserSearchCriteriaInputModel userSearchCriteriaInputModel = new UserSearchCriteriaInputModel { UserId = userId, IsEmployeeOverviewDetails = isEmployeeOverviewDetails };

            UserOutputModel userModel = _userManagementRepository.GetAllUsers(userSearchCriteriaInputModel, loggedInContext, validationMessages).FirstOrDefault();

            return userModel;
        }
        public List<HtmlTemplateApiReturnModel> GetHtmlTemplates(HtmlTemplateSearchInputModel htmlTemplateSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Info(string.Format(LoggingManagerAppConstants.LoggingManagerInfoValue, "GetHtmlTemplates", "HrManagement Service"));

            LoggingManager.Debug(htmlTemplateSearchInputModel.ToString());

            if (!CommonValidationHelper.ValidateLoggedInUser(loggedInContext, validationMessages))
            {
                return null;
            }

            List<HtmlTemplateApiReturnModel> htmlTemplateReturnModels = _companyManagementRepository.GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages).ToList();

            if (htmlTemplateReturnModels.Count > 0)
            {
                Parallel.ForEach(htmlTemplateReturnModels, template =>
                {
                    template.SelectedRoleIds = (template.IsRoleBased == true && template.Roles.Length > 0) ? template.Roles.Split(',').Select(p => new Guid(p)).ToList() : new List<Guid>();
                    template.MailUrls = (template.IsMailBased == true && template.Mails.Length > 0) ? template.Mails.Split(',').ToList() : new List<string>();
                });
            }

            return htmlTemplateReturnModels;
        }

        public UsersModel GetUserDetails(Guid userId, Guid companyId, LoggedInContext loggedInContext, string timeZone = null)
        {
            UsersModel userModel = _userManagementRepository.UserDetails(userId, companyId, timeZone);
            if (userModel != null)
            {
                userModel.Password = null;
                userModel.CompaniesList = _userManagementRepository.UserCompaniesList(userId);
            }
            return userModel;
        }

        public InitialDetailsOutputModel GetLoggedInUserInitialDetails(UserAuthToken userAuthToken, string timeZone = null)
        {
            UsersModel loggedUserModel = _userManagementRepository.UserDetails(userAuthToken.UserId, userAuthToken.CompanyId, timeZone);
            var initialDetails = new InitialDetailsOutputModel();
            initialDetails.AuthToken = userAuthToken.AuthToken;
            initialDetails.UsersModel = loggedUserModel;
            initialDetails.UserAuthToken = userAuthToken;

            var CompaniesList = _userManagementRepository.UserCompaniesList(userAuthToken.UserId);
            initialDetails.UsersModel.CompaniesList = CompaniesList;
            LoggedInContext loggedInUser = new LoggedInContext();
            loggedInUser.LoggedInUserId = userAuthToken.UserId;
            loggedInUser.CompanyGuid = userAuthToken.CompanyId;

            var searchCriteriaModel = new CompanySearchCriteriaInputModel();
            searchCriteriaModel.CompanyId = userAuthToken.CompanyId;
            initialDetails.CompanyDetails = _companyManagementRepository.SearchCompanies(searchCriteriaModel, loggedInUser, null).FirstOrDefault();

            var companySettingsSearchInputModel = new CompanySettingsSearchInputModel();
            companySettingsSearchInputModel.IsArchived = false;
            initialDetails.CompanySettings = _masterDataManagementRepository.GetCompanySettings(companySettingsSearchInputModel, loggedInUser, null).ToList();

            return initialDetails;
        }

        public Guid? ForgotPassword(string email, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered ForgotPassword with email " + email);
            email = email?.Trim();
            if (!UserManagementValidationHelpers.EmailValidation(email, validationMessages))
            {
                return null;
            }

            ResetPasswordInputModel resetPasswordModel = _userManagementRepository.ForgotPassword(email, validationMessages);
            
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

            //LoggedInContext loggedInContext = new LoggedInContext
            //{
            //    LoggedInUserId = resetPasswordModel.UserId
            //};

            //SmtpDetailsModel smtpDetails = _userManagementRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            //var html = _companyManagementRepository.GetHtmlTemplateByName("ResetPasswordWithOTPTemplate", null).Replace("##userName##", resetPasswordModel.FullName).Replace("##OTP##", resetPasswordModel.OTP.ToString());

            //try
            //{
            //    var toMails = resetPasswordModel.UserName.Split('\n');
            //    EmailGenericModel emailModel = new EmailGenericModel
            //    {
            //        SmtpServer = smtpDetails?.SmtpServer,
            //        SmtpServerPort = smtpDetails?.SmtpServerPort,
            //        SmtpMail = smtpDetails?.SmtpMail,
            //        SmtpPassword = smtpDetails?.SmtpPassword,
            //        ToAddresses = toMails,
            //        HtmlContent = html,
            //        Subject = "Reset Password Request",
            //        CCMails = null,
            //        BCCMails = null,
            //        MailAttachments = null,
            //        IsPdf = null
            //    };
            //    _emailService.SendMail(loggedInContext, emailModel);
            //}
            //catch (Exception exception)
            //{
            //    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "Login Api", exception));
            //    validationMessages.Add(new ValidationMessage
            //    {
            //        ValidationMessageType = MessageTypeEnum.Error,
            //        ValidationMessaage = string.Format(ValidationMessages.MailNotSend)
            //    });
            //}
            return resetPasswordModel.ResetGuid;
        }

        public Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered UpdatePassword with resetPasswordModel " + resetPasswordModel);

            Guid? resetGuid = resetPasswordModel.ResetGuid;

            if (!UserManagementValidationHelpers.ResetPasswordValidation(resetPasswordModel, validationMessages))
            {
                return null;
            }

            bool? isExpired = _userManagementRepository.ResetPassword(resetPasswordModel.ResetGuid, null, validationMessages);

            if (isExpired == true)
            {
                validationMessages.Add(new ValidationMessage
                {
                    ValidationMessageType = MessageTypeEnum.Error,
                    ValidationMessaage = string.Format(ValidationMessages.LinkHasBeenExpired, resetGuid)
                });

                return null;
            }

            LoggedInContext loggedInContext = new LoggedInContext();
            resetPasswordModel.NewPassword = Utilities.GetSaltedPassword(resetPasswordModel.NewPassword);

            if (resetPasswordModel.ResetGuid != null && resetPasswordModel.ResetGuid != Guid.Empty)
            {
                return _userManagementRepository.UpdateUserPassword(resetPasswordModel, loggedInContext, validationMessages);
            }

            Guid? isSuccess = _userManagementRepository.UpdatePassword(resetPasswordModel, loggedInContext, validationMessages);

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

        public bool? ResetPassword(Guid? resetGuid, int? otp, List<ValidationMessage> validationMessages)
        {
            LoggingManager.Debug("Entered ResetPassword with resetGuid " + resetGuid);

            if (!UserManagementValidationHelpers.ResetGuidValidation(resetGuid, validationMessages))
            {
                return false;
            }

            bool? isExpired = _userManagementRepository.ResetPassword(resetGuid, otp, validationMessages);

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

        public virtual void EnqueueBackgroundJob(UserInputModel userModel, UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            if (userModel.IsExternal)
            {
                BackgroundJob.Enqueue(() => SendExternalUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
            }
            else
            {
                BackgroundJob.Enqueue(() => SendUserRegistrationMail(userRegistrationDetails, loggedInContext, validationMessages));
            }
        }

        public void SendExternalUserRegistrationMail(UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            CompanyOutputModel companyDetails = _companyManagementService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            SmtpDetailsModel smtpDetails = _userManagementRepository.SearchSmtpCredentials(loggedInContext, validationMessages, companyDetails.SiteAddress);

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

        public bool SendUserRegistrationMail(UserRegistrationDetailsModel userRegistrationDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            SmtpDetailsModel smtpDetails = _userManagementRepository.SearchSmtpCredentials(loggedInContext, validationMessages, null);

            CompanyOutputModel companyDetails = _companyManagementService.GetCompanyById(loggedInContext.CompanyGuid, loggedInContext, validationMessages);

            var siteDomain = companyDetails.SiteDomain;

            HtmlTemplateSearchInputModel htmlTemplateSearchInputModel = new HtmlTemplateSearchInputModel()
            {
                IsArchived = false
            };

            var templates = GetHtmlTemplates(htmlTemplateSearchInputModel, loggedInContext, validationMessages);

            var roles = userRegistrationDetails.RoleIds != null ? userRegistrationDetails.RoleIds.Split(',').ToList() : new List<string>();

            var mailFound = templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Mails != null ? templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Mails.ToLower().Contains(userRegistrationDetails.UserName.ToLower()) : false;

            var rolesAvailable = templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate") != null ? templates.FirstOrDefault(p => p.HtmlTemplateName == "UserRegistrationNotificationTemplate").Roles.Split(',').ToList() : new List<string>();

            if (mailFound || rolesAvailable.Where(b => roles.Any(a => b.ToLower().Contains(a.ToLower()))).ToList().Count > 0)
            {
                CompanySettingsSearchInputModel companySettingMainLogoModel = new CompanySettingsSearchInputModel
                {
                    Key = "CompanySigninLogo",
                    IsArchived = false
                };

                string mainLogo = (_companyManagementRepository.GetCompanySettings(companySettingMainLogoModel, loggedInContext, new List<ValidationMessage>())?.FirstOrDefault()?.Value);

                var siteAddress = "https://" + companyDetails.SiteAddress + siteDomain + "/sessions/signin";

                var html = _companyManagementRepository.GetHtmlTemplateByName("UserRegistrationNotificationTemplate", loggedInContext.CompanyGuid);
                //var siteAddress = ConfigurationManager.AppSettings["SiteUrl"] + "/sessions/signin";
                html = html.Replace("##UserName##", userRegistrationDetails.UserName).
                        Replace("##CompanyName##", smtpDetails.CompanyName).
                        Replace("##siteUrl##", siteAddress).
                        Replace("##Name##", userRegistrationDetails.FirstName + " " + userRegistrationDetails.SurName).
                        Replace("##Password##", userRegistrationDetails.Password).
                        Replace("##CompanyRegistrationLogo##", mainLogo);

                var toMails = new string[1];
                toMails[0] = userRegistrationDetails.UserName;
                EmailGenericModel emailModel = new EmailGenericModel
                {
                    SmtpServer = smtpDetails?.SmtpServer,
                    SmtpServerPort = smtpDetails?.SmtpServerPort,
                    SmtpMail = smtpDetails?.SmtpMail,
                    SmtpPassword = smtpDetails?.SmtpPassword,
                    ToAddresses = toMails,
                    HtmlContent = html,
                    Subject = "Snovasys Business Suite: User registration notification",
                    CCMails = null,
                    BCCMails = null,
                    MailAttachments = null,
                    IsPdf = null
                };
                _emailService.SendMail(loggedInContext, emailModel);
                return true;
            }
            return true;
        }
    }
}
