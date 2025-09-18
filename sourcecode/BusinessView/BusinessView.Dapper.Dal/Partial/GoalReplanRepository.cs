using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Goals;
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
    public partial class GoalReplanRepository
    {
        public Guid? InsertGoalReplan(GoalReplanUpsertInputModel goalReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalReplanId", goalReplanUpsertInputModel.GoalReplanId);
                    vParams.Add("@GoalId", goalReplanUpsertInputModel.GoalId);
                    vParams.Add("@GoalReplanTypeId", goalReplanUpsertInputModel.GoalReplanTypeId);
                    vParams.Add("@Reason", goalReplanUpsertInputModel.Reason);
                    vParams.Add("@IsArchived", goalReplanUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", goalReplanUpsertInputModel.TimeZone);
					vParams.Add("@TimeStamp", goalReplanUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoalReplan, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertGoalReplan", "GoalReplanRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalReplanUpsert);
                return null;
            }
        }
    }
}
