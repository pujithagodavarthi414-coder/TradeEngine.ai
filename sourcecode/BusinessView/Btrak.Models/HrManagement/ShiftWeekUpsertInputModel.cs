using System;
using System.Text;
using System.Xml.Serialization;

namespace Btrak.Models.HrManagement
{
    public class ShiftWeekUpsertInputModel
    {
        public Guid? ShiftWeekId { get; set; }
        public string DayOfWeek { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        [XmlIgnore]
        public TimeSpan? StartTime { get; set; }
        [XmlIgnore]
        public TimeSpan? EndTime { get; set; }
        [XmlIgnore]
        public TimeSpan? DeadLine { get; set; }
        public int? AllowedBreakTime { get; set; }
        public byte[] TimeStamp { get; set; }
        public Guid? ShiftTimingId { get; set; }
        public bool? IsArchived { get; set; }
        public bool IsPaidBreak { get; set; }
        public string StartTimestring { get; set; }
        public string EndTimestring { get; set; }
        public string DeadLinestring { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", ShiftWeekId = " + ShiftWeekId);
            stringBuilder.Append(", StratTiming = " + StartTime);
            stringBuilder.Append(", DaysOfWeek = " + DayOfWeek);
            stringBuilder.Append(", DeadLine = " + DeadLine);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsPaidBreak = " + IsPaidBreak);
            return stringBuilder.ToString();
        }
    }
}