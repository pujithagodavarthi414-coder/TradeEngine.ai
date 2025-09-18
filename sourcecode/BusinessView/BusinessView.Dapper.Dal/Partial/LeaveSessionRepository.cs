using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.LeaveSessions;
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
    public partial class LeaveSessionRepository
    {
        public Guid? UpsertLeaveSession(LeaveSessionsInputModel leaveSessionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveSessionId", leaveSessionsInputModel.LeaveSessionId);
                    vParams.Add("@LeaveSessionName", leaveSessionsInputModel.LeaveSessionName);
                    vParams.Add("@IsArchived", leaveSessionsInputModel.IsArchived);
                    vParams.Add("@TimeStamp", leaveSessionsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveSession, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveSession", "LeaveSessionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveSession);
                return null;
            }
        }

        public List<LeaveSessionsOutputModel> GetAllLeaveSessions(LeaveSessionsInputModel leaveSessionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", leaveSessionsInputModel.LeaveSessionName);
                    vParams.Add("@IsArchived", leaveSessionsInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@LeaveSessionId", leaveSessionsInputModel.LeaveSessionId);
                    return vConn.Query<LeaveSessionsOutputModel>(StoredProcedureConstants.SpGetLeaveSessions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLeaveSessions", "LeaveSessionRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchLeaveSession);
                return new List<LeaveSessionsOutputModel>();
            }
        }
    }
}
