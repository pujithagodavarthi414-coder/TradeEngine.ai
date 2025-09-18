using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStorySubTypeApiReturnModel
    {
        public Guid UserStorySubTypeId { get; set; }
        public string UserStorySubTypeName { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public DateTimeOffset? InActiveDateTime { get; set; }
        public int TotalCount { get; set; }
        public byte[] TimeStamp { get; set; }
        public int? VersionNumber { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStorySubTypeId = " + UserStorySubTypeId);
            stringBuilder.Append(", UserStorySubTypeName = " + UserStorySubTypeName);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", InActiveDateTime = " + InActiveDateTime);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", VersionNumber = " + VersionNumber);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
