using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class RosterCompletionReport
    {
        public string RosterName { get; set; }
        public DateTime RequiredFromDate { get; set; }
        public DateTime RequiredToDate { get; set; }
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public Guid UserId { get; set; }
        public string UserName { get; set; }
        public decimal ActualRate { get; set; }
        public decimal PlannedRate { get; set; }
        public int ActualEmployeeId { get; set; }
        public int PlannedEmployeeId { get; set; }
    }
}
