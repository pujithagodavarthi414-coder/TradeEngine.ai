using System;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveOverViewReportGetOutputModel
    {
        public Guid? BranchId { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public double? Approved { get; set; } 
        public double? WaitingForApproval { get; set; } 
        public double? Rejected { get; set; } 
        public double? Balance { get; set; }
        public byte[] Pdf { get; set; }
        public string DownloadLink { get; set; }
        public string ApprovalChain { get; set; }
    }
}
