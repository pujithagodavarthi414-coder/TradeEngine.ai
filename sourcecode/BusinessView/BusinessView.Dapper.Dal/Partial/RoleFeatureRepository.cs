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
    public partial class RoleFeatureRepository
    {
        public List<RoleFeatureApiReturnModel> SearchRoleFeatures(Guid? userId, Guid? roleId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@RoleId", roleId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<RoleFeatureApiReturnModel>(StoredProcedureConstants.SpGetRoleFeaturesNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchRoleFeatures", "RoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchRoleFeatures);
                return new List<RoleFeatureApiReturnModel>();
            }
        }

        public bool? GetIfUserCanHaveAccess(Guid userId, Guid featureId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@FeatureId", featureId);
                    return vConn.Query<bool>(StoredProcedureConstants.SpEnsureUserAccessibility, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetIfUserCanHaveAccess", "RoleFeatureRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetIfUserCanHaveAccess);
                return null;
            }
        }
    }
}
