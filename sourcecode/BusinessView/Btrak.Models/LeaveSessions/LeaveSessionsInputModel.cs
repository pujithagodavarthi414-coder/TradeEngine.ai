using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveSessions
{
    public class LeaveSessionsInputModel : InputModelBase
    {
        public LeaveSessionsInputModel() : base(InputTypeGuidConstants.LeaveSessionCommandTypeGuid)
        {
        }
        public Guid? LeaveSessionId { get; set; }
        public string LeaveSessionName { get; set; }
        public bool? IsArchived { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveSessionId = " + LeaveSessionId);
            stringBuilder.Append(", LeaveSessionName = " + LeaveSessionName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
