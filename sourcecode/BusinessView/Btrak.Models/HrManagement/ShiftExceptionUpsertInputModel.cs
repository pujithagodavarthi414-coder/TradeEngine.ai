using System;
using System.Text;
using System.Xml.Serialization;

namespace Btrak.Models.HrManagement
{
    public class ShiftExceptionUpsertInputModel
    {
        public Guid? ShiftExceptionId { get; set; }
        public DateTime? ExceptionDate { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [XmlIgnore]
        public TimeSpan? StartTime { get; set; }
        [XmlIgnore]
        public TimeSpan? EndTime { get; set; }
        [XmlIgnore]
        public TimeSpan? DeadLine { get; set; }
        public int? AllowedBreakTime { get; set; }
        public bool? IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public string StartTimestring { get; set; }
        public string EndTimestring { get; set; }
        public string DeadLinestring { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", ShiftExceptionId = " + ShiftExceptionId);
            stringBuilder.Append(", StratTiming = " + StartTime);
            stringBuilder.Append(", ExceptionDate = " + ExceptionDate);
            stringBuilder.Append(", DeadLine = " + DeadLine);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
