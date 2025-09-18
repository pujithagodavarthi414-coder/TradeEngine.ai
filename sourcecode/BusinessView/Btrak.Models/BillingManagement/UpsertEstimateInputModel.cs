using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertEstimateInputModel : InputModelBase
    {

        public UpsertEstimateInputModel() : base(InputTypeGuidConstants.UpsertEstimateInputCommandTypeGuid)
        {
        }
        public Guid? EstimateId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? EstimateStatusId { get; set; }
        public string EstimateNumber { get; set; }
        public string EstimateTitle { get; set; }
        public string EstimateImageUrl { get; set; }
        public string PO { get; set; }
        public string Notes { get; set; }
        public string Terms { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalEstimateAmount { get; set; }
        public decimal EstimateDiscountAmount { get; set; }
        public decimal SubTotalEstimateAmount { get; set; }
        public DateTime? IssueDate { get; set; }
        public DateTime? DueDate { get; set; }
        public List<EstimateTasksInputModel> EstimateTasks { get; set; }
        public List<EstimateItemsInputModel> EstimateItems { get; set; }
        public string EstimateTasksXml { get; set; }
        public string EstimateItemsXml { get; set; }
        public string EstimateGoalsXml { get; set; }
        public string EstimateProjectsXml { get; set; }
        public string EstimateTaxXml { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EstimateId" + EstimateId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("EstimateStatusId" + EstimateStatusId);
            stringBuilder.Append("EstimateNumber" + EstimateNumber);
            stringBuilder.Append("EstimateTitle" + EstimateTitle);
            stringBuilder.Append("EstimateImageUrl" + EstimateImageUrl);
            stringBuilder.Append("PO" + PO);
            stringBuilder.Append("IssueDate" + IssueDate);
            stringBuilder.Append("DueDate" + DueDate);
            stringBuilder.Append("Notes" + Notes);
            stringBuilder.Append("Terms" + Terms);
            stringBuilder.Append("Discount" + Discount);
            stringBuilder.Append("TotalEstimateAmount" + TotalEstimateAmount);
            stringBuilder.Append("EstimateDiscountAmount" + EstimateDiscountAmount);
            stringBuilder.Append("SubTotalEstimateAmount" + SubTotalEstimateAmount);
            stringBuilder.Append("EstimateTasksXml" + EstimateTasksXml);
            stringBuilder.Append("EstimateItemsXml" + EstimateItemsXml);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
