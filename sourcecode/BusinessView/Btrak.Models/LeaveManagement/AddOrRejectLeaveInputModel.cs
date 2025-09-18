using System;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class ApproveOrRejectLeaveInputModel
    {
        public Guid? LeaveApplicationid { get; set; }
        public string LeaveReason { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsAdminApprove { get; set; }
        public byte[] TimeStamp { get; set; }
        
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveApplicationid = " + LeaveApplicationid);
            stringBuilder.Append("IsApproved = " + IsApproved);
            stringBuilder.Append("Reason = " + LeaveReason);
            return stringBuilder.ToString();
        }
    }
}
