using System;
using System.Text;

namespace Btrak.Models.LeaveSessions
{
    public class LeaveSessionsOutputModel
    {
        public Guid? LeaveSessionId { get; set; }
        public string LeaveSessionName { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTime? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public Guid? CompanyId { get; set; }
        public byte[] TimeStamp { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", LeaveSessionId = " + LeaveSessionId);
            stringBuilder.Append(", LeaveSessionName = " + LeaveSessionName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", CompanyId = " + CompanyId);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
