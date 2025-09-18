using System;
using System.Text;

namespace Btrak.Models.Status
{
    public class BugPriorityApiReturnModel
    {
        public Guid? BugPriorityId { get; set; }
        public string PriorityName { get; set; }
        public string Color { get; set; }
        public string Description { get; set; }
        public string Icon { get; set; }
        public int Order { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("BugPriorityId = " + BugPriorityId);
            stringBuilder.Append(", PriorityName = " + PriorityName);
            stringBuilder.Append(", Color = " + Color);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", Icon = " + Icon);
            stringBuilder.Append(", Order = " + Order);
            stringBuilder.Append(", IsArchived = " + IsArchived);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
