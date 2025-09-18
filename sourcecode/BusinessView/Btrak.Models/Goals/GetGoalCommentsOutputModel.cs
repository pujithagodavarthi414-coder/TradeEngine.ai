using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GetGoalCommentsOutputModel
    {
        public Guid GoalCommentId { get; set; }
        public Guid GoalId { get; set; }
        public string Comments { get; set; }
        public string UserName { get; set; }
        public Guid UserId { get; set; }
        public string ProfileImage { get; set; }
        public byte[] TimeStamp { get; set; }
        public DateTime CommentedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", GoalId = " + GoalId);
            stringBuilder.Append(", GoalCommentId = " + GoalCommentId);
            stringBuilder.Append(", Comments = " + Comments);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", CreatedByUserId = " + UserId);
            stringBuilder.Append(", ProfileImage = " + ProfileImage);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", CommentedDateTime = " + CommentedDateTime);
            return stringBuilder.ToString();
        }
    }
}