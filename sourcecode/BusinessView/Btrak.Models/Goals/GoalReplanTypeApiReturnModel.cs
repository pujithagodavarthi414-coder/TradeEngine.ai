using System;
using System.Text;

namespace Btrak.Models.Goals
{
    public class GoalReplanTypeApiReturnModel
    {
        public Guid? GoalReplanTypeId { get; set; }
        public string GoalReplanTypeName { get; set; }

        public int TotalCount { get; set; }
        public bool IsArchived { get; set; }
        public DateTimeOffset CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("GoalReplanTypeId = " + GoalReplanTypeId);
            stringBuilder.Append(", GoalReplanTypeName = " + GoalReplanTypeName);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }
}
