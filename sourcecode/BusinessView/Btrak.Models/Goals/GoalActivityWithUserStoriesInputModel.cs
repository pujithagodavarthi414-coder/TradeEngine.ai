using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalActivityWithUserStoriesInputModel : SearchCriteriaInputModelBase
    {
        public GoalActivityWithUserStoriesInputModel() : base(InputTypeGuidConstants.GoalTagSearchInputCommandTypeGuid)
        {
        }
        public Guid? ProjectId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public bool? IsIncludeUserStoryView { get; set; }
        public bool? IsIncludeLogTime { get; set; }
        public Guid? UserId { get; set; }
        public bool? IsFromActivity { get; set; }
        public int? TotalCount { get; set; }
        public DateTime? DateFrom { get; set; }
        public DateTime? DateTo { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", IsIncludeUserStoryView = " + IsIncludeUserStoryView);
            stringBuilder.Append(", IsIncludeLogTime = " + IsIncludeLogTime);
            stringBuilder.Append(", UserId = " + UserId);
            return stringBuilder.ToString();
        }
    }
}
