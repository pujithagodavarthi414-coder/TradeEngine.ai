using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class ShiftOrDepartment
    {
        public RosterShiftDetails shiftDetails { get; set; }
        public RosterDepartmentDetails departmentDetails { get; set; }
        public RosterAdhocRequirement adHocDetails { get; set; }
        public DateTime reqDate { get; set; }
        public int maxCount { get; set; }
        public int maxHours { get; set; }
    }
}
