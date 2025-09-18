using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class GetBugsCountBasedOnUserStoryInputModel : InputModelBase
    {
        public GetBugsCountBasedOnUserStoryInputModel() : base(InputTypeGuidConstants.UserStoryInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public Guid? TestCaseId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", TestCaseId = " + TestCaseId);
            stringBuilder.Append(", GoalId = " + GoalId);
            return stringBuilder.ToString();
        }
    }
}
