using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class EmployeeShiftInputModel : InputModelBase
    {
        public EmployeeShiftInputModel() : base(InputTypeGuidConstants.EmployeeShiftInputCommandTypeGuid)
        {
        }
        public Guid? EmployeeShiftId { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public Guid? EmployeeId { get; set; }
        public DateTime? ActiveFrom { get; set; }
        public DateTime? ActiveTo { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EmployeeShiftId = " + EmployeeShiftId);
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", EmployeeId = " + EmployeeId);
            stringBuilder.Append(", ActiveFrom = " + ActiveFrom);
            stringBuilder.Append(", ActiveTo = " + ActiveTo);
            return stringBuilder.ToString();
        }
    }
}
