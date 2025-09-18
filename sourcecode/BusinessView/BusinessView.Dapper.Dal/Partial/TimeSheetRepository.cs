using Btrak.Dapper.Dal.Helpers;
using Btrak.Dapper.Dal.Models;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.MasterData;
using Btrak.Models.TimeSheet;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

namespace Btrak.Dapper.Dal.Repositories
{
    public partial class TimeSheetRepository
    {
        public Guid? UpsertTimeSheet(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ButtonTypeId", timeSheetModel.ButtonTypeId);
                    vParams.Add("@TimesheetId", timeSheetModel.TimeSheetId);
                    vParams.Add("@UserId", timeSheetModel.UserId);
                    vParams.Add("@Date", timeSheetModel.Date);
                    vParams.Add("@TimeZone", timeSheetModel.TimeZone);
                    vParams.Add("@InTime", timeSheetModel.InTimeOffset);
                    vParams.Add("@LunchBreakStartTime", timeSheetModel.LunchBreakStartTimeOffset);
                    vParams.Add("@LunchBreakEndTime", timeSheetModel.LunchBreakEndTimeOffset);
                    vParams.Add("@OutTime", timeSheetModel.OutTimeOffset);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsFeed", timeSheetModel.IsFeed);
                    vParams.Add("@IsNextDay", timeSheetModel.IsNextDay);
                    vParams.Add("@BreakInTime", timeSheetModel.BreakInTimeOffset);
                    vParams.Add("@BreakOutTime", timeSheetModel.BreakOutTimeOffset);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheet, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheet", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTimeSheetUpsert);
                return null;
            }
        }

        public TimeSheetManagementButtonDetails GetEnableOrDisableTimeSheetButtonDetails(Guid? userId, DateTimeOffset? buttonClickedDate, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@ButtonClickedDate", buttonClickedDate);
                    return vConn.Query<TimeSheetManagementButtonDetails>(StoredProcedureConstants.SpGetEnableOrDisableTimeSheetButtonsDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEnableOrDisableTimeSheetButtonDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionInGetEnableOrDisableTimeSheetButtonDetails);
                return null;
            }
        }

        public List<TimeSheetManagementApiOutputModel> GetTimeSheetDetails(TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetManagementSearchInputModel.UserId);
                    vParams.Add("@DateFrom", timeSheetManagementSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", timeSheetManagementSearchInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", timeSheetManagementSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", timeSheetManagementSearchInputModel.PageSize);
                    vParams.Add("@SearchText", timeSheetManagementSearchInputModel.SearchText);
                    vParams.Add("@EmployeeSearchText", timeSheetManagementSearchInputModel.EmployeeSearchText);
                    vParams.Add("@SortBy", timeSheetManagementSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", timeSheetManagementSearchInputModel.SortDirection);
                    vParams.Add("@EntityId", timeSheetManagementSearchInputModel.EntityId);
                    vParams.Add("@TeamLeadId", timeSheetManagementSearchInputModel.TeamLeadId);
                    vParams.Add("@IncludeEmptyRecords", timeSheetManagementSearchInputModel.IncludeEmptyRecords);
                    return vConn.Query<TimeSheetManagementApiOutputModel>(StoredProcedureConstants.SpGetTimeSheetDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeSheetDetails);
                return new List<TimeSheetManagementApiOutputModel>();
            }
        }

        public Guid? UpsertUserBreakDetails(UserBreakDetailsInputModel userBreakModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BreakId", userBreakModel.BreakId);
                    vParams.Add("@UserId", userBreakModel.UserId);
                    vParams.Add("@BreakIn", userBreakModel.DateFromOffset);
                    vParams.Add("@BreakOut", userBreakModel.DateToOffset);
                    vParams.Add("@TimeZone", userBreakModel.TimeZone);
                    vParams.Add("@Date", userBreakModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertUserBreakDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionTimeSheetUpsert);
                return null;
            }
        }

        public List<UserBreakDetailsOutputModel> GetUserBreakDetails(GetUserBreakDetailsInputModel getUserBreakDetailsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", getUserBreakDetailsInputModel.UserId);
                    vParams.Add("@DateFrom", getUserBreakDetailsInputModel.DateFrom);
                    vParams.Add("@PageNumber", getUserBreakDetailsInputModel.PageNumber);
                    vParams.Add("@PageSize", getUserBreakDetailsInputModel.PageSize);
                    vParams.Add("@SortBy", getUserBreakDetailsInputModel.SortBy);
                    vParams.Add("@SortDirection", getUserBreakDetailsInputModel.SortDirection);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<UserBreakDetailsOutputModel>(StoredProcedureConstants.SpGetUserBreakDeatils, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetUserBreakDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeSheetDetails);
                return new List<UserBreakDetailsOutputModel>();
            }
        }

        public List<TimeSheetManagementApiOutputModel> GetTimeSheetHistoryDetails(TimeSheetManagementSearchInputModel timeSheetManagementSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", timeSheetManagementSearchInputModel.UserId);
                    vParams.Add("@DateFrom", timeSheetManagementSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", timeSheetManagementSearchInputModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", timeSheetManagementSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", timeSheetManagementSearchInputModel.PageSize);
                    vParams.Add("@SearchText", timeSheetManagementSearchInputModel.SearchText);
                    vParams.Add("@SortBy", timeSheetManagementSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", timeSheetManagementSearchInputModel.SortDirection);
                    return vConn.Query<TimeSheetManagementApiOutputModel>(StoredProcedureConstants.SpGetTimeSheetHistoryDetail, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetHistoryDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeSheetHistoryDetails);
                return new List<TimeSheetManagementApiOutputModel>();
            }
        }

        public List<TimeSheetManagementPermissionOutputModel> GetTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PermissionId", timeSheetPermissionsModel.PermissionId);
                    vParams.Add("@UserId", timeSheetPermissionsModel.UserId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", timeSheetPermissionsModel.DateFrom);
                    vParams.Add("@DateTo", timeSheetPermissionsModel.DateTo);
                    vParams.Add("@PermissionReasonId", timeSheetPermissionsModel.PermissionReasonId);
                    vParams.Add("@SortBy", timeSheetPermissionsModel.SortBy);
                    vParams.Add("@SortDirection", timeSheetPermissionsModel.SortDirection);
                    vParams.Add("@SearchText", timeSheetPermissionsModel.SearchText);
                    vParams.Add("@PageNumber", timeSheetPermissionsModel.PageNumber);
                    vParams.Add("@EntityId", timeSheetPermissionsModel.EntityId);
                    vParams.Add("@PageSize", timeSheetPermissionsModel.PageSize);
                    return vConn.Query<TimeSheetManagementPermissionOutputModel>(StoredProcedureConstants.SpGetPermissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetPermissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetTimeSheetPermissions);
                return new List<TimeSheetManagementPermissionOutputModel>();
            }
        }

        public Guid? UpsertTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PermissionId", timeSheetPermissionsInputModel.PermissionId);
                    vParams.Add("@UserId", timeSheetPermissionsInputModel.UserId);
                    vParams.Add("@Date", timeSheetPermissionsInputModel.Date);
                    vParams.Add("@Duration", timeSheetPermissionsInputModel.Duration);
                    vParams.Add("@Ismorning", timeSheetPermissionsInputModel.IsMorning);
                    vParams.Add("@IsDeleted", timeSheetPermissionsInputModel.IsDeleted);
                    vParams.Add("@PermissionReasonId", timeSheetPermissionsInputModel.PermissionReasonId);
                    vParams.Add("@TimeStamp", timeSheetPermissionsInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", timeSheetPermissionsInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPermission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetPermissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPermissionUpsert);
                return null;
            }
        }

        public Guid? UpsertTimeSheetPermissionReasons(TimeSheetPermissionReasonInputModel timeSheetPermissionReasonInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PermissionReasonId", timeSheetPermissionReasonInputModel.PermissionReasonId);
                    vParams.Add("@ReasonName", timeSheetPermissionReasonInputModel.PermissionReason);
                    vParams.Add("@IsArchived", timeSheetPermissionReasonInputModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@TimeStamp", timeSheetPermissionReasonInputModel.TimeStamp, DbType.Binary);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertPermissionReason, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetPermissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPermissionReasonUpsert);
                return null;
            }
        }

        public bool? UpsertUserPunchCard(UpsertUserPunchCardInputModel upsertUserPunchCardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                try
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ButtonTypeId", upsertUserPunchCardInputModel.ButtonTypeId);
                    vParams.Add("@ButtonClickedDate", upsertUserPunchCardInputModel.ButtonClickedDate);
                    vParams.Add("@TimeZone", upsertUserPunchCardInputModel.TimeZoneName);
                    vParams.Add("@Latitude", upsertUserPunchCardInputModel.Latitude);
                    vParams.Add("@Longitude", upsertUserPunchCardInputModel.Longitude);
                    vParams.Add("@IsMobilePunchCard", upsertUserPunchCardInputModel.IsMobilePunchCard);
                    vParams.Add("@IsFeed", upsertUserPunchCardInputModel.IsFeed);
                    vParams.Add("@UserReason", upsertUserPunchCardInputModel.UserReason);
                    vParams.Add("@OperationsPerformedBy", loggedInContext?.LoggedInUserId ?? Guid.Empty);
                    vParams.Add("@DeviceId", upsertUserPunchCardInputModel.DeviceId);
                    vParams.Add("@AutoTimeSheet", upsertUserPunchCardInputModel.AutoTimeSheet);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpUpsertUserPunchCard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
                catch (SqlException sqlException)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertUserPunchCard", "TimeSheetRepository", sqlException.Message), sqlException);

                    SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertUserPunchCard);
                    return null;
                }
            }
        }

        public bool? ValidateUserLocation(UserLocationInputModel userLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                try
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Latitude", userLocationInputModel.Latitude);
                    vParams.Add("@Longitude", userLocationInputModel.Longitude);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<bool?>(StoredProcedureConstants.SpValidateUserLocation, vParams,
                        commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
                catch (SqlException sqlException)
                {
                    LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "ValidateUserLocation", "TimeSheetRepository", sqlException.Message), sqlException);

                    SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionValidateUserLocation);
                    return null;
                }
            }
        }

        public List<TimeSheetPermissionReasonOutputModel> GetAllPermissionReasons(GetPermissionReasonModel getPermissionReasonModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                List<TimeSheetPermissionReasonOutputModel> permissionReasons;
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@PermissionReasonId", getPermissionReasonModel.PermissionReasonId);
                    vParams.Add("@SearchText", getPermissionReasonModel.SearchText);
                    vParams.Add("@IsArchived ", getPermissionReasonModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    permissionReasons = vConn.Query<TimeSheetPermissionReasonOutputModel>(StoredProcedureConstants.SpGetPermissionReasons, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
                return permissionReasons;
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllPermissionReasons", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertCompany);
                return new List<TimeSheetPermissionReasonOutputModel>();
            }
        }

        public List<TimeFeedHistoryApiReturnModel> GetFeedTimeHistory(GetFeedTimeHistoryInputModel getFeedTimeHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", getFeedTimeHistoryInputModel.UserId);
                    vParams.Add("@DateFrom", getFeedTimeHistoryInputModel.DateFrom);
                    vParams.Add("@DateTo", getFeedTimeHistoryInputModel.DateTo);
                    vParams.Add("@SortDirection", getFeedTimeHistoryInputModel.SortDirection);
                    vParams.Add("@SortBy", getFeedTimeHistoryInputModel.SortBy);
                    vParams.Add("@PageNumber", getFeedTimeHistoryInputModel.PageNumber);
                    vParams.Add("@PageSize", getFeedTimeHistoryInputModel.PageSize);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeFeedHistoryApiReturnModel>(StoredProcedureConstants.SpGetFeedTimeHistory, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetFeedTimeHistory", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetFeedTimeHistory);
                return null;
            }
        }

        public string IsIpExisting(LoggedInContext loggedInContext)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@IpAddress", loggedInContext.RequestedHostAddress);
                vParams.Add("@CompanyId", loggedInContext.CompanyGuid);

                return vConn.Query<string>(StoredProcedureConstants.SpIsIpExisting, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public TimeSheetDbEntity GetTimeSheetDetails(Guid userId, DateTime date)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@Date", date);

                return vConn.Query<TimeSheetDbEntity>(StoredProcedureConstants.SpGetTimeSheet, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }
        public IEnumerable<TimeSheetSpEntity> GetTimeSheetDetailsForaDate(DateTime dateFrom, DateTime dateTo, Guid branchId, Guid teamLeadId, Guid? userId)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@DateFrom", dateFrom);
                vParams.Add("@DateTo", dateTo);
                vParams.Add("@BranchId", branchId);
                vParams.Add("@TeamLeadId", teamLeadId);
                vParams.Add("@UserId", userId);

                return vConn.Query<TimeSheetSpEntity>(StoredProcedureConstants.SpGetTimeSheetDetailsForaDate, vParams, commandType: CommandType.StoredProcedure)
                    .ToList();
            }
        }
        public TimesheetDisableorEnableEntity GetEnableorDisableTimesheetButtons(Guid userId, DateTimeOffset? buttonClickedDate)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@UserId", userId);
                vParams.Add("@ButtonClickedDate", buttonClickedDate);

                return vConn.Query<TimesheetDisableorEnableEntity>(StoredProcedureConstants.SpGetEnableOrDisableTimeSheetButtonsDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
            }
        }

        public List<StatusReportOfAnEmployeeSpEntity> GetStatusReportOfAnEmployee(LoggedInContext loggedInContext,
            DateTime? dateFrom, DateTime? dateTo)
        {
            using (IDbConnection vConn = OpenConnection())
            {
                DynamicParameters vParams = new DynamicParameters();
                vParams.Add("@UserId", loggedInContext.LoggedInUserId);
                vParams.Add("@DateFrom", dateFrom);
                vParams.Add("@DateTo", dateTo);

                return vConn.Query<StatusReportOfAnEmployeeSpEntity>(StoredProcedureConstants.SpGetStatusReportOfAnEmployee, vParams, commandType: CommandType.StoredProcedure).ToList();
            }
        }

        public LoggingComplainceOutputModel GetLoggingCompliance(LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);

                    return vConn.Query<LoggingComplainceOutputModel>(
                        StoredProcedureConstants.SpGetLoggingCompliance, vParams,
                        commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLoggingCompliance", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException,
                    ValidationMessages.ExceptionUpsertUserPunchCard);
                return new LoggingComplainceOutputModel();
            }

        }

        public List<TimeSheetSubmissionFrequencyOutputModel> GetTimeSheetSubmissionTypes(string serachText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@SearchText", serachText);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetSubmissionFrequencyOutputModel>(StoredProcedureConstants.SpGetTimeSheetSubmissionTypes, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetSubmissionTypes", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<TimeSheetSubmissionFrequencyOutputModel>();
            }
        }

        public List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetSubmissions(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@TimeSheetSubmissionId", timeSheetSubmissionSearchInputModel.TimeSheetSubmissionId);
                    vParams.Add("@IsIncludedPastData", timeSheetSubmissionSearchInputModel.IsIncludedPastData);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetSubmissionSearchOutputModel>(StoredProcedureConstants.SpGetTimeSheetSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetSubmissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<TimeSheetSubmissionSearchOutputModel>();
            }
        }

        public List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetInterval(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@@TimeSheetIntervalId", timeSheetSubmissionSearchInputModel.TimeSheetSubmissionId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetSubmissionSearchOutputModel>(StoredProcedureConstants.SpGetTimeSheetIntervals, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetSubmissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<TimeSheetSubmissionSearchOutputModel>();
            }
        }

        public Guid? UpsertTimeSheetInterval(TimeSheetSubmissionUpsertInputModel timeSheetIntervalUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeSheetFrequencyId", timeSheetIntervalUpsertInputModel.TimeSheetFrequencyId);
                    vParams.Add("@@TimeSheetIntervalId", timeSheetIntervalUpsertInputModel.TimeSheetIntervalId);
                    vParams.Add("@TimeStamp", timeSheetIntervalUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheetInterval, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetSubmission", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public List<LineManagerOutputModel> GetLineManagersWithTimeZones(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LineManagerOutputModel>(StoredProcedureConstants.SpGetLineManagersWithTimeZones, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetSubmission", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public List<TimeSheetJobDetails> GetTimeSheetJobDetails(JobInputModel jobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@IsForProbation", jobInputModel.IsForProbation);
                    return vConn.Query<TimeSheetJobDetails>(StoredProcedureConstants.SpGetTimeSheetJobDetails, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetSubmission", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public Guid? UpsertTimeSheetJobDetails(JobInputModel jobInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@JobId", jobInputModel.JobId);
                    vParams.Add("@IsArchive", jobInputModel.IsArchived);
                    vParams.Add("@IsForProbation", jobInputModel.IsForProbation);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheetJobDetails, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetSubmission", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public Guid? UpsertTimeSheetSubmission(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeSheetFrequencyId", timeSheetSubmissionUpsertInputModel.TimeSheetFrequencyId);
                    vParams.Add("@TimeSheetSubmissionId", timeSheetSubmissionUpsertInputModel.TimeSheetSubmissionId);
                    vParams.Add("@ActiveFrom", timeSheetSubmissionUpsertInputModel.ActiveFrom);
                    vParams.Add("@ActiveTo", timeSheetSubmissionUpsertInputModel.ActiveTo);
                    vParams.Add("@TimeStamp", timeSheetSubmissionUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheetSubmission, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetSubmission", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }
        public List<EmlpoyeeShiftWeekOutputModel> GetEmployeeShiftWeekDays(EmlpoyeeShiftWeekModel emlpoyeeShiftWeekModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", emlpoyeeShiftWeekModel.DateFrom);
                    vParams.Add("@StatusId", emlpoyeeShiftWeekModel.StatusId);
                    vParams.Add("@DateTo", emlpoyeeShiftWeekModel.DateTo);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmlpoyeeShiftWeekOutputModel>(StoredProcedureConstants.SpGetEmployeeShiftWeek, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeShiftWeekDays", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<EmlpoyeeShiftWeekOutputModel>();
            }
        }
        public List<StatusOutputModel> GetStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<StatusOutputModel>(StoredProcedureConstants.SpGetStatus, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetStatus", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<StatusOutputModel>();
            }
        }

        public List<TimeSheetApproveLineManagersOutputModel> GetTimeSheetApproveLineManagers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetApproveLineManagersOutputModel>(StoredProcedureConstants.SpGetTimeSheetApproveLineManagers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTimeSheetApproveLineManagers", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<TimeSheetApproveLineManagersOutputModel>();
            }
        }

        public List<TimeSheetApproveLineManagersOutputModel> GetApproverUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetApproveLineManagersOutputModel>(StoredProcedureConstants.SpGetApproverUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApproverUsers", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<TimeSheetApproveLineManagersOutputModel>();
            }
        }

        public List<EmployeeTimeSheetPunchCardDetailsOutputModel> GetEmployeeTimeSheetPunchCardDetails(DateTime? date, Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Date", date);
                    vParams.Add("@UserId", UserId);
                    return vConn.Query<EmployeeTimeSheetPunchCardDetailsOutputModel>(StoredProcedureConstants.SpGetEmplopyeeTimeSheetSubmissionPunchCard, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeTimeSheetPunchCardDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<EmployeeTimeSheetPunchCardDetailsOutputModel>();
            }
        }

        public List<EmployeeTimeSheetPunchCardDetailsOutputModel> GetEmployeeTimeSheetPunchCardDetails(string date, Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@Date", date);
                    vParams.Add("@UserId", UserId);
                    return vConn.Query<EmployeeTimeSheetPunchCardDetailsOutputModel>(StoredProcedureConstants.SpGetEmplopyeeTimeSheetSubmissionPunchCard, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeTimeSheetPunchCardDetails", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<EmployeeTimeSheetPunchCardDetailsOutputModel>();
            }
        }


        public Guid? UpsertEmployeeTimeSheetPunchCard(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeSheetPunchCardId", employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId);
                    vParams.Add("@StartTime", employeeTimeSheetPunchCardUpsertInputModel.StartTime);
                    vParams.Add("@EndTime", employeeTimeSheetPunchCardUpsertInputModel.EndTime);
                    vParams.Add("@Date", employeeTimeSheetPunchCardUpsertInputModel.Date);
                    vParams.Add("@StatusId", employeeTimeSheetPunchCardUpsertInputModel.StatusId);
                    vParams.Add("@ApproverId", employeeTimeSheetPunchCardUpsertInputModel.ApproverId);
                    vParams.Add("@Breakmins", employeeTimeSheetPunchCardUpsertInputModel.Breakmins);
                    vParams.Add("@Summary", employeeTimeSheetPunchCardUpsertInputModel.Summary);
                    vParams.Add("@IsOnLeave", employeeTimeSheetPunchCardUpsertInputModel.IsOnLeave);
                    vParams.Add("@UserId", employeeTimeSheetPunchCardUpsertInputModel.UserId);
                    vParams.Add("@TimeSheetSubmissionId", employeeTimeSheetPunchCardUpsertInputModel.TimeSheetSubmissionId);
                    vParams.Add("@TimeStamp", employeeTimeSheetPunchCardUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheetSubmissionPunchCard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertEmployeeTimeSheetPunchCard", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public Guid? UpsertApproverEditTimeSheet(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@TimeSheetPunchCardId", employeeTimeSheetPunchCardUpsertInputModel.TimeSheetPunchCardId);
                    vParams.Add("@StartTime", employeeTimeSheetPunchCardUpsertInputModel.StartTime);
                    vParams.Add("@EndTime", employeeTimeSheetPunchCardUpsertInputModel.EndTime);
                    vParams.Add("@Date", employeeTimeSheetPunchCardUpsertInputModel.Date);
                    vParams.Add("@StatusId", employeeTimeSheetPunchCardUpsertInputModel.StatusId);
                    vParams.Add("@ApproverId", employeeTimeSheetPunchCardUpsertInputModel.ApproverId);
                    vParams.Add("@Breakmins", employeeTimeSheetPunchCardUpsertInputModel.Breakmins);
                    vParams.Add("@Summary", employeeTimeSheetPunchCardUpsertInputModel.Summary);
                    vParams.Add("@UserId", employeeTimeSheetPunchCardUpsertInputModel.UserId);
                    vParams.Add("@IsOnLeave", employeeTimeSheetPunchCardUpsertInputModel.IsOnLeave);
                    vParams.Add("@TimeSheetSubmissionId", employeeTimeSheetPunchCardUpsertInputModel.TimeSheetSubmissionId);
                    vParams.Add("@TimeStamp", employeeTimeSheetPunchCardUpsertInputModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertApproverTimeSheet, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertApproverEditTimeSheet", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

        public bool? UpdateEmployeeTimeSheetPunchCard(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusId", timeSheetPunchCardUpDateInputModel.StatusId);
                    vParams.Add("@ApproverId", timeSheetPunchCardUpDateInputModel.ApproverId);

                    vParams.Add("@UserId", timeSheetPunchCardUpDateInputModel.UserId);
                    vParams.Add("@IsRejected", timeSheetPunchCardUpDateInputModel.IsRejected);
                    vParams.Add("@RejectedReason", timeSheetPunchCardUpDateInputModel.RejectedReason);
                    if (timeSheetPunchCardUpDateInputModel.ReportingUserId == null)
                    {
                        vParams.Add("@FromDate", timeSheetPunchCardUpDateInputModel.FromDate);
                        vParams.Add("@ToDate", timeSheetPunchCardUpDateInputModel.ToDate);
                        vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    }
                    else
                    {
                        vParams.Add("@FromDate", timeSheetPunchCardUpDateInputModel.AutoFromDate);
                        vParams.Add("@ToDate", timeSheetPunchCardUpDateInputModel.AutoToDate);
                        vParams.Add("@OperationsPerformedBy", timeSheetPunchCardUpDateInputModel.ReportingUserId);
                    }
                    return vConn.Query<bool?>(StoredProcedureConstants.SpUpdateTimeSheetPunchCard, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateEmployeeTimeSheetPunchCard", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return false;
            }
        }

        public List<ApproverTimeSheetSubmissionsGetOutputModel> GetApproverTimeSheetSubmissions(ApproverTimeSheetSubmissionsGetInputModel approverTimeSheetSubmissionsGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (var vConn = OpenConnection())
                {
                    var vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@DateFrom", approverTimeSheetSubmissionsGetInputModel.DateFrom);
                    vParams.Add("@DateTo", approverTimeSheetSubmissionsGetInputModel.DateTo);
                    vParams.Add("@UserId", approverTimeSheetSubmissionsGetInputModel.UserId);
                    return vConn.Query<ApproverTimeSheetSubmissionsGetOutputModel>(StoredProcedureConstants.SpGetApproverTimeSheetSubmissions, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetApproverTimeSheetSubmissions", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return new List<ApproverTimeSheetSubmissionsGetOutputModel>();
            }
        }

        public List<TimeSheetModel> GetAllLateUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetModel>(StoredProcedureConstants.SpGetAllLateUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllLateUsers", "TimeSheetRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return null;
            }
        }
        public List<TimeSheetModel> GetAllAbsenceUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", activityKpiSearchModel.Date);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<TimeSheetModel>(StoredProcedureConstants.SpGetAllAbsenceUsers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetAllAbsenceUsers", "TimeSheetRepository ", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetWeekdays);
                return null;
            }
        }

        public Guid? UpsertTimeSheetStatus(TimesheetStatusModel timesheetStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@StatusId", timesheetStatusModel.StatusId);
                    vParams.Add("@StatusColor", timesheetStatusModel.StatusColour);
                    vParams.Add("@StatusName", timesheetStatusModel.StatusName);
                    vParams.Add("@TimeStamp", timesheetStatusModel.TimeStamp, DbType.Binary);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertTimeSheetStatus, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertTimeSheetStatus", "TimeSheetRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionPeakHour);
                return null;
            }
        }

    }
}
