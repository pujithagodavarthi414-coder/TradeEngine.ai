using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Comments
{
    public class CommentUserInputModel : InputModelBase
    {
        public CommentUserInputModel() : base(InputTypeGuidConstants.CommentUserInputCommandTypeGuid)
        {
        }

        public Guid? CommentId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string Comment { get; set; }
        public Guid? ParentCommentId { get; set; }
        public string TimeZone { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CommentId = " + CommentId);
            stringBuilder.Append(", ReceiverId = " + ReceiverId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", ParentCommentId = " + ParentCommentId);
            return stringBuilder.ToString();
        }
    }
}