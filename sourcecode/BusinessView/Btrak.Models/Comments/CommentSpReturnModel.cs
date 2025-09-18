using System;

namespace Btrak.Models.Comments
{
    public class CommentSpReturnModel
    {
        public Guid? CommentId { get; set; }
        public Guid? CommentedByUserId { get; set; }
        public Guid? ReceiverId { get; set; }
        public string Comment { get; set; }
        public Guid? ParentCommentId { get; set; }
        public bool AdminFlag { get; set; }

        public string ProfileImage { get; set; }

        public string CommentedByUserProfileImage { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public DateTimeOffset UpdatedDateTime { get; set; }
        public string CommentedByUserFullName { get; set; }
    }
}