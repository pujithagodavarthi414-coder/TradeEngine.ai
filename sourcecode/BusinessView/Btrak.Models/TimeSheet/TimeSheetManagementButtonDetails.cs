using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementButtonDetails : InputModelBase
    {
        public TimeSheetManagementButtonDetails() : base(InputTypeGuidConstants.TimeSheetButtonsInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public DateTimeOffset? StartTime { get; set; }
        public DateTimeOffset? LunchStartTime { get; set; }
        public DateTimeOffset? LunchEndTime { get; set; }
        public DateTimeOffset? BreakInTime { get; set; }
        public DateTimeOffset? BreakOutTime { get; set; }
        public DateTimeOffset? FinishTime { get; set; }
        public bool IsStart { get; set; }
        public bool IsLunchStart { get; set; }
        public bool IsLunchEnd { get; set; }
        public bool IsBreakIn { get; set; }
        public bool IsBreakOut { get; set; }
        public bool IsFinish { get; set; }
        public float SpentTime { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", StartTime = " + StartTime);
            stringBuilder.Append(", LunchStartTime = " + LunchStartTime);
            stringBuilder.Append(", LunchEndTime = " + LunchEndTime);
            stringBuilder.Append(", BreakInTime = " + BreakInTime);
            stringBuilder.Append(", BreakOutTime = " + BreakOutTime);
            stringBuilder.Append(", FinishTime = " + FinishTime);
            stringBuilder.Append(", IsStart = " + IsStart);
            stringBuilder.Append(", IsLunchStart = " + IsLunchStart);
            stringBuilder.Append(", IsLunchEnd = " + IsLunchEnd);
            stringBuilder.Append(", IsBreakIn = " + IsBreakIn);
            stringBuilder.Append(", IsBreakOut = " + IsBreakOut);
            stringBuilder.Append(", IsFinish = " + IsFinish);
            stringBuilder.Append(", SpentTime = " + SpentTime);
            return stringBuilder.ToString();
        }
    }
}
