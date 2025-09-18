using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterEmployeeUnavailability
    {
        public Guid EmployeeId { get; set; }
        public Guid UserId { get; set; }
        public DateTime PlanDate { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", PlanDate = " + PlanDate.ToShortDateString());
            return stringBuilder.ToString();
        }
    }
}
