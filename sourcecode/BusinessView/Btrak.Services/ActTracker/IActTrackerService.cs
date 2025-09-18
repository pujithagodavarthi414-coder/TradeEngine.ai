using System;
using System.Collections.Generic;
using BTrak.Common;
using Btrak.Models;
using Btrak.Models.ActTracker;
using Btrak.Models.ActivityTracker;

namespace Btrak.Services.ActTracker
{
    public interface IActTrackerService 
    {
        List<Guid?> UpsertActTrackerRoleConfiguration(ActTrackerRoleConfigurationUpsertInputModel actTrackerRoleConfigurationUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerAppUrlOutputModel> GetActTrackerAppUrlType(LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<Guid?> UpsertActTrackerScreenSHotFrequency(ActTrackerScreenShotFrequencyUpsertInputModel actTrackerScreenShotFrequencyUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDropDown(LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<Guid?> UpsertActTrackerRolePermission(ActTrackerRolePermissionUpsertInputModel actTrackerRolePermissionUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerRoleDropOutputModel> GetActTrackerRoleDeleteDropDown(LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<Guid?> UpsertActTrackerAppUrls(ActTrackerAppUrlsUpsertInputModel actTrackerAppUrlsUpsertInputModel,LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerAppUrlApiOutputModel> GetActTrackerAppUrls(ActTrackerAppUrlsSearchInputModel actTrackerAppUrlsSearchInputModel, LoggedInContext loggedInContext,List<ValidationMessage> validationMessages);
        List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsage(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerAppReportUsageSearchOutputModel> GetActTrackerAppReportUsageForChart(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ActTrackerScreenshotFrequencySearchOutputModel GetActTrackerUserScreenshotFrequency(ActTrackerScreenshotFrequencySearchInputModel actTrackerScreenshotFrequencySearchInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser);
        List<ActTrackerScreenshotsApiOutputModel> GetActTrackerUserActivityScreenshots(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActTrackerScreenshotsApiOutputModel> GetActTrackerUserActivityScreenshotsBasedOnId(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        PermissionRoles GetActTrackerRolePermissionRoles(ActTrackerRolePermissionRolesInputModel actTrackerRolePermissionRolesInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ActTrackerScreenShotFrequency GetActTrackerScreenShotFrequencyRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ActTrackerRoleConfiguration GetActTrackerRoleConfigurationRoles(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        string MultipleDeleteScreenShot(ActTrackerScreenshotDeleteInputModel actTrackerScreenshotDeleteInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        bool? GetActTrackerRecorder(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ActivityTrackerConfigModel GetActTrackerRecorderForTracker(ActivityTrackerInsertStatusInputModel activityTrackerInsertStatusInputModel, List<ValidationMessage> validationMessages, Guid? loggedInUser);
        byte[] UpsertActivityTrackerConfigurationState(ActivityTrackerConfigurationStateInputModel activityTrackerConfigurationStateInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivityTrackerHistoryOutputModel> GetActivityTrackerHistory(ActivityTrackerHistoryModel activityTrackerHistoryModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        Guid? UpsertActivityTrackerUserConfiguration(ActivityTrackerUserConfigurationInputModel activityTrackerUserConfigurationInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        ActivityTrackerConfigurationStateOutputModel GetActivityTrackerConfigurationState(LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<ActivityTrackerUserStatusOutputModel> GetActTrackerUserStatus(EmployeeWebAppUsageTimeSearchInputModel employeeWebAppUsageTimeSearchInputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<MostProductiveUsersOutputModel> GetMostProductiveUsers(MostProductiveUsersInputModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
        List<TrackingUserModel> GetTrackingUsers(TrackingUserModel inputModel, LoggedInContext loggedInContext, List<ValidationMessage> validationMessages);
    }
}
