using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Status;
using BTrak.Common;
using Dapper;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class GoalStatuRepository
    {
        public List<GoalStatusApiReturnModel> GetAllGoalStatuses(GoalStatusInputModel goalStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@GoalStatusId", goalStatusInputModel.GoalStatusId);
                    vParams.Add("@GoalStatusName", goalStatusInputModel.GoalStatusName);
					vParams.Add("@IsArchived", goalStatusInputModel.IsArchived);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalStatusApiReturnModel>(StoredProcedureConstants.SpGetGoalStatusNew, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllGoalStatuses", "GoalStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllGoalStatuses);
                return new List<GoalStatusApiReturnModel>();
            }
        }
    }
}
