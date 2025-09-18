using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class StatusReportOfAnEmployeeSpEntity
    {
        public Guid EmployeeId { get; set; }
        public Guid UserId { get; set; }
        public string EmployeeName{ get; set; }
        public string TaskName { get; set; }
        public string GoalName { get; set; }
        public string StatusColor { get; set; }
        public string StatusText { get; set; }
        public string OrginalEstimate { get; set; }
        public string SpentSoFar { get; set; }
        public string SpentToday { get; set; }
        public string TodaySpentTimeInHours { get; set; }
        public string Remaining { get; set; }
        public string TotalHoursLogged { get; set; }
        public string TotalSpentHoursInOffice { get; set; }
        public string RemainingHoursToBeLogged { get; set; }
        public string OverAllStatus { get; set; }
        public string TaskType { get; set; }
        public string Transition { get; set; }
        public string WorkDescription { get; set; }
    }
}
