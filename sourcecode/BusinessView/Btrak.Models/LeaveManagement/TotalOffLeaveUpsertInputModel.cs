using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.LeaveManagement
{
    public class TotalOffLeaveUpsertInputModel : InputModelBase
    {
        public TotalOffLeaveUpsertInputModel() : base(InputTypeGuidConstants.LeaveApplicabiltyInputCommandTypeGuid)
        {
        }

        public Guid? TotalOffLeaveId { get; set; }
        public int? TotalHoursPerMonth { get; set; }
        public int? NoOfLeavesToBeAdded { get; set; }
        public Guid? LeaveApplicabilityId { get; set; }
        public float? MinProductivity { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", TotalOffLeaveId = " + TotalOffLeaveId);
            stringBuilder.Append(", TotalHoursPerMonth = " + TotalHoursPerMonth);
            stringBuilder.Append(", NoOfLeavesToBeAdded = " + NoOfLeavesToBeAdded);
            stringBuilder.Append(", LeaveApplicabilityId = " + LeaveApplicabilityId);
            stringBuilder.Append(", MinProductivity = " + MinProductivity);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }

    }
}
