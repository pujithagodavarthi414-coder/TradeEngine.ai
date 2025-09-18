using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.Goals;
using Btrak.Models.Sprints;
using Btrak.Models.UserStory;
using BTrak.Common;
using Dapper;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class UserStoryReplanRepository
    {
        public Guid? InsertUserStoryReplan(UserStoryReplanUpsertInputModel userStoryReplanUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@UserStoryReplanId", userStoryReplanUpsertInputModel.UserStoryReplanId);
                    vParams.Add("@UserStoryId", userStoryReplanUpsertInputModel.UserStoryId);
                    vParams.Add("@UserStoryReplanTypeId", userStoryReplanUpsertInputModel.UserStoryReplanTypeId);
                    vParams.Add("@UserStoryReplanJson", userStoryReplanUpsertInputModel.UserStoryReplanJson);
					vParams.Add("@TimeStamp", userStoryReplanUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryReplan, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "InsertUserStoryReplan", "UserStoryReplanRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryReplanUpsert);
                return null;
            }
        }

        public List<GoalReplanHistoryApiReturnModel> GoalReplanHistory(GoalSearchCriteriaInputModel goalSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GoalId", goalSearchCriteriaInputModel.GoalId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", goalSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", goalSearchCriteriaInputModel.PageSize);
                    vParams.Add("@searchText", goalSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", goalSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", goalSearchCriteriaInputModel.SortDirection);
                    return vConn.Query<GoalReplanHistoryApiReturnModel>(StoredProcedureConstants.SpSearchGoalReplans, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GoalReplanHistory", "UserStoryReplanRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalReplanHistory);
                return new List<GoalReplanHistoryApiReturnModel>();
            }
        }

        public List<GoalReplanHistorySearchOutputModel> GetSprintReplanHistory(Guid? sprintId, int? goalReplanValue, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SprintId", sprintId);
                    vParams.Add("@SprintReplanCount", goalReplanValue);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalReplanHistorySearchOutputModel>(StoredProcedureConstants.SpGetSprintReplanHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSprintReplanHistory", "UserStoryReplanRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSprintReplanHistory);
                return new List<GoalReplanHistorySearchOutputModel>();
            }
        }
        public List<Guid?> UpsertUserStoryReplan(UserStoryReplanInputModel userStoryReplanInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GoalId", userStoryReplanInputModel.GoalId);
                    vParams.Add("@SprintId", userStoryReplanInputModel.SprintId);
                    vParams.Add("@IsFromSprint", userStoryReplanInputModel.IsFromSprint);
                    vParams.Add("@GoalReplanTypeId", userStoryReplanInputModel.GoalReplanId);
                    vParams.Add("@TimeZone", userStoryReplanInputModel.TimeZone);
                    vParams.Add("@UserStoryReplanXML", userStoryReplanInputModel.UserStoryReplanXML);
                    vParams.Add("@UserStoryDeadLine", userStoryReplanInputModel.UserStoryDeadLine);
                    vParams.Add("@UserStoryStartDate", userStoryReplanInputModel.UserStoryStartDate);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpInsertUserStoryReplanHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserStoryReplan", "UserStoryReplanRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUserStoryReplanUpsert);
                return null;
            }
        }

        public List<GoalReplanHistorySearchOutputModel> GetGoalReplanHistory(Guid? GoalId,int? goalReplanValue, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@GoalId", GoalId);
                    vParams.Add("@GoalReplanCount", goalReplanValue);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GoalReplanHistorySearchOutputModel>(StoredProcedureConstants.SpGetGoalReplanHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetGoalReplanHistory", "UserStoryReplanRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGoalReplanHistory);
                return new List<GoalReplanHistorySearchOutputModel>();
            }
        }
    }
}
