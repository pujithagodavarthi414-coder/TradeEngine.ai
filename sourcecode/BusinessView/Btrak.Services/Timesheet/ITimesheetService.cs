using Btrak.Models;
using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using Btrak.Dapper.Dal.SpModels;
using Btrak.Models.TimeSheet;
using Btrak.Models.MasterData;
using Btrak.Models.TestRail;
using Btrak.Models.ActivityTracker;

namespace Btrak.Services.TimeSheet
{
    public interface ITimeSheetService
    {
        Guid? UpsertTimeSheet(TimeSheetManagementInputModel timeSheetModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TimeSheetManagementButtonDetails GetEnableOrDisableTimeSheetButtonDetails(Guid? userId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetManagementApiOutputModel> GetTimeSheetDetails(TimeSheetManagementSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PdfGenerationOutputModel GetTimeSheetDetailsUploadTemplate(TimeSheetManagementSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertUserBreakDetails(UserBreakDetailsInputModel userBreakModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<UserBreakDetailsOutputModel> GetUserBreakDetails(GetUserBreakDetailsInputModel timeSheetManagementSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetManagementApiOutputModel> GetTimeSheetHistoryDetails(TimeSheetManagementSearchInputModel getTimeSheetDetails, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetManagementPermissionOutputModel> GetTimeSheetPermissions(TimeSheetManagementPermissionInputModel timeSheetPermissionsInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetPermissionReasonOutputModel> GetAllPermissionReasons(GetPermissionReasonModel getPermissionReasonModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeSheetPermissionReasons(TimeSheetPermissionReasonInputModel timeSheetPermissionReasonInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? UpsertUserPunchCard(UpsertUserPunchCardInputModel upsertUserPunchCardInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? ValidateUserLocation(UserLocationInputModel userLocationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeFeedHistoryApiReturnModel> GetFeedTimeHistory(GetFeedTimeHistoryInputModel getFeedTimeHistoryInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        /* Old Code */
        DateTime? ConvertFromUtCtoLocal(DateTime? time, Guid? timeZoneId,string defaultTimeZone =null);
        TimesheetDisableorEnableApiModel GetEnableorDisableTimesheetButtons(LoggedInContext loggedInContext);
        IList<AuditJsonModel> GetTimesheetHistoryDetails(Guid userId, DateTime dateFrom, DateTime dateTo);
        string GetProcessedMessage(LoggedInContext loggedInContext, DateTime? dateFrom, DateTime? dateTo);
        List<PermissionRegisterReturnOutputModel> SearchPermissionRegister(PermissionRegisterSearchInputModel permissionRegisterSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Task PushMessageToSlack(LoggedInContext loggedInContext, string url);
        Task PushMessageToUserWebHook(LoggedInContext loggedInContext, string url);
        LoggingComplainceOutputModel GetLoggingCompliance(LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        List<TimeSheetSubmissionFrequencyOutputModel> GetTimeSheetSubmissionTypes(string searchText, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetSubmissions(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetSubmissionSearchOutputModel> GetTimeSheetInterval(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeSheetSubmission(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeSheetStatus(TimesheetStatusModel timesheetStatusModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertTimeSheetInterval(TimeSheetSubmissionUpsertInputModel timeSheetSubmissionUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetSubmissionModel> GetEmployeeShiftWeekTimeSheets(TimeSheetSubmissionSearchInputModel timeSheetSubmissionSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<StatusOutputModel> GetStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        EmployeeTimeSheetPunchCardDetailsOutputModel GetEmployeeTimeSheetPunchCardDetails(string date, Guid? UserId, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertEmployeeTimeSheetPunchCard(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertApproverEditTimeSheet(EmployeeTimeSheetPunchCardUpsertInputModel employeeTimeSheetPunchCardUpsertInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? UpdateEmployeeTimeSheetPunchCard(TimeSheetPunchCardUpDateInputModel timeSheetPunchCardUpDateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetSubmissionModel> GetApproverTimeSheetSubmissions(ApproverTimeSheetSubmissionsGetInputModel approverTimeSheetSubmissionsGetInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetApproveLineManagersOutputModel> GetTimeSheetApproveLineManagers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetApproveLineManagersOutputModel> GetApproverUsers(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        List<TimeSheetModel> GetAllLateUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TimeSheetModel> GetAllAbsenceUsers(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
