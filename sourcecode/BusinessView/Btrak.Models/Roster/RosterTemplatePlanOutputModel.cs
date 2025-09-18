using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterTemplatePlanOutputModel
    {
        public Guid PlanId { get; set; }
        public Guid RequestId { get; set; }
        public Guid SolutionId { get; set; }
        public DateTime PlanDate { get; set; }
        public Guid? DepartmentId { get; set; }
        public string DepartmentName { get; set; }
        public Guid? ShiftId { get; set; }
        public string ShiftName { get; set; }
        public Guid? EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public string EmployeeProfileImage { get; set; }
        public decimal? TotalRate { get; set; }
        public string CurrencyCode { get; set; }
        public TimeSpan? FromTime { get; set; }
        public TimeSpan? ToTime { get; set; }
        public bool? IsArchived { get; set; }
        public string AvailableStatus { get; set; }
        public int TotalCount { get; set; }
    }
}
