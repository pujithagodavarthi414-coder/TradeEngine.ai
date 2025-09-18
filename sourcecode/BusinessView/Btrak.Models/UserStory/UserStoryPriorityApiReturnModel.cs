using System;
using System.Text;

namespace Btrak.Models.UserStory
{
    public class UserStoryPriorityApiReturnModel
    {
        public Guid? UserStoryPriorityId { get; set; }
        public string PriorityName { get; set; }

		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryPriorityId = " + UserStoryPriorityId);
            stringBuilder.Append(", PriorityName = " + PriorityName);
			stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			stringBuilder.Append(", TimeStamp = " + TimeStamp);
			stringBuilder.Append(", TotalCount = " + TotalCount);
			return stringBuilder.ToString();
        }
    }
}
