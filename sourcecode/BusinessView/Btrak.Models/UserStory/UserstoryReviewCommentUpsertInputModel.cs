using System;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.UserStory
{
    public class UserStoryReviewCommentUpsertInputModel : InputModelBase
    {
        public UserStoryReviewCommentUpsertInputModel() : base(InputTypeGuidConstants.UserStoryReviewCommentUpsertInputCommandTypeGuid)
        {
        }

        public Guid? UserStoryReviewCommentId { get; set; }
        public Guid? UserStoryId  { get; set; }
        public string Comment  { get; set; }
        public Guid? UserStoryReviewStatusId  { get; set; }
		public bool IsArchived { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryReviewCommentId = " + UserStoryReviewCommentId);
            stringBuilder.Append(", UserStoryId = " + UserStoryId);
            stringBuilder.Append(", Comment = " + Comment);
            stringBuilder.Append(", UserStoryReviewStatusId = " + UserStoryReviewStatusId);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			return stringBuilder.ToString();
        }
    }
}
