using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class ShiftWiseEmployeeRosterInputModel
    {
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public Guid[] Shifts { get; set; }
        public string ShiftString { get; set; }
        public bool IncludeWeekends { get; set; }
        public bool Includeholidays { get; set; }
        public Guid BranchId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", StartDate = " + StartDate.ToShortDateString());
            stringBuilder.Append(", EndDate = " + EndDate.ToShortDateString());
            stringBuilder.Append(", Shifts = " + Shifts.ToString());
            stringBuilder.Append(", IncludeWeekends = " + IncludeWeekends);
            stringBuilder.Append(", Includeholidays = " + Includeholidays);
            stringBuilder.Append(", BranchId = " + BranchId);
            return stringBuilder.ToString();
        }
    }
}
