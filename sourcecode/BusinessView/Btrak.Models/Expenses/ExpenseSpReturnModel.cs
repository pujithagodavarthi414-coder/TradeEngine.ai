using System;
using System.Collections.Generic;

namespace Btrak.Models.Expenses
{
    public class ExpenseSpReturnModel
    {
        public Guid? ExpenseId { get; set; }
        public string ExpenseName { get; set; }
        public Guid? ClaimedByUserId { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public Guid? ExpenseStatusId { get; set; }
        public bool ClaimReimbursement { get; set; }
        public DateTime? ExpenseDate { get; set; }
        public bool? IsApproved { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public string CurrencySymbol { get; set; }
        public string ClaimedByUserName { get; set; }
        public string CreatedByUserName { get; set; }
        public string ExpenseStatus { get; set; }
        public DateTime CreatedDateTime { get; set; }
        public int TotalCount { get; set; }
        public string Receipts { get; set; }
        public byte[] TimeStamp { get; set; }
        public string ExpenseCategorieConfigurationsXml { get; set; }
        public decimal? TotalAmount { get; set; }
        public string ExpenseCategoryNames { get; set; }
        public Guid? BranchId { get; set; }
        public string BranchName { get; set; }
        public string MerchantName { get; set; }
        public Guid? PaidStatusSetByUserId { get; set; }
        public string PaidStatusSetByUserName { get; set; }
        public string CronExpression { get; set; }
        public Guid? CronExpressionId { get; set; }
        public int? JobId { get; set; }
        public byte[] CronExpressionTimestamp { get; set; }
        public string IdentificationNumber { get; set; }
        public string ClaimedByUserMail { get; set; }
        public string CreatedByUserMail { get; set; }
        public List<ExpenseCategoryConfigurationModel> ExpenseCategoriesConfigurations { get; set; }
    }
}
