using System;
using System.Collections.Generic;

namespace Btrak.Models.ActivityTracker
{
    public class UserDailyReminderModel
    {
        public Guid UserId { get; set; }
        public Guid CompanyId { get; set; }
        public string UserName { get; set; }
        public string UserEmail { get; set; }
        public string TotalDeskTime { get; set; }
        public string ProductiveTime { get; set; }
        public string TotalIdleTime { get; set; }
        public string StartTime { get; set; }
        public string FinishTime { get; set; }
        public string MostUsedApps { get; set; }
        public List<ApplicationReportModel> ApplicationReports { get; set; }
        public string LoggedWorkItems { get; set; }
        public List<ApplicationReportModel> UserStories { get; set; }
        public String Commits { get; set; }
        public String WorkItemsActivity { get; set; }
        public List<ApplicationReportModel> UserStoryActivities { get; set; }
    }

    public class ApplicationReportModel
    {
        public string ApplicationName { get; set; }
    }
    public class LoggedUserStories
    {
        public Guid UserStoryId { get; set; }
        public string UserStoryUniqueName { get; set; }
        public string UserStoryName { get; set; }
        public string SpentTime { get; set; }
        public string CurrentStatus { get; set; }
        public string StatusColor { get; set; }
    }
}
