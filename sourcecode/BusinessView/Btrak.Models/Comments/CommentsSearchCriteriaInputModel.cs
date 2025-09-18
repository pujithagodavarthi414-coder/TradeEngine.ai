using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Comments
{
    public class CommentsSearchCriteriaInputModel: SearchCriteriaInputModelBase
    {
        public CommentsSearchCriteriaInputModel() : base(InputTypeGuidConstants.CommentSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? CommentId { get; set; }
        public Guid? CommentedByUserId { get; set; }
        public Guid? ReceiverId { get; set; }
        public bool? AdminFlag { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CommentId = " + CommentId);
            stringBuilder.Append(", ReceiverId = " + ReceiverId);
            stringBuilder.Append(", AdminFlag = " + AdminFlag);
            stringBuilder.Append(", CommentedByUserId = " + CommentedByUserId);
            return stringBuilder.ToString();
        }
    }
}