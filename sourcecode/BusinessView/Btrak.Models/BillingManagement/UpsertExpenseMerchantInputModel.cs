using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.BillingManagement
{
    public class UpsertExpenseMerchantInputModel : InputModelBase
    {
        public UpsertExpenseMerchantInputModel() : base(InputTypeGuidConstants.UpsertExpenseMerchantInputCommandTypeGuid)
        {
        }

        public Guid? ExpenseMerchantId { get; set; }
        public Guid? MerchantBankDetailsId { get; set; }
        public Guid? ExpenseId { get; set; }
        public string MerchantName { get; set; }
        public string PayeeName { get; set; }
        public string BankName { get; set; }
        public string BranchName { get; set; }
        public string AccountNumber { get; set; }
        public string IFSCCode { get; set; }
        public string SortCode { get; set; }
        public bool IsArchived { get; set; }
        public byte[] TimeStamp { get; set; }
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append("ExpenseMerchantId" + ExpenseMerchantId);
            stringBuilder.Append("MerchantBankDetailsId" + MerchantBankDetailsId);
            stringBuilder.Append("ExpenseId" + ExpenseId);
            stringBuilder.Append("MerchantName" + MerchantName);
            stringBuilder.Append("PayeeName" + PayeeName);
            stringBuilder.Append("BankName" + BankName);
            stringBuilder.Append("BranchName" + BranchName);
            stringBuilder.Append("AccountNumber" + AccountNumber);
            stringBuilder.Append("IFSCCode" + IFSCCode);
            stringBuilder.Append("SortCode" + SortCode);
            stringBuilder.Append("IsArchived" + IsArchived);
            stringBuilder.Append("TimeStamp" + TimeStamp);
            stringBuilder.Append("TotalCount" + TotalCount);
            return base.ToString();
        }
    }
}