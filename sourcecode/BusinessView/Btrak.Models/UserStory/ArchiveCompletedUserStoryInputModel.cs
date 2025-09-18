using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class ArchiveCompletedUserStoryInputModel : InputModelBase
    {
        public ArchiveCompletedUserStoryInputModel() : base(InputTypeGuidConstants.ArchieveCompletedUserStoriesInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public bool? IsFromSprint { get; set; }
        public Guid? SprintId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            return stringBuilder.ToString();
        }
    }
}
