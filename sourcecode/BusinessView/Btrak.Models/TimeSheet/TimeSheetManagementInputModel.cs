using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.TimeSheet
{
    public class TimeSheetManagementInputModel : InputModelBase
    {
        public TimeSheetManagementInputModel() : base(InputTypeGuidConstants.TimeSheetInputCommandTypeGuid)
        {
        }
        public Guid ButtonTypeId { get; set; }
        public Guid? TimeSheetId { get; set; }
        public Guid UserId { get; set; }
        public DateTime? Date { get; set; }
        public DateTime? InTime { get; set; }
        public DateTime? LunchBreakStartTime { get; set; }
        public DateTime? LunchBreakEndTime { get; set; }
        public DateTime? OutTime { get; set; }
        public Guid LoggedUserId { get; set; }
        public bool IsFeed { get; set; }
        public DateTime? BreakInTime {get;set;}
        public DateTime? BreakOutTime { get; set; }
        public string TimeZone { get; set; }
        public string TimeZoneOffset { get; set; }
        public bool? IsNextDay { get; set; }

        public DateTimeOffset? InTimeOffset { get; set; }
        public DateTimeOffset? LunchBreakStartTimeOffset { get; set; }
        public DateTimeOffset? LunchBreakEndTimeOffset { get; set; }
        public DateTimeOffset? OutTimeOffset { get; set; }
        public DateTimeOffset? BreakInTimeOffset { get; set; }
        public DateTimeOffset? BreakOutTimeOffset { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", ButtonTypeId = " + ButtonTypeId);
            stringBuilder.Append(", TimeSheetId = " + TimeSheetId);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", InTime = " + InTime);
            stringBuilder.Append(", LunchBreakStartTime = " + LunchBreakStartTime);
            stringBuilder.Append(", LunchBreakEndTime = " + LunchBreakEndTime);
            stringBuilder.Append(", OutTime = " + OutTime);
            stringBuilder.Append(", LoggedUserId = " + LoggedUserId);
            stringBuilder.Append(", IsFeed = " + IsFeed);
            stringBuilder.Append(", BreakInTime = " + BreakInTime);
            stringBuilder.Append(", BreakOutTime = " + BreakOutTime);
            stringBuilder.Append(", IsNextDay = " + IsNextDay);
            return stringBuilder.ToString();
        }
    }
}
