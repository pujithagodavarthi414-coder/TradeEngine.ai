using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class EstimateStatusModel
    {
        public Guid? EstimateStatusId { get; set; }
        public string EstimateStatusName { get; set; }
        public string EstimateStatusColor { get; set; }
        public string SearchText { get; set; }
        public bool IsArchived { get; set; }
        public DateTime? CreatedDateTime { get; set; }
        public byte[] TimeStamp { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EstimateStatusId" + EstimateStatusId);
            stringBuilder.Append("EstimateStatusName" + EstimateStatusName);
            stringBuilder.Append("EstimateStatusColor" + EstimateStatusColor);
            stringBuilder.Append("SearchText" + SearchText);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            return base.ToString();
        }
    }
}