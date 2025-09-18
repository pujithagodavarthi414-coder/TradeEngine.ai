using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterSolution
    {
        public Guid SolutionId { get; set; }
        public string SolutionName { get; set; }
        public decimal Budget { get; set; }
    }
}
