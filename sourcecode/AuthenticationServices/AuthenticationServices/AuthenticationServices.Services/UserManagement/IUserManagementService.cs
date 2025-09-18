using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.User;
using System;
using System.Collections.Generic;
using AuthenticationServices.Models.Employee;

namespace AuthenticationServices.Services.UserManagement
{
    public interface IUserManagementService
    {
        Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserOutputModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserOutputModel GetUserById(Guid? userId, bool? isEmployeeOverviewDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UsersModel GetUserDetails(Guid userId, Guid companyId, LoggedInContext loggedInContext, string timeZone = null);
        Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? ChangePassword(UserPasswordResetModel changePasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        InitialDetailsOutputModel GetLoggedInUserInitialDetails(UserAuthToken userAuthToken,
            string timeZone = null);

        Guid? ForgotPassword(string email, List<ValidationMessage> validationMessages);
        Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, List<ValidationMessage> validationMessages);
        bool? ResetPassword(Guid? resetGuid, int? otp, List<ValidationMessage> validationMessages);
        void EnqueueBackgroundJob(UserInputModel userModel, UserRegistrationDetailsModel userRegistrationDetails,
            LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
