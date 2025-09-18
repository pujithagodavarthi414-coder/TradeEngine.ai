using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceGoalInputModel : InputModelBase
    {
        public InvoiceGoalInputModel() : base(InputTypeGuidConstants.InvoiceGoalInputCommandTypeGuid)
        {
        }
        public Guid? InvoiceGoalId { get; set; }
        public Guid? InvoiceId { get; set; }
        public Guid? GoalId { get; set; }
        public bool IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceGoalId" + InvoiceGoalId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("GoalId" + GoalId);
            stringBuilder.Append("IsArchived" + IsArchived);
            return stringBuilder.ToString();
        }
    }
}
