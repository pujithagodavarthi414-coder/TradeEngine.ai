using Btrak.Dapper.Dal.SpModels;
using Dapper;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;
using BTrak.Common;
using Btrak.Dapper.Dal.Helpers;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserAuthTokenRepository
    {
        public string GetUserAuthToken(string userName)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserName", userName);
                return vConn.Query<string>(StoredProcedureConstants.SpGetUserAuthToken, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public UserAuthTokenSpEntity GetUserAuthTokenReadItem(Guid? userId)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                var aa = vConn.Query<UserAuthTokenSpEntity>(StoredProcedureConstants.SpUserAuthTokensReadItem, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                return aa;
            }
        }

        public bool Delete(Guid userId)
        {
            var blResult = false;
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);

                int iResult = vConn.Execute(StoredProcedureConstants.SpUserAuthTokensDelete, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }


        public bool EnsureUserCanHaveAccess(Guid roleId, string rootPath)
        {
            using (var vConn = OpenConnection())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@RoleId", roleId);
                vParams.Add("@RootPath", rootPath);

                return vConn.Query<bool>(StoredProcedureConstants.SpEnsureUserCanHaveAccess, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public ValidUserOutputmodel ValidateAuthTokenAndActionPath(Guid userId, string actionPath,string authToken)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@ActionPath", actionPath);
                    vParams.Add("@AuthToken", authToken);
                    return vConn.Query<ValidUserOutputmodel>(StoredProcedureConstants.SpValidateAuthTokenAndActionPath,
                        vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateAuthTokenAndActionPath", "UserAuthTokenRepository", sqlException.Message), sqlException);

                return null;
            }
           
        }

        public bool ValidateApiKey(string apiKey)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@@ApiKey", apiKey);
                    return vConn.Query<bool>(StoredProcedureConstants.SpValidateApiKey,
                        vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }

            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateApiKey", "UserAuthTokenRepository", sqlException.Message), sqlException);

                return false;
            }

        }
    }
}
