using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryReplanTypeOutputModel
    {
        public Guid? UserStoryReplanTypeId { get; set; }
        public string ReplanTypeName { get; set; }
        public DateTimeOffset? CreatedDateTime { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public DateTimeOffset? UpdatedDateTime { get; set; }
        public Guid? UpdatedByUserId { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool? IsArchived { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(" UserStoryReplanTypeId = " + UserStoryReplanTypeId);
            stringBuilder.Append(", ReplanTypeName = " + ReplanTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", UpdatedDateTime = " + UpdatedDateTime);
            stringBuilder.Append(", UpdatedByUserId = " + UpdatedByUserId);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
