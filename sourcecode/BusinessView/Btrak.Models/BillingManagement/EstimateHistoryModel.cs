using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class EstimateHistoryModel
    {
        public Guid? EstimateId { get; set; }
        public string EstimateNumber { get; set; }
        public string EstimateTitle { get; set; }
        public string OldValue { get; set; }
        public string NewValue { get; set; }
        public string Description { get; set; }
        public Guid? EstimateTaskId { get; set; }
        public Guid? EstimateItemId { get; set; }
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
            stringBuilder.Append("EstimateId" + EstimateId);
            stringBuilder.Append("EstimateNumber" + EstimateNumber);
            stringBuilder.Append("EstimateTitle" + EstimateTitle);
            stringBuilder.Append("OldValue" + OldValue);
            stringBuilder.Append("NewValue" + NewValue);
            stringBuilder.Append("Description" + Description);
            stringBuilder.Append("EstimateTaskId" + EstimateTaskId);
            stringBuilder.Append("EstimateItemId" + EstimateItemId);
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
