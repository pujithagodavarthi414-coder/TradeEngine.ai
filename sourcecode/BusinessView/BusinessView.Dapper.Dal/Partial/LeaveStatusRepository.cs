using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.MasterData;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Partial
{
    public class LeaveStatusRepository : BaseRepository
    {
        public Guid? UpsertLeaveStatus(LeaveStatusUpsertModel leaveStatusUpsertModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveStatusId", leaveStatusUpsertModel.LeaveStatusId); 
                    vParams.Add("@LeaveStatusName", leaveStatusUpsertModel.LeaveStatusName);
                    vParams.Add("@IsArchived", leaveStatusUpsertModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", leaveStatusUpsertModel.TimeStamp, DbType.Binary);
                    vParams.Add("@LeaveStatusColour", leaveStatusUpsertModel.LeaveStatusColour);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveStatus", "LeaveStatusRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionLeaveStatus);
                return null;
            }
        }

        public List<GetLeaveStatusOutputModel> GetLeaveStatus(GetLeavestatusSearchCriteriaInputModel getLeavestatusSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@LeaveStatusId", getLeavestatusSearchCriteriaInputModel.LeaveStatusId);
                    vParams.Add("@LeaveStatusName", getLeavestatusSearchCriteriaInputModel.LeaveStatusName);
                    vParams.Add("@SearchText", getLeavestatusSearchCriteriaInputModel.SearchText);
                    vParams.Add("@IsArchived", getLeavestatusSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<GetLeaveStatusOutputModel>(StoredProcedureConstants.SpGetLeaveStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeaveStatus", "LeaveStatusRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLeaveStatuses);
                return new List<GetLeaveStatusOutputModel>();
            }
        }
    }
}
