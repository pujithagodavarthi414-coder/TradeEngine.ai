using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.MasterData
{
    public class TimeSheetPunchCardUpDateInputModel
    {
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public Guid? ApproverId { get; set; }
        public Guid? StatusId { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsRejected { get; set; }
        public string RejectedReason { get; set; }
        public string TimesheetTitle { get; set; }
        public Guid? ReportingUserId { get; set; }

        public string AutoFromDate { get; set; }
        public string AutoToDate { get; set; }
    }
}
