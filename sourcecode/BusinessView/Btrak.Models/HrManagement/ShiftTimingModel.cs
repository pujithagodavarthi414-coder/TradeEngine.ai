using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.HrManagement
{
    public class ShiftTimingInputModel : InputModelBase
    {
        public ShiftTimingInputModel() : base(InputTypeGuidConstants.ShiftTimingInputCommandTypeGuid)
        {
        }
        public Guid? ShiftTimingId { get; set; }      
        public TimeSpan? StartTime { get; set; }
        public Guid? BranchId { get; set; }
        public bool IsDefault { get; set; }
        public string Shift { get; set; }
        public TimeSpan? EndTime { get; set; }
        public bool IsArchived { get; set; }
        public List<string> DaysOfWeek { get; set; }
        public List<ShiftWeekUpsertInputModel> ShiftWeekItems { get; set; }
        public List<ShiftExceptionUpsertInputModel> ShiftExceptionItems { get; set; }
        public string DaysOfWeekXML { get; set; }
        public string ShiftWeekJson { get; set; }
        public string ShiftExceptionJson { get; set; }
        public bool IsClone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ShiftTimingId = " + ShiftTimingId);
            stringBuilder.Append(", Timing = " + StartTime);
            stringBuilder.Append(", Shift = " + Shift);
            stringBuilder.Append(", EndTime = " + EndTime);
            return stringBuilder.ToString();
        }
    }
}
