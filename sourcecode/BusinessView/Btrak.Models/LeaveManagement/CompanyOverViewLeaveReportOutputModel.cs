using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class CompanyOverViewLeaveReportOutputModel
    {
        public Guid? BranchId { get; set; }
        public int? NumberOfMembers { get; set; }
        public string CompanyName { get; set; }
        public double? NumberOfWorkingDays { get; set; }
        public double? NumberOfAbsenceDays { get; set; }
        public double? AbsencePercentage { get; set; }   
        public byte[] ReportInPdf { get; set; }
        public string DownloadLink { get; set; }
    }
}
