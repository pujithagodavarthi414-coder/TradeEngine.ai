using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class ExpenseUpsertInputModel: InputModelBase
    {
        public ExpenseUpsertInputModel() : base(InputTypeGuidConstants.ExpenseUpsertInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseId { get; set; }
        public string ExpenseName { get; set; }
        public string ExpensesXmlModel { get; set; }
        public string Description { get; set; }
        public Guid? ExpenseCategoryId { get; set; }
        public Guid? PaymentStatusId { get; set; }
        public Guid? CashPaidThroughId { get; set; }
        public Guid? ExpenseReportId { get; set; }
        public Guid? ExpenseStatusId { get; set; }
        public Guid? BillReceiptId { get; set; }
        public bool ClaimReimbursement { get; set; }
        public Guid? MerchantId { get; set; }
        public DateTime? ReceiptDate { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public decimal? Amount { get; set; }
        public Guid? RepliedByUserId { get; set; }
        public DateTime? RepliedDateTime { get; set; }
        public string Reason { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsPaid { get; set; }
        public bool? IsArchived { get; set; }
        public decimal? ActualBudget { get; set; }
        public string ReferenceNumber { get; set; }
        public string CronExpression { get; set; }
        public string CronExpressionDescription { get; set; }
        public Guid? CronExpressionId { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? BranchId { get; set; }
        public bool IsRecurringExpense { get; set; }
        public byte[] CronExpressionTimeStamp { get; set; }
        public int JobId { get; set; }
        public Guid? ClaimedByUserId { get; set; }
        public List<ExpenseCategoryConfigurationModel> ExpenseCategories { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseId = " + ExpenseId);
            stringBuilder.Append(", ExpenseName = " + ExpenseName);
            stringBuilder.Append(", Description = " + Description);
            stringBuilder.Append(", ExpenseCategoryId = " + ExpenseCategoryId);
            stringBuilder.Append(", PaymentStatusId = " + PaymentStatusId);
            stringBuilder.Append(", CashPaidThroughId = " + CashPaidThroughId);
            stringBuilder.Append(", ExpenseReportId = " + ExpenseReportId);
            stringBuilder.Append(", ExpenseStatusId = " + ExpenseStatusId);
            stringBuilder.Append(", BillReceiptId = " + BillReceiptId);
            stringBuilder.Append(", ClaimReimbursement = " + ClaimReimbursement);
            stringBuilder.Append(", MerchantId = " + MerchantId);
            stringBuilder.Append(", ReceiptDate = " + ReceiptDate);
            stringBuilder.Append(", ExpenseDate = " + ExpenseDate);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", RepliedByUserId = " + RepliedByUserId);
            stringBuilder.Append(", RepliedDateTime = " + RepliedDateTime);
            stringBuilder.Append(", Reason = " + Reason);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", ActualBudget = " + ActualBudget);
            stringBuilder.Append(", ReferenceNumber = " + ReferenceNumber);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            return stringBuilder.ToString();
        }
    }

    public class ExpenseCategoryConfigurationModel
    {
        public Guid? ExpenseCategoryConfigurationId { get; set; }
        public Guid? ExpenseId { get; set; }
        public string Description { get; set; }
        public decimal? Amount { get; set; }
        public Guid? ExpenseCategoryId { get; set; }
        public string CategoryName { get; set; }
        public string MerchantName { get; set; }
        public Guid?  MerchantId { get; set; }
        public string ExpenseCategoryName { get; set; }
        public string Receipts { get; set; }
    }
}
