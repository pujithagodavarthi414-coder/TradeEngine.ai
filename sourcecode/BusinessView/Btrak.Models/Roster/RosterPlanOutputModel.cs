using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterPlanOutputModel
    {
        public Guid PlanId { get; set; }
        public Guid RequestId { get; set; }
        public Guid SolutionId { get; set; }
        public DateTime PlanDate { get; set; }
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public Guid? ShiftId { get; set; }
        public string ShiftName { get; set; }
        public Guid? PlannedEmployeeId { get; set; }
        public string PlannedEmployeeName { get; set; }
        public string PlannedEmployeeProfileImage { get; set; }
        public string EmployeeName { get; set; }
        public decimal? PlannedRate { get; set; }
        public string CurrencyCode { get; set; }
        public TimeSpan? PlannedFromTime { get; set; }
        public TimeSpan? PlannedToTime { get; set; }
        public Guid? ActualEmployeeId { get; set; }
        public string ActualEmployeeName { get; set; }
        public string ActualEmployeeProfileImage { get; set; }
        public decimal? ActualRate { get; set; }
        public TimeSpan? ActualFromTime { get; set; }
        public TimeSpan? ActualToTime { get; set; }
        public bool? IsArchived { get; set; }
        public int TotalCount { get; set; }
    }
}
