using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Goals
{
    public class ArchiveGoalInputModel : InputModelBase
    {
        public ArchiveGoalInputModel() : base(InputTypeGuidConstants.GoalArchiveInputCommandTypeGuid)
        {
        }

        public Guid? GoalId { get; set; }
        public bool Archive { get; set; }
        public string TimeZone { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalId = " + GoalId);
            stringBuilder.Append(", Archive = " + Archive);
            return stringBuilder.ToString();
        }
    }
}
