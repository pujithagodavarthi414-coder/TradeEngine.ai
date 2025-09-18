using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Expenses
{
    public class ExpenseApiReturnModel
    {
        public Guid? ExpenseId { get; set; }
        public string ExpenseName { get; set; }
        public Guid? PaymentStatusId { get; set; }
        public Guid? ClaimedByUserId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? ExpenseStatusId { get; set; }
        public bool ClaimReimbursement { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public bool? IsApproved { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencySymbol { get; set; }
        public string PaymentStatus { get; set; }
        public string ClaimedByUserName { get; set; }
        public string CreatedByUserName { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public string CreatedOn { get; set; }
        public string ExpenseDateOn { get; set; }
        public int TotalCount { get; set; }
        public string Receipts { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ExpenseStatus { get; set; }
        public decimal? TotalAmount { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string MerchantName { get; set; }
        public Guid? PaidStatusSetByUserId { get; set; }
        public string PaidStatusSetByUserName { get; set; }
        public string ExpenseCategoryNames { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int? JobId { get; set; }
        public byte[] CronExpressionTimestamp { get; set; }
        public string IdentificationNumber { get; set; }
        public List<ExpenseCategoryConfigurationModel> ExpenseCategoriesConfigurations { get; set; }
        public string ExcelBlobPath { get; set; }
        public string ClaimedByUserMail { get; set; }
        public string CreatedByUserMail { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseId = " + ExpenseId);
            stringBuilder.Append(", PaymentStatusId = " + PaymentStatusId);
            stringBuilder.Append(", ClaimedByUserId = " + ClaimedByUserId);
            stringBuilder.Append(", ExpenseStatusId = " + ExpenseStatusId);
            stringBuilder.Append(", ClaimReimbursement = " + ClaimReimbursement);
            stringBuilder.Append(", ExpenseDate = " + ExpenseDate);
            stringBuilder.Append(", IsApproved = " + IsApproved);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", PaymentStatus = " + PaymentStatus);
            stringBuilder.Append(", CreatedDateTime = " + CreatedDateTime);
            stringBuilder.Append(", CreatedOn = " + CreatedOn);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            stringBuilder.Append(", ClaimedByUserName = " + ClaimedByUserName);
            stringBuilder.Append(", ExpenseDateOn = " + ExpenseDateOn);
            stringBuilder.Append(", TimeStamp = " + TimeStamp);
            return stringBuilder.ToString();
        }
    }

    public class ExpenseExcelModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string UserIFSCCode { get; set; }
        public decimal? TotalAmount { get; set; }
        public string TransactionType { get; set; }
        public string DebitAccountNumber { get; set; }
        public string DebitAccountIfsc { get; set; }
        public string BeneficiaryAccountNumber { get; set; }
        public string BeneficiaryName { get; set; }
        public string RemarksForClient { get; set; }
        public string RemarksForBeneficiary { get; set; }
        public string TraceAccountNumber { get; set; }
        public string FileReference { get; set; }
        public string ExcelBlobPath { get; set; }
        public string ExpenseName { get; set; }
        public string IdentificationNumber { get; set; }
    }
}
