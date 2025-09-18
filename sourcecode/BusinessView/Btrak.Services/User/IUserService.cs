using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using Btrak.Models.User;
using Btrak.Models.UserStory;

namespace Btrak.Services.User
{
    public interface IUserService
    {
        //New Code
        Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserOutputModel> GetAllUsers(Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserDropDownOutputModel> GetUsersDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UserOutputModel GetUserById(Guid? userId, bool? isEmployeeOverviewDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? importConfiguration = false);
        Guid? ChangePassword(UserPasswordResetModel changePasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        UsersModel GetUserDetailsByName(string userName);
        UsersModel GetUserDetails(Guid userId, LoggedInContext loggedInContext, string timeZone = null);
        bool IsUserExisted(string userName, string password, List<ValidationMessage> validationMessages);
        bool? ForgotPassword(string email, List<ValidationMessage> validationMessages);
        bool? ResetPassword(Guid? resetGuid, List<ValidationMessage> validationMessages);
        Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel,  List<ValidationMessage> validationMessages);
        List<string> GetLoggedInUserRelatedwebhook(LoggedInContext loggedInContext, Guid? userId, Guid? projectId);
        Guid? UploadProfileImage(UploadProfileImageInputModel uploadProfileImageInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserDropDownOutputModel> GetAdhocUsersDropDown(string searchText, bool? isForDropDown, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);

        bool UpsertUserWebHooks(UserWebHookInputModel userWebHookInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        UserWebHookInputModel GetUserWebHooksById(Guid UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ////Old Code 
        //void AddOrUpdateUserDetails(UserDetailModel userDetailModel, LoggedInContext loggedInContext);

        //Guid? GetEmployeeId(Guid userId);
        //List<MembersModel> GetMembers(Guid userId);
        //List<UserProjects> GetAccessProjectsOfUser(Guid id);
        //List<Issues> GetReportedIssues(Guid id);
        //List<Issues> GetAssignedIssues(Guid id);
        //IList<UsersModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext);
        //void ChangePasswordByAdmin(ChangePasswordModel changePasswordModel);
        //List<GetEmployeeToDoList> GetEmployeeToDoList(int pageNumber, int pageSize, Guid userId);
        //int GetEmployeeToDoListCount(int pageNumber, int pageSize, Guid userId);
        //List<LeadsModel> GetLeadsToDoList(int pageNumber, int pageSize);
        //UserModel GetSingleUserDetails(Guid loggedUserId);
        //int GetLeadsToDoListCount(int pageNumber, int pageSize);
        //UserModel GetUserDetailsOfAdmin(Guid loggedUserId);
        //void UpdatePassword(UserModel model);
        //List<StatusReportModel> GetNotReviewedReports(int pageNumber, int pageSize, Guid userId);
        //List<StatusReportModel> GetNotSubmittedReports(int pageNumber, int pageSize, Guid userId);
        //int GetNotReviewedReportsCount(int pageNumber, int pageSize, Guid userId);
        //int GetNotSubmittedReportsCount(int pageNumber, int pageSize, Guid userId);
        //bool IsPopupShouldShow(Guid userId);
        //IList<UsersModel> GetGoalResponsiblePersons(LoggedInContext loggedInContext);
        //string AddOrUpdateUserProfile(string profileImage, Guid userId);
        //void DeleteUserImage(Guid userId);
        List<Models.User.UserModel> GetAllUsersForSlackApp(Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);


        InitialDetailsOutputModel GetLoggedInUserInitialDetails(UserAuthToken userAuthToken, string timeZone = null);
        List<UserOutputModel> GetUsersByRoles(Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        
        bool IsMobileNumberExists(string mobileNumber, List<ValidationMessage> validationMessages);
        UsersModel GetUserDetailsByMobile(string mobileNumber);
      
    }
}
