using Btrak.Dapper.Dal.Helpers;
using Btrak.Models.HrDashboard;
using BTrak.Common;
using Dapper;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using Btrak.Models;

namespace Btrak.Dapper.Dal.Partial
{
    public class HrDashboardRepository : BaseRepository
    {
        public List<EmployeeAttendanceSpOutputModel> GetEmployeeAttendanceByDay(EmployeeAttendanceSearchInputModel employeeAttendanceSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", employeeAttendanceSearchInputModel.Date);
                    vParams.Add("@BranchId", employeeAttendanceSearchInputModel.BranchId);
                    vParams.Add("@TeamLeadId", employeeAttendanceSearchInputModel.TeamLeadId);
                    vParams.Add("@DepartmentId",employeeAttendanceSearchInputModel.DepartmentId);
                    vParams.Add("@DesignationId", employeeAttendanceSearchInputModel.DesignationId);
                    vParams.Add("@SearchText", employeeAttendanceSearchInputModel.SearchText);
                    vParams.Add("@EntityId", employeeAttendanceSearchInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeAttendanceSpOutputModel>(StoredProcedureConstants.SpGetEmployeeAttendanceByDay, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeAttendanceByDay", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeAttendanceByDay);
                return new List<EmployeeAttendanceSpOutputModel>();
            }
        }

        public List<EmployeeWorkingDaysOutputModel> GetEmployeeWorkingDays(EmployeeWorkingDaysSearchCriteriaInputModel employeeWorkingDaysSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Date", employeeWorkingDaysSearchCriteriaInputModel.Date);
                    vParams.Add("@BranchId", employeeWorkingDaysSearchCriteriaInputModel.BranchId);
                    vParams.Add("@TeamLeadId", employeeWorkingDaysSearchCriteriaInputModel.TeamLeadId);
                    vParams.Add("@DepartmentId", employeeWorkingDaysSearchCriteriaInputModel.DepartmentId);
                    vParams.Add("@DesignationId", employeeWorkingDaysSearchCriteriaInputModel.DesignationId);
                    vParams.Add("@PageNumber", employeeWorkingDaysSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", employeeWorkingDaysSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SearchText", employeeWorkingDaysSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", employeeWorkingDaysSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", employeeWorkingDaysSearchCriteriaInputModel.SortDirection);
                    vParams.Add("@EntityId", employeeWorkingDaysSearchCriteriaInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeWorkingDaysOutputModel>(StoredProcedureConstants.SpGetWorkingDays, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeWorkingDays", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeWorkingDays);
                return new List<EmployeeWorkingDaysOutputModel>();
            }
        }

        public List<EmployeeSpentTimeOutputModel> GetEmployeeSpentTime(Guid? userId, string fromDate, string toDate, Guid? entityId,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@UserId", userId);
                    vParams.Add("@FromDate", fromDate);
                    vParams.Add("@ToDate", toDate);
                    vParams.Add("@entityId", entityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<EmployeeSpentTimeOutputModel>(StoredProcedureConstants.SpGetSpentTime, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeeSpentTime", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeeSpentTime);
                return new List<EmployeeSpentTimeOutputModel>();
            }
        }

        public List<LateEmployeeOutputModel> GetLateEmployee(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Type", hrDashboardSearchCriteriaInputModel.Type);
                    vParams.Add("@Date", hrDashboardSearchCriteriaInputModel.Date);
                    vParams.Add("@DateFrom", hrDashboardSearchCriteriaInputModel.DateFrom);
                    vParams.Add("@DateTo", hrDashboardSearchCriteriaInputModel.DateTo);
                    vParams.Add("@IsMorningLateEmployee", hrDashboardSearchCriteriaInputModel.IsMorningLateEmployee);
                    vParams.Add("@IsLunchBreakLongTake", hrDashboardSearchCriteriaInputModel.IsLunchBreakLongTake);
                    vParams.Add("@IsMorningAndAfterNoonLate", hrDashboardSearchCriteriaInputModel.IsMorningAndAfterNoonLate);
                    vParams.Add("@IsMoreSpentTime", hrDashboardSearchCriteriaInputModel.IsMoreSpentTime);
                    /* Here Order is for getting the top / bottom spent time employees */
                    vParams.Add("@Order", hrDashboardSearchCriteriaInputModel.Order);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", hrDashboardSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", hrDashboardSearchCriteriaInputModel.PageSize);
                    vParams.Add("@SearchText", hrDashboardSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", hrDashboardSearchCriteriaInputModel.SortBy);
                    vParams.Add("@EntityId", hrDashboardSearchCriteriaInputModel.EntityId);
                    vParams.Add("@SortDirection", hrDashboardSearchCriteriaInputModel.SortDirection);
                    return vConn.Query<LateEmployeeOutputModel>(StoredProcedureConstants.SpGetEmployeeLateTimingDetails, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLateEmployee", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLateEmployee);
                return new List<LateEmployeeOutputModel>();
            }
        }

        public List<EmployeePresenceApiOutputModel> GetEmployeePresence(HrDashboardSearchCriteriaInputModel hrDashboardSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@BranchId", hrDashboardSearchCriteriaInputModel.BranchId);
                    vParams.Add("@WorkingStatus", hrDashboardSearchCriteriaInputModel.WorkingStatus);
                    vParams.Add("@TeamLeadId", hrDashboardSearchCriteriaInputModel.TeamLeadId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", hrDashboardSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", hrDashboardSearchCriteriaInputModel.PageSize);
                    vParams.Add("@searchText", hrDashboardSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", hrDashboardSearchCriteriaInputModel.SortBy);
                    vParams.Add("@SortDirection", hrDashboardSearchCriteriaInputModel.SortDirection);
                    return vConn.Query<EmployeePresenceApiOutputModel>(StoredProcedureConstants.SpGetEmployeePresence, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetEmployeePresence", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetEmployeePresence);
                return new List<EmployeePresenceApiOutputModel>();
            }
        }

        public List<LeavesReportOutputModel> GetLeavesReport(LeavesReportSearchCriteriaInputModel leavesReportSearchCriteriaInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@Year", leavesReportSearchCriteriaInputModel.Year);
                    vParams.Add("@BranchId", leavesReportSearchCriteriaInputModel.BranchId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    vParams.Add("@PageNumber", leavesReportSearchCriteriaInputModel.PageNumber);
                    vParams.Add("@PageSize", leavesReportSearchCriteriaInputModel.PageSize);
                    vParams.Add("@searchText", leavesReportSearchCriteriaInputModel.SearchText);
                    vParams.Add("@SortBy", leavesReportSearchCriteriaInputModel.SortBy);
                    vParams.Add("@EntityId", leavesReportSearchCriteriaInputModel.EntityId);
                    vParams.Add("@SortDirection", leavesReportSearchCriteriaInputModel.SortDirection);
                    return vConn.Query<LeavesReportOutputModel>(StoredProcedureConstants.SpGetLeavesReport, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLeavesReport", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLeavesReport);
                return new List<LeavesReportOutputModel>();
            }
        }

        public List<LateEmployeeCountSpOutputModel> GetLateEmployeeCount(LateEmployeeCountSearchInputModel lateEmployeeCountSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@DateFrom", lateEmployeeCountSearchInputModel.DateFrom);
                    vParams.Add("@DateTo", lateEmployeeCountSearchInputModel.DateTo);
                    vParams.Add("@BranchId", lateEmployeeCountSearchInputModel.BranchId);
                    vParams.Add("@TeamLeadId", lateEmployeeCountSearchInputModel.TeamLeadId);
                    vParams.Add("@DepartmentId", lateEmployeeCountSearchInputModel.DepartmentId);
                    vParams.Add("@DesignationId", lateEmployeeCountSearchInputModel.DesignationId);
                    vParams.Add("@EntityId", lateEmployeeCountSearchInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LateEmployeeCountSpOutputModel>(StoredProcedureConstants.SpGetLateEmployeeCount, vParams, commandType: CommandType.StoredProcedure)
                        .ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLateEmployeeCount", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLateEmployeeCount);
                return new List<LateEmployeeCountSpOutputModel>();
            }
        }

        public List<LineManagersOutputModel> GetLineManagers(string searchText,bool? isReportToOnly, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SearchText", searchText);
                    vParams.Add("@IsReportToOnly", isReportToOnly);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<LineManagersOutputModel>(StoredProcedureConstants.SpGetLineManagers, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetLineManagers", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetLineManagers);
                return new List<LineManagersOutputModel>();
            }
        }

        public List<DailyLogTimeReportOutputModel> GetDailyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SelectedDate", logTimeReportSearchInputModel.SelectedDate);
                    vParams.Add("@BranchId", logTimeReportSearchInputModel.BranchId);
                    vParams.Add("@SearchText", logTimeReportSearchInputModel.SearchText);
                    vParams.Add("@LineManagerId", logTimeReportSearchInputModel.LineManagerId);
                    vParams.Add("@EntityId", logTimeReportSearchInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<DailyLogTimeReportOutputModel>(StoredProcedureConstants.SpGetDailyLogReport, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetDailyLogTimeReport", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetDailyLogTimeReport);
                return new List<DailyLogTimeReportOutputModel>();
            }
        }

        public List<MonthlyLogTimeReportSpOutputModel> GetMonthlyLogTimeReport(LogTimeReportSearchInputModel logTimeReportSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SelectedDate", logTimeReportSearchInputModel.SelectedDate);
                    vParams.Add("@BranchId", logTimeReportSearchInputModel.BranchId);
                    vParams.Add("@LineManagerId", logTimeReportSearchInputModel.LineManagerId);
                    vParams.Add("@SearchText", logTimeReportSearchInputModel.SearchText);
                    vParams.Add("@SortBy", logTimeReportSearchInputModel.SortBy);
                    vParams.Add("@SortDirection", logTimeReportSearchInputModel.SortDirection);
                    vParams.Add("@PageNumber", logTimeReportSearchInputModel.PageNumber);
                    vParams.Add("@PageSize", logTimeReportSearchInputModel.PageSize);
                    vParams.Add("@EntityId", logTimeReportSearchInputModel.EntityId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<MonthlyLogTimeReportSpOutputModel>(StoredProcedureConstants.SpMonthlyLogReports, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetMonthlyLogTimeReport", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMonthlyLogTimeReport);
                return new List<MonthlyLogTimeReportSpOutputModel>();
            }
        }

        public List<OrganizationchartModel> GetOrganizationChartDetails(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<OrganizationchartModel>(StoredProcedureConstants.SpGetEmployeesForOrgChart, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetOrganizationChartDetails", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetMonthlyLogTimeReport);
                return new List<OrganizationchartModel>();
            }
        }

        public Guid? UpsertSignature(SignatureModel signatureModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@SignatureId", signatureModel.SignatureId);
                    vParams.Add("@ReferenceId", signatureModel.ReferenceId);
                    vParams.Add("@InviteeId", signatureModel.InviteeId);
                    vParams.Add("@SignatureUrl", signatureModel.SignatureUrl);
                    vParams.Add("@IsArchived", signatureModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertSignature, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertSignature", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertSignature);
                return null;
            }
        }

        public List<SignatureModel> GetSignature(SignatureModel signatureModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", signatureModel.ReferenceId);
                    vParams.Add("@InviteeId", signatureModel.InviteeId);
                    vParams.Add("@IsArchived", signatureModel.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<SignatureModel>(StoredProcedureConstants.SpGetSignature, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetSignature", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetSignature);
                return new List<SignatureModel>();
            }
        }

        public Guid? UpsertReminder(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReminderId", reminder.ReminderId);
                    vParams.Add("@RemindOn", reminder.RemindOn);
                    vParams.Add("@OfUser", reminder.OfUser);
                    vParams.Add("@NotificationType", reminder.NotificationType);
                    vParams.Add("@ReferenceTypeId", reminder.ReferenceTypeId);
                    vParams.Add("@ReferenceId", reminder.ReferenceId);
                    vParams.Add("@AdditionalInfo", reminder.AdditionalInfo);
                    vParams.Add("@IsArchived", reminder.IsArchived);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<Guid?>(StoredProcedureConstants.SpUpsertReminder, vParams, commandType: CommandType.StoredProcedure).FirstOrDefault();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpsertReminder", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionUpsertReminder);
                return null;
            }
        }

        public List<ReminderModel> GetRemindersBasedOnReference(ReminderModel reminder, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReferenceId", reminder.ReferenceId);
                    vParams.Add("@OperationsPerformedBy", loggedInContext.LoggedInUserId);
                    return vConn.Query<ReminderModel>(StoredProcedureConstants.SpGetRemindersBasedOnReference, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetRemindersBasedOnReference", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(validationMessages, sqlException, ValidationMessages.ExceptionGetReminder);
                return new List<ReminderModel>();
            }
        }

        public List<ReminderDetailsModel> GetTodaysReminders()
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    return vConn.Query<ReminderDetailsModel>(StoredProcedureConstants.SpGetTodaysReminders, vParams, commandType: CommandType.StoredProcedure).ToList();
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "GetTodaysReminders", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(null, sqlException, ValidationMessages.ExceptionGetReminder);
                return new List<ReminderDetailsModel>();
            }
        }

        public void UpdateReminderStatus(ReminderDetailsModel reminder)
        {
            try
            {
                using (IDbConnection vConn = OpenConnection())
                {
                    DynamicParameters vParams = new DynamicParameters();
                    vParams.Add("@ReminderId", reminder.ReminderId);
                    vParams.Add("@Status", reminder.Status);
                    vConn.Query<Guid?>(StoredProcedureConstants.SpUpdateReminderStatus, vParams, commandType: CommandType.StoredProcedure);
                }
            }
            catch (SqlException sqlException)
            {
                LoggingManager.Error(string.Format(LoggingManagerAppConstants.LoggingManagerErrorValue, "UpdateReminderStatus", "HrDashboardRepository", sqlException.Message), sqlException);

                SqlValidationHelper.ValidateGetAllSqlExceptions(null, sqlException, ValidationMessages.ExceptionUpsertReminder);
            }
        }

        //public IEnumerable<HrDashboardLateEmployeeCountSpEntity> GetLateEmployeeCountDetails(DateTime dateFrom, DateTime dateTo, Guid teamLeadId, Guid branchId, Guid companyId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@DateFrom", dateFrom);
        //        vParams.Add("@DateTo", dateTo);
        //        vParams.Add("@TeamLeadId", teamLeadId);
        //        vParams.Add("@BranchId", branchId);
        //        vParams.Add("@CompanyId", companyId);

        //        return vConn.Query<HrDashboardLateEmployeeCountSpEntity>("USP_GetLateEmployeeCount", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardEachAuditSpEntity> GetEachAuditDetails(Guid userId, Guid featureId, DateTime dateFrom, DateTime dateTo, Guid companyId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@FeatureId", featureId);
        //        vParams.Add("@DateFrom", dateFrom);
        //        vParams.Add("@DateTo", dateTo);
        //        vParams.Add("@CompanyId", companyId);

        //        return vConn.Query<HrDashboardEachAuditSpEntity>("USP_GetEachAudit", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardMoreTimeViewedAuditSpEntity> GetMoreTimeViewedAuditDetails(Guid userId, Guid featureId, DateTime dateFrom, DateTime dateTo, Guid companyId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@FeatureId", featureId);
        //        vParams.Add("@DateFrom", dateFrom);
        //        vParams.Add("@DateTo", dateTo);
        //        vParams.Add("@CompanyId", companyId);

        //        return vConn.Query<HrDashboardMoreTimeViewedAuditSpEntity>("USP_GetMoreTimeViewedAudit", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardEmployeeMtdAttendanceSpEntity> GetEmployeeMtdAttendenceDetails(Guid userId, DateTime enteredmonth, Guid companyId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@Date", enteredmonth);
        //        vParams.Add("@CompanyId", companyId);

        //        return vConn.Query<HrDashboardEmployeeMtdAttendanceSpEntity>("USP_GetEmployeeMTDInformation", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardEmployeeYtdAttendanceSpEntity> GetEmployeeYtdAttendenceDetails(Guid userId, string text, int year)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@Type", text);
        //        vParams.Add("@Year", year);

        //        return vConn.Query<HrDashboardEmployeeYtdAttendanceSpEntity>("USP_GetEmployeeYTDInformation", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardDailyTasksSpEntity> GetDailyTasksDetails(DateTime taskdate, Guid userId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@Date", taskdate);
        //        vParams.Add("@UserId", userId);

        //        return vConn.Query<HrDashboardDailyTasksSpEntity>("USP_GetDailyTasks", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardProcessDashboardOverallStatusSpEntity> GetProcessDashboardOverallStatusDetails(DateTime statusDate, Guid userId, string statusType)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@Date", statusDate);
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@StatusType",statusType);

        //        return vConn.Query<HrDashboardProcessDashboardOverallStatusSpEntity>("USP_GetProcessDashboardStatusForIndividual", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<HrDashboardProcessDashboardOverallStatusWithSpEntity> GetProcessDashboardOverallStatusWithGoalsDetails(DateTime statusDate, Guid userId, string statusType)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@Date", statusDate);
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@StatusType", statusType);

        //        return vConn.Query<HrDashboardProcessDashboardOverallStatusWithSpEntity>("USP_GetProcessDashboardOverallStatusWithGoals", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}


        //public IEnumerable<HrDashboardTaskSpentTimeSpEntity> GetTaskSpentTimeReportDetails(Guid projectId, string dateDesc, DateTime dateFrom, DateTime dateTo, int days, string userDesc, Guid userId, string hoursDesc, int hoursFrom, int hoursTo)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@ProjectId", projectId);
        //        vParams.Add("@DateDesc", dateDesc);
        //        vParams.Add("@DateFrom", dateFrom);
        //        vParams.Add("@DateTo", dateTo);
        //        vParams.Add("@Days", days);
        //        vParams.Add("@UserDesc", userDesc);
        //        vParams.Add("@UserId", userId);
        //        vParams.Add("@HoursDesc", hoursDesc);
        //        vParams.Add("@HoursFrom", hoursFrom);
        //        vParams.Add("@HoursTo", hoursTo);
        //        return vConn.Query<HrDashboardTaskSpentTimeSpEntity>("USP_GetEmployeeUserStorySpentTimeReport", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}

        //public IEnumerable<LogTimeReportSpEntity> GetGoalLogReport(Guid loginUser, Guid companyId)
        //{
        //    using (var vConn = OpenConnection())
        //    {
        //        var vParams = new DynamicParameters();
        //        vParams.Add("@LoginUser", loginUser);
        //        vParams.Add("@CompanyId", companyId);

        //        return vConn.Query<LogTimeReportSpEntity>("USP_GetGoalLogReport", vParams, commandType: CommandType.StoredProcedure)
        //            .ToList();
        //    }
        //}
    }
}
