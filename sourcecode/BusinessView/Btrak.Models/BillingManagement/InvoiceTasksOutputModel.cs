using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceTasksOutputModel
    {
        public Guid? InvoiceTaskId { get; set; }
        public Guid? InvoiceId { get; set; }
        public string TaskName { get; set; }
        public string TaskDescription { get; set; }
        public double Rate { get; set; }
        public double Hours { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceTaskId" + InvoiceTaskId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("TaskName" + TaskName);
            stringBuilder.Append("TaskDescription" + TaskDescription);
            stringBuilder.Append("Rate" + Rate);
            stringBuilder.Append("Hours" + Hours);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
