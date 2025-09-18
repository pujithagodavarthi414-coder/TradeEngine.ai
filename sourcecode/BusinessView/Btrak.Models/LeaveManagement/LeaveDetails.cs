using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Btrak.Models.LeaveManagement
{
    public class LeaveDetails
    {
        public Guid? LeaveFrequencyId { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }
        public string LeaveTypeName { get; set; }
        public float? LeavesTaken { get; set; }
        public float? ActualBalance { get; set; }
        public float? EffectiveBalance { get; set; }
        public float? CarryForwardLeaves { get; set; }
        public float? IsCarryForward { get; set; }
        public bool? IsPaid { get; set; }
        public Guid? LeaveTypeId { get; set; }
    }
}
