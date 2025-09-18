using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterPlanSolutionOutput
    {
        public RosterBasicDetails rosterBasicDetails { get; set; }
        public List<WorkingDays> workingDays { get; set; }
        public List<RosterShiftDetails> rosterShiftDetails { get; set; }
        public List<RosterDepartmentDetails> rosterDepartmentDetails { get; set; }
        public List<RosterAdhocRequirement> rosterAdhocRequirement { get; set; }
        public List<RosterPlanSolution> rosterPlanSolutions { get; set; }
    }
}
