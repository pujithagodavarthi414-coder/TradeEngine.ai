using Btrak.Models;
using Btrak.Models.ActivityTracker;
using Btrak.Models.ActTracker;
using BTrak.Common;
using System;
using System.Collections.Generic;

namespace Btrak.Services.ActivityTracker
{
    public interface IActivityTrackerService
    {
        string UpsertActivityTrackerStatus(string deviceId, List<ValidationMessage> validationMessages, Guid? loggedInUser, string userIpAddress, string timeZone);
        List<TimeUsageOfApplicationApiOutputModel> GetTotalTimeUsageOfApplicationsByUsers(TimeUsageOfApplicationSearchInputModel timeUsageOfApplicationSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<GetTimeUsageDrillDownOutputModel> GetTimeUsageDrillDown(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int GetTotalTeamMembers(TimeUsageDrillDownSearchInputModel timeUsageDrillDownSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeSearchOutputModel> GetEmployees(EmployeeSearchInputModel employeeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeWebAppUsageTimeOutputModel> GetWebAppUsageTime(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void GetChatActivityTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages, bool? isSingle = null);
        ActivityTrackerInformationOutputModel GetActivityTrackerInformation(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TrackedInformationOfUserStoryOutputModel GetTrackedInformationOfUserStory(TrackedInformationOfUserStorySearchInputModel trackedInformationOfUserStorySearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeTrackerOutputModel> GetAppUsageCompleteReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeTrackerUserstoryOutputModel> GetAppUsageUserStoryReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<EmployeeTrackerTimesheetOutputModel> GetAppUsageTimesheetReport(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivityTrackerUsageOutputModel> GetUserActivityTrackerUsageReport(ActivityTrackerUsageInputModel activityTrackerUsageInputModel, LoggedInContext loggedInContext,
            List<ValidationMessage> validationMessages);
        ActivityTrackerTrackingStateOutputModel UpsertUserActivityToken(ActivityTrackerTokenInputModel activityTrackerTokenInputModel, Guid? loggedInUserId, List<ValidationMessage> validationMessages);
        List<EmployeeTrackerOutputModel> GetIdleAndInactiveTimeForEmployee(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void ActivityTrackerProduceData(string sqlquery);
        bool UpserActivityTrackerUsage(InsertUserActivityInputModel insertUserActivityInputModel, List<ValidationMessage> validationMessages, LoggedInContext loggedInUser);
        List<ActivityTrackerMode> GetActivityTrackerModes(List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        bool UpsertActivityTrackerModeConfig(ActivityTrackerModeConfigurationInputModel config, List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        List<ActivityTrackerModeConfigurationOutputModel> GetActivityTrackerModeConfig(List<ValidationMessage> validationMessages, LoggedInContext loggedInContext);
        List<ActivityTrackerDesktopsModel> GetTrackerDesktops(ActivityTrackerDesktopsModel activityTrackerDesktopsModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        TrackerModeOutputModel GetModeType(TrackerModeInputModel input, List<ValidationMessage> validationMessages);
        List<TrackerUserTimelineModel> GetUserTrackerTimeline(EmployeeTrackerSearchInputModel employeeTrackerSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivityReportOutputModel> GetActivityReport(ActivityReportInputModel activityReportInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TeamActivityOutputModel> GetTeamActivity(TeamActivityInputModel teamActivityInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        void SendConfiguredEmailReports();
        List<ApplicationCategoryModel> GetApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertApplicationCategory(ApplicationCategoryModel applicationCategoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<AvailabilityCalendarOutputModel> GetAvailabilityCalendar(AvailabilityCalendarInputModel availabilityCalendarInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        CompanyStatus GetCompanyStatus(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

        string GetProductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetUnproductiveTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetIdleTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetNeutralTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetDeskTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetUserStartTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string GetUserFinishTime(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int GetLateEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int GetPresentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        int GetAbsentEmployees(ActivityKpiSearchModel activityKpiSearchModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);

    }
}