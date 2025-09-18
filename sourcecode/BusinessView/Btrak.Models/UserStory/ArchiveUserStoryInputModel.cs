using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class ArchiveUserStoryInputModel : InputModelBase
    {
        public ArchiveUserStoryInputModel() : base(InputTypeGuidConstants.ArchieveUserStoryInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryId { get; set; }
        public bool IsArchive { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? SprintId { get; set; }
        public Guid? UserStoryStatusId { get; set; }
        public bool? IsFromSprint { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryId = " + UserStoryId);
            stringBuilder.Append(", IsArchive = " + IsArchive);
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", TimeZone = " + TimeZone);
            return stringBuilder.ToString();
        }
    }
}
