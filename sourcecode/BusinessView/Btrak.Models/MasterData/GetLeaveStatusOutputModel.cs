using System;
using System.Text;

namespace Btrak.Models.MasterData
{
    public class GetLeaveStatusOutputModel
    {
        public Guid? LeaveStatusId { get; set; }
        public string LeaveStatusName { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? TotalCount { get; set; }

        public string LeaveStatusColour { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" LeaveStatusId = " + LeaveStatusId);
            stringBuilder.Append(", LeaveStatusName = " + LeaveStatusName);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}