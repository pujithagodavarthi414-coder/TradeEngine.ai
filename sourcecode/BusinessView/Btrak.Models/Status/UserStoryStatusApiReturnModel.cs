using System;
using System.Text;

namespace Btrak.Models.Status
{
    public class UserStoryStatusApiReturnModel
    {
        public Guid? UserStoryStatusId { get; set; }
        public string UserStoryStatusName { get; set; }
        public string UserStoryStatusColor { get; set; }

        public bool IsArchived { get; set; }
        public DateTimeOffset? ArchivedDateTime { get; set; }

		public DateTimeOffset CreatedDateTime { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }
        public int LookUpKey { get; set; }
        public Guid? TaskStatusId { get; set; }
        public string TaskStatusName { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("UserStoryStatusId = " + UserStoryStatusId);
            stringBuilder.Append(", UserStoryStatusName = " + UserStoryStatusName);
            stringBuilder.Append(", UserStoryStatusColor = " + UserStoryStatusColor);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", ArchivedDateTime = " + ArchivedDateTime);
            return stringBuilder.ToString();
        }
    }
}
