using Btrak.Dapper.Dal.Helpers;
using Btrak.Models;
using Btrak.Models.LeaveManagement;
using Btrak.Models.LeaveType;
using Btrak.Models.MasterData;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{

    public partial class LeaveTypeRepository
    {
        public Guid? UpsertLeaveType(LeaveTypeInputModel leaveTypeInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveTypeId", leaveTypeInputModel.LeaveTypeId);
                    vParams.Add("@LeaveTypeName", leaveTypeInputModel.LeaveTypeName);
                    vParams.Add("@IsArchived", leaveTypeInputModel.IsArchived);
                    vParams.Add("@LeaveShortName", leaveTypeInputModel.LeaveTypeShortName);
                    vParams.Add("@MasterLeaveTypeId", leaveTypeInputModel.MasterLeaveTypeId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsIncludeHolidays", leaveTypeInputModel.IsToIncludeHolidays);
                    vParams.Add("@LeaveTypeColor", leaveTypeInputModel.LeaveTypeColor);
                    vParams.Add("@TimeStamp", leaveTypeInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertLeaveType, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertLeaveType", "LeaveTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertLeaveType);
                return null;
            }
        }

        public List<LeaveFrequencySearchOutputModel> GetAllLeaveTypes(LeaveTypeSearchCriteriaInputModel leaveTypeSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@LeaveTypeId", leaveTypeSearchCriteriaInputModel.LeaveTypeId);
                    vParams.Add("@LeaveTypeName", leaveTypeSearchCriteriaInputModel.LeaveTypeName);
                    vParams.Add("@IsArchived", leaveTypeSearchCriteriaInputModel.IsArchived);
                    vParams.Add("@IsApplyLeavePage", leaveTypeSearchCriteriaInputModel.IsApplyLeave);
                    vParams.Add("@SearchText", leaveTypeSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", leaveTypeSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", leaveTypeSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@PageNumber", leaveTypeSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", leaveTypeSearchCriteriaInputModel.PageSize);
                    vParams.Add("@UserId", leaveTypeSearchCriteriaInputModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LeaveFrequencySearchOutputModel>(StoredProcedureConstants.SpGetLeaveTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLeaveTypes", "LeaveTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionSearchLeaveType);
                return new List<LeaveFrequencySearchOutputModel>();
            }
        }

        public List<MasterLeaveTypeSearchOutputModel> GetMasterLeaveTypes( LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MasterLeaveTypeSearchOutputModel>(StoredProcedureConstants.SpGetMasterLeaveTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMasterLeaveTypes", "LeaveTypeRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetAllMasterLeavetypes);
                return new List<MasterLeaveTypeSearchOutputModel>();
            }
        }

    }
}

