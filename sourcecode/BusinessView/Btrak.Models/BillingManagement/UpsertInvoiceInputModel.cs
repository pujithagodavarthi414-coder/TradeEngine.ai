using BTrak.Common;
using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertInvoiceInputModel : InputModelBase
    {

        public UpsertInvoiceInputModel() : base(InputTypeGuidConstants.UpsertInvoiceInputCommandTypeGuid)
        {
        }
        public Guid? InvoiceId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? InvoiceStatusId { get; set; }
        public string InvoiceNumber { get; set; }
        public string InvoiceTitle { get; set; }
        public string InvoiceImageUrl { get; set; }
        public string PO { get; set; }
        public string Notes { get; set; }
        public string Terms { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalInvoiceAmount { get; set; }
        public decimal InvoiceDiscountAmount { get; set; }
        public decimal SubTotalInvoiceAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal DueAmount { get; set; }
        public DateTime? IssueDate { get; set; }
        public DateTime? DueDate { get; set; }
        public List<InvoiceTasksInputModel> InvoiceTasks { get; set; }
        public List<InvoiceItemsInputModel> InvoiceItems { get; set; }
        public List<InvoiceGoalInputModel> InvoiceGoals { get; set; }
        public List<InvoiceProjectsInputModel> InvoiceProjects { get; set; }
        public List<InvoiceTaxInputModel> InvoiceTax { get; set; }
        public string InvoiceTasksXml { get; set; }
        public string InvoiceItemsXml { get; set; }
        public string InvoiceGoalsXml { get; set; }
        public string InvoiceProjectsXml { get; set; }
        public string InvoiceTaxXml { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("InvoiceStatusId" + InvoiceStatusId);
            stringBuilder.Append("InvoiceNumber" + InvoiceNumber);
            stringBuilder.Append("InvoiceTitle" + InvoiceTitle);
            stringBuilder.Append("InvoiceImageUrl" + InvoiceImageUrl);
            stringBuilder.Append("PO" + PO);
            stringBuilder.Append("IssueDate" + IssueDate);
            stringBuilder.Append("DueDate" + DueDate);
            stringBuilder.Append("Notes" + Notes);
            stringBuilder.Append("Terms" + Terms);
            stringBuilder.Append("Discount" + Discount);
            stringBuilder.Append("TotalInvoiceAmount" + TotalInvoiceAmount);
            stringBuilder.Append("InvoiceDiscountAmount" + InvoiceDiscountAmount);
            stringBuilder.Append("SubTotalInvoiceAmount" + SubTotalInvoiceAmount);
            stringBuilder.Append("AmountPaid" + AmountPaid);
            stringBuilder.Append("DueAmount" + DueAmount);
            stringBuilder.Append("InvoiceTasksXml" + InvoiceTasksXml);
            stringBuilder.Append("InvoiceItemsXml" + InvoiceItemsXml);
            stringBuilder.Append("InvoiceGoalsXml" + InvoiceGoalsXml);
            stringBuilder.Append("InvoiceProjectsXml" + InvoiceProjectsXml);
            stringBuilder.Append("InvoiceTaxXml" + InvoiceTaxXml);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}
