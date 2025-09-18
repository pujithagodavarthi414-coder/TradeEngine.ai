using System;
using System.Collections.Generic;
using System.Text;
using BTrak.Common;

namespace Btrak.Models.Expenses
{
    public class ExpenseSearchCriteriaInputModel : SearchCriteriaInputModelBase
    {
        public ExpenseSearchCriteriaInputModel() : base(InputTypeGuidConstants.ExpenseSearchCriteriaInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseId { get; set; }
        public Guid? ExpenseCategoryId { get; set; }
        public Guid? PaymentStatusId { get; set; }
        public Guid? ClaimedByUserId { get; set; }
        public string ExpenseStatusId { get; set; }
        public bool? ClaimReimbursement { get; set; }
        public Guid? MerchantId { get; set; }
        public Guid? BranchId { get; set; }
        public DateTime? ReceiptDate { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public bool? IsApproved { get; set; }
        public bool? IsMyExpenses { get; set; }
        public bool? IsPendingExpenses { get; set; }
        public bool? IsApprovedExpenses { get; set; }
        public DateTime? ExpenseDateFrom { get; set; }
        public DateTime? ExpenseDateTo { get; set; }
        public DateTime? CreatedDateTimeFrom { get; set; }
        public DateTime? CreatedDateTimeTo { get; set; }
        public string ExpenseIdList { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseId = " + ExpenseId);
            stringBuilder.Append(", ExpenseCategoryId = " + ExpenseCategoryId);
            stringBuilder.Append(", PaymentStatusId = " + PaymentStatusId);
            stringBuilder.Append(", ClaimedByUserId = " + ClaimedByUserId);
            stringBuilder.Append(", ExpenseStatusId = " + ExpenseStatusId);
            stringBuilder.Append(", ClaimReimbursement = " + ClaimReimbursement);
            stringBuilder.Append(", MerchantId = " + MerchantId);
            stringBuilder.Append(", ReceiptDate = " + ReceiptDate);
            stringBuilder.Append(", ExpenseDate = " + ExpenseDate);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            return stringBuilder.ToString();
        }
    }
}
