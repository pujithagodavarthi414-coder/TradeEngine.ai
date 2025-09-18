using System;
using System.Collections.Generic;
using System.Text;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.SystemManagement;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Models;

namespace AuthenticationServices.Repositories.Repositories.UserManagement
{
    public interface IUserManagementRepository
    {
        List<UserDbEntity> GetUserDetailsByNameAndSiteAddress(string userName, string siteAddress,
            string isAllowSupportLogin = null);
        UserDbEntity GetSingleUserDetails(Guid userId);

        Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        ResetPasswordInputModel ForgotPassword(string email, List<ValidationMessage> validationMessages);

        bool? ResetPassword(Guid? resetGuid,  int? otp, List<ValidationMessage> validationMessages);

        Guid? UpdateUserPassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        List<UserOutputModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        SmtpDetailsModel SearchSmtpCredentials(LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages, string SiteAddress);

        List<UserDbEntity> GetUserDetailsByName(string userName, string isAllowSupportLogin = null);
        UserDbEntity GetUserDetailsByUserIdAndCompanyId(Guid userId, Guid companyId, string isAllowSupportLogin = null);
        UsersModel UserDetails(Guid userId, Guid companyId, string timeZone = null);
        List<CompaniesList> UserCompaniesList(Guid? userId);
    }
}
