using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class EstimateOutputModel
    {
        public Guid? EstimateId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? EstimateStatusId { get; set; }
        public string EstimateStatusName { get; set; }
        public string EstimateStatusColor { get; set; }
        public string ClientName { get; set; }
        public string UserName { get; set; }
        public string CurrencyCode { get; set; }
        public string Symbol { get; set; }
        public string BranchName { get; set; }
        public string EstimateNumber { get; set; }
        public string EstimateImageUrl { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public bool IsRecurring { get; set; }
        public DateTime? DueDate { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalEstimateAmount { get; set; }
        public decimal EstimateDiscountAmount { get; set; }
        public decimal SubTotalEstimateAmount { get; set; }
        public string Title { get; set; }
        public string Notes { get; set; }
        public string Terms { get; set; }
        public string PO { get; set; }
        public string ProjectName { get; set; }
        public DateTime? IssueDate { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public string EstimateTasksXml { get; set; }
        public string EstimateItemsXml { get; set; }
        public List<EstimateTasksInputModel> EstimateTasks { get; set; }
        public List<EstimateItemsInputModel> EstimateItems { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("EstimateId" + EstimateId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("UserId" + UserId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("EstimateStatusId" + EstimateStatusId);
            stringBuilder.Append("EstimateStatusName" + EstimateStatusName);
            stringBuilder.Append("EstimateStatusColor" + EstimateStatusColor);
            stringBuilder.Append("ClientName" + ClientName);
            stringBuilder.Append("UserName" + UserName);
            stringBuilder.Append("CurrencyCode" + CurrencyCode);
            stringBuilder.Append("Symbol" + Symbol);
            stringBuilder.Append("BranchName" + BranchName);
            stringBuilder.Append("EstimateNumber" + EstimateNumber);
            stringBuilder.Append("EstimateImageUrl" + EstimateImageUrl);
            stringBuilder.Append("CC" + CC);
            stringBuilder.Append("BCC" + BCC);
            stringBuilder.Append("IsRecurring" + IsRecurring);
            stringBuilder.Append("DueDate" + DueDate);
            stringBuilder.Append("Discount" + Discount);
            stringBuilder.Append("TotalEstimateAmount" + TotalEstimateAmount);
            stringBuilder.Append("EstimateDiscountAmount" + EstimateDiscountAmount);
            stringBuilder.Append("SubTotalEstimateAmount" + SubTotalEstimateAmount);
            stringBuilder.Append("Title" + Title);
            stringBuilder.Append("Notes" + Notes);
            stringBuilder.Append("Terms" + Terms);
            stringBuilder.Append("PO" + PO);
            stringBuilder.Append("ProjectName" + ProjectName);
            stringBuilder.Append("IssueDate" + IssueDate);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("EstimateTasksXml" + EstimateTasksXml);
            stringBuilder.Append("EstimateItemsXml" + EstimateItemsXml);
            return base.ToString();
        }
    }
}
