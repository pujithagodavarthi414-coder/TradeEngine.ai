using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceTasksInputModel : InputModelBase
    {
        public InvoiceTasksInputModel() : base(InputTypeGuidConstants.InvoiceTasksInputCommandTypeGuid)
        {
        }

        public Guid? InvoiceTaskId { get; set; }
        public Guid? InvoiceId { get; set; }
        public string TaskName { get; set; }
        public string TaskDescription { get; set; }
        public decimal Rate { get; set; }
        public decimal Hours { get; set; }
        public decimal Total { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public int Order { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceTaskId" + InvoiceTaskId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("TaskName" + TaskName);
            stringBuilder.Append("TaskDescription" + TaskDescription);
            stringBuilder.Append("Rate" + Rate);
            stringBuilder.Append("Hours" + Hours);
            stringBuilder.Append("Total" + Total);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("Order" + Order);
            return base.ToString();
        }
    }
}
