using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.Roster
{
    public class EmployeeTimesheetRate
    {

        public DateTime LogDate { get; set; }
        public string UserName { get; set; }
        public Guid UserId { get; set; }
        public Guid EmployeeId { get; set; }
        public string EmployeeName { get; set; }
        public int TotalMinutesWorked { get; set; }
        public int Breakmins { get; set; }
        public decimal ActualRate { get; set; }
        public string Email { get; set; }
        public string CurrencyCode { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LogDate = " + LogDate.ToShortDateString());
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", EmployeeName = " + EmployeeName);
            stringBuilder.Append(", TotalMinutesWorked = " + TotalMinutesWorked);
            stringBuilder.Append(", Breakmins = " + Breakmins);
            stringBuilder.Append(", ActualRate = " + ActualRate);
            stringBuilder.Append(", Email = " + Email);
            return stringBuilder.ToString();
        }
    }
}
