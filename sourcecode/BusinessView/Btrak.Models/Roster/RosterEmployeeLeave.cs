using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterEmployeeLeave
    {
        public Guid EmployeeId { get; set; }
        public Guid UserId { get; set; }
        public DateTime LeaveDateFrom { get; set; }
        public DateTime LeaveDateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", LeaveDateFrom = " + LeaveDateFrom.ToShortDateString());
            stringBuilder.Append(", LeaveDateTo = " + LeaveDateTo.ToShortDateString());
            return stringBuilder.ToString();
        }
    }
}
