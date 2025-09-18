using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceProjectsOutputModel
    {
        public Guid? InvoiceProjectId { get; set; }
        public Guid? InvoiceId { get; set; }
        public Guid? ProjectId { get; set; }
        public string ProjectName { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceProjectId" + InvoiceProjectId);
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ProjectId" + ProjectId);
            stringBuilder.Append("ProjectName" + ProjectName);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
