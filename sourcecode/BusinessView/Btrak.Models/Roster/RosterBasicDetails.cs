using System;

namespace Btrak.Models.Roster
{
    public class RosterBasicDetails
    {
        public string RostName { get; set; }
        public DateTime RostStartDate { get; set; }
        public DateTime RostEndDate { get; set; }
        public int RostBudget { get; set; }
        public Guid BranchId { get; set; }
        public int RostEmployeeRequired { get; set; }
        public bool IncludeHolidays { get; set; }
        public bool IncludeWeekends { get; set; }
        public int RostMaxWorkDays { get; set; }
        public int RostMaxWorkHours { get; set; }
        public string RosterShiftDetails { get; set; }
        public string RosterDepartmentDetails { get; set; }
        public string RosterAdhocRequirement { get; set; }
        public Guid? RostEmployeeId { get; set; }
    }
}
