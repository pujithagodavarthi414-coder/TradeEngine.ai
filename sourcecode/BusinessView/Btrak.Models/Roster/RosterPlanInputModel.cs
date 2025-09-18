using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterPlanInputModel
    {
        public Guid RequestId { get; set; }
        public RosterPlanBasicInput BasicInput { get; set; }
        public RosterSolution Solution { get; set; }
        public List<RosterPlan> Plans { get; set; }
    }

    public class RosterPlanBasicInput
    {
        public string RostName { get; set; }
        public DateTime? StartDate { get; set; }
        public DateTime? EndDate { get; set; }
        public Guid BranchId { get; set; }
        public decimal Breakmins { get; set; }
        public decimal Budget { get; set; }
        public bool IsApprove { get; set; }
        public bool IsSubmitted { get; set; }
        public bool IsTemplate { get; set; }
        public bool? IsArchived { get; set; }
        public int TimeZone { get; set; }
    }
}
