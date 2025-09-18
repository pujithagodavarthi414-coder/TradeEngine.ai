using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UpdateMultipleUserStoriesGoalInputModel : InputModelBase
    {
        public UpdateMultipleUserStoriesGoalInputModel() : base(InputTypeGuidConstants.UpdateMultipleUserStoriesGoalInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public string UserStoryIds { get; set; }
        public string UserStoryIdsXml { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", UserStoryIds = " + UserStoryIds);
            stringBuilder.Append(", UserStoryIdsXml = " + UserStoryIdsXml);
            return stringBuilder.ToString();
        }
    }
}
