using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.LeaveManagement
{
    public class DeleteLeaveModel : InputModelBase
    {
        public DeleteLeaveModel() : base(InputTypeGuidConstants.DeleteLeaveModelInputCommandTypeGuid)
        {
        }

        public Guid? LeaveId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("LeaveId = " + LeaveId);
            return stringBuilder.ToString();
        }
    }
}
