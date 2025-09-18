using System;

namespace Btrak.Dapper.Dal.SpModels
{
    public class CommentsSpEntity
    {
        public Guid Id { get; set; }
        public Guid? ParentCommentId { get; set; }
        public Guid? ReceiverCommentId { get; set; }
        public string Comment { get; set; }
        public string FirstName { get; set; }
        public string SurName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public Guid CreatedByUserId { get; set; }
        public string ProfileImage { get; set; }
    }
}
