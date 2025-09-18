using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.SystemManagement;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Models;
using System;
using System.Collections.Generic;

namespace AuthenticationServices.Repositories.Repositories.UserManagement
{
    public class FakeUserManagementRepository : IUserManagementRepository
    {
        public Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return new Guid("5D893EB5-CDE3-45E0-9290-2382220CB709");
        }

        public List<UserOutputModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            List<UserOutputModel> userOutput = new List<UserOutputModel>();
            var user = new UserOutputModel();
            user.Id = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C");
            user.UserId = new Guid("99DD4149-C0FB-464B-99BA-8D6D9E09982C");
            user.FirstName = "test";
            user.SurName = "test";
            user.FullName = "test test";
            user.Email = "test@test.com";
            user.RoleName = "Role";
            user.MobileNo = "";
            user.IsActive = true;
            user.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(user);

            user = new UserOutputModel();
            user.Id = new Guid("DAE20421-988E-408C-A788-319D2968A628");
            user.UserId = new Guid("DAE20421-988E-408C-A788-319D2968A628");
            user.FirstName = "test1";
            user.SurName = "test1";
            user.FullName = "test1 test1";
            user.Email = "test1@test.com";
            user.RoleName = "Role1";
            user.MobileNo = "";
            user.IsActive = false;
            user.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(user);

            user = new UserOutputModel();
            user.Id = new Guid("B68C7B00-0C4F-4F18-98B2-3F845D1FBABA");
            user.UserId = new Guid("B68C7B00-0C4F-4F18-98B2-3F845D1FBABA");
            user.FirstName = "test2";
            user.SurName = "test2";
            user.FullName = "test2 test2";
            user.Email = "test2@test.com";
            user.RoleName = "Role2";
            user.MobileNo = "";
            user.IsActive = true;
            user.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(user);

            user = new UserOutputModel();
            user.Id = new Guid("B46B7D0B-3AA3-4B4B-897B-C088EFCBABD2");
            user.UserId = new Guid("B46B7D0B-3AA3-4B4B-897B-C088EFCBABD2");
            user.FirstName = "test3";
            user.SurName = "test3";
            user.FullName = "test3 test3";
            user.Email = "test3@test.com";
            user.RoleName = "Role3";
            user.MobileNo = "";
            user.IsActive = true;
            user.CompanyId = new Guid(loggedInContext.CompanyGuid.ToString());
            userOutput.Add(user);

            if (userSearchCriteriaInputModel.UserId != null || !String.IsNullOrEmpty(userSearchCriteriaInputModel.SearchText))
            {
                var filteredUsers = new List<UserOutputModel>();
                var yesText = "yes";
                var noText = "no";
                if (userSearchCriteriaInputModel.UserId != null && !String.IsNullOrEmpty(userSearchCriteriaInputModel.SearchText))
                {
                    var searchText = userSearchCriteriaInputModel.SearchText.ToLower();
                    foreach (var userDetails in userOutput)
                    {
                        if (userDetails.UserId == userSearchCriteriaInputModel.UserId && (userDetails.FullName.ToLower().Contains(searchText) || userDetails.Email.ToLower().Contains(searchText) 
                            || userDetails.RoleName.ToLower().Contains(searchText) || userDetails.MobileNo.ToLower().Contains(searchText) || (yesText.Contains(searchText) && userDetails.IsActive == true) 
                            || (noText.Contains(searchText) && userDetails.IsActive == false)))
                        {
                            filteredUsers.Add(userDetails);
                        }
                    }
                }
                else if(userSearchCriteriaInputModel.UserId != null)
                {
                    foreach (var userDetails in userOutput)
                    {
                        if (userDetails.UserId == userSearchCriteriaInputModel.UserId)
                        {
                            filteredUsers.Add(userDetails);
                        }
                    }
                }
                else if (!String.IsNullOrEmpty(userSearchCriteriaInputModel.SearchText))
                {
                    var searchText = userSearchCriteriaInputModel.SearchText.ToLower();
                    foreach (var userDetails in userOutput)
                    {

                        if (userDetails.FullName.ToLower().Contains(searchText) || userDetails.Email.ToLower().Contains(searchText) || userDetails.RoleName.ToLower().Contains(searchText) || userDetails.MobileNo.ToLower().Contains(searchText)
                            || (yesText.Contains(searchText) && userDetails.IsActive == true) || (noText.Contains(searchText) && userDetails.IsActive == false ))
                        {
                            filteredUsers.Add(userDetails);
                        }
                    }
                }

                return filteredUsers;
            }
            return userOutput;
        }

        public SmtpDetailsModel SearchSmtpCredentials(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string SiteAddress)
        {
            SmtpDetailsModel smtpDetails = new SmtpDetailsModel();
            return smtpDetails;
        }

        public UserDbEntity GetSingleUserDetails(Guid userId)
        {
            return new UserDbEntity();
        }

        public List<UserDbEntity> GetUserDetailsByName(string userName, string isAllowSupportLogin = null)
        {
            return new List<UserDbEntity>();
        }

        public Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }
        
        public List<UserDbEntity> GetUserDetailsByNameAndSiteAddress(string userName, string siteAddress,
            string isAllowSupportLogin = null)
        {
            return new List<UserDbEntity>();
        }

        public UsersModel UserDetails(Guid userId, Guid companyId, string timeZone = null)
        {
            return new UsersModel();
        }

        public List<CompaniesList> UserCompaniesList(Guid? userId)
        {
            return new List<CompaniesList>();
        }

        public UserDbEntity GetUserDetailsByUserIdAndCompanyId(Guid userId, Guid companyId,
            string isAllowSupportLogin = null)
        {
            return new UserDbEntity();
        }
        public ResetPasswordInputModel ForgotPassword(string email, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public bool? ResetPassword(Guid? resetGuid, int? otp, List<ValidationMessage> validationMessages)
        {
            return true;
        }

        public Guid? UpdateUserPassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            return null;
        }

        public Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            return null;
        }
    }

}
