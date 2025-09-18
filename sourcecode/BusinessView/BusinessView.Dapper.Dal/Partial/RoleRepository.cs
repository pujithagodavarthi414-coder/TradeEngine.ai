using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Role;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class RoleRepository
    {
        public Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleModel.RoleId);
                    vParams.Add("@RoleName", roleModel.RoleName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", roleModel.TimeStamp,DbType.Binary);
                    vParams.Add("@FeatureGuids", roleModel.FeatureIdXml);
                    vParams.Add("@IsArchived", roleModel.IsArchived);
                    vParams.Add("@IsDeveloper", roleModel.IsDeveloper);
                    vParams.Add("@IsNewRole", roleModel.IsNewRole);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertRoleFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertRole", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertRole);
                return null;
            }
        }

        public Guid? DeleteRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleModel.RoleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", roleModel.TimeStamp, DbType.Binary);
                    vParams.Add("@IsArchived", roleModel.IsArchived);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpDeleteRole, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "DeleteRole", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionDeleteRole);
                return null;
            }
        }

        public RolesOutputModel GetRoleDetailsByName(string roleName, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", null);
                    vParams.Add("@RoleName", roleName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNo", 1);
                    vParams.Add("@PageSize", 10);
                    return vConn.Query<RolesOutputModel>(StoredProcedureConstants.SpGetRoles, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRoleDetailsByName", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetRoleDetailsByName);
                return null;
            }
        }

        public List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleSearchCriteriaInputModel.RoleId);
                    vParams.Add("@RoleName", roleSearchCriteriaInputModel.RoleName);
                    vParams.Add("@SearchText", roleSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNo", roleSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", roleSearchCriteriaInputModel.PageSize);
                    vParams.Add("@IsArchived", roleSearchCriteriaInputModel.IsArchived);
                    return vConn.Query<RolesOutputModel>(StoredProcedureConstants.SpGetRoles, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllRoles", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return new List<RolesOutputModel>();
            }
        }

        public List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RoleDropDownOutputModel>(StoredProcedureConstants.SpGetRolesDropDown, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllRolesDropDown", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return new List<RoleDropDownOutputModel>();
            }
        }

        public List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeatureId", roleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RoleFeatureOutputModel>(StoredProcedureConstants.SpGetRoleByFeatureId, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRolesByFeatureId", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return new List<RoleFeatureOutputModel>();
            }
        }

        public Guid? updateFeatureInputModel(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", updateFeatureInputModel.RoleId);
                    vParams.Add("@FeatureId", updateFeatureInputModel.FeatureId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateRoleFeature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "updateFeatureInputModel", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return null;
            }
        }

        public List<RoleDetailsOutputModel> GetRolesFromAuthenticationServices(Guid? companyId, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenAuthConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    var query = "SELECT Id, RoleName, ISNULL(IsDeveloper, 0) AS IsDeveloper, ISNULL(IsAdministrator, 0) AS IsAdministrator, ISNULL(IsHidden, 0) AS IsHidden FROM [dbo].[Role] WHERE CompanyId='" + companyId + "' AND RoleName<>'Super Admin'";
                    var roleList = vConn.Query<RoleDetailsOutputModel>(query, commandType: CommandType.Text).ToList();
                    return roleList;
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "updateFeatureInputModel", "RoleRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllRoles);
                return new List<RoleDetailsOutputModel>();
            }
        }
    }
}
