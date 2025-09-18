using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceHistoryModel
    {
        public Guid? InvoiceId { get; set; }
        public string InvoiceNumber { get; set; }
        public string InvoiceTitle { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
        public Guid? InvoiceTaskId { get; set; }
        public Guid? InvoiceItemId { get; set; }
        public string TaskName { get; set; }
        public string TaskDescription { get; set; }
        public decimal Rate { get; set; }
        public decimal Hours { get; set; }
        public string ItemName { get; set; }
        public string ItemDescription { get; set; }
        public decimal Price { get; set; }
        public decimal Quantity { get; set; }
        public string PerformedByUserName { get; set; }
        public string PerformedByUserProfileImage { get; set; }
        public DateTime? CreatedDateTime { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("InvoiceNumber" + InvoiceNumber);
            stringBuilder.Append("InvoiceTitle" + InvoiceTitle);
            stringBuilder.Append("OldValue" + OldValue);
            stringBuilder.Append("NewValue" + NewValue);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("InvoiceTaskId" + InvoiceTaskId);
            stringBuilder.Append("InvoiceItemId" + InvoiceItemId);
            stringBuilder.Append("TaskName" + TaskName);
            stringBuilder.Append("TaskDescription" + TaskDescription);
            stringBuilder.Append("Rate" + Rate);
            stringBuilder.Append("ItemName" + ItemName);
            stringBuilder.Append("ItemDescription" + ItemDescription);
            stringBuilder.Append("Price" + Price);
            stringBuilder.Append("Quantity" + Quantity);
            stringBuilder.Append("PerformedByUserName" + PerformedByUserName);
            stringBuilder.Append("PerformedByUserProfileImage" + PerformedByUserProfileImage);
            stringBuilder.Append("CreatedDateTime" + CreatedDateTime);
            return base.ToString();
        }
    }
}
