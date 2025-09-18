using System;
using System.Text;

namespace Btrak.Models.Status
{
    public class GoalStatusApiReturnModel
    {
        public Guid? GoalStatusId { get; set; }
        public string GoalStatusName { get; set; }

		public DateTimeOffset CreatedDateTime { get; set; }
		public bool IsArchived { get; set; }
		public byte[] TimeStamp { get; set; }
		public int TotalCount { get; set; }

		public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalStatusId = " + GoalStatusId);
            stringBuilder.Append(", GoalStatusName = " + GoalStatusName);
			stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
			stringBuilder.Append(", IsArchived = " + IsArchived);
			stringBuilder.Append(", TimeStamp = " + TimeStamp);
			stringBuilder.Append(", TotalCount = " + TotalCount);
			return stringBuilder.ToString();
        }
    }
}
