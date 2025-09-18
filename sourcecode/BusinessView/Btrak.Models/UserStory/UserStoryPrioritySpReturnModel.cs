using System;

namespace Btrak.Models.UserStory
{
    public class UserStoryPrioritySpReturnModel
    {
        public Guid? UserStoryPriorityId { get; set; }
        public string PriorityName { get; set; }

		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }
	}
}
