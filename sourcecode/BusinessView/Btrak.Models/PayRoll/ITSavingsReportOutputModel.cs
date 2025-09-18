using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class ITSavingsReportOutputModel
    {
        public string EmployeeNumber { get; set; }
        public string EmployeeName { get; set; }
        public float RentPaid { get; set; }
        public string LandlordPANNumber { get; set; }
        public string JoinedDate { get; set; }
        public string PANNumber { get; set; }
        public string DateOfLeaving { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
