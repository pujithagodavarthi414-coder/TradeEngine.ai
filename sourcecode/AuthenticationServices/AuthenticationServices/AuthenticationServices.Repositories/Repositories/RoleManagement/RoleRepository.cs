using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Models.Role;
using AuthenticationServices.Repositories.Helpers;
using Dapper;
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace AuthenticationServices.Repositories.Repositories.RoleManagement
{
    public class RoleRepository : IRoleRepository
    {
        IConfiguration _iconfiguration;
        public RoleRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }
        public Guid? UpsertRole(RolesInputModel roleModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleModel.RoleId);
                    vParams.Add("@RoleName", roleModel.RoleName);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", roleModel.TimeStamp, DbType.Binary);
                    vParams.Add("@FeatureGuids", roleModel.FeatureIdXml);
                    vParams.Add("@IsArchived", roleModel.IsArchived);
                    vParams.Add("@IsDeveloper", roleModel.IsDeveloper);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
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
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleModel.RoleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
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

        public List<RolesOutputModel> GetAllRoles(RolesSearchCriteriaInputModel roleSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@RoleId", roleSearchCriteriaInputModel.RoleId);
                    vParams.Add("@RoleName", roleSearchCriteriaInputModel.RoleName);
                    vParams.Add("@SearchText", roleSearchCriteriaInputModel.SearchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    if(roleSearchCriteriaInputModel.CompanyId == null)
                    {
                        vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
                    }
                    else
                    {
                        vParams.Add("@CompanyId", roleSearchCriteriaInputModel.CompanyId);
                    }
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

        public List<RoleFeatureOutputModel> GetRolesByFeatureId(Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@FeatureId", roleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
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

        public List<RoleDropDownOutputModel> GetAllRolesDropDown(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@CompanyId", loggedInContext.CompanyGuid);
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

        public Guid? updateFeatureInputModel(UpdateFeatureInputModel updateFeatureInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnectionAuthentication())
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
