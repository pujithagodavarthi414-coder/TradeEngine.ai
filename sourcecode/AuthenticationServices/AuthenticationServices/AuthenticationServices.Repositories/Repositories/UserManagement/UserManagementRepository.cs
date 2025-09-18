using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.SystemManagement;
using AuthenticationServices.Models.User;
using AuthenticationServices.Repositories.Helpers;
using AuthenticationServices.Repositories.Models;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace AuthenticationServices.Repositories.Repositories.UserManagement
{
    public class UserManagementRepository : IUserManagementRepository
    {
        IConfiguration _iconfiguration;
        private readonly AppSettings _appSettings;
        public UserManagementRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        //public UserManagementRepository()
        //{
            
        //}

        public List<UserDbEntity> GetUserDetailsByNameAndSiteAddress(string userName, string siteAddress, string isAllowSupportLogin = null)
        {
            string url = siteAddress;

            var splits = url.Split('.');

            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters(); 
                vParams.Add("@UserName", userName);
                vParams.Add("@SiteAddress", splits[0]);
                vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");
                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByNameAndSiteAddress, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<UserDbEntity> GetUserDetailsByName(string userName, string isAllowSupportLogin = null)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserName", userName);
                    vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");

                    return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByName, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch(SqlException e)
            {
                return null;
            }
        }

        public UserDbEntity GetUserDetailsByUserIdAndCompanyId(Guid userId, Guid companyId, string isAllowSupportLogin = null)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@CompanyId", companyId);
                    vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");

                    return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByUserIdAndCompanyId,
                        vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserDetailsByUserIdAndCompanyId", "UserRepository", sqlException.Message), sqlException);

                //SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, "");// ValidationMessages.ExceptionUserUpsert);
                return null;
            }
        }

        public UserDbEntity GetSingleUserDetails(Guid userId)
        {
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public UsersModel UserDetails(Guid userId, Guid companyId, string timeZone = null)
        {
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@CompanyId", companyId);
                vParams.Add("@TimeZone", timeZone);

                return vConn.Query<UsersModel>(StoredProcedureConstants.SpUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<CompaniesList> UserCompaniesList(Guid? userId)
        {
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                return vConn.Query<CompaniesList>(StoredProcedureConstants.SpUserCompaniesList, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userModel.UserId);
                    vParams.Add("@FirstName", userModel.FirstName);
                    vParams.Add("@SurName", userModel.SurName);
                    vParams.Add("@Email", userModel.Email);
                    vParams.Add("@Password", userModel.Password);
                    vParams.Add("@RoleIds", userModel.RoleId);
                    vParams.Add("@IsPasswordForceReset", userModel.IsPasswordForceReset);
                    vParams.Add("@IsActive", userModel.IsActive);
                    vParams.Add("@IsExternal", userModel.IsExternal);
                    vParams.Add("@MobileNo", userModel.MobileNo);
                    vParams.Add("@IsAdmin", userModel.IsAdmin);
                    vParams.Add("@IsActiveOnMobile", userModel.IsActiveOnMobile);
                    vParams.Add("@ProfileImage", userModel.ProfileImage);
                    vParams.Add("@LastConnection", userModel.LastConnection);
                    vParams.Add("@TimeStamp", userModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", userModel.IsArchived);
                    vParams.Add("@TimeZoneId", userModel.TimeZoneId);
                    vParams.Add("@DesktopId", userModel.DesktopId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Language", userModel.Language);
                    //vParams.Add("@ModuleIdsXml", userModel.ModuleIdsXml);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    vParams.Add("@IdentityServerCallback", userModel.IdentityServerCallback);
                    vParams.Add("@UpdateProfileDetails", userModel.UpdateProfileDetails);
                    vParams.Add("@IsFromClient", userModel.IsFromClient);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUser, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUser", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserUpsert);
                return null;
            }
        }

        public ResetPasswordInputModel ForgotPassword(string email, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailId", email);
                    return vConn.Query<ResetPasswordInputModel>(StoredProcedureConstants.SpGetResetPasswordDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForgotPassword);
                return null;
            }
        }

        public bool? ResetPassword(Guid? resetGuid,  int? otp, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ResetId", resetGuid);
                    vParams.Add("@OTP", otp);
                    return vConn.Query<bool>(StoredProcedureConstants.SpUpdateResetPassword, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ResetPassword", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionResetPassword);
                return null;
            }
        }

        public Guid? UpdateUserPassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext,  List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ResetGuid", resetPasswordModel.ResetGuid);
                    vParams.Add("@NewPassword", resetPasswordModel.NewPassword);
                    vParams.Add("@ConfirmPassword", resetPasswordModel.ConfirmPassword);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateUserForgottenPassword, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateUserPassword", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePassword);
                return null;
            }
        }

        public Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ChangedToUserId", resetPasswordModel.UserId);
                    vParams.Add("@ResetGuid", resetPasswordModel.ResetGuid);
                    vParams.Add("@NewPassword", resetPasswordModel.NewPassword);
                    vParams.Add("@ConfirmPassword", resetPasswordModel.ConfirmPassword);
                    //vParams.Add("@TimeStamp", resetPasswordModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", resetPasswordModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", (loggedInContext.LoggedInUserId == Guid.Empty) ? Guid.Empty : loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdatePassword, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAdhocUsersDropDown", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpdatePassword);
                return null;
            }
        }

        public List<UserOutputModel> GetAllUsers(UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userSearchCriteriaInputModel.UserId);
                    vParams.Add("@UserName", userSearchCriteriaInputModel.UserName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RoleId", userSearchCriteriaInputModel.RoleId);
                    vParams.Add("@SearchText", userSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsUsersPage", userSearchCriteriaInputModel.IsUsersPage);
                    vParams.Add("@IsActive", userSearchCriteriaInputModel.IsActive);
                    vParams.Add("@SortBy", userSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", userSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@EmployeeNameText", userSearchCriteriaInputModel.EmployeeNameText);
                    vParams.Add("@PageNo", userSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", userSearchCriteriaInputModel.PageSize);
                    vParams.Add("@EntityId", userSearchCriteriaInputModel.EntityId);
                    vParams.Add("@BranchId", userSearchCriteriaInputModel.BranchId);
                    vParams.Add("@IsEmployeeOverviewDetails", userSearchCriteriaInputModel.IsEmployeeOverviewDetails);
                    vParams.Add("@RoleIds", userSearchCriteriaInputModel.RoleIds);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUsers, vParams, commandType: CommandType.StoredProcedure).ToList(); // need to write Proc
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsers", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return new List<UserOutputModel>();
            }
        }

        public Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userProfileInputModel.UserId);
                    vParams.Add("@FirstName", userProfileInputModel.FirstName);
                    vParams.Add("@SurName", userProfileInputModel.SurName);
                    vParams.Add("@Email", userProfileInputModel.Email);
                    vParams.Add("@MobileNo", userProfileInputModel.MobileNo);
                    vParams.Add("@TimeStamp", userProfileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpUpdateUserProfileDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserProfileDetails", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return null;
            }
        }

        public SmtpDetailsModel SearchSmtpCredentials(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string SiteAddress)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId == Guid.Empty ? null : loggedInContext?.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext?.CompanyGuid == Guid.Empty ? null : loggedInContext?.CompanyGuid);
                    vParams.Add("@SiteAddress", SiteAddress);
                    return vConn.Query<SmtpDetailsModel>(StoredProcedureConstants.SpGetSmtpCredentials, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchSmtpCredentials", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchSystemCurrencies);
                return new SmtpDetailsModel();
            }
        }

        protected IDbConnection OpenConnection()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("BTrakConnectionString"));
            connection.Open();
            return connection;
        }

        protected IDbConnection OpenConnectionAuthentication()
        {
            IDbConnection connection = new SqlConnection(_iconfiguration.GetConnectionString("AuthConnectionString"));
            connection.Open();
            return connection;
        }

    }
}
