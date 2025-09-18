using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using AuthenticationServices.Common;
using AuthenticationServices.Models;
using AuthenticationServices.Repositories.Models;
using AuthenticationServices.Repositories.SpModels;
using Dapper;
using Microsoft.Extensions.Configuration;

namespace AuthenticationServices.Repositories.Repositories.UserAuthTokenRepository
{
    public class UserAuthTokenRepository //: BaseRepository
    {
        IConfiguration _iconfiguration;

        public UserAuthTokenRepository(IConfiguration iconfiguration)
        {
            _iconfiguration = iconfiguration;
        }

        public bool Insert(UserAuthTokenDbEntity aUserAuthToken)
        {
            var blResult = false;
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aUserAuthToken.Id);
                vParams.Add("@UserId", aUserAuthToken.UserId);
                vParams.Add("@UserName", aUserAuthToken.UserName);
                vParams.Add("@DateCreated", aUserAuthToken.DateCreated);
                vParams.Add("@AuthToken", aUserAuthToken.AuthToken);
                vParams.Add("@CompanyId", aUserAuthToken.CompanyId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpUserAuthTokenInsert, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public bool UpdateAuthToken(UserAuthTokenDbEntity aUserAuthToken)
        {
            var blResult = false;
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@Id", aUserAuthToken.Id);
                vParams.Add("@UserId", aUserAuthToken.UserId);
                vParams.Add("@UserName", aUserAuthToken.UserName);
                vParams.Add("@DateCreated", aUserAuthToken.DateCreated);
                vParams.Add("@AuthToken", aUserAuthToken.AuthToken);
                vParams.Add("@CompanyId", aUserAuthToken.CompanyId);
                int iResult = vConn.Execute(StoredProcedureConstants.SpUserAuthTokenUpdate, vParams, commandType: CommandType.StoredProcedure);
                if (iResult == -1) blResult = true;
            }
            return blResult;
        }

        public UserAuthTokenSpEntity GetUserAuthTokenReadItem(Guid? userId, Guid? companyId)
        {
            using (var vConn = OpenConnectionAuthentication())
            {
                var vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@CompanyId", companyId);
                var aa = vConn.Query<UserAuthTokenSpEntity>(StoredProcedureConstants.SpUserAuthTokensReadItem, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                return aa;
            }
        }

        public bool ValidateApiKey(string apiKey)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
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

        public ValidUserOutputmodel ValidateAuthTokenAndActionPath(Guid userId, Guid companyId, string actionPath, string authToken)
        {
            try
            {
                using (var vConn = OpenConnectionAuthentication())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@CompanyId", companyId);
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
