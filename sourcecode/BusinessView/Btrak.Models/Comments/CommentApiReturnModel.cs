using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Comments
{
    public class CommentApiReturnModel
    {
        public Guid? CommentId
        {
            get;
            set;
        }

        public Guid? CommentedOnObjectId
        {
            get;
            set;
        }

        public UserMiniModel CommentedByUser
        {
            get;
            set;
        }

        public string Comment
        {
            get;
            set;
        }

        public Guid? ParentCommentId
        {
            get;
            set;
        }

        public DateTimeOffset OriginallyCommentedDateTime
        {
            get;
            set;
        }

        public DateTimeOffset CommentUpdatedDateTime
        {
            get;
            set;
        }

        public List<CommentApiReturnModel> ChildComments
        {
            get;
            set;
        }

        public Guid? ReceiverId { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("CommentId = " + CommentId);
            stringBuilder.Append(", CommentedOnObjectId = " + CommentedOnObjectId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", ParentCommentId = " + ParentCommentId);
            stringBuilder.Append(", OriginallyCommentedDateTime = " + OriginallyCommentedDateTime);
            stringBuilder.Append(", CommentUpdatedDateTime = " + CommentUpdatedDateTime);
            return stringBuilder.ToString();
        }
    }
}