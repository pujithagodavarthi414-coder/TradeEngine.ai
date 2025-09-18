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
    public partial class GoalReplanTypeRepository
    {
        public Guid? UpsertGoalReplanType(GoalReplanTypeUpsertInputModel goalReplanTypeUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalReplanTypeId", goalReplanTypeUpsertInputModel.GoalReplanTypeId);
                    vParams.Add("@GoalReplanTypeName", goalReplanTypeUpsertInputModel.GoalReplanTypeName);
                    vParams.Add("@IsArchived", goalReplanTypeUpsertInputModel.IsArchived);
					vParams.Add("@TimeStamp", goalReplanTypeUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@TimeZone", goalReplanTypeUpsertInputModel.TimeZone);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertGoalReplanType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertGoalReplanType", "GoalReplanTypeRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalReplanTypeUpsert);
                return null;
            }
        }

        public List<GoalReplanTypeApiReturnModel> GetAllGoalReplanTypes(GoalReplanTypeInputModel goalReplanTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalReplanTypeId", goalReplanTypeInputModel.GoalReplanTypeId);
                    vParams.Add("@GoalReplanTypeName", goalReplanTypeInputModel.GoalReplanTypeName);
                    vParams.Add("@IsArchived", goalReplanTypeInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalReplanTypeApiReturnModel>(StoredProcedureConstants.SpGetGoalReplanTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllGoalReplanTypes", "GoalReplanTypeRepository", sqlException.Message),sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllGoalReplanTypes);
                return new List<GoalReplanTypeApiReturnModel>();
            }
        }
    }
}
