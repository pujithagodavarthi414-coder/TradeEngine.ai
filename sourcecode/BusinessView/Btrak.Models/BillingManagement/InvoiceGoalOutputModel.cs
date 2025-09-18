using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceGoalOutputModel
    {
        public Guid? InvoiceGoalId { get; set; }
        public Guid? InvoiceId { get; set; }
        public Guid? GoalId { get; set; }
        public Guid? GoalStatusId { get; set; }
        public string GoalName { get; set; }
        public string GoalStatusName { get; set; }
        public string GoalStatusColor { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceGoalId" + InvoiceGoalId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("GoalId" + GoalId);
            stringBuilder.Append("GoalStatusId" + GoalStatusId);
            stringBuilder.Append("GoalName" + GoalName);
            stringBuilder.Append("GoalStatusName" + GoalStatusName);
            stringBuilder.Append("GoalStatusColor" + GoalStatusColor);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
