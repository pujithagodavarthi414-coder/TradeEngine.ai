using System;
using System.Collections.Generic;

namespace Btrak.Models.ScheduledConfigurations
{
    public class ScheduledConfigurationsModel
    {
        public string TemplateName { get; set; }
        public Guid CompanyId { get; set; }
        public string SiteUrl { get; set; }
        public string UsersJson { get; set; }
        public List<UsersForEmailModel> UsersForReminders { get; set; }
    }

    public class UsersForEmailModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string Email { get; set; }
    }

    public class CompanySummaryReportModel
    {
        public string OfficeAnniversaryToday { get; set; }
        public string MarriageAnniversaryToday { get; set; }
        public string BirthdayToday { get; set; }
        public string PeopleLeaveToday { get; set; }
        public string PeopleLateToday { get; set; }
        public string PeopleLeaveYesterday { get; set; }
        public string PeopleDidnotFinishTrackerYesterday { get; set; }
        public string PeopleWorkMoreThanTrackerYesterday { get; set; }
    }

    public class CompanySummaryBaseModel
    {
        public string Name { get; set; }
        public Guid? UserId { get; set; }
        public string Email { get; set; }
        public string Result { get; set; }
    }
}
