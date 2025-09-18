using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveStatusSetHistorySearchReturnModel
    {
        public Guid? LeaveHistoryId { get; set; }
		public Guid?  LeaveApplicationId { get; set; }
        public Guid?  LeaveStatusId { get; set; }
        public DateTime? LeaveDateFrom { get; set; }
        public DateTime? LeaveDateTo { get; set; }
        public Guid?  LeaveStuatusSetByUserId { get; set; }
        public DateTime?  CreatedDateTime { get; set; }
        public DateTime? EndDateTime { get; set; }
        public string  CreatedDate { get; set; }
        public Guid?  CreatedByUserId { get; set; }
        public string  Reason { get; set; }
        public string Description { get; set; }
        public string StatusSetUser { get; set; }
        public string LeaveAppliedUser { get; set; }
        public bool? OnBehalf { get; set; }
        public string ProfileImage { get; set; }
        public string ApproveList { get; set; }
        public string LeaveStatusName { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string LeaveDateFromFormat { get; set; }
        public string LeaveDateToFormat { get; set; }
        public string LeaveStatusColour { get; set; }
    }
}
