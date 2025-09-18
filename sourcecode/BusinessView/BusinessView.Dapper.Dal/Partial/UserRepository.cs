using BTrak.Common;
using Btrak.Dapper.Dal.Models;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.User;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models.SystemManagement;
using System.Threading.Tasks;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserRepository
    {
        //New Code 
        public Guid? UpsertUser(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userModel.UserId);
                    vParams.Add("@FirstName", userModel.FirstName);
                    vParams.Add("@SurName", userModel.SurName);
                    vParams.Add("@Email", userModel.Email);
                    vParams.Add("@Password", userModel.Password);
                    vParams.Add("@RoleIds", userModel.RoleId);
                    vParams.Add("@IsPasswordForceReset", userModel.IsPasswordForceReset);
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
                    vParams.Add("@ModuleIdsXml", userModel.ModuleIdsXml);
                    vParams.Add("@UserAuthenticationId", userModel.UserAuthenticationId);
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

        public List<UserOutputModel> GetAllUsers(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
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
                    vParams.Add("@UserIdsXML", userSearchCriteriaInputModel.UserIdsXML);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsers", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return new List<UserOutputModel>();
            }
        }

        public Guid? GetEmployeeId(Guid? UserAuthenticationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserAuthenticationId", UserAuthenticationId);
                    vParams.Add("@OperationPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid>(StoredProcedureConstants.SpGetEmployeeIdByUserAuthenticatonId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllUsers", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return null;
            }
        }

        public List<UserOutputModel> GetUserDetailsAndCountry(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", userId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUserDetailsAndCountry, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCountry", "PayRollRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionEmployeePFReport);
                return null;
            }
        }

        //Resigned user list
        public async Task UpdateResignedUserStatus(LoggedInContext loggedInContext, Guid? employeeId)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeId);
                    vConn.Query<UserOutputModel>(StoredProcedureConstants.SpUpdateResignedUserStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoals", "GoalRepository", sqlException.Message), sqlException);
            }
        }
        //get user offset minutes
        public int GetOffsetMinutes(Guid? employeeId)
        {
            int offset = 0;
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@EmployeeId", employeeId);
                    offset = vConn.Query<int>(StoredProcedureConstants.SpGetOffSetMinutes, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchGoals", "GoalRepository", sqlException.Message), sqlException);
            }
            return offset;
        }


        public List<UserOutputModel> GetUsersByRoles(Btrak.Models.User.UserSearchCriteriaInputModel userSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@RoleIds", userSearchCriteriaInputModel.RoleIds);
                    return vConn.Query<UserOutputModel>(StoredProcedureConstants.SpGetUsersByRoles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersByRoles", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsers);
                return new List<UserOutputModel>();
            }
        }

        public Guid? UpsertUserProfileDetails(UserProfileInputModel userProfileInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userProfileInputModel.UserId);
                    vParams.Add("@FirstName", userProfileInputModel.FirstName);
                    vParams.Add("@SurName", userProfileInputModel.SurName);
                    vParams.Add("@Email", userProfileInputModel.Email);
                    vParams.Add("@MobileNo", userProfileInputModel.MobileNo);
                    vParams.Add("@TimeStamp", userProfileInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateUserProfileDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserProfileDetails", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserUpsert);
                return null;
            }
        }


        public List<UserDropDownOutputModel> GetUsersDropDown(String searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserDropDownOutputModel>(StoredProcedureConstants.SpGetUsersDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUsersDropDown", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsersDropDown);
                return new List<UserDropDownOutputModel>();
            }
        }

        public List<UserDropDownOutputModel> GetAdhocUsersDropDown(String searchText, bool? isForDropDown, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@isForDropDown", isForDropDown);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserDropDownOutputModel>(StoredProcedureConstants.SpGetAdhocUsersDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAdhocUsersDropDown", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllUsersDropDown);
                return new List<UserDropDownOutputModel>();
            }
        }

        public Guid? UpdatePassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
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

        public Guid? UpdateUserPassword(UserPasswordResetModel resetPasswordModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
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

        public List<UserSpEntity> GetAllUsersForSlack(LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<UserSpEntity>(StoredProcedureConstants.SpGetAllUsersForSlack, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public ResetPasswordInputModel ForgotPassword(string email, List<ValidationMessage> validationMessages, string siteAddress, bool canByPassSiteCheck, Guid resetGuid)
        {
            try
            {
                string url = siteAddress;

                var splits = url.Split('.');

                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailId", email);
                    vParams.Add("@SiteAddress", splits[0]);
                    vParams.Add("@CanBypassSiteCheck", canByPassSiteCheck);
                    vParams.Add("@ResetGuid", resetGuid);
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

        public ResetPasswordInputModel GetUserDetailsByEmail(string email, List<ValidationMessage> validationMessages, string siteAddress, bool canByPassSiteCheck, Guid resetGuid)
        {
            try
            {
                string url = siteAddress;

                var splits = url.Split('.');

                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@EmailId", email);
                    vParams.Add("@SiteAddress", splits[0]);
                    vParams.Add("@CanBypassSiteCheck", canByPassSiteCheck);
                    vParams.Add("@ResetGuid", resetGuid);
                    return vConn.Query<ResetPasswordInputModel>(StoredProcedureConstants.SpGetUserDetailsByEmail, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ForgotPassword", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionForgotPassword);
                return null;
            }
        }

        public bool? ResetPassword(Guid? resetGuid, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@ResetId", resetGuid);
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

        public Guid? UpsertUserDetails(UserInputModel userModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userModel.UserId);
                    vParams.Add("@FirstName", userModel.FirstName);
                    vParams.Add("@SurName", userModel.SurName);
                    vParams.Add("@Email", userModel.Email);
                    vParams.Add("@Password", userModel.Password);
                    vParams.Add("@Role", userModel.Role);
                    vParams.Add("@IsPasswordForceReset", userModel.IsPasswordForceReset);
                    vParams.Add("@IsActive", userModel.IsActive);
                    vParams.Add("@MobileNo", userModel.MobileNo);
                    vParams.Add("@IsAdmin", userModel.IsAdmin);
                    vParams.Add("@ReferenceId", userModel.ReferenceId);
                    vParams.Add("@IsActiveOnMobile", userModel.IsActiveOnMobile);
                    vParams.Add("@ProfileImage", userModel.ProfileImage);
                    vParams.Add("@LastConnection", userModel.LastConnection);
                    vParams.Add("@TimeStamp", userModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", userModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserDetails", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserUpsert);
                return null;
            }
        }

        //Old Code 
        public Guid GetUserId(Guid employeeId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", employeeId);
                return vConn.Query<Guid>(StoredProcedureConstants.SpGetUserId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public Guid GetUserByUserAuthenticationIdAndCompanyId(Guid? userAuthenticationId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", userAuthenticationId);
                vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                return vConn.Query<Guid>(StoredProcedureConstants.SpGetUserByUserAuthenticationIdAndCompanyId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public Guid GetUserAuthenticationIdByClientId(Guid? clientId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (var vConn = OpenConnection())
            {
                string query = "SELECT U.UserAuthenticationId FROM [User] U INNER JOIN Client C ON C.UserId = U.Id WHERE C.Id = '" + clientId + "'";
                return vConn.Query<Guid>(query, commandType: CommandType.Text).FirstOrDefault();
            }
        }

        public UserDbEntity GetSingleUserDetails(Guid userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public UserDbEntity UpdateUserPassword(UserDbEntity userDbEntity)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters(); 
                vParams.Add("@Id", userDbEntity.Id);
                vParams.Add("@Password", userDbEntity.Password);
                vParams.Add("@UpdatedDateTime", userDbEntity.UpdatedDateTime);
                vParams.Add("@UpdatedByUserId", userDbEntity.UpdatedByUserId);
                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpUpdateUserPassword, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<UserDbEntity> GetUserDetailsByName(string userName, string isAllowSupportLogin = null)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);
                vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByName, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<UserDbEntity> GetUserDetailsByName(string userName, bool mail)
        {
            using (var vConn = OpenConnection())
            {
                userName = "admin01@nxussaas.com";
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);
                vParams.Add("@ForRecurring", mail);
                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByName, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public UserDbEntity GetLogInUserDetailsByName(string userName)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetLogInUserDetailsByName, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public void LoginAudit(Guid? userId, string browserName, string ipAddress)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@BrowserName", browserName);
                vParams.Add("@IPAddress", ipAddress);
                vConn.Query<UserDbEntity>(StoredProcedureConstants.SpLoginAudit, vParams, commandType: CommandType.StoredProcedure);
            }
        }

        public List<UserDbEntity> GetUserDetailsByNameAndSiteAddress(string userName, string siteAddress, string isAllowSupportLogin = null)
        {
            string url = siteAddress;

            var splits = url.Split('.');

            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);
                vParams.Add("@SiteAddress", splits[0]);
                vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");
                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByNameAndSiteAddress, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public UserDbEntity GetUserDetailsByNameAndCompanyId(string userName, Guid companyId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);
                vParams.Add("@CompanyId", companyId);

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpetUserDetailsByNameAndCompanyId, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public Guid? GetCompanyIdBySiteAddress(string siteAddress)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@SiteAddress", siteAddress);

                return vConn.Query<Guid?>(StoredProcedureConstants.SpGetCompanyIdBySiteAddress, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public UsersModel UserDetails(Guid? userId, string timeZone = null)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@TimeZone", timeZone);

                return vConn.Query<UsersModel>(StoredProcedureConstants.SpUserDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<CompaniesList> UserCompaniesList(Guid? userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                return vConn.Query<CompaniesList>(StoredProcedureConstants.SpUserCompaniesList, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<WebhookSpEntity> GetSlackWebhook(LoggedInContext loggedInContext, Guid? userId, Guid? projectId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                vParams.Add("@ProjectId", projectId);
                vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                return vConn.Query<WebhookSpEntity>(StoredProcedureConstants.SpGetWebHook, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public virtual SmtpDetailsModel SearchSmtpCredentials(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, string SiteAddress)
        {
            try
            {
                using (var vConn = OpenConnection())
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

        public bool UpsertUserWebHooks(UserWebHookInputModel userWebHookInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@WebHooksXml", userWebHookInputModel.WebHookXml);
                    vParams.Add("@UserId", userWebHookInputModel.UserId);
                    return vConn.Execute(StoredProcedureConstants.SpUpsertUserWebHook, vParams, commandType: CommandType.StoredProcedure) == -1;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserWebHooks", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return false;
            }
        }

        public UserWebHookInputModel GetUserWebHooksById(Guid userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    return vConn.Query<UserWebHookInputModel>(StoredProcedureConstants.SpGetUserWebHooksById, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserWebHooksById", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return null;
            }
        }
        public List<CompaniesList> GetUserCompaniesListOfLoggedInUser(string userName, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserName", userName);
                    return vConn.Query<CompaniesList>(StoredProcedureConstants.SpGetUserWebHooksById, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCompaniesListOfLoggedInUser", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return null;
            }
        }

        public UserDbEntity GetLogInUserDetailsByMobileNumber(string mobileNumber)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@MobileNumber", mobileNumber);

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetLogInUserDetailsByMobileNumber, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<UserDbEntity> GetLogInUserDetailsByMobileNumber(string mobileNumber, string isAllowSupportLogin = null)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@MobileNumber", mobileNumber);
                vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");

                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByMobileNumber, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public List<UserDbEntity> GetUserDetailsByMobileAndSiteAddress(string mobileNumber, string siteAddress, string isAllowSupportLogin = null)
        {
            string url = siteAddress;

            var splits = url.Split('.');

            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@MobileNumber", mobileNumber);
                vParams.Add("@SiteAddress", splits[0]);
                vParams.Add("@IsSupportLogin", isAllowSupportLogin == "true");
                return vConn.Query<UserDbEntity>(StoredProcedureConstants.SpGetUserDetailsByMobileNumberAndSiteAddress, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }
        public List<UsersByCompanyIdModel> GetAllUserIdsByCompanyId(Guid? companyId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@companyId", companyId);
                    return vConn.Query<UsersByCompanyIdModel>(StoredProcedureConstants.SpGetAllUserIdsByCompanyId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserCompaniesListOfLoggedInUser", "UserRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, null);
                return null;
            }

        }
    }
}
