using System;
using System.Text;

namespace Btrak.Models.HrManagement
{
    public class ShiftTimingsSearchOutputModel
    {
        public Guid? ShiftTimingId { get; set;}
        public Guid? BranchId { get; set; }
        public bool IsDefault { get; set; }
        public dynamic StartTime { get; set; }
        public string Shift { get; set; }
        public string TimeZoneName { get; set; }
        public dynamic EndTime { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append("Timing = " + StartTime);
            stringBuilder.Append("Shift = " + Shift);
            stringBuilder.Append("EndTime = " + EndTime);
            stringBuilder.Append("CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append("CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}