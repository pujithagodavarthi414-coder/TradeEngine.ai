using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalActivityApiReturnOutputModel
    {
        public DateTimeOffset? Date { get; set; }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public Guid? UserProfile { get; set; }
        public Guid? UserStoryId { get; set; }
        public string UserStoryName { get; set; }
        public Guid? UserStoryHistoryId { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string History { get; set; }
        public string Description { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", Date = " + Date);
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserId = " + UserName);
            stringBuilder.Append(", UserId = " + UserProfile);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", UserStoryName = " + UserStoryName);
            stringBuilder.Append(", UserStoryHistoryId = " + UserStoryHistoryId);
            stringBuilder.Append(", OldValue = " + OldValue);
            stringBuilder.Append(", NewValue = " + NewValue);
            stringBuilder.Append(", History = " + History);
            stringBuilder.Append(",Description =" + Description);
            return stringBuilder.ToString();
        }
    }
}
