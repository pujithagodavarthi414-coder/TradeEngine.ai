using System;
using System.Collections.Generic;
using System.Text;

namespace Btrak.Models.Canteen
{
    public class CanteenCreditInputModel
    {
        public List<Guid?> UserIds { get; set; }
        public decimal? Amount { get; set; }
        public Guid? CurrencyId { get; set; }
        public Guid? CanteenCreditId { get; set; }
        public bool? IsArchived { get; set; }

        public override string ToString()
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.Append(", UserIds = " + UserIds);
            stringBuilder.Append(", Amount = " + Amount);
            stringBuilder.Append(", CurrencyId = " + CurrencyId);
            return stringBuilder.ToString();
        }
    }
}
