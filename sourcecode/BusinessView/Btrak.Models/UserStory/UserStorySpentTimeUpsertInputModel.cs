using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStorySpentTimeUpsertInputModel : InputModelBase
    {
        public UserStorySpentTimeUpsertInputModel() : base(InputTypeGuidConstants.UserStorySpentTimeUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStorySpentTimeId { get; set; }
        public Guid? UserStoryId { get; set; }
        public DateTimeOffset? DateFrom { get; set; }
        public DateTimeOffset? DateTo { get; set; }
        public Guid? LogTimeOptionId { get; set; }
        public string Comment { get; set; }
        public bool? IsArchived { get; set; }
        public bool? IsFromAudits { get; set; }
        public string RawSpentTime { get; set; }
        public string TimeZone { get; set; }
        public string RawRemainingTimeSetOrReducedBy { get; set; }
        public DateTime? StartTime { get; set; }
        public DateTime? EndTime { get; set; }
        public bool? BreakType { get; set; }

        public decimal? SpentTime { get; set; }
        public decimal? RemainingTimeSetOrReducedBy { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStorySpentTimeId = " + UserStorySpentTimeId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", DateFrom = " + DateFrom);
            stringBuilder.Append(", DateTo = " + DateTo);
            stringBuilder.Append(", LogTimeOptionId = " + LogTimeOptionId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", RawSpentTime = " + RawSpentTime);
            stringBuilder.Append(", RawRemainingTimeSetOrReducedBy = " + RawRemainingTimeSetOrReducedBy);
            stringBuilder.Append(", SpentTime = " + SpentTime);
            stringBuilder.Append(", BreakType = " + BreakType);
            stringBuilder.Append(", IsFromAudits = " + IsFromAudits);
            stringBuilder.Append(", RemainingTimeSetOrReducedBy = " + RemainingTimeSetOrReducedBy);
            return stringBuilder.ToString();
        }
    }
}
