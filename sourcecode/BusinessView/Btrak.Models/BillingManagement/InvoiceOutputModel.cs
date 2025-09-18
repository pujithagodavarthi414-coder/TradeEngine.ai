using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class InvoiceOutputModel
    {
        public Guid? InvoiceId { get; set; }
        public Guid? ClientId { get; set; }
        public Guid? UserId { get; set; }
        public Guid? BranchId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? InvoiceStatusId { get; set; }
        public string InvoiceStatusName { get; set; }
        public string InvoiceStatusColor { get; set; }
        public string ClientName { get; set; }
        public string UserName { get; set; }
        public string CurrencyCode { get; set; }
        public string Symbol { get; set; }
        public string BranchName { get; set; }
        public string InvoiceNumber { get; set; }
        public string InvoiceImageUrl { get; set; }
        public string TO { get; set; }
        public string CC { get; set; }
        public string BCC { get; set; }
        public bool IsRecurring { get; set; }
        public DateTime? DueDate { get; set; }
        public decimal Discount { get; set; }
        public decimal TotalInvoiceAmount { get; set; }
        public decimal InvoiceDiscountAmount { get; set; }
        public decimal SubTotalInvoiceAmount { get; set; }
        public decimal AmountPaid { get; set; }
        public decimal DueAmount { get; set; }
        public string Title { get; set; }
        public string Notes { get; set; }
        public string Terms { get; set; }
        public string PO { get; set; }
        public string ProjectName { get; set; }
        public DateTime? IssueDate { get; set; }
        public bool IsArchived { get; set; }
        public bool IsForMail { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }
        public string InvoiceTasksXml { get; set; }
        public string InvoiceItemsXml { get; set; }
        public List<InvoiceTasksInputModel> InvoiceTasks { get; set; }
        public List<InvoiceItemsInputModel> InvoiceItems { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("InvoiceId" + InvoiceId);
            stringBuilder.Append("ClientId" + ClientId);
            stringBuilder.Append("UserId" + UserId);
            stringBuilder.Append("BranchId" + BranchId);
            stringBuilder.Append("CurrencyId" + CurrencyId);
            stringBuilder.Append("InvoiceStatusId" + InvoiceStatusId);
            stringBuilder.Append("InvoiceStatusName" + InvoiceStatusName);
            stringBuilder.Append("InvoiceStatusColor" + InvoiceStatusColor);
            stringBuilder.Append("ClientName" + ClientName);
            stringBuilder.Append("UserName" + UserName);
            stringBuilder.Append("CurrencyCode" + CurrencyCode);
            stringBuilder.Append("Symbol" + Symbol);
            stringBuilder.Append("BranchName" + BranchName);
            stringBuilder.Append("InvoiceNumber" + InvoiceNumber);
            stringBuilder.Append("InvoiceImageUrl" + InvoiceImageUrl);
            stringBuilder.Append("TO" + TO);
            stringBuilder.Append("CC" + CC);
            stringBuilder.Append("BCC" + BCC);
            stringBuilder.Append("IsRecurring" + IsRecurring);
            stringBuilder.Append("DueDate" + DueDate);
            stringBuilder.Append("Discount" + Discount);
            stringBuilder.Append("TotalInvoiceAmount" + TotalInvoiceAmount);
            stringBuilder.Append("InvoiceDiscountAmount" + InvoiceDiscountAmount);
            stringBuilder.Append("SubTotalInvoiceAmount" + SubTotalInvoiceAmount);
            stringBuilder.Append("AmountPaid" + AmountPaid);
            stringBuilder.Append("DueAmount" + DueAmount);
            stringBuilder.Append("Title" + Title);
            stringBuilder.Append("Notes" + Notes);
            stringBuilder.Append("Terms" + Terms);
            stringBuilder.Append("PO" + PO);
            stringBuilder.Append("ProjectName" + ProjectName);
            stringBuilder.Append("IssueDate" + IssueDate);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("IsForMail" + IsForMail);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            stringBuilder.Append("InvoiceTasksXml" + InvoiceTasksXml);
            stringBuilder.Append("InvoiceItemsXml" + InvoiceItemsXml);
            return base.ToString();
        }
    }
}
