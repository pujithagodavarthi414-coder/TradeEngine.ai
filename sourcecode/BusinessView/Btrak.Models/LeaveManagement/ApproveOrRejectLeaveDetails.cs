using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class ApproveOrRejectLeaveDetails
    {
        public string ApproveOrRejectedBy { get; set; }
        public string LeaveStatus { get; set; }
        public string Reason { get; set; }
        public Guid? AppliedUserId { get; set; }
        public Guid? LeaveStatusId { get; set; }
        public Guid? LeaveApplicationId { get; set; }
        public string DateFrom { get; set; }
        public string DateTo { get; set; }
    }


}
