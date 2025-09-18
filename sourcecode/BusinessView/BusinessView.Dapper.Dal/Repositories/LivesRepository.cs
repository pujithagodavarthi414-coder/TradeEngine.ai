using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Lives;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public class LivesRepository : BaseRepository
    {
        public List<UserLevelAccessOutputModel> GetUserLevelAccess(UserLevelAccessModel userLevelAccessModel ,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@UserId", userLevelAccessModel.UserId);
                    vParams.Add("@ProgramId", userLevelAccessModel.ProgramId);
                    vParams.Add("@LevelIds", userLevelAccessModel.LevelXml);
                    vParams.Add("@RoleIds", userLevelAccessModel.RoleXml);
                    vParams.Add("@IsLevelRemovel", userLevelAccessModel.IsLevelRemovel);
                    return vConn.Query<UserLevelAccessOutputModel>(StoredProcedureConstants.SpGetUserLevelAccess, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetClientAccss", "ClientRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetClients);
                return new List<UserLevelAccessOutputModel>();
            }

        }
    }
}
