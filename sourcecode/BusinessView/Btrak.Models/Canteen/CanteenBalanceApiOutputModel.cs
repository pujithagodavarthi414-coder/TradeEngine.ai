using BTrak.Common;
using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class CanteenBalanceApiOutputModel : InputModelBase
    {
        public CanteenBalanceApiOutputModel() : base(InputTypeGuidConstants.CanteenBalanceSearchCriteriaInputCommandTypeGuid)
        {
        }
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public string UserProfileImage { get; set; }
        public decimal? TotalCreditedAmount { get; set; }
        public decimal? TotalDebitedAmount { get; set; }
        public decimal? TotalBalanceAmount { get; set; }
        public Guid? CurrencyId { get; set; }
        public string CurrencyName { get; set; }
        public int? TotalCount { get; set; }
        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", UserProfileImage = " + UserProfileImage);
            stringBuilder.Append(", TotalCreditedAmount = " + TotalCreditedAmount);
            stringBuilder.Append(", TotalDebitedAmount = " + TotalDebitedAmount);
            stringBuilder.Append(", TotalBalanceAmount = " + TotalBalanceAmount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
