using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.Status;
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
    public partial class UserStoryStatuRepository
    {
        public Guid? UpsertStatus(UserStoryStatusUpsertInputModel userStoryStatusUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TaskStatusId", userStoryStatusUpsertInputModel.TaskStatusId);
                    vParams.Add("@UserStoryStatusId", userStoryStatusUpsertInputModel.UserStoryStatusId);
                    vParams.Add("@StatusName", userStoryStatusUpsertInputModel.UserStoryStatusName);
                    vParams.Add("@StatusColor", userStoryStatusUpsertInputModel.UserStoryStatusColor);
                    vParams.Add("@IsArchived", userStoryStatusUpsertInputModel.IsArchived);
                    vParams.Add("@TimeZone", userStoryStatusUpsertInputModel.TimeZone);
					vParams.Add("@TimeStamp", userStoryStatusUpsertInputModel.TimeStamp, DbType.Binary);
					vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserStoryStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertStatus", "UserStoryStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertStatus);
                return null;
            }
        }

        public List<UserStoryStatusApiReturnModel> GetAllStatuses(UserStoryStatusInputModel userStoryStatusInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserStoryStatusId", userStoryStatusInputModel.UserStoryStatusId);
                    vParams.Add("@TaskStatusId", userStoryStatusInputModel.TaskStatusId);
                    vParams.Add("@TaskStatusName", userStoryStatusInputModel.TaskStatusName);
                    vParams.Add("@StatusName", userStoryStatusInputModel.UserStoryStatusName);
                    vParams.Add("@StatusColor", userStoryStatusInputModel.UserStoryStatusColor);
                    vParams.Add("@IsArchived", userStoryStatusInputModel.IsArchived);
                    vParams.Add("@ArchivedDateTime", userStoryStatusInputModel.ArchivedDateTime);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserStoryStatusApiReturnModel>(StoredProcedureConstants.SpGetUserStoryStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllStatuses", "UserStoryStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllStatuses);
                return new List<UserStoryStatusApiReturnModel>();
            }
        }

        public List<UserstoryStatusApiTaskStatusReturnModel> GetAllTaskStatuses(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();                    
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserstoryStatusApiTaskStatusReturnModel>(StoredProcedureConstants.SpGetTaskStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllTaskStatuses", "UserStoryStatuRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllStatuses);
                return new List<UserstoryStatusApiTaskStatusReturnModel>();
            }
        }
    }
}