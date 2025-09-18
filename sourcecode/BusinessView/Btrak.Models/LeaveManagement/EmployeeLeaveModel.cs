using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveManagement
{
    public class EmployeeLeaveModel : InputModelBase
    {
        public EmployeeLeaveModel() : base(InputTypeGuidConstants.LeaveInputCommandTypeGuid)
        {
        }
        public Guid? Id { get; set; }
        public Guid? UserId { get; set; }
        public Guid? LeaveTypeId { get; set; }
        public Guid? LeaveSessionId { get; set; }
        public DateTime? Date { get; set; }
        public string ReasonForAbsent { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Id = " + Id);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", LeaveTypeId = " + LeaveTypeId);
            stringBuilder.Append(", LeaveSessionId = " + LeaveSessionId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", ReasonForAbsent = " + ReasonForAbsent);
            return stringBuilder.ToString();
        }
    }
}
