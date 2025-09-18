using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterPlanSolution
    {
        public Guid RequestId { get; set; }
        public RosterSolution Solution { get; set; }
        public List<RosterPlan> Plans { get; set; }
    }
}
