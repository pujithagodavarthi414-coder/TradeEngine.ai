using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.PayRoll
{
    public class EmployeePFReportOutputModel
    {
        public string UANNumber { get; set; }
        public string Employeename { get; set; }
        public string ProfileImage { get; set; }
        public Guid UserId { get; set; }
        public bool IsArchived { get; set; }
        public float GrossWages { get; set; }
        public float EPFWages { get; set; }
        public float EPSWages { get; set; }
        public float EDLIWages { get; set; }
        public float EPFContribution { get; set; }
        public float EPSContribution { get; set; }
        public float EPFANDPSDifference { get; set; }
        public float NCPDays { get; set; }
        public int RefundOfAdvance { get; set; }
        public int TotalRecordsCount { get; set; }
    }
}
