using System;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class SearchCanteenCreditSpOutputModel
    {
        public Guid? UserId { get; set; }
        public string UserName { get; set; }
        public decimal Amount { get; set; }
        public Guid? CanteenCreditId { get; set; }
        public Guid? CurrencyId  { get; set; }
        public Guid? CreatedByUserId { get; set; }
        public string CurrencyName { get; set; }   
        public string CreatedByUserName { get; set; }
        public DateTime CreditedDate { get; set; }   
        public int TotalCount { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserId = " + UserId);
            stringBuilder.Append(", UserName = " + UserName);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", CanteenCreditId = " + CanteenCreditId);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            stringBuilder.Append(", CreatedByUserId = " + CreatedByUserId);
            stringBuilder.Append(", CurrencyName = " + CurrencyName);
            stringBuilder.Append(", CreatedByUserName = " + CreatedByUserName);
            stringBuilder.Append(", CreditedDate = " + CreditedDate);
            stringBuilder.Append(", TotalCount = " + TotalCount);
            return stringBuilder.ToString();
        }
    }
}
