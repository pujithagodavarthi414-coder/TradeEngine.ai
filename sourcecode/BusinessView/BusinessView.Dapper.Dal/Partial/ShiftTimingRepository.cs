using Btrak.Models;
using Btrak.Models.HrManagement;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Dapper.Dal.Helpers;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class ShiftTimingRepository
    {
        public Guid? UpsertShiftTiming(ShiftTimingInputModel shiftTimingInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ShiftTimingId", shiftTimingInputModel.ShiftTimingId);
                    vParams.Add("@Shift", shiftTimingInputModel.Shift);
                    vParams.Add("@IsArchived", shiftTimingInputModel.IsArchived);
                    vParams.Add("@BranchId", shiftTimingInputModel.BranchId);
                    vParams.Add("@IsDefault", shiftTimingInputModel.IsDefault);
                    vParams.Add("@DayOfWeek", shiftTimingInputModel.DaysOfWeekXML);
                    vParams.Add("@ShiftWeekJson", shiftTimingInputModel.ShiftWeekJson);
                    vParams.Add("@ShiftExceptionJson", shiftTimingInputModel.ShiftExceptionJson);
                    vParams.Add("@IsClone", shiftTimingInputModel.IsClone);
                    vParams.Add("@TimeStamp", shiftTimingInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertShiftTiming, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftTiming", "ShiftTimingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionShiftTimingUpsert);
                return null;
            }
        }

        public List<ShiftTimingsSearchOutputModel> SearchShiftTimings(ShiftTimingsSearchInputModel shiftTimingsSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", shiftTimingsSearchInputModel.SearchText);
                    vParams.Add("@ShiftTimingId", shiftTimingsSearchInputModel.ShiftTimingId);
                    vParams.Add("@EmployeeId", shiftTimingsSearchInputModel.EmployeeId);
                    vParams.Add("@IsArchived", shiftTimingsSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ShiftTimingsSearchOutputModel>(StoredProcedureConstants.SpGetShiftTimings, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "SearchShiftTimings", "ShiftTimingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetShiftTimings);
                return new List<ShiftTimingsSearchOutputModel>();
            }
        }

        public Guid? UpsertShiftWeek(ShiftWeekUpsertInputModel shiftWeekUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ShiftTimingId", shiftWeekUpsertInputModel.ShiftTimingId);
                    vParams.Add("@DaysOfWeek", shiftWeekUpsertInputModel.DayOfWeek);
                    vParams.Add("@ShiftWeekId", shiftWeekUpsertInputModel.ShiftWeekId);
                    vParams.Add("@Deadline", shiftWeekUpsertInputModel.DeadLine);
                    vParams.Add("@EndTime", shiftWeekUpsertInputModel.EndTime);
                    vParams.Add("@StratTiming", shiftWeekUpsertInputModel.StartTime);
                    vParams.Add("@AllowedBreakTime", shiftWeekUpsertInputModel.AllowedBreakTime);
                    vParams.Add("@IsArchived", shiftWeekUpsertInputModel.IsArchived);
                    vParams.Add("@IsPaidBreak", shiftWeekUpsertInputModel.IsPaidBreak);
                    vParams.Add("@TimeStamp", shiftWeekUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertShiftWeek, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftWeek", "ShiftTimingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertShiftWeek);
                return null;
            }
        }

        public List<ShiftWeekSearchOutputModel> GetShiftWeek(ShiftWeekSearchInputModel shiftWeekSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", shiftWeekSearchInputModel.SearchText);
                    vParams.Add("@ShiftTimingId", shiftWeekSearchInputModel.ShiftTimingId);
                    vParams.Add("@ShiftWeekId", shiftWeekSearchInputModel.ShiftWeekId);
                    vParams.Add("@IsArchived", shiftWeekSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ShiftWeekSearchOutputModel>(StoredProcedureConstants.SpGetShiftWeek, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShiftWeek", "ShiftTimingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetShiftWeek);
                return new List<ShiftWeekSearchOutputModel>();
            }
        }

        public Guid? UpsertShiftException(ShiftExceptionUpsertInputModel shiftExceptionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ShiftTimingId", shiftExceptionUpsertInputModel.ShiftTimingId);
                    vParams.Add("@ExceptionDate", shiftExceptionUpsertInputModel.ExceptionDate);
                    vParams.Add("@ShiftExceptionsId", shiftExceptionUpsertInputModel.ShiftExceptionId);
                    vParams.Add("@Deadline", shiftExceptionUpsertInputModel.DeadLine);
                    vParams.Add("@StratTiming", shiftExceptionUpsertInputModel.StartTime);
                    vParams.Add("@EndTiming", shiftExceptionUpsertInputModel.EndTime);
                    vParams.Add("@AllowedBreakTime", shiftExceptionUpsertInputModel.AllowedBreakTime);
                    vParams.Add("@IsArchived", shiftExceptionUpsertInputModel.IsArchived);
                    vParams.Add("@TimeStamp", shiftExceptionUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertShiftExceptions, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {

                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertShiftException", "ShiftTimingRepository", sqlException.Message), sqlException);
                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertShiftException);
                return null;
            }
        }

        public List<ShiftExceptionSearchOutputModel> GetShiftException(ShiftExceptionSearchInputModel shiftExceptionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", shiftExceptionSearchInputModel.SearchText);
                    vParams.Add("@ShiftTimingId", shiftExceptionSearchInputModel.ShiftTimingId);
                    vParams.Add("@ShiftExceptionsId", shiftExceptionSearchInputModel.ShiftExceptionsId);
                    vParams.Add("@IsArchived", shiftExceptionSearchInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ShiftExceptionSearchOutputModel>(StoredProcedureConstants.SpGetShiftException, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetShiftException", "ShiftTimingRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetShiftException);
                return new List<ShiftExceptionSearchOutputModel>();
            }
        }
    }
}
