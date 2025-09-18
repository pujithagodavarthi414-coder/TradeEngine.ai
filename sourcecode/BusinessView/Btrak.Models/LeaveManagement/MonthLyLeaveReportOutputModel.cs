
using System.Collections.Generic;

namespace Btrak.Models.LeaveManagement
{
    public class MonthLyLeaveReportOutputModel
    {
        public string Month { get; set; }
        public float? NumberOfLeaves { get; set; }
    }

    public class MontlyLeaveOutputModel
    {
        public List<MonthLyLeaveReportOutputModel> MonthlyReports { get; set; }
        public byte[] Pdf { get; set; }
        public string DownloadLink { get; set; }
    }
}
